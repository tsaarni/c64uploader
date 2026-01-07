# C64 Ultimate Uploader

Remotely upload and run programs on Commodore 64 Ultimate via its [REST API](https://1541u-documentation.readthedocs.io/en/latest/api/api_calls.html).

> [!NOTE]
> This code was generated with GitHub Copilot and is not thoroughly tested or reviewed.

## Features

The program can be used as command-line tool or text-based user interface (TUI).
In command-line mode, it allows uploading and running a specific local file or poking memory.
In TUI mode, it allows browsing, uploading and running programs from a local copy of Assembly64 collection.

Following file types are supported:

- `.prg` — C64 program files (direct upload and run).
- `.crt` — Cartridge images (direct upload and run).
- `.d64` — Disk images (uploads via FTP to `/Temp`, mounts as drive A, extracts and runs first PRG via DMA).

The file type is auto-detected based on the file extension.

## Usage

### TUI Mode

Launch without arguments to browse and upload files from Assembly64 collection:

```bash
./c64uploader [options]
```

It uses Assembly64 collection from local path specified via `-assembly64` option.
It scans `.releaselog.json` metadata files to build the index of available files.

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

* `address` — Memory address to poke (0-65535 or 0x0000-0xFFFF or $0000-$FFFF)
* `value` — Value to write (0-255 or 0x00-0xFF or $00-$FF)

### Common Options for All Modes

- `-host` — C64 Ultimate hostname or IP (default: `c64u`)
- `-assembly64` — Path to Assembly64 collection (default: `~/Downloads/assembly64`)


## Compilation

```bash
go build
```
