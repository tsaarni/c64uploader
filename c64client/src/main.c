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

// Server configuration - change to your server IP
#define SERVER_HOST "192.168.2.66"
#define SERVER_PORT 6465  // Native protocol port

// Screen dimensions
#define SCREEN_WIDTH  40
#define SCREEN_HEIGHT 25
#define LIST_HEIGHT   18  // Lines available for list display

// UI state
static byte socket_id = 0;
static bool connected = false;

// Menu/list state
#define MAX_ITEMS 20
static char item_names[MAX_ITEMS][32];
static int  item_ids[MAX_ITEMS];
static int  item_count = 0;
static int  total_count = 0;
static int  cursor = 0;
static int  offset = 0;
static int  current_page = 0;  // 0=cats, 1=list, 2=search

// Current category or search query
static char current_category[32];
static char search_query[32];
static int  search_query_len = 0;

// Line buffer for protocol
static char line_buffer[128];

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
// Network
//-----------------------------------------------------------------------------

bool connect_to_server(void)
{
    print_status("connecting...");

    socket_id = uci_tcp_connect(SERVER_HOST, SERVER_PORT);

    if (!uci_success())
    {
        print_status("connect failed!");
        return false;
    }

    connected = true;

    // Read greeting line "OK Assembly64 Browser"
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

    // Build command: "SEARCH query offset 20"
    char cmd[64];
    sprintf(cmd, "SEARCH %s %d 20", query, start);

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
        if (current_page == 0)
        {
            if (k == KSCAN_Q) return 'q';
            if (k == KSCAN_W) return 'u';
            if (k == KSCAN_CSR_DOWN && shift) return 'u';
            if (k == KSCAN_S || k == KSCAN_CSR_DOWN) return 'd';
            if (k == KSCAN_SLASH) return '/';
        }
        // In list view
        else if (current_page == 1)
        {
            if (k == KSCAN_W) return 'u';
            if (k == KSCAN_CSR_DOWN && shift) return 'u';
            if (k == KSCAN_S || k == KSCAN_CSR_DOWN) return 'd';
            if (k == KSCAN_N) return 'n';
            if (k == KSCAN_P) return 'p';
        }
        // In search mode
        else if (current_page == 2)
        {
            // Cursor navigation only when we have results
            if (item_count > 0)
            {
                if (k == KSCAN_CSR_DOWN && shift) return 'u';
                if (k == KSCAN_CSR_DOWN) return 'd';
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

void draw_list(const char *title)
{
    clear_screen();

    // Title
    print_at_color(0, 0, title, 7);  // Yellow

    // Search input line (page 2 only)
    if (current_page == 2)
    {
        print_at(0, 1, "search: ");
        print_at(8, 1, search_query);
        print_at(8 + search_query_len, 1, "_");  // Cursor
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
    if (current_page == 0)
        print_at(0, 23, "w/s:move enter:sel /:search q:quit");
    else if (current_page == 1)
        print_at(0, 23, "w/s:move enter:run del:back n/p:page");
    else
        print_at(0, 23, "type to search enter:run del:back");
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
    print_at(0, 6, "getting ip address...");

    uci_getipaddress();
    if (uci_success())
    {
        print_at(0, 8, "ip: ");
        print_at(4, 8, uci_data);
    }

    print_at(0, 10, "press any key to connect");
    wait_key();

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
    char last_key = 0;

    while (running)
    {
        char key = get_key();

        if (key != 0 && key != last_key)
        {
            // Get current title
            const char *title = "assembly64 - categories";
            if (current_page == 1)
                title = current_category;
            else if (current_page == 2)
                title = "assembly64 - search";

            switch (key)
            {
            case 'q':
                if (current_page == 0)
                    running = false;
                break;

            case '/':  // Start search
                if (current_page == 0)
                {
                    current_page = 2;
                    search_query[0] = 0;
                    search_query_len = 0;
                    item_count = 0;
                    total_count = 0;
                    cursor = 0;
                    offset = 0;
                    draw_list("assembly64 - search");
                }
                break;

            case 'u':  // Up
                if (cursor > 0)
                {
                    cursor--;
                    draw_list(title);
                }
                break;

            case 'd':  // Down
                if (cursor < item_count - 1)
                {
                    cursor++;
                    draw_list(title);
                }
                break;

            case '\r':  // Enter
                if (current_page == 0)
                {
                    // Select category
                    strcpy(current_category, item_names[cursor]);
                    load_entries(current_category, 0);
                    draw_list(current_category);
                }
                else if (item_count > 0)
                {
                    // Run entry (page 1 or 2)
                    run_entry(item_ids[cursor]);
                }
                break;

            case 8:  // Backspace
                if (current_page == 2)
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
                else if (current_page == 1)
                {
                    load_categories();
                    draw_list("assembly64 - categories");
                }
                break;

            case 'n':  // Next page (list view only)
                if (current_page == 1 && offset + item_count < total_count)
                {
                    load_entries(current_category, offset + 20);
                    draw_list(title);
                }
                break;

            case 'p':  // Previous page (list view only)
                if (current_page == 1 && offset > 0)
                {
                    int new_offset = offset - 20;
                    if (new_offset < 0) new_offset = 0;
                    load_entries(current_category, new_offset);
                    draw_list(title);
                }
                break;

            default:
                // Typed character in search mode
                if (current_page == 2 &&
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
                break;
            }
        }
        last_key = key;
    }

    disconnect_from_server();
    clear_screen();
    print_at(0, 0, "goodbye!");

    return 0;
}
