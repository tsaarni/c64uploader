# c64uploader

A Go program to remotely upload and run games on Commodore 64 Ultimate via its [REST API](https://1541u-documentation.readthedocs.io/en/latest/api/api_calls.html).

**Note:** This code was generated with GitHub Copilot and not properly tested or even reviewed.

## Features

- Auto-detects file format by extension
- Supports multiple file types:
  - `.prg` - C64 program files (direct upload and run)
  - `.crt` - Cartridge images (direct upload and run)
  - `.d64` - Disk images (uploads disk image via FTP to `/Temp`, mounts it as drive A and extracts+runs first PRG via DMA for fastest startup.)
- Two modes of operation: TUI and CLI
  - CLI mode: Upload and run a single file specified as a command-line argument
  - TUI mode: Interactive terminal UI for browsing and uploading files from the Assembly64 collection (uses `.releaselog.json` files for metadata, which do not seem to contain all files)


## Compilation

```bash
go build
```

## Usage

```bash
./c64uploader [options] <file>
```

If no `<file>` argument is provided, the program launches in TUI mode.

### Options

- `-host string` - C64 Ultimate hostname or IP address (default: `c64u`)
- `-assembly64 string` - Path to Assembly64 collection (default: `~/Downloads/assembly64`)
