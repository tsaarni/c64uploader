# Assembly64 Browser - C64 Client

Native C64 client for browsing the Assembly64 database via Ultimate II+ network interface.

## Requirements

- **oscar64** compiler - https://github.com/drmortalwombat/oscar64
- **Ultimate II+** or **Ultimate 64** with network enabled
- Optionally: VICE emulator for testing

## Building

```bash
# Build PRG file
make prg

# Build CRT cartridge
make crt

# Build D64 disk image (requires VICE c1541)
make d64
```

## Running

### In VICE emulator
```bash
make run
```

### On real hardware
1. Copy `build/a64browser.prg` to your Ultimate II+ USB drive
2. Or use FTP: `U2P_HOST=192.168.1.x make deploy`

## Project Structure

```
c64client/
├── src/
│   ├── main.c        - Main client application
│   ├── ultimate.h    - Ultimate II+ library header
│   └── ultimate.c    - Ultimate II+ library (ported from cc65)
├── build/            - Output directory
├── Makefile
└── README.md
```

## Ultimate II+ Library

The `ultimate.h/c` library provides access to Ultimate II+ Command Interface:

### Network functions
- `uci_tcp_connect(host, port)` - Connect to TCP server
- `uci_socket_read(socket, length)` - Read from socket
- `uci_socket_write(socket, data)` - Write to socket
- `uci_socket_close(socket)` - Close connection

### Convenience functions
- `uci_tcp_nextchar(socket)` - Read single character
- `uci_tcp_nextline(socket, buffer)` - Read line

### DOS functions
- `uci_identify()` - Check Ultimate presence
- `uci_getipaddress()` - Get IP address
- `uci_change_dir(path)` - Change directory
- `uci_open_file(attrib, name)` - Open file
- etc.

## Server Protocol

See [`../uploader/C64PROTOCOL.md`](../uploader/C64PROTOCOL.md) for details.

## Configuration

Edit `main.c` to set your server IP:
```c
#define SERVER_HOST "192.168.1.100"
#define SERVER_PORT 6400
```

## Credits

- Ultimate II+ library ported from [ultimateii-dos-lib](https://github.com/xlar54/ultimateii-dos-lib) by Scott Hutter, Francesco Sblendorio
- Oscar64 compiler by DrMortalWombat
