# Agent Instructions

## Rules for Agents
- **CRITICAL: NEVER** try to auto-detect the `go` or `oscar64` compiler location by searching the filesystem (e.g., using `ls`, `find`, or `list_dir` on parent/system directories).
- If `go` or `oscar64` is not in the PATH, you **MUST** ask the USER for the path or the required environment variables.
- Do not make assumptions about the local environment.

## Project Overview
**c64uploader**: Go tool to control C64 Ultimate (upload, FTP, server).
**a64browser**: Native C64 client (written in C) for browsing/launching content in the server.

## Build Instructions

### c64uploader (Go)
Located in `uploader/`.

Compile with:
```bash
cd uploader
go build
```
Result: `uploader/c64uploader`


**Troubleshooting:**
- If `go: command not found`: Ask USER to install Go language (https://go.dev/dl/).

### a64browser (C64)
Located in `c64client/`. Requires **Oscar64** compiler.

Compile with:
```bash
cd c64client
make prg    # builds PRG
make crt    # builds CRT
```
Result: `c64client/build/a64browser.{prg,crt}`

**Troubleshooting:**
- If `make: oscar64: No such file or directory`:
  - Ask USER to install Oscar64 on their path or provide the path to the executable.
  - Ask USER for their path to the Oscar64 installation directory and use it in the make command (e.g. `make OSCAR64=<OSCAR64_PATH>/bin/oscar64`).
- If build fails with missing headers (e.g. `stdio.h not found`):
  - The compiler cannot find standard includes.
  - Ask USER to set `OSCAR64_INCLUDE` environment variable to their Oscar64 include directory (e.g. `OSCAR64_INCLUDE=<OSCAR64_PATH>/include`) and use it in the make command (e.g. `make OSCAR64_INCLUDE=<OSCAR64_PATH>/include`).

## Test on Device

**CRITICAL:** Before proceeding, ask  USER to start the server first using command `./uploader/c64uploader server -v`.

To test the latest changes and launch them on real hardware in one sequence:

Upload and Run:
```bash
./uploader/c64uploader load c64client/build/a64browser.{prg,crt}
```

**Note:** If the C64 Ultimate is reachable as `c64u` (default hostname), you can omit the `-host` flag.

**Troubleshooting**

- If upload fails (`dial tcp: lookup ...`)
  - Ask USER for the C64 Ultimate IP address or hostname.
  - Retry with explicit host: `./uploader/c64uploader load -host <ADDRESS> ...`


## Key Locations
- `uploader/main.go`: Entry point for Go app.
- `c64client/src/`: C source files (`main.c`, `uci.c`).
- `docs/`: Protocols, database specification, interface description and system diagrams.
