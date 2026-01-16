# JSON Database Format Specification

This document describes the JSON database format for indexing the Assembly64 C64 software collection.

## Overview

The database is split into separate JSON files per category:
- `games.json`
- `demos.json`
- `music.json`
- `graphics.json`
- `tools.json`
- `intros.json`
- `misc.json`

Each file follows the same structure but contains entries for its specific category.

## File Structure

```json
{
  "version": "1.0",
  "generated": "2025-01-15T20:00:00Z",
  "source": "csdb",
  "totalEntries": 133861,

  "entries": [...]
}
```

| Field | Type | Description |
|-------|------|-------------|
| `version` | string | Schema version |
| `generated` | string | ISO 8601 timestamp of generation |
| `source` | string | Data source identifier (e.g., "csdb") |
| `totalEntries` | int | Number of entries in this file |
| `entries` | array | Array of entry objects |

## Entry Structure

```json
{
  "id": 1,
  "category": "games",
  "title": "The Great Giana Sisters",
  "releaseName": "The Great Giana Sisters +9DFH",
  "group": "Remember",

  "top200Rank": 8,
  "is4k": false,

  "path": "Games/CSDB/All/T/THEA - THEA/The Great Giana Sisters/Remember/The Great Giana Sisters +9DFH",

  "files": [
    {"name": "giana.d64", "type": "d64", "size": 174848}
  ],
  "primaryFile": "giana.d64",
  "fileType": "d64",

  "crack": {
    "isCracked": true,
    "trainers": 9,
    "flags": ["docs", "fastload", "highscore"]
  },

  "language": null,
  "region": null,
  "engine": null,
  "isPreview": false,
  "version": null
}
```

### Entry Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | int | Sequential identifier for protocol communication |
| `category` | string | Category: games, demos, music, graphics, tools, intros, misc |
| `title` | string | Original title (extracted from path level 4) |
| `releaseName` | string | Full release name including crack info (from path level 6) |
| `group` | string | Cracking group or publisher (from path level 5) |
| `top200Rank` | int/null | Rank 1-200 if in Top200 folder, null otherwise |
| `is4k` | bool | True if entry exists in 4k competition folder |
| `path` | string | Relative path from assembly64 root directory |
| `files` | array | Array of file objects in the release folder |
| `primaryFile` | string | Recommended file to launch |
| `fileType` | string | File extension of primary file (d64, prg, t64, tap, crt) |
| `crack` | object | Crack/trainer information (see below) |
| `language` | string/null | Language if specified: german, french, english, etc. |
| `region` | string/null | Region if specified: PAL, NTSC |
| `engine` | string/null | Game engine if known: seuck, gkgm, bdck |
| `isPreview` | bool | True if release name contains "Preview" |
| `version` | string/null | Version string if present (e.g., "V1.1") |

### File Object

```json
{"name": "giana.d64", "type": "d64", "size": 174848}
```

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Filename |
| `type` | string | File extension |
| `size` | int | File size in bytes |

### Crack Object

```json
{
  "isCracked": true,
  "trainers": 9,
  "flags": ["docs", "fastload", "highscore"]
}
```

| Field | Type | Description |
|-------|------|-------------|
| `isCracked` | bool | True if release name contains "+" |
| `trainers` | int | Number of trainers (0 if none) |
| `flags` | array | Array of flag strings (see below) |

### Crack Flags

Parsed from release name suffix (e.g., `+9DFH`):

| Code | Flag String | Meaning |
|------|-------------|---------|
| D | docs | Documentation/manual included |
| F | fastload | Fastloader |
| H | highscore | Highscore saver |
| P | palntsxfix | PAL/NTSC fix |
| T | tape | Tape version |
| I | intro | Has intro |
| G | gfx | Modified graphics |
| R | trainer | Generic trainer flag |
| S | save | Save game support |

Multi-disk indicators (1D, 2D, 3D) are also captured in flags.

## Path Structure

Paths are relative to the assembly64 root directory (specified via `-assembly64` flag).

**Directory hierarchy for Games:**
```
Games/CSDB/All/{Letter}/{Range}/{Title}/{Group}/{ReleaseName}/
```

Example:
```
Games/CSDB/All/T/THEA - THEA/The Great Giana Sisters/Remember/The Great Giana Sisters +9DFH/
```

**Path components:**
- Level 1: Category (Games)
- Level 2: Source (CSDB)
- Level 3: Collection (All)
- Level 4: Alphabetical letter
- Level 5: Alphabetical range (e.g., "THEA - THEA")
- Level 6: Title (original game name)
- Level 7: Group (cracker/publisher)
- Level 8: Release name (with crack info)

## Metadata Extraction

### From Directory Structure

| Metadata | Source |
|----------|--------|
| `title` | Path level 6 folder name |
| `group` | Path level 7 folder name |
| `releaseName` | Path level 8 folder name |

### From Release Name Parsing

The release name is parsed to extract:

| Pattern | Extracted Field |
|---------|-----------------|
| `+` or `+N` | `crack.isCracked`, `crack.trainers` |
| `+NDFH` etc. | `crack.flags` |
| `[german]`, `[french]` | `language` |
| `[seuck]`, `[gkgm]` | `engine` |
| `NTSC`, `PAL` | `region` |
| `Preview` | `isPreview` |
| `V1.0`, `V2.1` | `version` |

### From Cross-Reference

| Metadata | Source |
|----------|--------|
| `top200Rank` | Presence in `Games/CSDB/Top200/` folder (rank from folder name prefix) |
| `is4k` | Presence in `Games/CSDB/4k/` folder |

## Estimated File Sizes

| Category | Entries | Minified | Gzipped |
|----------|---------|----------|---------|
| Games | ~134,000 | ~80 MB | ~10 MB |
| Demos | ~61,000 | ~37 MB | ~5 MB |
| Music | ~130,000 | ~78 MB | ~10 MB |
| Others | TBD | TBD | TBD |

**Estimate:** ~600 bytes per entry (minified JSON)

## Usage

### Generating the Database

Use the `dbgen` command to generate the database from your Assembly64 collection:

```bash
# Generate c64uploader.json in the assembly64 directory (default)
./c64uploader dbgen -assembly64 ~/assembly64

# Or specify a custom output path
./c64uploader dbgen -assembly64 ~/assembly64 -out ~/custom/path.json
```

### Using the Database

The JSON database (`c64uploader.json`) is automatically loaded from the assembly64 directory:

```bash
# TUI mode (uses <assembly64>/c64uploader.json by default)
./c64uploader tui -assembly64 ~/assembly64

# Server mode
./c64uploader server -assembly64 ~/assembly64

# Force legacy mode (skip JSON database)
./c64uploader tui -legacy -assembly64 ~/assembly64

# Use a custom database path
./c64uploader tui -db ~/custom/path.json -assembly64 ~/assembly64
```

### File Path Construction

Full file path is constructed as:
```
{assembly64_root}/{path}/{primaryFile}
```

Example:
```
/home/user/assembly64/Games/CSDB/All/.../giana.d64
```

Where `assembly64_root` is the value passed to `-assembly64` flag.

### Advanced Search

When using the JSON database in TUI mode, press `/` to open the advanced search form.
This allows filtering by all metadata fields: language, region, engine, trainer count, Top200 status, etc.
