/*****************************************************************
 * Ultimate 64/II+ Command Library for Oscar64
 *
 * Ported from cc65 version by Scott Hutter, Francesco Sblendorio
 * Oscar64 port for c64uploader project
 *****************************************************************/

#include <string.h>
#include <stdlib.h>
#include "ultimate.h"

// Global buffers
char uci_status[UCI_STATUS_QUEUE_SZ];
char uci_data[UCI_DATA_QUEUE_SZ * 2];

// Internal state
static uint8_t uci_target = UCI_TARGET_DOS1;
static int uci_data_index = 0;
static int uci_data_len = 0;
static char temp_char[2];

//-----------------------------------------------------------------------------
// Low-level register access
//-----------------------------------------------------------------------------

void uci_settarget(uint8_t id)
{
    uci_target = id;
}

bool uci_isdataavailable(void)
{
    return (*UCI_STATUS_REG & UCI_STAT_DATA_AV) != 0;
}

bool uci_isstatusdataavailable(void)
{
    return (*UCI_STATUS_REG & UCI_STAT_STAT_AV) != 0;
}

void uci_sendcommand(uint8_t *bytes, int count)
{
    int x;
    int success = 0;

    bytes[0] = uci_target;

    while (success == 0)
    {
        // Wait for idle state: bits 5 and 4 both clear
        while (!((*UCI_STATUS_REG & 0x20) == 0 && (*UCI_STATUS_REG & 0x10) == 0))
            ;

        // Write bytes to command data register
        for (x = 0; x < count; x++)
            *UCI_CMD_DATA_REG = bytes[x];

        // Push command
        *UCI_CONTROL_REG = UCI_CTRL_PUSH_CMD;

        // Check for error
        if (*UCI_STATUS_REG & UCI_STAT_ERROR)
        {
            // Clear error and try again
            *UCI_CONTROL_REG = UCI_CTRL_CLR_ERR;
        }
        else
        {
            // Wait for command to complete: bit 5 clear, bit 4 set means busy
            while ((*UCI_STATUS_REG & 0x20) == 0 && (*UCI_STATUS_REG & 0x10) == 0x10)
                ;
            success = 1;
        }
    }
}

void uci_accept(void)
{
    // Acknowledge the data
    *UCI_CONTROL_REG |= UCI_CTRL_DATA_ACC;
    while ((*UCI_STATUS_REG & UCI_STAT_DATA_ACC) != 0)
        ;
}

void uci_abort(void)
{
    *UCI_CONTROL_REG |= UCI_CTRL_ABORT;
}

int uci_readdata(void)
{
    int count = 0;
    uci_data[0] = 0;

    while (uci_isdataavailable())
    {
        uci_data[count++] = *UCI_RESP_DATA_REG;
    }
    uci_data[count] = 0;
    return count;
}

int uci_readstatus(void)
{
    int count = 0;
    uci_status[0] = 0;

    while (uci_isstatusdataavailable())
    {
        uci_status[count++] = *UCI_STATUS_DATA_REG;
    }
    uci_status[count] = 0;
    return count;
}

//-----------------------------------------------------------------------------
// Identification
//-----------------------------------------------------------------------------

void uci_identify(void)
{
    uint8_t cmd[] = {0x00, DOS_CMD_IDENTIFY};
    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, 2);
    uci_readdata();
    uci_readstatus();
    uci_accept();
}

//-----------------------------------------------------------------------------
// Directory operations
//-----------------------------------------------------------------------------

void uci_get_path(void)
{
    uint8_t cmd[] = {0x00, DOS_CMD_GET_PATH};
    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, 2);
    uci_readdata();
    uci_readstatus();
    uci_accept();
}

void uci_open_dir(void)
{
    uint8_t cmd[] = {0x00, DOS_CMD_OPEN_DIR};
    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, 2);
    uci_readstatus();
    uci_accept();
}

void uci_get_dir(void)
{
    uint8_t cmd[] = {0x00, DOS_CMD_READ_DIR};
    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, 2);
}

void uci_change_dir(const char *directory)
{
    int len = strlen(directory);
    uint8_t *cmd = (uint8_t *)malloc(len + 2);
    int x;

    cmd[0] = 0x00;
    cmd[1] = DOS_CMD_CHANGE_DIR;
    for (x = 0; x < len; x++)
        cmd[x + 2] = directory[x];

    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, len + 2);
    free(cmd);

    uci_readstatus();
    uci_accept();
}

void uci_create_dir(const char *directory)
{
    int len = strlen(directory);
    uint8_t *cmd = (uint8_t *)malloc(len + 2);
    int x;

    cmd[0] = 0x00;
    cmd[1] = DOS_CMD_CREATE_DIR;
    for (x = 0; x < len; x++)
        cmd[x + 2] = directory[x];

    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, len + 2);
    free(cmd);

    uci_readdata();
    uci_readstatus();
    uci_accept();
}

void uci_change_dir_home(void)
{
    uint8_t cmd[] = {0x00, DOS_CMD_COPY_HOME_PATH};
    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, 2);
    uci_readstatus();
    uci_accept();
}

//-----------------------------------------------------------------------------
// File operations
//-----------------------------------------------------------------------------

void uci_open_file(uint8_t attrib, const char *filename)
{
    int len = strlen(filename);
    uint8_t *cmd = (uint8_t *)malloc(len + 3);
    int x;

    cmd[0] = 0x00;
    cmd[1] = DOS_CMD_OPEN_FILE;
    cmd[2] = attrib;
    for (x = 0; x < len; x++)
        cmd[x + 3] = filename[x];

    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, len + 3);
    free(cmd);

    uci_readdata();
    uci_readstatus();
    uci_accept();
}

void uci_close_file(void)
{
    uint8_t cmd[] = {0x00, DOS_CMD_CLOSE_FILE};
    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, 2);
    uci_readdata();
    uci_readstatus();
    uci_accept();
}

void uci_read_file(uint8_t length)
{
    uint8_t cmd[] = {0x00, DOS_CMD_READ_DATA, 0x00, 0x00};
    cmd[2] = length & 0xFF;
    cmd[3] = length >> 8;

    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, 4);
}

void uci_write_file(uint8_t *data, int length)
{
    uint8_t *cmd = (uint8_t *)malloc(length + 4);
    int x;

    cmd[0] = 0x00;
    cmd[1] = DOS_CMD_WRITE_DATA;
    cmd[2] = 0x00;
    cmd[3] = 0x00;
    for (x = 0; x < length; x++)
        cmd[x + 4] = data[x];

    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, length + 4);
    free(cmd);

    uci_readdata();
    uci_readstatus();
    uci_accept();
}

void uci_delete_file(const char *filename)
{
    int len = strlen(filename);
    uint8_t *cmd = (uint8_t *)malloc(len + 2);
    int x;

    cmd[0] = 0x00;
    cmd[1] = DOS_CMD_DELETE_FILE;
    for (x = 0; x < len; x++)
        cmd[x + 2] = filename[x];

    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, len + 2);
    free(cmd);

    uci_readstatus();
    uci_accept();
}

void uci_rename_file(const char *filename, const char *newname)
{
    int len1 = strlen(filename);
    int len2 = strlen(newname);
    uint8_t *cmd = (uint8_t *)malloc(len1 + len2 + 3);
    int x;

    cmd[0] = 0x00;
    cmd[1] = DOS_CMD_RENAME_FILE;
    for (x = 0; x < len1; x++)
        cmd[x + 2] = filename[x];
    cmd[len1 + 2] = 0x00;
    for (x = 0; x < len2; x++)
        cmd[len1 + 3 + x] = newname[x];

    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, len1 + len2 + 3);
    free(cmd);

    uci_readstatus();
    uci_accept();
}

void uci_copy_file(const char *sourcefile, const char *destfile)
{
    int len1 = strlen(sourcefile);
    int len2 = strlen(destfile);
    uint8_t *cmd = (uint8_t *)malloc(len1 + len2 + 3);
    int x;

    cmd[0] = 0x00;
    cmd[1] = DOS_CMD_COPY_FILE;
    for (x = 0; x < len1; x++)
        cmd[x + 2] = sourcefile[x];
    cmd[len1 + 2] = 0x00;
    for (x = 0; x < len2; x++)
        cmd[len1 + 3 + x] = destfile[x];

    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, len1 + len2 + 3);
    free(cmd);

    uci_readstatus();
    uci_accept();
}

//-----------------------------------------------------------------------------
// Disk operations
//-----------------------------------------------------------------------------

void uci_mount_disk(uint8_t id, const char *filename)
{
    int len = strlen(filename);
    uint8_t *cmd = (uint8_t *)malloc(len + 3);
    int x;

    cmd[0] = 0x00;
    cmd[1] = DOS_CMD_MOUNT_DISK;
    cmd[2] = id;
    for (x = 0; x < len; x++)
        cmd[x + 3] = filename[x];

    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, len + 3);
    free(cmd);

    uci_readdata();
    uci_readstatus();
    uci_accept();
}

void uci_unmount_disk(uint8_t id)
{
    uint8_t cmd[] = {0x00, DOS_CMD_UMOUNT_DISK, id};
    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, 3);
    uci_readdata();
    uci_readstatus();
    uci_accept();
}

void uci_swap_disk(uint8_t id)
{
    uint8_t cmd[] = {0x00, DOS_CMD_SWAP_DISK, id};
    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, 3);
    uci_readdata();
    uci_readstatus();
    uci_accept();
}

//-----------------------------------------------------------------------------
// Network - basic
//-----------------------------------------------------------------------------

void uci_getinterfacecount(void)
{
    uint8_t saved = uci_target;
    uint8_t cmd[] = {0x00, NET_CMD_GET_INTERFACE_COUNT};

    uci_settarget(UCI_TARGET_NETWORK);
    uci_sendcommand(cmd, 2);
    uci_readdata();
    uci_readstatus();
    uci_accept();

    uci_target = saved;
}

void uci_getipaddress(void)
{
    uint8_t saved = uci_target;
    uint8_t cmd[] = {0x00, NET_CMD_GET_IP_ADDRESS, 0x00};

    uci_settarget(UCI_TARGET_NETWORK);
    uci_sendcommand(cmd, 3);
    uci_readdata();
    uci_readstatus();
    uci_accept();

    uci_target = saved;
}

//-----------------------------------------------------------------------------
// Network - TCP/UDP connections
//-----------------------------------------------------------------------------

static uint8_t uci_connect(const char *host, uint16_t port, uint8_t netcmd)
{
    uint8_t saved = uci_target;
    int len = strlen(host);
    uint8_t *cmd = (uint8_t *)malloc(len + 5);
    int x;

    cmd[0] = 0x00;
    cmd[1] = netcmd;
    cmd[2] = port & 0xFF;
    cmd[3] = (port >> 8) & 0xFF;
    for (x = 0; x < len; x++)
        cmd[x + 4] = host[x];
    cmd[len + 4] = 0x00;

    uci_settarget(UCI_TARGET_NETWORK);
    uci_sendcommand(cmd, len + 5);
    free(cmd);

    uci_readdata();
    uci_readstatus();
    uci_accept();

    uci_target = saved;
    uci_data_index = 0;
    uci_data_len = 0;

    return uci_data[0];
}

uint8_t uci_tcp_connect(const char *host, uint16_t port)
{
    return uci_connect(host, port, NET_CMD_TCP_SOCKET_CONNECT);
}

uint8_t uci_udp_connect(const char *host, uint16_t port)
{
    return uci_connect(host, port, NET_CMD_UDP_SOCKET_CONNECT);
}

void uci_socket_close(uint8_t socketid)
{
    uint8_t saved = uci_target;
    uint8_t cmd[] = {0x00, NET_CMD_SOCKET_CLOSE, socketid};

    uci_settarget(UCI_TARGET_NETWORK);
    uci_sendcommand(cmd, 3);
    uci_readdata();
    uci_readstatus();
    uci_accept();

    uci_target = saved;
}

int uci_socket_read(uint8_t socketid, uint16_t length)
{
    uint8_t saved = uci_target;
    uint8_t cmd[] = {0x00, NET_CMD_SOCKET_READ, socketid,
                     (uint8_t)(length & 0xFF), (uint8_t)((length >> 8) & 0xFF)};

    uci_settarget(UCI_TARGET_NETWORK);
    uci_sendcommand(cmd, 5);
    uci_readdata();
    uci_readstatus();
    uci_accept();

    uci_target = saved;
    return uci_data[0] | (uci_data[1] << 8);
}

static void uci_socket_write_internal(uint8_t socketid, const char *data, bool ascii)
{
    uint8_t saved = uci_target;
    int len = strlen(data);
    uint8_t *cmd = (uint8_t *)malloc(len + 3);
    int x;
    char c;

    cmd[0] = 0x00;
    cmd[1] = NET_CMD_SOCKET_WRITE;
    cmd[2] = socketid;

    for (x = 0; x < len; x++)
    {
        c = data[x];
        if (ascii)
        {
            // Convert PETSCII to ASCII
            if ((c >= 97 && c <= 122) || (c >= 193 && c <= 218))
                c &= 95;
            else if (c >= 65 && c <= 90)
                c |= 32;
            else if (c == 13)
                c = 10;
        }
        cmd[x + 3] = c;
    }

    uci_settarget(UCI_TARGET_NETWORK);
    uci_sendcommand(cmd, len + 3);
    free(cmd);

    uci_readdata();
    uci_readstatus();
    uci_accept();

    uci_target = saved;
    uci_data_index = 0;
    uci_data_len = 0;
}

void uci_socket_write(uint8_t socketid, const char *data)
{
    uci_socket_write_internal(socketid, data, false);
}

void uci_socket_write_ascii(uint8_t socketid, const char *data)
{
    uci_socket_write_internal(socketid, data, true);
}

void uci_socket_write_char(uint8_t socketid, char c)
{
    temp_char[0] = c;
    temp_char[1] = 0;
    uci_socket_write(socketid, temp_char);
}

//-----------------------------------------------------------------------------
// Network - TCP listener
//-----------------------------------------------------------------------------

int uci_tcp_listen_start(uint16_t port)
{
    uint8_t saved = uci_target;
    uint8_t cmd[] = {0x00, NET_CMD_TCP_LISTENER_START,
                     (uint8_t)(port & 0xFF), (uint8_t)((port >> 8) & 0xFF)};

    uci_settarget(UCI_TARGET_NETWORK);
    uci_sendcommand(cmd, 4);
    uci_readdata();
    uci_readstatus();
    uci_accept();

    uci_target = saved;
    return uci_data[0] | (uci_data[1] << 8);
}

int uci_tcp_listen_stop(void)
{
    uint8_t saved = uci_target;
    uint8_t cmd[] = {0x00, NET_CMD_TCP_LISTENER_STOP};

    uci_settarget(UCI_TARGET_NETWORK);
    uci_sendcommand(cmd, 2);
    uci_readdata();
    uci_readstatus();
    uci_accept();

    uci_target = saved;
    return uci_data[0] | (uci_data[1] << 8);
}

int uci_tcp_get_listen_state(void)
{
    uint8_t saved = uci_target;
    uint8_t cmd[] = {0x00, NET_CMD_GET_LISTENER_STATE};

    uci_settarget(UCI_TARGET_NETWORK);
    uci_sendcommand(cmd, 2);
    uci_readdata();
    uci_readstatus();
    uci_accept();

    uci_target = saved;
    return uci_data[0] | (uci_data[1] << 8);
}

uint8_t uci_tcp_get_listen_socket(void)
{
    uint8_t saved = uci_target;
    uint8_t cmd[] = {0x00, NET_CMD_GET_LISTENER_SOCKET};

    uci_settarget(UCI_TARGET_NETWORK);
    uci_sendcommand(cmd, 2);
    uci_readdata();
    uci_readstatus();
    uci_accept();

    uci_target = saved;
    return uci_data[0];
}

//-----------------------------------------------------------------------------
// Network - convenience read functions
//-----------------------------------------------------------------------------

char uci_tcp_nextchar(uint8_t socketid)
{
    char result;

    if (uci_data_index < uci_data_len)
    {
        result = uci_data[uci_data_index + 2];
        uci_data_index++;
    }
    else
    {
        do
        {
            uci_data_len = uci_socket_read(socketid, UCI_DATA_QUEUE_SZ - 4);
            if (uci_data_len == 0)
                return 0; // EOF
        } while (uci_data_len == -1);

        result = uci_data[2];
        uci_data_index = 1;
    }
    return result;
}

static int uci_tcp_nextline_internal(uint8_t socketid, char *result, bool swapcase)
{
    int c, count = 0;
    *result = 0;

    while ((c = uci_tcp_nextchar(socketid)) != 0 && c != 0x0A)
    {
        if (c == 0x0D)
            continue;

        if (swapcase)
        {
            if ((c >= 97 && c <= 122) || (c >= 193 && c <= 218))
                c &= 95;
            else if (c >= 65 && c <= 90)
                c |= 32;
        }
        result[count++] = c;
    }
    result[count] = 0;
    return c != 0 || count > 0;
}

int uci_tcp_nextline(uint8_t socketid, char *result)
{
    return uci_tcp_nextline_internal(socketid, result, false);
}

int uci_tcp_nextline_ascii(uint8_t socketid, char *result)
{
    return uci_tcp_nextline_internal(socketid, result, true);
}

void uci_tcp_emptybuffer(void)
{
    uci_data_index = 0;
}

void uci_reset_data(void)
{
    uci_data_len = 0;
    uci_data_index = 0;
    memset(uci_data, 0, UCI_DATA_QUEUE_SZ * 2);
    memset(uci_status, 0, UCI_STATUS_QUEUE_SZ);
}

//-----------------------------------------------------------------------------
// Drive control
//-----------------------------------------------------------------------------

void uci_enable_drive_a(void)
{
    uint8_t cmd[] = {0x00, CTRL_CMD_ENABLE_DISK_A};
    uci_settarget(UCI_TARGET_CONTROL);
    uci_sendcommand(cmd, 2);
    uci_readdata();
    uci_readstatus();
    uci_accept();
}

void uci_disable_drive_a(void)
{
    uint8_t cmd[] = {0x00, CTRL_CMD_DISABLE_DISK_A};
    uci_settarget(UCI_TARGET_CONTROL);
    uci_sendcommand(cmd, 2);
    uci_readdata();
    uci_readstatus();
    uci_accept();
}

void uci_enable_drive_b(void)
{
    uint8_t cmd[] = {0x00, CTRL_CMD_ENABLE_DISK_B};
    uci_settarget(UCI_TARGET_CONTROL);
    uci_sendcommand(cmd, 2);
    uci_readdata();
    uci_readstatus();
    uci_accept();
}

void uci_disable_drive_b(void)
{
    uint8_t cmd[] = {0x00, CTRL_CMD_DISABLE_DISK_B};
    uci_settarget(UCI_TARGET_CONTROL);
    uci_sendcommand(cmd, 2);
    uci_readdata();
    uci_readstatus();
    uci_accept();
}

//-----------------------------------------------------------------------------
// Time
//-----------------------------------------------------------------------------

void uci_get_time(void)
{
    uint8_t cmd[] = {0x00, DOS_CMD_GET_TIME};
    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, 2);
    uci_readdata();
    uci_readstatus();
    uci_accept();
}

void uci_set_time(const char *data)
{
    uint8_t cmd[8];
    int x;

    cmd[0] = 0x00;
    cmd[1] = DOS_CMD_SET_TIME;
    for (x = 0; x < 6; x++)
        cmd[x + 2] = data[x];

    uci_settarget(UCI_TARGET_DOS1);
    uci_sendcommand(cmd, 8);
    uci_readstatus();
    uci_accept();
}

//-----------------------------------------------------------------------------
// Control
//-----------------------------------------------------------------------------

void uci_freeze(void)
{
    uint8_t cmd[] = {0x00, 0x05};
    uci_settarget(UCI_TARGET_CONTROL);
    uci_sendcommand(cmd, 2);
    uci_readdata();
    uci_readstatus();
    uci_accept();
}
