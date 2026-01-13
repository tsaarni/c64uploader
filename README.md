# C64 Ultimate Uploader

Remotely upload and run programs on Commodore 64 Ultimate via its [REST API](https://1541u-documentation.readthedocs.io/en/latest/api/api_calls.html).

> [!NOTE]
> This code was generated with GitHub Copilot and Claude Code and is not thoroughly tested or reviewed.

## Features

The program can be used as:
- **Command-line tool** - Upload and run a specific local file or poke memory
- **Text-based UI (TUI)** - Browse and run programs from Assembly64 collection
- **Telnet server** - Access Assembly64 browser via any telnet client (ANSI terminal)
- **Native protocol server** - For the C64 native client (included)

Following file types are supported:

- `.prg` - C64 program files (direct upload and run)
- `.crt` - Cartridge images (direct upload and run)
- `.d64`, `.g64`, `.d71`, `.d81` - Disk images (uploads via FTP to `/Temp`, mounts as drive A, extracts and runs first PRG via DMA)

The file type is auto-detected based on the file extension.

## Usage

### TUI Mode

Launch without arguments to browse and upload files from Assembly64 collection:

```bash
./c64uploader [options]
```

Uses Assembly64 collection from local path specified via `-assembly64` option.
Scans `.releaselog.json` metadata files to build the index of available files.

Note that the metadata seems to be incomplete. Not all files are listed in the menu.

### CLI Mode

Upload and run a specific file:

```bash
./c64uploader [options] <filename>
```

### Poke Mode

Issue POKE commands to modify C64 memory (e.g., change border color, enable cheats):

```bash
./c64uploader [options] poke <address>,<value>
```

* `address` - Memory address to poke (0-65535 or 0x0000-0xFFFF or $0000-$FFFF)
* `value` - Value to write (0-255 or 0x00-0xFF or $00-$FF)

### Telnet Server Mode

Start a telnet server for remote Assembly64 browsing with ANSI terminal support:

```bash
./c64uploader [options] -telnet <port>
```

Example:
```bash
./c64uploader -host 192.168.2.100 -assembly64 ~/Assembly64 -telnet 2323
```

Then connect from any telnet client:
```bash
telnet localhost 2323
```

Features:
- Full ANSI color terminal interface
- Arrow key navigation, search, category browsing
- Works with any telnet client (PuTTY, terminal, etc.)

### Native Protocol Server Mode

Start a native protocol server for the C64 client:

```bash
./c64uploader [options] -native <port>
```

Example:
```bash
./c64uploader -host 192.168.2.100 -assembly64 ~/Assembly64 -native 6465
```

The native protocol is a simple line-based protocol optimized for low-bandwidth C64 communication.

### Common Options

| Option | Description | Default |
|--------|-------------|---------|
| `-host` | C64 Ultimate hostname or IP | `c64u` |
| `-assembly64` | Path to Assembly64 collection | `~/Downloads/assembly64` |
| `-telnet` | Start telnet server on specified port | (disabled) |
| `-native` | Start native protocol server on specified port | (disabled) |

## C64 Native Client

A native C64 client is included in the `c64client/` directory. It runs directly on the C64 with Ultimate II+ cartridge and connects to the native protocol server.

### Requirements

- [Oscar64](https://github.com/drmortalwombat/oscar64) compiler
- Ultimate II+ or Ultimate 64 with network enabled
- The uploader running with `-native 6465` option

### Installing Oscar64 on Linux

Oscar64 is a C compiler for the C64. To install on Linux:

```bash
# Clone the repository
git clone https://github.com/drmortalwombat/oscar64.git
cd oscar64

# Build using make
make

# Install system-wide (optional)
sudo make install
```

If not installed system-wide, you can set the include path:
```bash
export OSCAR64_INCLUDE=/path/to/oscar64/include
```

Or add `oscar64` directory to your PATH.

### Building the C64 Client

```bash
cd c64client
make prg
```

This produces `build/a64browser.prg`.

### Running on C64

1. Start the server on your PC:
   ```bash
   ./c64uploader -host <ultimate-ip> -assembly64 <path> -native 6465
   ```

2. Copy `build/a64browser.prg` to your Ultimate II+ USB drive

3. Run the program on your C64

4. On startup:
   - Press **C** to configure server IP (saved to `/Usb1/a64browser.cfg`)
   - Press any other key to connect with current settings

### C64 Client Controls

**Category list:**
- **W/S** or cursor keys - Navigate up/down
- **Enter** or right arrow - Enter category
- **/** - Search mode
- **C** - Settings menu
- **Q** - Quit

**Entry list:**
- **W/S** or cursor keys - Navigate up/down
- **Enter** - Run selected entry
- **N/P** - Next/Previous page
- **DEL** or left arrow - Back to categories

**Search mode:**
- Type to search (minimum 2 characters)
- **Enter** - Run selected result
- **DEL** - Delete character or exit search

**Settings:**
- **W/S** - Navigate
- **Enter** - Edit field / Save
- **DEL** - Delete character (in edit) or back (in menu)
- Numbers and `.` - Enter IP address

### Makefile Targets

```bash
make prg      # Build PRG file (default)
make crt      # Build CRT cartridge (16KB)
make d64      # Build D64 disk image
make run      # Run in VICE emulator (x64sc)
make deploy   # Upload to Ultimate via FTP (set U2P_HOST env var)
make runprg   # Run PRG directly on Ultimate via HTTP API
make runcrt   # Run CRT directly on Ultimate via HTTP API
make clean    # Remove build files
```

## Compilation

```bash
go build
```

## Architecture

```
c64uploader/
├── main.go          # Entry point, argument parsing
├── api.go           # Ultimate II+ REST API client
├── index.go         # Assembly64 metadata indexing
├── tui.go           # Text-based UI (Bubble Tea)
├── telnet.go        # Telnet server with ANSI support
├── native.go        # Native protocol server for C64 client
└── c64client/       # Native C64 client
    ├── src/
    │   ├── main.c       # Client application
    │   └── ultimate.c   # UCI library for Ultimate II+
    └── Makefile
```
