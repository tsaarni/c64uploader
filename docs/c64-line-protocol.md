# C64 Protocol Specification

**Current version**: 1.0

## Overview

The C64 protocol is a simple, line-based text protocol designed for low-bandwidth communication between Commodore 64 clients and the `c64uploader` server.
The protocol uses TCP connections with plain text commands and responses, making it easy to implement on resource-constrained 8-bit systems.

## Connection Flow

1. Client establishes TCP connection to server (default port varies)
2. Server sends greeting: `OK c64uploader\n`
3. Client sends commands, server responds
4. Connection remains open until client sends `QUIT` or timeout occurs (5 minutes of inactivity)
5. Server sends goodbye message and closes connection

## Protocol Characteristics

- **Line-based**: Each command and response line is terminated by `\n` (newline)
- **Text-based**: All data is transmitted as ASCII text
- **Stateless**: Each command is independent
- **Connection timeout**: 5 minutes of inactivity
- **Default page size**: 20 entries per page (for results paging)

## Command Format

Commands are case-insensitive and follow this general format:
```
COMMAND [arg1] [arg2] [arg3]
```

Arguments are separated by whitespace.

## Response Format

All responses start with either `OK` or `ERR`:

### Success Response
```
OK [additional data]\n
[payload lines...]\n
.\n
```

### Error Response
```
ERR [error message]\n
```

The `.` (period) character on its own line indicates the end of multi-line responses.

---

## Command Reference

### 1. CATS - List Categories

The `CATS` command retrieves all available categories from the database. Categories include the count of entries in each category.
This is the first command a client issues to populate the category menu.

#### Syntax
```
CATS
```

#### Arguments
None

#### Response Format
```
OK <count>\n
<category1>|<count1>\n
<category2>|<count2>\n
...
.\n
```

- `count`: Total number of categories
- Each category line contains: `category_name|entry_count`
- Lines are pipe-delimited (`|`)

#### Example

**Request:**
```
CATS
```

**Response:**
```
OK 8
Demo|1523
Crack Intro|342
Game|2891
Music|156
Graphics|89
Tool|213
Magazine|45
Misc|127
.
```

---

### 2. LIST - List Category Entries

The `LIST` command is used to browse entries within a specific category.
It supports pagination through `offset` and `count` parameters, allowing clients to load data in manageable chunks.

#### Syntax
```
LIST <category> <offset> <count>
```

#### Arguments
- `category`: Category name (case-insensitive)
- `offset`: Starting index, 0-based
- `count`: Number of entries to return (use 0 to return all from offset)

#### Response Format
```
OK <returned_count> <total_count>\n
<id1>|<name1>|<group1>|<year1>|<type1>\n
<id2>|<name2>|<group2>|<year2>|<type2>\n
...
.\n
```

- `returned_count`: Number of entries in this response
- `total_count`: Total entries available in the category
- Each entry line contains: `id|name|group|year|file_type`
- Fields are pipe-delimited (`|`)

#### Examples

**Example 1: First page of games**

Request:
```
LIST Game 0 20
```

Response:
```
OK 20 2891
0|Arkanoid|Taito|1987|prg
1|Boulder Dash|First Star|1984|prg
2|Commando|Elite|1985|prg
3|Defender of the Crown|Cinemaware|1987|d64
4|Elite|Firebird|1985|prg
5|Ghosts 'n Goblins|Elite|1986|d64
6|IK+|System 3|1987|prg
7|Last Ninja|System 3|1987|d64
8|Maniac Mansion|Lucasfilm|1988|d64
9|Paradroid|Hewson|1985|prg
10|Pirates!|MicroProse|1987|d64
11|R-Type|Electric Dreams|1988|crt
12|Summer Games|Epyx|1984|prg
13|Turrican|Rainbow Arts|1990|d64
14|Uridium|Hewson|1986|prg
15|Winter Games|Epyx|1985|d64
16|Wizball|Ocean|1987|d64
17|Zak McKracken|Lucasfilm|1988|d64
18|1942|Elite|1986|prg
19|Barbarian|Palace|1987|d64
.
```

**Example 2: Second page with custom count**

Request:
```
LIST Game 20 10
```

Response:
```
OK 10 2891
20|Bruce Lee|Datasoft|1984|prg
21|Bubble Bobble|Firebird|1987|d64
22|California Games|Epyx|1987|d64
23|Castlevania|Konami|1990|crt
24|Choplifter|Broderbund|1982|prg
25|Creatures|Thalamus|1990|d64
26|Decathlon|Activision|1983|prg
27|Golden Axe|Virgin|1990|d64
28|Impossible Mission|Epyx|1984|prg
29|Jumpman|Epyx|1983|prg
.
```

**Example 3: Invalid category**

Request:
```
LIST InvalidCategory
```

Response:
```
ERR Unknown category: InvalidCategory
```

**Example 4: Offset beyond available entries**

Request:
```
LIST Demo 5000 20
```

Response:
```
OK 0 1523
.
```


---

### 3. SEARCH - Search Entries

The `SEARCH` command performs a case-insensitive substring search across both the `Name` and `Group` fields of entries.
The query can contain multiple words.
Results are returned in the order they appear in the database.

An optional category filter can be specified to limit results to a specific category (Games, Demos, Music).


#### Syntax
```
SEARCH <offset> <count> <query>
SEARCH <offset> <count> <category> <query>
```

#### Arguments
- `offset`: Starting index, 0-based
- `count`: Number of results to return (use 0 to return all from offset)
- `category`: (Optional) Category to filter by (Games, Demos, Music, or All). If omitted or "All", searches all categories.
- `query`: Search term (case-insensitive, can be multi-word)

#### Response Format
```
OK <returned_count> <total_count>\n
<id1>|<name1>|<group1>|<year1>|<type1>\n
<id2>|<name2>|<group2>|<year2>|<type2>\n
...
.\n
```

Same format as `LIST` command.

#### Examples

**Example 1: Search for "ninja"**

Request:
```
SEARCH 0 0 ninja
```

Response:
```
OK 5 5
7|Last Ninja|System 3|1987|d64
145|Last Ninja 2|System 3|1988|d64
289|Last Ninja 3|System 3|1991|d64
421|Ninja|Sculptured Software|1986|prg
892|Shadow of the Ninja|Natsume|1990|d64
.
```

**Example 2: Search with pagination**

Request:
```
SEARCH 0 5 demo
```

Response:
```
OK 5 156
12|Coma Light 13|Oxyron|2001|prg
45|State of the Art|Spaceballs|1992|d64
78|Edge of Disgrace|Booze Design|1993|d64
112|Desert Dream|Kefrens|1993|d64
156|Deus Ex Machina|Crest|2014|prg
.
```

**Example 3: Search with category filter**

Request:
```
SEARCH 0 20 Games ninja
```

Response:
```
OK 3 3
7|Last Ninja|System 3|1987|d64
145|Last Ninja 2|System 3|1988|d64
289|Last Ninja 3|System 3|1991|d64
.
```

**Example 4: Search Music category**

Request:
```
SEARCH 0 10 Music commando
```

Response:
```
OK 2 2
50123|Commando|Rob Hubbard||sid
50456|Commando Remix|Various||sid
.
```

**Example 5: No matches**

Request:
```
SEARCH 0 0 qwertyzxcv
```

Response:
```
OK 0 0
.
```


---

### 4. INFO - Get Entry Details

The `INFO` command retrieves all metadata for a specific entry.
This includes the entry's name, group/publisher, release year, category, file type, and relative path within the archive.
Clients typically use this before running an entry or to display detailed information to the user.

Note that metadata can be incomplete for some entries.

#### Syntax
```
INFO <id>
```

#### Arguments
- `id`: Entry ID (numeric, obtained from LIST or SEARCH)

#### Response Format
```
OK\n
NAME|<name>\n
GROUP|<group>\n
YEAR|<year>\n
CAT|<category>\n
TYPE|<file_type>\n
PATH|<relative_path>\n
.\n
```

Each field is on its own line with format: `FIELD|value`

#### Examples

**Example 1: Valid entry**

Request:
```
INFO 7
```

Response:
```
OK
NAME|Last Ninja
GROUP|System 3
YEAR|1987
CAT|Game
TYPE|d64
PATH|Games/L/Last_Ninja.d64
.
```

**Example 2: Invalid ID**

Request:
```
INFO 99999
```

Response:
```
ERR Invalid ID
```

---

### 5. RUN - Execute Entry

The `RUN` command will instruct the server to upload the specified entry from the server archive to the C64 Ultimate hardware via its REST API and execute it.

The behavior depends on the file type:

- **PRG files**: Loaded directly into memory and executed
- **CRT files**: Cartridge image is mounted
- **SID files**: Music file is played using the Ultimate's SID player
- **D64/G64/D71/D81 files**: Disk image is mounted, first program is loaded directly into memory and executed

Supported file types: `prg`, `crt`, `sid`, `d64`, `g64`, `d71`, `d81`

#### Syntax
```
RUN <id>
```

#### Arguments
- `id`: Entry ID (numeric, obtained from LIST or SEARCH)

#### Response Format

**Success:**
```
OK Running <entry_name>\n
```

**Error:**
```
ERR <error_message>\n
```

#### Examples

**Example 1: Run an entry**

Request:
```
RUN 0
```

Response:
```
OK Running Arkanoid
```

**Example 2: Invalid ID**

Request:
```
RUN 99999
```

Response:
```
ERR Invalid ID
```


---

### 6. ADVSEARCH - Advanced Search

The `ADVSEARCH` command performs an advanced search with multiple filter parameters.
Unlike the simple `SEARCH` command, this allows filtering by category, title, group, file type, and Top200 status using key=value pairs.

#### Syntax
```
ADVSEARCH <offset> <count> [key=value ...]
```

#### Arguments
- `offset`: Starting index, 0-based
- `count`: Number of results to return (use 0 to return all from offset)
- `key=value`: Optional filter parameters (see below)

#### Filter Parameters

| Key | Description | Example |
|-----|-------------|---------|
| `cat` | Category filter (Games, Demos, Music, All) | `cat=Games` |
| `title` | Partial match on title | `title=ninja` |
| `group` | Partial match on group/publisher | `group=system` |
| `type` | File type filter (d64, prg, crt, sid) | `type=d64` |
| `top200` | Show only Top200 entries (1=yes) | `top200=1` |

#### Response Format
```
OK <returned_count> <total_count>\n
<id1>|<name1>|<group1>|<year1>|<type1>\n
<id2>|<name2>|<group2>|<year2>|<type2>\n
...\n
.\n
```

Same format as `LIST` and `SEARCH` commands.

#### Examples

**Example 1: Search Games containing "ninja" in title**

Request:
```
ADVSEARCH 0 20 cat=Games title=ninja
```

Response:
```
OK 3 3
7|Last Ninja|System 3|1987|d64
145|Last Ninja 2|System 3|1988|d64
289|Last Ninja 3|System 3|1991|d64
.
```

**Example 2: Search Top200 games only**

Request:
```
ADVSEARCH 0 20 cat=Games top200=1
```

Response:
```
OK 20 200
1|Uridium|Hewson|1986|prg
2|Paradroid|Hewson|1985|prg
...
.
```

**Example 3: Search for SID files**

Request:
```
ADVSEARCH 0 10 type=sid
```

Response:
```
OK 10 50000
50001|Commando|Rob Hubbard||sid
50002|Delta|Rob Hubbard||sid
...
.
```

**Example 4: Combined filters**

Request:
```
ADVSEARCH 0 20 cat=Games type=prg group=hewson
```

Response:
```
OK 5 5
1|Uridium|Hewson|1986|prg
2|Paradroid|Hewson|1985|prg
...
.
```


---

### 7. QUIT - Close Connection

The `QUIT` command allows the client to close the connection gracefully.
After sending the goodbye message, the server immediately closes the TCP connection.

#### Syntax
```
QUIT
```

#### Arguments
None

#### Response Format
```
OK Goodbye\n
```

Server closes connection after sending this response.

#### Example

Request:
```
QUIT
```

Response:
```
OK Goodbye
```

*(Connection closes)*
