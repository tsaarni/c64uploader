/*****************************************************************
 * Ultimate 64/II+ Command Library for Oscar64
 *
 * Ported from cc65 version by Scott Hutter, Francesco Sblendorio
 * Oscar64 port for c64uploader project
 *
 * Based on ultimate_dos-1.2.docx and command interface.docx
 * https://github.com/markusC64/1541ultimate2/tree/master/doc
 *****************************************************************/

#ifndef _ULTIMATE_H_
#define _ULTIMATE_H_

#include <stdint.h>
#include <stdbool.h>

// Hardware registers for Ultimate II+ Command Interface
#define UCI_CONTROL_REG    ((volatile uint8_t*)0xDF1C)
#define UCI_STATUS_REG     ((volatile uint8_t*)0xDF1C)
#define UCI_CMD_DATA_REG   ((volatile uint8_t*)0xDF1D)
#define UCI_ID_REG         ((volatile uint8_t*)0xDF1D)
#define UCI_RESP_DATA_REG  ((volatile uint8_t*)0xDF1E)
#define UCI_STATUS_DATA_REG ((volatile uint8_t*)0xDF1F)

// Control register bits
#define UCI_CTRL_PUSH_CMD   0x01
#define UCI_CTRL_DATA_ACC   0x02
#define UCI_CTRL_ABORT      0x04
#define UCI_CTRL_CLR_ERR    0x08

// Status register bits
#define UCI_STAT_CMD_BUSY   0x01
#define UCI_STAT_DATA_ACC   0x02
#define UCI_STAT_ABORT_P    0x04
#define UCI_STAT_ERROR      0x08
#define UCI_STAT_STATE_MASK 0x30
#define UCI_STAT_STAT_AV    0x40
#define UCI_STAT_DATA_AV    0x80

// Buffer sizes
#define UCI_DATA_QUEUE_SZ   896
#define UCI_STATUS_QUEUE_SZ 256

// Target IDs
#define UCI_TARGET_DOS1     0x01
#define UCI_TARGET_DOS2     0x02
#define UCI_TARGET_NETWORK  0x03
#define UCI_TARGET_CONTROL  0x04

// DOS commands
#define DOS_CMD_IDENTIFY       0x01
#define DOS_CMD_OPEN_FILE      0x02
#define DOS_CMD_CLOSE_FILE     0x03
#define DOS_CMD_READ_DATA      0x04
#define DOS_CMD_WRITE_DATA     0x05
#define DOS_CMD_FILE_SEEK      0x06
#define DOS_CMD_FILE_INFO      0x07
#define DOS_CMD_FILE_STAT      0x08
#define DOS_CMD_DELETE_FILE    0x09
#define DOS_CMD_RENAME_FILE    0x0A
#define DOS_CMD_COPY_FILE      0x0B
#define DOS_CMD_CHANGE_DIR     0x11
#define DOS_CMD_GET_PATH       0x12
#define DOS_CMD_OPEN_DIR       0x13
#define DOS_CMD_READ_DIR       0x14
#define DOS_CMD_COPY_UI_PATH   0x15
#define DOS_CMD_CREATE_DIR     0x16
#define DOS_CMD_COPY_HOME_PATH 0x17
#define DOS_CMD_LOAD_REU       0x21
#define DOS_CMD_SAVE_REU       0x22
#define DOS_CMD_MOUNT_DISK     0x23
#define DOS_CMD_UMOUNT_DISK    0x24
#define DOS_CMD_SWAP_DISK      0x25
#define DOS_CMD_GET_TIME       0x26
#define DOS_CMD_SET_TIME       0x27

// Control commands
#define CTRL_CMD_ENABLE_DISK_A  0x30
#define CTRL_CMD_DISABLE_DISK_A 0x31
#define CTRL_CMD_ENABLE_DISK_B  0x32
#define CTRL_CMD_DISABLE_DISK_B 0x33
#define CTRL_CMD_DRIVE_A_POWER  0x34
#define CTRL_CMD_DRIVE_B_POWER  0x35
#define DOS_CMD_ECHO            0xF0

// Network commands
#define NET_CMD_GET_INTERFACE_COUNT 0x02
#define NET_CMD_GET_IP_ADDRESS      0x05
#define NET_CMD_TCP_SOCKET_CONNECT  0x07
#define NET_CMD_UDP_SOCKET_CONNECT  0x08
#define NET_CMD_SOCKET_CLOSE        0x09
#define NET_CMD_SOCKET_READ         0x10
#define NET_CMD_SOCKET_WRITE        0x11
#define NET_CMD_TCP_LISTENER_START  0x12
#define NET_CMD_TCP_LISTENER_STOP   0x13
#define NET_CMD_GET_LISTENER_STATE  0x14
#define NET_CMD_GET_LISTENER_SOCKET 0x15

// Listener states
#define NET_LISTENER_NOT_LISTENING  0x00
#define NET_LISTENER_LISTENING      0x01
#define NET_LISTENER_CONNECTED      0x02
#define NET_LISTENER_BIND_ERROR     0x03
#define NET_LISTENER_PORT_IN_USE    0x04

// Global buffers
extern char uci_status[UCI_STATUS_QUEUE_SZ];
extern char uci_data[UCI_DATA_QUEUE_SZ * 2];

// Check if last command succeeded (status starts with "00")
// Note: inline function instead of macro due to oscar64 preprocessor quirk
inline bool uci_success(void)
{
    return uci_status[0] == '0' && uci_status[1] == '0';
}

// Low-level functions
void uci_settarget(uint8_t id);
void uci_sendcommand(uint8_t *bytes, int count);
int  uci_readdata(void);
int  uci_readstatus(void);
void uci_accept(void);
void uci_abort(void);
bool uci_isdataavailable(void);
bool uci_isstatusdataavailable(void);

// Identification
void uci_identify(void);

// Directory operations
void uci_get_path(void);
void uci_open_dir(void);
void uci_get_dir(void);
void uci_change_dir(const char *directory);
void uci_create_dir(const char *directory);
void uci_change_dir_home(void);

// File operations
void uci_open_file(uint8_t attrib, const char *filename);
void uci_close_file(void);
void uci_read_file(uint8_t length);
void uci_write_file(uint8_t *data, int length);
void uci_delete_file(const char *filename);
void uci_rename_file(const char *filename, const char *newname);
void uci_copy_file(const char *sourcefile, const char *destfile);

// Disk operations
void uci_mount_disk(uint8_t id, const char *filename);
void uci_unmount_disk(uint8_t id);
void uci_swap_disk(uint8_t id);

// Network - basic
void uci_getinterfacecount(void);
void uci_getipaddress(void);

// Network - TCP
uint8_t uci_tcp_connect(const char *host, uint16_t port);
uint8_t uci_udp_connect(const char *host, uint16_t port);
void    uci_socket_close(uint8_t socketid);
int     uci_socket_read(uint8_t socketid, uint16_t length);
void    uci_socket_write(uint8_t socketid, const char *data);
void    uci_socket_write_char(uint8_t socketid, char c);
void    uci_socket_write_ascii(uint8_t socketid, const char *data);

// Network - TCP listener
int     uci_tcp_listen_start(uint16_t port);
int     uci_tcp_listen_stop(void);
int     uci_tcp_get_listen_state(void);
uint8_t uci_tcp_get_listen_socket(void);

// Network - convenience read functions
char uci_tcp_nextchar(uint8_t socketid);
int  uci_tcp_nextline(uint8_t socketid, char *result);
int  uci_tcp_nextline_ascii(uint8_t socketid, char *result);
void uci_tcp_emptybuffer(void);
void uci_reset_data(void);

// Drive control
void uci_enable_drive_a(void);
void uci_disable_drive_a(void);
void uci_enable_drive_b(void);
void uci_disable_drive_b(void);

// Time
void uci_get_time(void);
void uci_set_time(const char *data);

// Control
void uci_freeze(void);

#endif // _ULTIMATE_H_
