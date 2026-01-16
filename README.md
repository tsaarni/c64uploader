# C64 Ultimate Uploader

Remotely upload and run programs on Commodore 64 Ultimate via its [REST API](https://1541u-documentation.readthedocs.io/en/latest/api/api_calls.html).

> [!NOTE]
> This code was generated with AI coding assistant and is not thoroughly tested or reviewed.


![System Diagram](./docs/system-diagram.png)

## Features

This project consists of two components:

### c64uploader (Go application)

A command-line tool that runs on your PC and communicates with the C64 Ultimate via its REST API. It provides multiple modes of operation:

- **TUI Mode** - Interactive terminal UI for browsing and running programs from a local Assembly64 collection
- **Load Mode** - Upload and run individual files (PRG, CRT, D64, etc.) from local paths or remote URLs
- **FTP Mode** - Transfer files to the C64 Ultimate's filesystem via FTP
- **Poke Mode** - Modify C64 memory addresses (useful for cheats and memory tricks)
- **Server Mode** - Host a lightweight protocol server for the C64 client application

### a64browser (C64 native application)

A native C64 program that runs directly on the C64 Ultimate. It connects to the `c64uploader` server over the network, enabling you to browse and launch programs from your Assembly64 collection entirely from the C64 itself—no PC interaction needed once the server is running.




## c64uploader Usage

The `c64uploader` tool runs on your PC and uses a subcommand-based interface: `c64uploader <command> [options] [arguments]`.

### TUI Mode

Browse and upload files from local Assembly64 collection to C64 Ultimate using an interactive terminal UI:

```bash
./c64uploader tui [options]
```

**Options:**
- `-host <ip>` - C64 Ultimate hostname or IP address (default: `c64u`)
- `-assembly64 <path>` - Path to Assembly64 collection (default: `~/Downloads/assembly64`)
- `-db <path>` - Path to JSON database file (default: `<assembly64>/c64uploader.json`)
- `-legacy` - Force legacy `.releaselog.json` loading instead of JSON database
- `-v` - Enable verbose debug logging

**Data Sources:**
- **JSON Database (default)** - Uses `c64uploader.json` database in the assembly64 directory for fast loading and rich metadata. Generate with `dbgen` command.
- **Legacy Mode** - Falls back to scanning `.releaselog.json` metadata files if JSON database not found, or when `-legacy` flag is used.

**Controls:**
- **↑/↓** - Navigate up/down
- **Tab** - Cycle through categories
- **Enter** - Load and run selected entry
- **/** - Open advanced search (JSON database mode only)
- **Esc** - Clear search or quit
- **Q** - Quit
- **Ctrl+L** - Refresh index (legacy mode) / Reset search and filters (JSON database mode)

**Advanced Search (press `/`):**

When using the JSON database, press `/` to open an advanced search form with filters for:
- Title and Group (partial text match)
- Language (german, french, english...)
- Region (PAL, NTSC)
- Engine (seuck, gkgm, bdck...)
- File type (d64, prg, crt...)
- Trainer count (min/max)
- Top 200 games only
- 4K competition entries only
- Has documentation
- Has fastloader
- Cracked/original filter

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
- `-db <path>` - Path to JSON database file (default: `<assembly64>/c64uploader.json`)
- `-legacy` - Force legacy `.releaselog.json` loading instead of JSON database
- `-port <port>` - C64 protocol server port (default: `6465`)
- `-v` - Enable verbose debug logging

**Example:**
```bash
./c64uploader server -host 192.168.2.100 -assembly64 ~/assembly64 -port 6465
```

The C64 protocol is a simple line-based protocol optimized for low-bandwidth C64 communication.
See `uploader/C64PROTOCOL.md` for protocol details.

### Database Generator

Generate a JSON database from your Assembly64 collection for faster loading and richer search capabilities:

```bash
./c64uploader dbgen [options]
```

**Options:**
- `-assembly64 <path>` - Path to Assembly64 data directory (required)
- `-out <path>` - Output JSON database file (default: `<assembly64>/c64uploader.json`)

**Example:**
```bash
./c64uploader dbgen -assembly64 ~/assembly64
```

The generator scans the `Games/CSDB/All` directory structure and extracts metadata from directory names including:
- Title, group, and release name
- Crack information (trainers, flags like docs/fastload/highscore)
- Language, region, and game engine
- Top 200 ranking (cross-referenced from `Games/CSDB/Top200/`)
- 4K competition status (cross-referenced from `Games/CSDB/4k/`)

See `docs/json-database-format.md` for the complete database schema specification.

## a64browser (C64 Client)

The `a64browser` is a native C64 application located in the `c64client/` directory. It runs directly on your C64 Ultimate and connects to the `c64uploader` server over the network, allowing you to browse and launch programs from your Assembly64 collection.

**Prerequisites:** Network and FTP File Service must be enabled on your C64 Ultimate.


### Running a64browser on C64

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

### Controls

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
