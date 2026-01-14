# C64 Ultimate Uploader

Remotely upload and run programs on Commodore 64 Ultimate via its [REST API](https://1541u-documentation.readthedocs.io/en/latest/api/api_calls.html).

> [!NOTE]
> This code was generated with AI coding assistant and is not thoroughly tested or reviewed.

## Features

The `c64uploader` can be used as:
- **Command-line tool** - Upload and run a specific local file or remote URL, or poke memory
- **Text-based UI (TUI)** - Browse and run programs from local Assembly64 collection
- **Server for C64 client** - For browsing and running programs directly on C64 (included)

Following file types are supported:

- `.prg` - C64 program files (direct upload and run)
- `.crt` - Cartridge images (direct upload and run)
- `.d64`, `.g64`, `.d71`, `.d81` - Disk images (uploads via FTP to `/Temp`, mounts as drive A, extracts and runs first PRG via DMA)

The file type is auto-detected based on the file extension.

## Usage

The program uses a subcommand-based interface. Run `c64uploader <command> [options] [arguments]`.

### TUI Mode

Browse and upload files from local Assembly64 collection to C64 Ultimate using an interactive terminal UI:

```bash
./c64uploader tui [options]
```

**Options:**
- `-host <ip>` - C64 Ultimate hostname or IP address (default: `c64u`)
- `-assembly64 <path>` - Path to Assembly64 collection (default: `~/Downloads/assembly64`)
- `-v` - Enable verbose debug logging

Uses Assembly64 collection from local path specified via `-assembly64` option.
Scans `.releaselog.json` metadata files to build the index of available files.

Note that the metadata seems to be incomplete. Not all files are listed in the menu.

### Load Mode

Upload and run a specific file (PRG, CRT, D64, etc.) from a local path or remote URL:

```bash
./c64uploader load [options] <filename|url>
```

**Options:**
- `-host <ip>` - C64 Ultimate hostname or IP address (default: `c64u`)
- `-v` - Enable verbose debug logging

**Examples:**
```bash
# Load from local file
./c64uploader load -host 192.168.2.100 ~/games/space_invaders.prg

# Load from remote URL
./c64uploader load https://example.com/foo.d64
```

### FTP Mode

Upload a file to C64 Ultimate via FTP from a local path or remote URL:

```bash
./c64uploader ftp [options] <filename|url> <destination>
```

**Options:**
- `-host <ip>` - C64 Ultimate hostname or IP address (default: `c64u`)
- `-v` - Enable verbose debug logging

**Examples:**
```bash
# Upload from local file
./c64uploader ftp -host 192.168.2.100 ~/games/space_invaders.prg /Temp/space_invaders.prg

# Upload from remote URL
./c64uploader ftp https://example.com/foo.prg /Temp
```

### Poke Mode

Issue POKE commands to modify C64 memory (e.g., change border color, enable cheats):

```bash
./c64uploader poke [options] <address>,<value>
```

* `address` - Memory address to poke (0-65535 or 0x0000-0xFFFF or $0000-$FFFF)
* `value` - Value to write (0-255 or 0x00-0xFF or $00-$FF)

**Options:**
- `-host <ip>` - C64 Ultimate hostname or IP address (default: `c64u`)
- `-v` - Enable verbose debug logging

**Examples:**
```bash
./c64uploader poke 53280,0      # Decimal address and value (black border)
./c64uploader poke 0xD020,1     # Hex address with 0x prefix (white border)
./c64uploader poke $D020,2      # Hex address with $ prefix (red border)
./c64uploader poke D020,5       # Hex address without prefix (green border)
```

### Server Mode

Start the C64 protocol server for the C64 client:

```bash
./c64uploader server [options]
```

**Options:**
- `-host <ip>` - C64 Ultimate hostname or IP address (default: `c64u`)
- `-assembly64 <path>` - Path to Assembly64 collection (default: `~/Downloads/assembly64`)
- `-port <port>` - C64 protocol server port (default: `6465`)
- `-v` - Enable verbose debug logging

**Example:**
```bash
./c64uploader server -host 192.168.2.100 -assembly64 ~/Assembly64 -port 6465
```

The C64 protocol is a simple line-based protocol optimized for low-bandwidth C64 communication.
See `uploader/C64PROTOCOL.md` for details.

## C64 Client

A native C64 client is included in the `c64client/` directory.
It runs directly on the C64 Ultimate and connects to the `c64uploader` server.
Network and FTP File Service must be enabled on the C64 Ultimate.

### Requirements

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

1. Upload the C64 client to your C64 Ultimate
   ```bash
   ./c64uploader ftp -host <ultimate-ip> build/a64browser.crt
   ```

2. Start the server on your PC
   ```bash
   ./c64uploader server -host <ultimate-ip> -assembly64 <path>
   ```

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
cd uploader
go build
```

## Architecture

```
c64uploader/
├── uploader/        # Go server application
│   ├── main.go      # Entry point, argument parsing
│   ├── apiclient.go # Ultimate II+ REST API client
│   ├── index.go     # Assembly64 metadata indexing
│   ├── tui.go       # Text-based UI (Bubble Tea)
│   └── server.go    # Native protocol server for C64 client
├── c64client/       # Native C64 client
│   ├── src/
│   │   ├── main.c   # Client application
│   │   └── ultimate.c # UCI library for Ultimate II+
│   └── Makefile
└── README.md
```
