/*****************************************************************
 * Assembly64 Browser - C64 Client
 *
 * Native C64 client for browsing Assembly64 database via
 * Ultimate II+ network interface.
 *****************************************************************/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <c64/vic.h>
#include <c64/keyboard.h>
#include "ultimate.h"

// Server configuration
#define DEFAULT_SERVER_HOST "192.168.2.66"
#define SERVER_PORT 6465  // Native protocol port
#define SETTINGS_FILE "/Usb1/a64browser.cfg"

// Settings structure
static char server_host[32] = DEFAULT_SERVER_HOST;

// Screen dimensions
#define SCREEN_WIDTH  40
#define SCREEN_HEIGHT 25
#define LIST_HEIGHT   18  // Lines available for list display

// UI state
static byte socket_id = 0;
static bool connected = false;

// Pages: 0=cats, 1=list, 2=search, 3=settings, 4=advsearch, 5=advresults, 6=info
#define PAGE_CATS        0
#define PAGE_LIST        1
#define PAGE_SEARCH      2
#define PAGE_SETTINGS    3
#define PAGE_ADV_SEARCH  4
#define PAGE_ADV_RESULTS 5
#define PAGE_INFO        6

// Menu/list state
#define MAX_ITEMS 20
static char item_names[MAX_ITEMS][32];
static int  item_ids[MAX_ITEMS];
static int  item_count = 0;
static int  total_count = 0;
static int  cursor = 0;
static int  offset = 0;
static int  current_page = PAGE_CATS;

// Current category or search query
static char current_category[32];
static char search_query[32];
static int  search_query_len = 0;

// Search category filter: 0=All, 1=Games, 2=Demos, 3=Music
static int  search_category = 0;
static const char *search_cat_names[] = {"All", "Games", "Demos", "Music"};

// Advanced search form state
#define ADV_FIELD_CAT     0
#define ADV_FIELD_TITLE   1
#define ADV_FIELD_GROUP   2
#define ADV_FIELD_TYPE    3
#define ADV_FIELD_TOP200  4
#define ADV_FIELD_SEARCH  5  // Execute search button
#define ADV_FIELD_COUNT   6

static int  adv_cursor = 0;           // Current field
static bool adv_editing = false;      // Are we editing a text field?
static int  adv_edit_pos = 0;         // Cursor position in edit

// Advanced search field values
static int  adv_category = 0;         // 0=All, 1=Games, 2=Demos, 3=Music
static char adv_title[24];
static char adv_group[24];
static int  adv_type = 0;             // 0=Any, 1=prg, 2=d64, 3=crt, 4=sid
static bool adv_top200 = false;

static const char *adv_type_names[] = {"Any", "prg", "d64", "crt", "sid"};

// Settings edit state
static int  settings_cursor = 0;  // Which setting is selected
static int  settings_edit_pos = 0;  // Cursor position in edit field
static bool settings_editing = false;  // Are we editing a field?

// Line buffer for protocol
static char line_buffer[128];

// Info screen state
static int info_return_page = PAGE_CATS;  // Page to return to after info
#define MAX_INFO_LINES 12
static char info_labels[MAX_INFO_LINES][8];   // "NAME", "GROUP", etc.
static char info_values[MAX_INFO_LINES][32];  // The values
static int  info_line_count = 0;

// VIC chip at $D000
#define vic (*(struct VIC *)0xd000)

// Screen memory
#define SCREEN_RAM ((char*)0x0400)
#define COLOR_RAM  ((char*)0xD800)

//-----------------------------------------------------------------------------
// Screen utilities
//-----------------------------------------------------------------------------

void clear_screen(void)
{
    memset(SCREEN_RAM, ' ', 1000);
    memset(COLOR_RAM, 14, 1000);  // Light blue
}

void print_at(byte x, byte y, const char *text)
{
    char *pos = SCREEN_RAM + y * 40 + x;
    while (*text)
    {
        char c = *text++;
        // Convert ASCII to PETSCII screen codes
        if (c >= 'a' && c <= 'z')
            c = c - 'a' + 1;
        else if (c >= 'A' && c <= 'Z')
            c = c - 'A' + 1;
        else if (c == '|')
            c = ' ';  // Replace pipe separator with space
        *pos++ = c;
    }
}

void print_at_color(byte x, byte y, const char *text, byte color)
{
    char *pos = SCREEN_RAM + y * 40 + x;
    char *col = COLOR_RAM + y * 40 + x;
    while (*text)
    {
        char c = *text++;
        if (c >= 'a' && c <= 'z')
            c = c - 'a' + 1;
        else if (c >= 'A' && c <= 'Z')
            c = c - 'A' + 1;
        else if (c == '|')
            c = ' ';
        *pos++ = c;
        *col++ = color;
    }
}

void clear_line(byte y)
{
    memset(SCREEN_RAM + y * 40, ' ', 40);
}

void print_status(const char *msg)
{
    clear_line(24);
    print_at(0, 24, msg);
}

//-----------------------------------------------------------------------------
// Settings
//-----------------------------------------------------------------------------

void load_settings(void)
{
    // Make sure we're targeting DOS
    uci_settarget(UCI_TARGET_DOS1);

    // Try to open settings file for reading
    uci_open_file(0x01, SETTINGS_FILE);  // 0x01 = read
    if (!uci_success())
        return;  // No settings file, use defaults

    // Read server host
    uci_read_file(31);

    // Wait for data to be available (with timeout)
    int timeout = 1000;
    while (!uci_isdataavailable() && timeout > 0)
        timeout--;

    int len = uci_readdata();
    uci_readstatus();
    uci_accept();

    if (len > 0)
    {
        // Copy until newline or end
        int i = 0;
        while (i < 31 && i < len && uci_data[i] != 0 && uci_data[i] != '\n' && uci_data[i] != '\r')
        {
            server_host[i] = uci_data[i];
            i++;
        }
        server_host[i] = 0;
    }

    uci_close_file();
}

void save_settings(void)
{
    // Make sure we're targeting DOS, not network
    uci_settarget(UCI_TARGET_DOS1);

    // Delete existing file first (ignore errors)
    uci_delete_file(SETTINGS_FILE);

    // Open settings file for writing (0x06 = create + write)
    uci_open_file(0x06, SETTINGS_FILE);
    if (!uci_success())
        return;

    // Write server host
    uci_write_file((uint8_t*)server_host, strlen(server_host));
    uci_close_file();
}

//-----------------------------------------------------------------------------
// Network
//-----------------------------------------------------------------------------

bool connect_to_server(void)
{
    print_status("connecting...");

    socket_id = uci_tcp_connect(server_host, SERVER_PORT);

    if (!uci_success())
    {
        print_status("connect failed!");
        return false;
    }

    connected = true;

    // Read greeting line "OK c64uploader"
    uci_tcp_nextline(socket_id, line_buffer);

    print_status("connected!");
    return true;
}

void disconnect_from_server(void)
{
    if (connected)
    {
        uci_socket_write(socket_id, "QUIT\n");
        uci_socket_close(socket_id);
        connected = false;
    }
}

//-----------------------------------------------------------------------------
// Protocol
//-----------------------------------------------------------------------------

void send_command(const char *cmd)
{
    if (!connected)
        return;
    uci_socket_write(socket_id, cmd);
    uci_socket_write_char(socket_id, '\n');
}

// Read a line from server, returns length
int read_line(void)
{
    return uci_tcp_nextline(socket_id, line_buffer);
}

// Parse "OK n total" response, returns n
int parse_ok_count(void)
{
    // line_buffer contains "OK n total"
    char *p = line_buffer + 3;  // Skip "OK "
    return atoi(p);
}

// Load categories from server
void load_categories(void)
{
    print_status("loading categories...");

    send_command("CATS");
    read_line();  // "OK n"

    item_count = 0;
    total_count = parse_ok_count();

    // Read category lines until "."
    while (item_count < MAX_ITEMS)
    {
        read_line();
        if (line_buffer[0] == '.')
            break;

        // Parse "Category|count"
        char *p = strchr(line_buffer, '|');
        if (p)
        {
            *p = 0;  // Terminate at |
            strncpy(item_names[item_count], line_buffer, 31);
            item_names[item_count][31] = 0;
            item_ids[item_count] = atoi(p + 1);  // Store count as "id"
            item_count++;
        }
    }

    cursor = 0;
    offset = 0;
    current_page = 0;
    print_status("ready");
}

// Load entries for a category
void load_entries(const char *category, int start)
{
    print_status("loading...");

    // Build command: "LIST category offset 20"
    char cmd[64];
    strcpy(cmd, "LIST ");
    strcat(cmd, category);
    strcat(cmd, " ");

    // Convert offset to string
    char num[8];
    sprintf(num, "%d", start);
    strcat(cmd, num);
    strcat(cmd, " 20");

    send_command(cmd);
    read_line();  // "OK n total"

    // Parse "OK n total"
    char *p = line_buffer + 3;
    int n = atoi(p);
    p = strchr(p, ' ');
    if (p)
        total_count = atoi(p + 1);

    item_count = 0;
    offset = start;

    // Read entry lines until "."
    while (item_count < MAX_ITEMS && item_count < n)
    {
        read_line();
        if (line_buffer[0] == '.')
            break;

        // Parse "id|name|group|year|type"
        char *id_str = line_buffer;
        char *name = strchr(id_str, '|');
        if (name)
        {
            *name++ = 0;
            item_ids[item_count] = atoi(id_str);

            // Find end of name (next |)
            char *end = strchr(name, '|');
            if (end)
                *end = 0;

            strncpy(item_names[item_count], name, 31);
            item_names[item_count][31] = 0;
            item_count++;
        }
    }

    // Consume remaining lines until "."
    while (line_buffer[0] != '.')
        read_line();

    cursor = 0;
    current_page = 1;
    print_status("ready");
}

// Run selected entry
void run_entry(int id)
{
    print_status("running...");

    char cmd[32];
    sprintf(cmd, "RUN %d", id);
    send_command(cmd);

    read_line();  // "OK Running xxx" or "ERR xxx"
    print_status(line_buffer);
}

// Search entries
void do_search(const char *query, int start)
{
    print_status("searching...");

    // Build command: "SEARCH offset count [category] query"
    char cmd[64];
    if (search_category == 0) {
        // All categories - don't include category parameter
        sprintf(cmd, "SEARCH %d 20 %s", start, query);
    } else {
        // Specific category filter
        sprintf(cmd, "SEARCH %d 20 %s %s", start, search_cat_names[search_category], query);
    }

    send_command(cmd);
    read_line();  // "OK n total"

    // Parse "OK n total"
    char *p = line_buffer + 3;
    int n = atoi(p);
    p = strchr(p, ' ');
    if (p)
        total_count = atoi(p + 1);

    item_count = 0;
    offset = start;

    // Read entry lines until "."
    while (item_count < MAX_ITEMS && item_count < n)
    {
        read_line();
        if (line_buffer[0] == '.')
            break;

        // Parse "id|name|group|year|type"
        char *id_str = line_buffer;
        char *name = strchr(id_str, '|');
        if (name)
        {
            *name++ = 0;
            item_ids[item_count] = atoi(id_str);

            // Find end of name (next |)
            char *end = strchr(name, '|');
            if (end)
                *end = 0;

            strncpy(item_names[item_count], name, 31);
            item_names[item_count][31] = 0;
            item_count++;
        }
    }

    // Consume remaining lines until "."
    while (line_buffer[0] != '.')
        read_line();

    cursor = 0;
    current_page = 2;
    print_status("ready");
}

// Execute advanced search
void do_adv_search(int start)
{
    print_status("searching...");

    // Build command: "ADVSEARCH offset count [key=value ...]"
    char cmd[96];
    sprintf(cmd, "ADVSEARCH %d 20", start);

    // Add category filter
    if (adv_category > 0)
    {
        strcat(cmd, " cat=");
        strcat(cmd, search_cat_names[adv_category]);
    }

    // Add title filter
    if (adv_title[0])
    {
        strcat(cmd, " title=");
        strcat(cmd, adv_title);
    }

    // Add group filter
    if (adv_group[0])
    {
        strcat(cmd, " group=");
        strcat(cmd, adv_group);
    }

    // Add file type filter
    if (adv_type > 0)
    {
        strcat(cmd, " type=");
        strcat(cmd, adv_type_names[adv_type]);
    }

    // Add top200 filter
    if (adv_top200)
    {
        strcat(cmd, " top200=1");
    }

    send_command(cmd);
    read_line();  // "OK n total"

    // Parse "OK n total"
    char *p = line_buffer + 3;
    int n = atoi(p);
    p = strchr(p, ' ');
    if (p)
        total_count = atoi(p + 1);

    item_count = 0;
    offset = start;

    // Read entry lines until "."
    while (item_count < MAX_ITEMS && item_count < n)
    {
        read_line();
        if (line_buffer[0] == '.')
            break;

        // Parse "id|name|group|year|type"
        char *id_str = line_buffer;
        char *name = strchr(id_str, '|');
        if (name)
        {
            *name++ = 0;
            item_ids[item_count] = atoi(id_str);

            // Find end of name (next |)
            char *end = strchr(name, '|');
            if (end)
                *end = 0;

            strncpy(item_names[item_count], name, 31);
            item_names[item_count][31] = 0;
            item_count++;
        }
    }

    // Consume remaining lines until "."
    while (line_buffer[0] != '.')
        read_line();

    cursor = 0;
    print_status("ready");
}

// Fetch info for an entry
bool fetch_info(int id)
{
    print_status("loading info...");

    char cmd[32];
    sprintf(cmd, "INFO %d", id);
    send_command(cmd);
    read_line();  // "OK" or "ERR ..."

    if (line_buffer[0] == 'E')
    {
        print_status(line_buffer);
        return false;
    }

    info_line_count = 0;

    // Read field lines until "."
    while (info_line_count < MAX_INFO_LINES)
    {
        read_line();
        if (line_buffer[0] == '.')
            break;

        // Parse "LABEL|value"
        char *sep = strchr(line_buffer, '|');
        if (sep)
        {
            *sep = 0;
            // Only add if value is non-empty
            if (sep[1] != 0)
            {
                strncpy(info_labels[info_line_count], line_buffer, 7);
                info_labels[info_line_count][7] = 0;
                strncpy(info_values[info_line_count], sep + 1, 31);
                info_values[info_line_count][31] = 0;
                info_line_count++;
            }
        }
    }

    // Consume any remaining lines
    while (line_buffer[0] != '.')
        read_line();

    print_status("ready");
    return info_line_count > 0;
}

//-----------------------------------------------------------------------------
// Keyboard input
//-----------------------------------------------------------------------------

// Debug: show key info on status line
void debug_key(byte k, bool shift)
{
    char buf[32];
    // Also show what keyb_codes returns
    char c = (k < 64) ? keyb_codes[shift ? k + 64 : k] : '?';
    sprintf(buf, "k=%02x c=%02x", k, c);
    print_at(28, 24, buf);
}

char get_key(void)
{
    keyb_poll();

    if (keyb_key & KSCAN_QUAL_DOWN)
    {
        // Strip both DOWN (0x80) and SHIFT (0x40) qualifiers to get base scancode
        byte k = keyb_key & 0x3f;
        bool shift = (keyb_key & KSCAN_QUAL_SHIFT) != 0;

        // Debug output
        debug_key(k, shift);

        // Always handle these
        if (k == KSCAN_RETURN) return '\r';
        if (k == KSCAN_DEL) return 8;  // Backspace

        // In category menu
        if (current_page == PAGE_CATS)
        {
            if (k == KSCAN_Q) return 'q';
            if (k == KSCAN_C) return 'c';  // Settings
            if (k == KSCAN_W) return 'u';
            if (k == KSCAN_CSR_DOWN && shift) return 'u';
            if (k == KSCAN_S || k == KSCAN_CSR_DOWN) return 'd';
            if (k == KSCAN_SLASH) return '/';
            if (k == KSCAN_CSR_RIGHT && !shift) return '>';  // Right = enter category
        }
        // In list view
        else if (current_page == PAGE_LIST)
        {
            if (k == KSCAN_W) return 'u';
            if (k == KSCAN_CSR_DOWN && shift) return 'u';
            if (k == KSCAN_S || k == KSCAN_CSR_DOWN) return 'd';
            if (k == KSCAN_N) return 'n';
            if (k == KSCAN_P) return 'p';
            if (k == KSCAN_I) return 'i';  // Info
            if (k == KSCAN_CSR_RIGHT && shift) return 8;  // Left = back
        }
        // In search mode
        else if (current_page == PAGE_SEARCH)
        {
            // Left arrow = back
            if (k == KSCAN_CSR_RIGHT && shift) return 8;  // Left = back

            // Tab = cycle category filter (C= key, scancode 0x0F)
            if (k == 0x0F) return '\t';  // C= key for tab (cycle category)

            // Cursor navigation only when we have results
            if (item_count > 0)
            {
                if (k == KSCAN_CSR_DOWN && shift) return 'u';
                if (k == KSCAN_CSR_DOWN) return 'd';
                if (k == KSCAN_I) return 'i';  // Info
            }

            // Return printable character using keyb_codes table
            if (k < 64)
            {
                byte c = (byte)keyb_codes[shift ? k + 64 : k];
                // ASCII lowercase a-z (0x61-0x7A) -> convert to uppercase
                if (c >= 'a' && c <= 'z')
                    return c - 32;  // Convert to uppercase A-Z
                // ASCII uppercase A-Z (0x41-0x5A)
                if (c >= 'A' && c <= 'Z')
                    return c;
                // Numbers 0-9 (0x30-0x39)
                if (c >= '0' && c <= '9')
                    return c;
            }
        }
        // In settings
        else if (current_page == PAGE_SETTINGS)
        {
            if (!settings_editing)
            {
                if (k == KSCAN_W || (k == KSCAN_CSR_DOWN && shift)) return 'u';
                if (k == KSCAN_S || k == KSCAN_CSR_DOWN) return 'd';
                if (k == KSCAN_CSR_RIGHT && shift) return 8;  // Left = back
            }
            else
            {
                // Editing mode - return typed characters
                if (k < 64)
                {
                    byte c = (byte)keyb_codes[shift ? k + 64 : k];
                    if (c >= '0' && c <= '9') return c;
                    if (c == '.') return '.';
                }
            }
        }
        // In advanced search form
        else if (current_page == PAGE_ADV_SEARCH)
        {
            if (!adv_editing)
            {
                // Navigation
                if (k == KSCAN_W || (k == KSCAN_CSR_DOWN && shift)) return 'u';
                if (k == KSCAN_S || k == KSCAN_CSR_DOWN) return 'd';
                if (k == KSCAN_CSR_RIGHT && shift) return 8;  // Left = back
                if (k == KSCAN_SPACE) return ' ';  // Toggle/cycle
            }
            else
            {
                // Editing text field - return typed characters
                if (k < 64)
                {
                    byte c = (byte)keyb_codes[shift ? k + 64 : k];
                    if (c >= 'a' && c <= 'z') return c - 32;  // Uppercase
                    if (c >= 'A' && c <= 'Z') return c;
                    if (c >= '0' && c <= '9') return c;
                    if (c == ' ') return '_';  // Use underscore for spaces
                }
            }
        }
        // In advanced search results
        else if (current_page == PAGE_ADV_RESULTS)
        {
            if (k == KSCAN_W || (k == KSCAN_CSR_DOWN && shift)) return 'u';
            if (k == KSCAN_S || k == KSCAN_CSR_DOWN) return 'd';
            if (k == KSCAN_N) return 'n';
            if (k == KSCAN_P) return 'p';
            if (k == KSCAN_I) return 'i';  // Info
            if (k == KSCAN_CSR_RIGHT && shift) return 8;  // Left = back
        }
        // In info screen - any key returns
        else if (current_page == PAGE_INFO)
        {
            return 'x';  // Any key = exit info
        }
    }
    return 0;
}

void wait_key(void)
{
    keyb_poll();
    while (keyb_key & KSCAN_QUAL_DOWN)
        keyb_poll();
    while (!(keyb_key & KSCAN_QUAL_DOWN))
        keyb_poll();
}

//-----------------------------------------------------------------------------
// UI Drawing
//-----------------------------------------------------------------------------

// Draw a single item line (for partial updates)
// row_offset: 4 for normal lists, 2 for adv results
void draw_item_at(int i, bool selected, byte row_offset)
{
    byte y = i + row_offset;
    clear_line(y);
    if (selected)
    {
        print_at_color(0, y, ">", 1);  // White
        print_at_color(2, y, item_names[i], 1);
    }
    else
    {
        print_at_color(2, y, item_names[i], 14);  // Light blue (default)
    }
}

// Draw item for normal list pages (row offset 4)
void draw_item(int i, bool selected)
{
    draw_item_at(i, selected, 4);
}

// Update cursor display without full redraw (only redraws 2 lines)
// row_offset: 4 for normal lists, 2 for adv results
void update_cursor_at(int old_cursor, int new_cursor, byte row_offset)
{
    if (old_cursor >= 0 && old_cursor < item_count)
        draw_item_at(old_cursor, false, row_offset);
    if (new_cursor >= 0 && new_cursor < item_count)
        draw_item_at(new_cursor, true, row_offset);
}

// Update cursor for normal list pages (row offset 4)
void update_cursor(int old_cursor, int new_cursor)
{
    update_cursor_at(old_cursor, new_cursor, 4);
}

void draw_list(const char *title)
{
    clear_screen();

    // Title
    print_at_color(0, 0, title, 7);  // Yellow

    // Search input line (page 2 only)
    if (current_page == 2)
    {
        // Show category filter
        print_at(0, 1, "[");
        print_at_color(1, 1, search_cat_names[search_category], 5);  // Green
        print_at(1 + strlen(search_cat_names[search_category]), 1, "] ");
        // Search input
        int searchX = 3 + strlen(search_cat_names[search_category]);
        print_at(searchX, 1, search_query);
        print_at(searchX + search_query_len, 1, "_");  // Cursor
    }

    // Info line
    if (item_count > 0)
    {
        char info[40];
        sprintf(info, "%d-%d of %d", offset + 1, offset + item_count, total_count);
        print_at(0, 2, info);
    }

    // Draw items
    for (int i = 0; i < item_count && i < LIST_HEIGHT; i++)
    {
        byte y = i + 4;
        if (i == cursor)
        {
            // Highlight selected item
            print_at_color(0, y, ">", 1);  // White
            print_at_color(2, y, item_names[i], 1);
        }
        else
        {
            print_at(2, y, item_names[i]);
        }
    }

    // Help line
    if (current_page == PAGE_CATS)
        print_at(0, 23, "w/s:move enter:sel /:search c:cfg q:quit");
    else if (current_page == PAGE_LIST)
        print_at(0, 23, "w/s:move enter:run i:info del:back n/p:pg");
    else
        print_at(0, 23, "type:search c=:cat enter:run i:info del:bk");
}

void draw_settings(void)
{
    clear_screen();
    print_at_color(0, 0, "settings", 7);  // Yellow

    // Server IP field
    byte y = 4;
    if (settings_cursor == 0)
    {
        print_at_color(0, y, ">", 1);
        print_at_color(2, y, "server:", 1);
        if (settings_editing)
        {
            print_at_color(10, y, server_host, 5);  // Green when editing
            // Show cursor
            print_at_color(10 + settings_edit_pos, y, "_", 5);
        }
        else
        {
            print_at_color(10, y, server_host, 1);
        }
    }
    else
    {
        print_at_color(2, y, "server:", 14);
        print_at_color(10, y, server_host, 14);
    }

    // Save button
    y = 6;
    if (settings_cursor == 1)
    {
        print_at_color(0, y, ">", 1);
        print_at_color(2, y, "[save]", 1);
    }
    else
    {
        print_at_color(2, y, "[save]", 14);
    }

    // Help
    if (settings_editing)
        print_at(0, 23, "type ip  enter:done  del:erase");
    else
        print_at(0, 23, "w/s:move enter:edit/save del:back");
}

// Draw a single advanced search field (for partial updates)
void draw_adv_field(int field, bool selected)
{
    byte y = 2 + field * 2;  // Fields at rows 2, 4, 6, 8, 10, 12
    byte color = selected ? 1 : 14;

    clear_line(y);

    // Cursor indicator
    if (selected)
        print_at_color(0, y, ">", 1);

    switch (field)
    {
    case ADV_FIELD_CAT:
        print_at_color(2, y, "category:", color);
        print_at_color(12, y, "[", color);
        print_at_color(13, y, search_cat_names[adv_category], 5);
        print_at_color(13 + strlen(search_cat_names[adv_category]), y, "]", color);
        break;

    case ADV_FIELD_TITLE:
        print_at_color(2, y, "title:", color);
        if (adv_editing && selected)
        {
            print_at_color(10, y, adv_title, 5);
            print_at_color(10 + strlen(adv_title), y, "_", 5);
        }
        else if (adv_title[0])
            print_at_color(10, y, adv_title, color);
        else
            print_at_color(10, y, "(any)", 11);
        break;

    case ADV_FIELD_GROUP:
        print_at_color(2, y, "group:", color);
        if (adv_editing && selected)
        {
            print_at_color(10, y, adv_group, 5);
            print_at_color(10 + strlen(adv_group), y, "_", 5);
        }
        else if (adv_group[0])
            print_at_color(10, y, adv_group, color);
        else
            print_at_color(10, y, "(any)", 11);
        break;

    case ADV_FIELD_TYPE:
        print_at_color(2, y, "type:", color);
        print_at_color(10, y, "[", color);
        print_at_color(11, y, adv_type_names[adv_type], 5);
        print_at_color(11 + strlen(adv_type_names[adv_type]), y, "]", color);
        break;

    case ADV_FIELD_TOP200:
        print_at_color(2, y, "top200:", color);
        print_at_color(10, y, adv_top200 ? "[yes]" : "[no]", adv_top200 ? 5 : 11);
        break;

    case ADV_FIELD_SEARCH:
        print_at_color(2, y, "[search]", color);
        break;
    }
}

// Update advanced search cursor (only redraws 2 lines)
void update_adv_cursor(int old_field, int new_field)
{
    if (old_field >= 0 && old_field < ADV_FIELD_COUNT)
        draw_adv_field(old_field, false);
    if (new_field >= 0 && new_field < ADV_FIELD_COUNT)
        draw_adv_field(new_field, true);
}

void draw_adv_search(void)
{
    clear_screen();
    print_at_color(0, 0, "advanced search", 7);  // Yellow

    // Draw all fields
    for (int i = 0; i < ADV_FIELD_COUNT; i++)
        draw_adv_field(i, i == adv_cursor);

    // Help line
    if (adv_editing)
        print_at(0, 23, "type text  enter:done  del:erase");
    else
        print_at(0, 23, "w/s:move space:toggle enter:search del:back");
}

void draw_adv_results(void)
{
    clear_screen();

    // Title with count on same line
    char title[40];
    sprintf(title, "results %d-%d of %d", offset + 1, offset + item_count, total_count);
    print_at_color(0, 0, title, 7);  // Yellow

    // Draw items starting at row 2 - limit to 19 items (rows 2-20)
    // Row 21-22 empty, row 23 for help
    int max_display = 19;
    for (int i = 0; i < item_count && i < max_display; i++)
    {
        byte y = i + 2;
        if (i == cursor)
        {
            print_at_color(0, y, ">", 1);  // White
            print_at_color(2, y, item_names[i], 1);
        }
        else
        {
            print_at(2, y, item_names[i]);
        }
    }

    // Help line at row 23
    print_at(0, 23, "w/s:move enter:run i:info del:back");
}

void draw_info(void)
{
    clear_screen();
    print_at_color(0, 0, "entry info", 7);  // Yellow

    // Draw all info fields with labels
    for (int i = 0; i < info_line_count; i++)
    {
        byte y = 2 + i;
        // Label in cyan
        print_at_color(2, y, info_labels[i], 3);
        print_at_color(2 + strlen(info_labels[i]), y, ":", 3);
        // Value in white
        print_at_color(10, y, info_values[i], 1);
    }

    // Help line
    print_at(0, 23, "press any key to return");
}

//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------

int main(void)
{
    // Set up screen
    vic.color_border = VCOL_BLACK;
    vic.color_back = VCOL_BLACK;

    clear_screen();
    print_at(0, 0, "assembly64 browser");
    print_at(0, 2, "checking ultimate...");

    // Check Ultimate II+ is present
    uci_identify();
    if (!uci_success())
    {
        print_at(0, 4, "ultimate ii+ not found!");
        print_at(0, 6, "press any key to exit");
        wait_key();
        return 1;
    }

    print_at(0, 4, "ultimate ii+ detected");
    print_at(0, 6, "loading settings...");
    load_settings();

    print_at(0, 8, "server: ");
    print_at(8, 8, server_host);

    print_at(0, 10, "getting ip address...");
    uci_getipaddress();
    if (uci_success())
    {
        print_at(0, 12, "ip: ");
        print_at(4, 12, uci_data);
    }

    print_at(0, 14, "c=config, any other key=connect");

    // Wait for keypress and check if it's 'c' for config
    bool need_config = false;
    keyb_poll();
    while (keyb_key & KSCAN_QUAL_DOWN)
        keyb_poll();
    while (!(keyb_key & KSCAN_QUAL_DOWN))
        keyb_poll();
    // Check if 'c' was pressed
    byte k = keyb_key & 0x3f;
    if (k == KSCAN_C)
        need_config = true;

    if (need_config)
    {
        // Go to settings
        current_page = PAGE_SETTINGS;
        settings_cursor = 0;
        settings_editing = false;
        settings_edit_pos = strlen(server_host);
        draw_settings();

        // Settings loop - exit when user presses backspace from non-edit mode
        while (current_page == PAGE_SETTINGS)
        {
            char key = get_key();
            if (key == 'u' && !settings_editing && settings_cursor > 0)
            {
                settings_cursor--;
                draw_settings();
            }
            else if (key == 'd' && !settings_editing && settings_cursor < 1)
            {
                settings_cursor++;
                draw_settings();
            }
            else if (key == '\r')
            {
                if (settings_cursor == 0)
                {
                    settings_editing = !settings_editing;
                    if (settings_editing)
                        settings_edit_pos = strlen(server_host);
                    draw_settings();
                }
                else if (settings_cursor == 1)
                {
                    print_status("saving...");
                    save_settings();
                    print_status("saved! connecting...");
                    current_page = PAGE_CATS;  // Exit settings loop
                }
            }
            else if (key == 8)  // Backspace
            {
                if (settings_editing && settings_edit_pos > 0)
                {
                    settings_edit_pos--;
                    server_host[settings_edit_pos] = 0;
                    draw_settings();
                }
                else if (!settings_editing)
                {
                    current_page = PAGE_CATS;  // Exit settings, try connect
                }
            }
            else if (settings_editing && ((key >= '0' && key <= '9') || key == '.'))
            {
                if (settings_edit_pos < 30)
                {
                    server_host[settings_edit_pos++] = key;
                    server_host[settings_edit_pos] = 0;
                    draw_settings();
                }
            }
        }
    }

    // Connect to server
    if (!connect_to_server())
    {
        print_at(0, 12, "press any key to exit");
        wait_key();
        return 1;
    }

    // Load categories
    load_categories();
    draw_list("assembly64 - categories");

    bool running = true;

    while (running)
    {
        char key = get_key();

        if (key != 0)
        {
            // Get current title
            const char *title = "assembly64 - categories";
            if (current_page == PAGE_LIST)
                title = current_category;
            else if (current_page == PAGE_SEARCH)
                title = "assembly64 - search";

            switch (key)
            {
            case 'q':
                if (current_page == PAGE_CATS)
                    running = false;
                break;

            case 'c':  // Settings
                if (current_page == PAGE_CATS)
                {
                    current_page = PAGE_SETTINGS;
                    settings_cursor = 0;
                    settings_editing = false;
                    settings_edit_pos = strlen(server_host);
                    draw_settings();
                }
                break;

            case '/':  // Start advanced search
                if (current_page == PAGE_CATS)
                {
                    current_page = PAGE_ADV_SEARCH;
                    adv_cursor = 0;
                    adv_editing = false;
                    // Reset form fields
                    adv_category = 0;
                    adv_title[0] = 0;
                    adv_group[0] = 0;
                    adv_type = 0;
                    adv_top200 = false;
                    item_count = 0;
                    total_count = 0;
                    cursor = 0;
                    offset = 0;
                    draw_adv_search();
                }
                break;

            case '\t':  // Tab = cycle category in search mode
                if (current_page == PAGE_SEARCH)
                {
                    search_category = (search_category + 1) % 4;  // 0-3: All, Games, Demos, Music
                    // Re-search if we have a query
                    if (search_query_len >= 2)
                        do_search(search_query, 0);
                    draw_list("assembly64 - search");
                }
                break;

            case 'u':  // Up
                if (current_page == PAGE_SETTINGS)
                {
                    if (settings_cursor > 0)
                    {
                        settings_cursor--;
                        draw_settings();
                    }
                }
                else if (current_page == PAGE_ADV_SEARCH)
                {
                    if (adv_cursor > 0)
                    {
                        int old = adv_cursor;
                        adv_cursor--;
                        update_adv_cursor(old, adv_cursor);
                    }
                }
                else if (current_page == PAGE_ADV_RESULTS)
                {
                    if (cursor > 0)
                    {
                        int old = cursor;
                        cursor--;
                        update_cursor_at(old, cursor, 2);  // Row offset 2 for adv results
                    }
                    else if (offset > 0)
                    {
                        // At top of list, go to previous page
                        int new_offset = offset - 20;
                        if (new_offset < 0) new_offset = 0;
                        do_adv_search(new_offset);
                        // Go to bottom of new page, but max visible is 18
                        cursor = item_count - 1;
                        if (cursor > 18) cursor = 18;
                        draw_adv_results();
                    }
                }
                else if (cursor > 0)
                {
                    int old = cursor;
                    cursor--;
                    update_cursor(old, cursor);
                }
                break;

            case 'd':  // Down
                if (current_page == PAGE_SETTINGS)
                {
                    if (settings_cursor < 1)  // 2 items: server, save
                    {
                        settings_cursor++;
                        draw_settings();
                    }
                }
                else if (current_page == PAGE_ADV_SEARCH)
                {
                    if (adv_cursor < ADV_FIELD_COUNT - 1)
                    {
                        int old = adv_cursor;
                        adv_cursor++;
                        update_adv_cursor(old, adv_cursor);
                    }
                }
                else if (current_page == PAGE_ADV_RESULTS)
                {
                    // Max 19 visible items (0-18)
                    int max_visible = 18;
                    if (cursor < item_count - 1 && cursor < max_visible)
                    {
                        int old = cursor;
                        cursor++;
                        update_cursor_at(old, cursor, 2);  // Row offset 2 for adv results
                    }
                    else if (offset + item_count < total_count)
                    {
                        // At bottom of visible list or at end, go to next page
                        do_adv_search(offset + 20);
                        cursor = 0;  // Go to top of new page
                        draw_adv_results();
                    }
                }
                else if (cursor < item_count - 1)
                {
                    int old = cursor;
                    cursor++;
                    update_cursor(old, cursor);
                }
                break;

            case ' ':  // Space - toggle/cycle in advanced search
                if (current_page == PAGE_ADV_SEARCH && !adv_editing)
                {
                    if (adv_cursor == ADV_FIELD_CAT)
                    {
                        adv_category = (adv_category + 1) % 4;
                        draw_adv_search();
                    }
                    else if (adv_cursor == ADV_FIELD_TYPE)
                    {
                        adv_type = (adv_type + 1) % 5;
                        draw_adv_search();
                    }
                    else if (adv_cursor == ADV_FIELD_TOP200)
                    {
                        adv_top200 = !adv_top200;
                        draw_adv_search();
                    }
                }
                break;

            case '>':  // Right arrow - enter category (not run)
                if (current_page == PAGE_CATS)
                {
                    strcpy(current_category, item_names[cursor]);
                    load_entries(current_category, 0);
                    draw_list(current_category);
                }
                break;

            case '\r':  // Enter
                if (current_page == PAGE_CATS)
                {
                    // Select category
                    strcpy(current_category, item_names[cursor]);
                    load_entries(current_category, 0);
                    draw_list(current_category);
                }
                else if (current_page == PAGE_SETTINGS)
                {
                    if (settings_cursor == 0)
                    {
                        // Toggle edit mode on server field
                        settings_editing = !settings_editing;
                        if (settings_editing)
                            settings_edit_pos = strlen(server_host);
                        draw_settings();
                    }
                    else if (settings_cursor == 1)
                    {
                        // Save settings
                        print_status("saving...");
                        save_settings();
                        print_status("saved!");
                        // Go back to categories
                        current_page = PAGE_CATS;
                        draw_list("assembly64 - categories");
                    }
                }
                else if (current_page == PAGE_ADV_SEARCH)
                {
                    if (adv_editing)
                    {
                        // Exit edit mode
                        adv_editing = false;
                        draw_adv_search();
                    }
                    else if (adv_cursor == ADV_FIELD_TITLE)
                    {
                        // Start editing title
                        adv_editing = true;
                        adv_edit_pos = strlen(adv_title);
                        draw_adv_search();
                    }
                    else if (adv_cursor == ADV_FIELD_GROUP)
                    {
                        // Start editing group
                        adv_editing = true;
                        adv_edit_pos = strlen(adv_group);
                        draw_adv_search();
                    }
                    else if (adv_cursor == ADV_FIELD_SEARCH)
                    {
                        // Execute search and go to results page
                        do_adv_search(0);
                        if (item_count > 0)
                        {
                            current_page = PAGE_ADV_RESULTS;
                            draw_adv_results();
                        }
                        else
                        {
                            print_status("no results found");
                        }
                    }
                }
                else if (current_page == PAGE_ADV_RESULTS && item_count > 0)
                {
                    // Run selected result
                    run_entry(item_ids[cursor]);
                }
                else if (item_count > 0)
                {
                    // Run entry (page 1 or 2)
                    run_entry(item_ids[cursor]);
                }
                break;

            case 8:  // Backspace
                if (current_page == PAGE_SETTINGS)
                {
                    if (settings_editing && settings_edit_pos > 0)
                    {
                        // Delete last char from server_host
                        settings_edit_pos--;
                        server_host[settings_edit_pos] = 0;
                        draw_settings();
                    }
                    else if (!settings_editing)
                    {
                        // Go back to categories
                        current_page = PAGE_CATS;
                        draw_list("assembly64 - categories");
                    }
                }
                else if (current_page == PAGE_SEARCH)
                {
                    if (search_query_len > 0)
                    {
                        // Delete last char from search
                        search_query_len--;
                        search_query[search_query_len] = 0;
                        // Re-search if query still has chars
                        if (search_query_len >= 2)
                            do_search(search_query, 0);
                        else
                        {
                            item_count = 0;
                            total_count = 0;
                        }
                        draw_list("assembly64 - search");
                    }
                    else
                    {
                        // Empty search, go back to categories
                        load_categories();
                        draw_list("assembly64 - categories");
                    }
                }
                else if (current_page == PAGE_LIST)
                {
                    load_categories();
                    draw_list("assembly64 - categories");
                }
                else if (current_page == PAGE_ADV_SEARCH)
                {
                    if (adv_editing)
                    {
                        // Delete character from current field
                        if (adv_cursor == ADV_FIELD_TITLE && strlen(adv_title) > 0)
                        {
                            adv_title[strlen(adv_title) - 1] = 0;
                            draw_adv_search();
                        }
                        else if (adv_cursor == ADV_FIELD_GROUP && strlen(adv_group) > 0)
                        {
                            adv_group[strlen(adv_group) - 1] = 0;
                            draw_adv_search();
                        }
                    }
                    else
                    {
                        // Go back to categories
                        load_categories();
                        draw_list("assembly64 - categories");
                    }
                }
                else if (current_page == PAGE_ADV_RESULTS)
                {
                    // Go back to advanced search form
                    current_page = PAGE_ADV_SEARCH;
                    draw_adv_search();
                }
                break;

            case 'n':  // Next page
                if (current_page == PAGE_LIST && offset + item_count < total_count)
                {
                    load_entries(current_category, offset + 20);
                    draw_list(title);
                }
                else if (current_page == PAGE_ADV_RESULTS && offset + item_count < total_count)
                {
                    do_adv_search(offset + 20);
                    draw_adv_results();
                }
                break;

            case 'p':  // Previous page
                if (current_page == PAGE_LIST && offset > 0)
                {
                    int new_offset = offset - 20;
                    if (new_offset < 0) new_offset = 0;
                    load_entries(current_category, new_offset);
                    draw_list(title);
                }
                else if (current_page == PAGE_ADV_RESULTS && offset > 0)
                {
                    int new_offset = offset - 20;
                    if (new_offset < 0) new_offset = 0;
                    do_adv_search(new_offset);
                    draw_adv_results();
                }
                break;

            case 'i':  // Info
                if ((current_page == PAGE_LIST || current_page == PAGE_SEARCH ||
                     current_page == PAGE_ADV_RESULTS) && item_count > 0)
                {
                    // Remember where to return
                    info_return_page = current_page;
                    // Fetch and display info
                    if (fetch_info(item_ids[cursor]))
                    {
                        current_page = PAGE_INFO;
                        draw_info();
                    }
                }
                break;

            case 'x':  // Exit info screen
                if (current_page == PAGE_INFO)
                {
                    current_page = info_return_page;
                    if (current_page == PAGE_LIST)
                        draw_list(current_category);
                    else if (current_page == PAGE_SEARCH)
                        draw_list("assembly64 - search");
                    else if (current_page == PAGE_ADV_RESULTS)
                        draw_adv_results();
                }
                break;

            default:
                // Typed character in search mode
                if (current_page == PAGE_SEARCH &&
                    ((key >= 'A' && key <= 'Z') || (key >= '0' && key <= '9')))
                {
                    if (search_query_len < 30)
                    {
                        search_query[search_query_len++] = key;
                        search_query[search_query_len] = 0;
                        // Search after 2+ chars
                        if (search_query_len >= 2)
                            do_search(search_query, 0);
                        draw_list("assembly64 - search");
                    }
                }
                // Typed character in settings edit mode
                else if (current_page == PAGE_SETTINGS && settings_editing &&
                         ((key >= '0' && key <= '9') || key == '.'))
                {
                    if (settings_edit_pos < 30)
                    {
                        server_host[settings_edit_pos++] = key;
                        server_host[settings_edit_pos] = 0;
                        draw_settings();
                    }
                }
                // Typed character in advanced search edit mode
                else if (current_page == PAGE_ADV_SEARCH && adv_editing &&
                         ((key >= 'A' && key <= 'Z') || (key >= '0' && key <= '9') || key == '_'))
                {
                    if (adv_cursor == ADV_FIELD_TITLE && strlen(adv_title) < 22)
                    {
                        int len = strlen(adv_title);
                        adv_title[len] = key;
                        adv_title[len + 1] = 0;
                        draw_adv_search();
                    }
                    else if (adv_cursor == ADV_FIELD_GROUP && strlen(adv_group) < 22)
                    {
                        int len = strlen(adv_group);
                        adv_group[len] = key;
                        adv_group[len + 1] = 0;
                        draw_adv_search();
                    }
                }
                break;
            }
        }
    }

    disconnect_from_server();
    clear_screen();
    print_at(0, 0, "goodbye!");

    return 0;
}
