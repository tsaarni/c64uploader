# UCI (Ultimate Command Interface) - C Programming Reference

> [!WARNING]
> This document is generated with LLM using the source code in https://github.com/GideonZ/1541ultimate/ as a reference.
> There is no warranty of correctness.

> [!NOTE]
> Official Command Interface documentation can be found at
> * https://1541u-documentation.readthedocs.io/en/latest/command%20interface.html
> * https://github.com/GideonZ/1541ultimate/tree/master/doc

## Prerequisites

The UCI registers are mapped into the C64's I/O space. This mapping is **optional** and must be enabled in the Ultimate settings:

1. Enter the Ultimate menu
2. Go to **C64 and Cartridge Settings**
3. Set **Command Interface** to **Enabled**


### State Machine

The state machine is driven by interactions with the **Control Register** (Write) and **Status Register** (Read).

*   **Control (Write)**: Triggers transitions (e.g., `CTL_PUSH_CMD`, `CTL_DATA_ACC`).
*   **Status (Read)**: Used to monitor the current state (Bits 4-5) and check if data is available (Bit 7).
*   **Result (Read)**: Used to read the actual response data bytes when in a data state.


```
IDLE (0x00)
   |
   | Write CTL_PUSH_CMD
   v
CMD_BUSY (0x10)    <--- Poll Status (Bits 4-5)
   |
   v
DATA_LAST (0x20)   or   DATA_MORE (0x30)
   |                        |
   | While Status Bit 7     | While Status Bit 7
   | is set (0x80):         | is set (0x80):
   | Read CMD_IF_RESULT     | Read CMD_IF_RESULT
   |                        |
   v                        v
Write CTL_DATA_ACC       Write CTL_DATA_ACC
   |                        |
   v                        v
  IDLE                  CMD_BUSY
```


### Base Address Relocability

The UCI base address is not fixed. The system automatically relocates it based on the active cartridge to avoid I/O conflicts. Your code must handle these common addresses:

| Mode | Base Address | Notes |
| :--- | :--- | :--- |
| **Standard** | `$DF1C` | Default for most scenarios and standard cartridges. |
| **EasyFlash** | `$DE1C` | Used when EasyFlash is active. |
| **High** | `$DFFC` | Used for SID player and special modes. |

You can auto-detect the correct base address by probing the **Command Register** (Base + 1). Reading this register returns the fixed identification value **`0xC9`**.

**Detection Logic:**
1.  Read address `$DF1D` (Standard + 1). If `0xC9`, Base is `$DF1C`.
2.  Read address `$DE1D` (EasyFlash + 1). If `0xC9`, Base is `$DE1C`.
3.  Read address `$DFFD` (High + 1). If `0xC9`, Base is `$DFFC`.
4.  If `0xC9` is not found at any of these locations, the UCI is **disabled** (not mapped).

This allows a single client binary to work across all modes without recompilation.

### Register Addresses

```c
// UCI Hardware Registers (Memory-mapped I/O relative to Base Address)
// Common bases: 0xDF1C (Standard), 0xDE1C (EasyFlash), 0xDFFC (SID)
#define UCI_BASE       0xDF1C                 // Change this as needed

#define OUR_DEVICE     (*(volatile unsigned char*)(UCI_BASE-1)) // Device ID register
#define CMD_IF_CONTROL (*(volatile unsigned char*)(UCI_BASE+0)) // Control/Status register
#define CMD_IF_COMMAND (*(volatile unsigned char*)(UCI_BASE+1)) // Command data output
#define CMD_IF_RESULT  (*(volatile unsigned char*)(UCI_BASE+2)) // Result data input
#define CMD_IF_STATUS  (*(volatile unsigned char*)(UCI_BASE+3)) // Status message input

// UCI Identifier
#define UCI_IDENTIFIER 0xC9
```

### Control Register Bit Definitions

```c
// Control Register - Write Operations (writing to $DF1C)
#define CTL_PUSH_CMD    0x01  // Bit 0: Push/execute command
#define CTL_DATA_ACC    0x02  // Bit 1: Acknowledge data, request next block
#define CTL_ABORT       0x04  // Bit 2: Abort current operation
#define CTL_CLR_ERR     0x08  // Bit 3: Clear error flag

// Status Register - Read Operations (reading from $DF1C)
// Bit 0: CMD_BUSY  - Command pending
// Bit 1: DATA_ACC  - Data accepted (reflects write)
// Bit 2: ABORT_P   - Abort pending
// Bit 3: ERROR     - Error occurred
// Bits 4-5: STATE  - Protocol state (see below)
// Bit 6: STAT_AV   - Status data available in $DF1F
// Bit 7: DATA_AV   - Response data available in $DF1E

#define STAT_STATE_BITS    0x30  // Mask for state bits (bits 4-5)
#define STAT_STATE_IDLE    0x00  // 00: Ready for new command
#define STAT_STATE_BUSY    0x10  // 01: Command being processed
#define STAT_STATE_LAST    0x20  // 10: Last data block available
#define STAT_STATE_MORE    0x30  // 11: More data blocks available
#define STAT_STAT_AV       0x40  // Bit 6: Status string available
#define STAT_DATA_AV       0x80  // Bit 7: Response data available

// Buffer size limits
#define CMD_MAX_COMMAND_LEN  896
#define CMD_MAX_REPLY_LEN    896
#define CMD_MAX_STATUS_LEN   256
```

### Target and Command IDs

```c
// Target IDs
#define UCI_TARGET_DOS     0x01  // DOS/File System (also 0x02)
#define UCI_TARGET_NETWORK 0x03  // Network
#define UCI_TARGET_CONTROL 0x04  // Control
#define UCI_TARGET_KERNAL  0x05  // Kernal/File I/O

// DOS Commands
// From Ultimate II source repository: software/filemanager/dos.h
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
#define DOS_CMD_CREATE_DIR     0x16
#define DOS_CMD_GET_TIME       0x26
#define DOS_CMD_SET_TIME       0x27
#define DOS_CMD_MOUNT_DISK     0x23
#define DOS_CMD_UMOUNT_DISK    0x24

// File Open Mode Flags (for DOS_CMD_OPEN_FILE)
// From Ultimate II source repository:software/filesystem/fs_errors_flags.h
#define FA_READ           0x01  // Read access
#define FA_OPEN_EXISTING  0x00  // Open existing file (default)
#define FA_WRITE          0x02  // Write access (file should exist if no create flags set)
#define FA_CREATE_NEW     0x04  // Create new file (file should not exist yet)
#define FA_CREATE_ALWAYS  0x08  // Create or overwrite file (clears contents)
#define FA_CREATE_ANY     (FA_CREATE_NEW | FA_CREATE_ALWAYS)
#define FA_ANY_WRITE_FLAG (FA_CREATE_NEW | FA_CREATE_ALWAYS | FA_WRITE)
#define FA_OPEN_ALWAYS    0x10  // Open existing or create new file
#define FA_OPEN_FROM_CBM  0x80  // Special flag for CBM filesystem access

// Network Commands
// From Ultimate II source repository: software/io/network/network_target.h
#define NET_CMD_IDENTIFY            0x01
#define NET_CMD_GET_INTERFACE_COUNT 0x02
#define NET_CMD_GET_IPADDR          0x05
#define NET_CMD_SET_IPADDR          0x06
#define NET_CMD_OPEN_TCP            0x07
#define NET_CMD_OPEN_UDP            0x08
#define NET_CMD_CLOSE_SOCKET        0x09
#define NET_CMD_READ_SOCKET         0x10
#define NET_CMD_WRITE_SOCKET        0x11
```

### Key Points for Implementing UCI Client

1. **Volatile keyword is critical** - Prevents compiler optimization of register reads
2. **No delays needed** - Just poll in tight loops
3. **Always wait after CMD_PUSH_CMD** - Call `uci_wait_busy()` before reading results
4. **Check DMA_ACTIVE bit (0x80)** before reading data
5. **Handle multi-block transfers** - Check for `CMD_STATE_MORE_DATA` (0x30)
6. **Little-endian byte order** - Low byte first for 16-bit+ values
7. **Null-terminate strings** - When sending string parameters
8. **Always call accept (DATA_ACC) after EVERY command** - This is critical! After reading status, you MUST call accept to return the state machine to IDLE. Failure to do so will cause subsequent commands to fail with "81,invalid params" or similar errors.
9. **Detecting if UCI is not enabled**: Reading from Control Register will return `0xFF` if the Command Interface is not enabled (floating bus). When properly enabled and idle, it should return `0x00`.


### Notes

- Typical response times: microseconds to milliseconds
- Network operations depend on network latency
- File operations depend on SD card speed


You can find the complete implementation details in [`software/io/c64/c64_crt.cc`](https://github.com/GideonZ/1541ultimate/blob/master/software/io/c64/c64_crt.cc) (cartridge configuration), [`software/io/c64/c64.cc`](https://github.com/GideonZ/1541ultimate/blob/master/software/io/c64/c64.cc) (address application), [`software/io/command_interface/command_intf.cc`](https://github.com/GideonZ/1541ultimate/blob/master/software/io/command_interface/command_intf.cc) (default initialization), and [`fpga/io/command_interface/vhdl_source/command_protocol.vhd`](https://github.com/GideonZ/1541ultimate/blob/master/fpga/io/command_interface/vhdl_source/command_protocol.vhd) (hardware logic defining the `0xC9` response).


## General Message Structure

All messages follow this basic structure:
- **Byte 0**: Target ID (0x03 for Network)
- **Byte 1**:  Command ID
- **Bytes 2+**:  Command-specific parameters


## UCI DOS Command Message Structures

### File Operation Commands:

#### **0x01 - DOS_CMD_IDENTIFY**
```
Command:   [target, 0x01]
Length:   2 bytes
Reply:    "ULTIMATE-II DOS V1.2" (20 bytes)
Status:   "00,OK,00,00"
```

#### **0x02 - DOS_CMD_OPEN_FILE**
```
Command:  [target, 0x02, mode, filename...]
Length:   3+ bytes
          - mode: File open mode (see File Open Mode Flags below)
          - filename: Null-terminated filename string
Reply:    Empty
Status:   "00,OK,00,00" or file system error string
Notes:    Opens a file in the current path. Only one file can be open at a time.
```

File Open Mode Flags:

| Flag | Description |
|------|-------------|
| FA_READ | Read access |
| FA_OPEN_EXISTING | Open existing file (default) |
| FA_WRITE | Write access (file should exist if no create flags set) |
| FA_CREATE_NEW | Create new file (file should not exist yet) |
| FA_CREATE_ALWAYS | Create or overwrite file (clears contents) |
| FA_CREATE_ANY | the two above ORred |
| FA_ANY_WRITE_FLAG | the three above ORred |
| FA_OPEN_ALWAYS | Open existing or create new file |
| FA_OPEN_FROM_CBM | Special flag for CBM filesystem access |

Flags can be combined with OR, e.g.:
  - Read-only:       FA_READ
  - Write new file:  FA_WRITE | FA_CREATE_ALWAYS
  - Read-write:      FA_READ | FA_WRITE | FA_OPEN_EXISTING
  - Write/create:    FA_WRITE | FA_OPEN_ALWAYS

#### **0x03 - DOS_CMD_CLOSE_FILE**
```
Command:  [target, 0x03]
Length:   2 bytes
Reply:    Empty
Status:   "00,OK,00,00" or "84,NO FILE TO CLOSE"
```

#### **0x04 - DOS_CMD_READ_DATA**
```
Command:  [target, 0x04, length_low, length_high]
Length:   4 bytes
          - length:  Number of bytes to read (little-endian, max 512)
Reply:    [file_data... ] (variable length, may span multiple messages)
Status:   "00,OK,00,00" or error
Notes:    Enters "data mode" - use get_more_data for additional chunks
```

#### **0x05 - DOS_CMD_WRITE_DATA**
```
Command:  [target, 0x05, length_low, length_high, data...]
Length:   4+ bytes
          - length: Number of bytes being written (little-endian)
          - data: Bytes to write
Reply:    Empty
Status:   "00,OK,00,00" or "85,NO FILE OPEN" or file system error
```

#### **0x06 - DOS_CMD_FILE_SEEK**
```
Command:  [target, 0x06, pos0, pos1, pos2, pos3]
Length:   6 bytes
          - pos:  32-bit file position (little-endian)
Reply:    Empty
Status:   "00,OK,00,00" or "85,NO FILE OPEN" or error
```

#### **0x07 - DOS_CMD_FILE_INFO**
```
Command:  [target, 0x07]
Length:   2 bytes
Reply:    [size(4), date(2), time(2), ext(3), attrib(1), filename...]
          - size: 32-bit file size (little-endian)
          - date: 16-bit DOS date (little-endian)
          - time: 16-bit DOS time (little-endian)
          - ext: 3-byte extension
          - attrib: File attributes
          - filename: Null-terminated filename (max 64 chars)
Status:   "00,OK,00,00" or "85,NO FILE OPEN"
Notes:    Returns info about currently open file
```

#### **0x08 - DOS_CMD_FILE_STAT**
```
Command:  [target, 0x08, filename...]
Length:   3+ bytes
          - filename: Null-terminated filename string
Reply:    [size(4), date(2), time(2), ext(3), attrib(1), filename...]
          (Same structure as FILE_INFO)
Status:   "00,OK,00,00" or "82,FILE NOT FOUND"
Notes:    Returns file info without opening the file
```

#### **0x09 - DOS_CMD_DELETE_FILE**
```
Command:  [target, 0x09, filename...]
Length:   3+ bytes
          - filename: Null-terminated filename string
Reply:    Empty
Status:   "00,OK,00,00" or file system error
```

#### **0x0A - DOS_CMD_RENAME_FILE**
```
Command:  [target, 0x0A, oldname\0, newname\0]
Length:    4+ bytes
          - oldname:  Null-terminated old filename
          - newname: Null-terminated new filename
Reply:    Empty
Status:   "00,OK,00,00" or file system error
```

#### **0x0B - DOS_CMD_COPY_FILE**
```
Command:  [target, 0x0B, filename\0, destination\0]
Length:   4+ bytes
          - filename:  Null-terminated source filename
          - destination: Null-terminated destination path
Reply:    Empty
Status:    "00,OK,00,00" or file system error
```

### Directory Operation Commands:

#### **0x11 - DOS_CMD_CHANGE_DIR**
```
Command:  [target, 0x11, path...]
Length:   3+ bytes
          - path: Null-terminated directory path (can be relative or absolute)
Reply:    Empty
Status:   "00,OK,00,00" or "83,NO SUCH DIRECTORY"
```

#### **0x12 - DOS_CMD_GET_PATH**
```
Command:  [target, 0x12]
Length:   2 bytes
Reply:    [current_path... ] (null-terminated string)
Status:   "00,OK,00,00"
```

#### **0x13 - DOS_CMD_OPEN_DIR**
```
Command:  [target, 0x13]
Length:   2 bytes
Reply:    Empty
Status:   "00,OK,00,00" or "86,CAN'T READ DIRECTORY" or "01,DIRECTORY EMPTY"
Notes:    Prepares directory listing for reading with READ_DIR
```

#### **0x14 - DOS_CMD_READ_DIR**
```
Command:  [target, 0x14]
Length:   2 bytes
Reply:    Multiple directory entries, each:
          [size(4), date(2), time(2), ext(3), attrib(1), filename...]
          (Same structure as FILE_STAT reply)
Status:   "00,OK,00,00"
Notes:    Enters "data mode" - use get_more_data for additional entries
```

#### **0x15 - DOS_CMD_COPY_UI_PATH**
```
Command:  [target, 0x15]
Length:   2 bytes
Reply:    Empty
Status:    "99,FUNCTION NOT IMPLEMENTED"
```

#### **0x16 - DOS_CMD_CREATE_DIR**
```
Command:  [target, 0x16, dirname...]
Length:   3+ bytes
          - dirname: Null-terminated directory name
Reply:    Empty
Status:   "00,OK,00,00" or file system error
```

#### **0x17 - DOS_CMD_COPY_HOME_PATH**
```
Command:  [target, 0x17]
Length:   2 bytes
Reply:    [home_path...] (null-terminated string)
Status:   "00,OK,00,00" or error
Notes:    Changes to home directory and returns the path
```

### REU/Memory Commands:

#### **0x21 - DOS_CMD_LOAD_REU**
```
Command:  [target, 0x21, addr0, addr1, addr2, addr3, length0, length1, length2, length3]
Length:   10 bytes
          - addr:  32-bit REU memory address (little-endian)
          - length: 32-bit number of bytes to load (little-endian)
Reply:    Empty
Status:   "00,OK,00,00" or "85,NO FILE OPEN" or error
Notes:    Loads file data directly into REU memory
```

#### **0x22 - DOS_CMD_SAVE_REU**
```
Command:  [target, 0x22, addr0, addr1, addr2, addr3, length0, length1, length2, length3]
Length:   10 bytes
          - addr: 32-bit REU memory address (little-endian)
          - length: 32-bit number of bytes to save (little-endian)
Reply:    [bytes_written(4)] (32-bit little-endian)
Status:   "00,OK,00,00" or "85,NO FILE OPEN" or error
Notes:    Saves REU memory directly to file
```

### Disk Image Commands:

#### **0x23 - DOS_CMD_MOUNT_DISK**
```
Command:  [target, 0x23, drive_id, filename...]
Length:   4+ bytes
          - drive_id: Drive number (8-11 for drives A-D)
          - filename: Null-terminated disk image filename
Reply:    Empty
Status:   "00,OK,00,00" or error codes:
          - "82,FILE NOT FOUND"
          - "89,NOT A DISK IMAGE"
          - "90,DRIVE NOT PRESENT"
          - "91,INCOMPATIBLE IMAGE"
```

#### **0x24 - DOS_CMD_UMOUNT_DISK**
```
Command:  [target, 0x24, drive_id]
Length:   3 bytes
          - drive_id: Drive number to unmount
Reply:    Empty
Status:   "00,OK,00,00" or "90,DRIVE NOT PRESENT"
```

#### **0x25 - DOS_CMD_SWAP_DISK**
```
Command:  [target, 0x25, drive_id]
Length:   3 bytes
          - drive_id: Drive number to swap disk sides
Reply:    Empty
Status:    "00,OK,00,00" or "90,DRIVE NOT PRESENT"
Notes:    Swaps between sides of dual-sided disk images (D71, D81)
```

### Time Commands:

#### **0x26 - DOS_CMD_GET_TIME**
```
Command:  [target, 0x26, format]
Length:   2 or 3 bytes
          - format: Optional format selector (0=default, 1=extended)
Reply:    Format 0: "WD DD. MM.YY HH:MM:SS" (23 bytes)
          Format 1: [year, month, day, weekday, hour, min, sec] (7 bytes)
Status:   "00,OK,00,00"
```

#### **0x27 - DOS_CMD_SET_TIME**
```
Command:  [target, 0x27, year, month, day, hour, min, sec]
Length:   8 bytes
          - year: Years since 1980 (0-127)
          - month: 1-12
          - day: 1-31
          - hour:  0-23
          - min: 0-59
          - sec: 0-59
Reply:    [formatted_time... ] (23 bytes, same as GET_TIME format 0)
Status:   "00,OK,00,00" or "98,FUNCTION PROHIBITED"
```

### RAMDisk Commands:

#### **0x41 - CTRL_CMD_LOAD_INTO_RAMDISK**
```
Command:  [target, 0x41, drive_id, filename...]
Length:   4+ bytes
          - drive_id: RAMDisk drive number (bit 7 set = "what-if" mode)
          - filename: Null-terminated disk image filename
Reply:    Empty
Status:   "00,OK,00,00" or error
Notes:    Loads disk image into RAM disk
```

#### **0x42 - CTRL_CMD_SAVE_RAMDISK**
```
Command:  [target, 0x42, drive_id, filename...]
Length:   4+ bytes
          - drive_id: RAMDisk drive number
          - filename: Null-terminated destination filename
Reply:    Empty
Status:   "00,OK,00,00" or error
Notes:     Saves RAM disk contents to disk image file
```

### Utility Commands:

#### **0xF0 - DOS_CMD_ECHO**
```
Command:  [target, 0xF0, data...]
Length:   2+ bytes
          - data: Any data to echo back
Reply:    Same as command (echo of input data)
Status:   "00,OK,00,00"
Notes:    Test command that echoes back the input
```

### Common DOS Error Status Messages:
- `"00,OK,00,00"` - Success
- `"01,DIRECTORY EMPTY"` - No entries in directory
- `"02,REQUEST TRUNCATED"` - Request was truncated
- `"81,NOT IN DATA MODE"` - Command requires data mode first
- `"82,FILE NOT FOUND"` - File does not exist
- `"83,NO SUCH DIRECTORY"` - Directory does not exist
- `"84,NO FILE TO CLOSE"` - No file is currently open
- `"85,NO FILE OPEN"` - Operation requires an open file
- `"86,CAN'T READ DIRECTORY"` - Directory read failed
- `"87,INTERNAL ERROR"` - Internal error occurred
- `"88,NO INFORMATION AVAILABLE"` - No info available
- `"89,NOT A DISK IMAGE"` - File is not a valid disk image
- `"90,DRIVE NOT PRESENT"` - Drive ID not available
- `"91,INCOMPATIBLE IMAGE"` - Image type incompatible with drive
- `"98,FUNCTION PROHIBITED"` - Function not allowed
- `"99,FUNCTION NOT IMPLEMENTED"` - Feature not implemented

### Notes:
- All multi-byte integers use **little-endian** format
- Strings are **null-terminated**
- Maximum data message length:  512 bytes
- The DOS maintains state (idle, in_file, in_directory)
- Only one file can be open at a time
- Directory listings use "get_more_data" for pagination

You can find the complete implementation in [`software/filemanager/dos.cc`](https://github.com/GideonZ/1541ultimate/blob/912875ee6482f8b9d8b06cb9d0d2ca7955ba4a1e/software/filemanager/dos.cc), [`software/filemanager/dos.h`](https://github.com/GideonZ/1541ultimate/blob/912875ee6482f8b9d8b06cb9d0d2ca7955ba4a1e/software/filemanager/dos.h), and [`software/filesystem/fs_errors_flags.h`](https://github.com/markusC64/1541ultimate2/blob/ec4328b5090947d91afc887c2a4f46c9303cffcb/software/filesystem/fs_errors_flags.h).

Based on the code I've found, here's the complete message structure for each UCI network command:

## UCI Network Command Message Structures

### Command Structures:

#### **0x01 - NET_CMD_IDENTIFY**
```
Command:   [0x03, 0x01]
Length:   2 bytes
Reply:    "ULTIMATE-II NETWORK INTERFACE V1.0" (34 bytes)
Status:   "00,OK,00,00"
```

#### **0x02 - NET_CMD_GET_INTERFACE_COUNT**
```
Command:  [0x03, 0x02]
Length:   2 bytes
Reply:    [count] (1 byte - number of network interfaces)
Status:   "00,OK,00,00"
```

#### **0x03 - NET_CMD_SET_INTERFACE** *(commented out in code)*
```
Command:  [0x03, 0x03, interface_number]
Length:   3 bytes
Reply:    Empty
Status:   "00,OK,00,00" or error
```

#### **0x04 - NET_CMD_GET_NETADDR** (Get MAC Address)
```
Command:  [0x03, 0x04, interface_number]
Length:   3 bytes
Reply:    [mac0, mac1, mac2, mac3, mac4, mac5] (6 bytes)
Status:   "00,OK,00,00" or error
```

#### **0x05 - NET_CMD_GET_IPADDR**
```
Command:  [0x03, 0x05, interface_number]
Length:   3 bytes
Reply:    [IP address, netmask, gateway] (12 bytes total - 4 bytes each)
Status:   "00,OK,00,00" or error
```

#### **0x06 - NET_CMD_SET_IPADDR**
```
Command:  [0x03, 0x06, interface_number, ip0, ip1, ip2, ip3,
           mask0, mask1, mask2, mask3, gw0, gw1, gw2, gw3]
Length:   15 bytes (2 header + 1 interface + 12 IP data)
Reply:    Empty
Status:    "00,OK,00,00" or error
```

#### **0x07 - NET_CMD_OPEN_TCP**
```
Command:  [0x03, 0x07, port_low, port_high, hostname...]
Length:   5+ bytes (minimum:  2 header + 2 port + 1+ hostname)
          - port_low:  Low byte of port number
          - port_high: High byte of port number
          - hostname: Null-terminated hostname or IP string
Reply:    [socket_number] (1 byte, 0-255)
Status:   "00,OK,00,00" or error codes:
          - "84,UNRESOLVED HOST"
          - "85,ERROR OPENING SOCKET"
          - "11,ERROR ON CONNECT:  <errno>"
```

#### **0x08 - NET_CMD_OPEN_UDP**
```
Command:  [0x03, 0x08, port_low, port_high, hostname...]
Length:   5+ bytes (same structure as OPEN_TCP)
Reply:    [socket_number] (1 byte, 0-255)
Status:   Same as OPEN_TCP
```

#### **0x09 - NET_CMD_CLOSE_SOCKET**
```
Command:  [0x03, 0x09, socket_number]
Length:   3 bytes
Reply:    Empty
Status:   "00,OK,00,00" or error
```

#### **0x10 - NET_CMD_READ_SOCKET**
```
Command:  [0x03, 0x10, socket_number, length_low, length_high]
Length:    5 bytes
          - socket_number: Socket to read from (0-255)
          - length_low: Low byte of bytes to read
          - length_high: High byte of bytes to read
          - Max read length: CMD_MAX_REPLY_LEN - 2 (894 bytes)
Reply:    [bytes_read_low, bytes_read_high, data...]
          - First 2 bytes: Number of bytes actually read (little-endian)
          - Remaining bytes: The actual data
Status:   "00,OK,00,00" or error codes:
          - "01,CONNECTION CLOSED BY HOST"
          - "02,NO DATA:  <errno>"
```

#### **0x11 - NET_CMD_WRITE_SOCKET**
```
Command:  [0x03, 0x11, socket_number, data...]
Length:   3+ bytes
          - socket_number: Socket to write to
          - data:  Bytes to send (length = command->length - 3)
Reply:    [bytes_written_low, bytes_written_high]
          - Number of bytes actually written (little-endian)
Status:   "00,OK,00,00" or "12,SEND ERROR:  <errno>"
```

### Common Error Status Messages:
- `"00,OK,00,00"` - Success
- `"81,INVALID PARAMS"` - Invalid parameter count
- `"82,PARAMETER(S) OUT OF RANGE"` - Parameter value out of range
- `"83,INTERFACE NOT AVAILABLE"` - Network interface not available
- `"86,INTERNAL ERROR"` - Internal error occurred

### Notes:
- All multi-byte integers use **little-endian** format (low byte first)
- Maximum command length:  896 bytes
- Maximum reply length: 896 bytes
- Hostnames in OPEN_TCP/UDP are null-terminated strings
- Socket numbers are limited to 0-255

You can find the complete implementation in [`software/io/network/network_target.cc`](https://github.com/GideonZ/1541ultimate/blob/912875ee6482f8b9d8b06cb9d0d2ca7955ba4a1e/software/io/network/network_target.cc).
