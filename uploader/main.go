// Remote control client for the C64 Ultimate.
// It supports uploading and running various file formats including PRG, CRT, and D64 disk images.
// The application can run in either CLI mode (single file upload) or TUI mode (interactive browser for Assembly64).
package main

import (
	"flag"
	"fmt"
	"io"
	"log/slog"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
)

// isURL checks if a string is a URL.
func isURL(s string) bool {
	return strings.HasPrefix(s, "http://") || strings.HasPrefix(s, "https://")
}

// downloadURL downloads a remote file to memory.
func downloadURL(url string) ([]byte, error) {
	slog.Info("Downloading remote file", "url", url)
	resp, err := http.Get(url)
	if err != nil {
		return nil, fmt.Errorf("downloading URL: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("download failed with status: %s", resp.Status)
	}

	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("reading response body: %w", err)
	}

	slog.Info("Download complete", "size", len(data))
	return data, nil
}

// detectFileType determines the file type from extension.
func detectFileType(filename string) string {
	ext := strings.ToLower(filepath.Ext(filename))
	switch ext {
	case ".prg":
		return "prg"
	case ".crt":
		return "crt"
	case ".d64":
		return "d64"
	case ".d71":
		return "d71"
	case ".d81":
		return "d81"
	case ".g64":
		return "g64"
	case ".g71":
		return "g71"
	default:
		return ""
	}
}

// uploadAndRunFile uploads a file and runs it based on file type.
func uploadAndRunFile(client *APIClient, fileData []byte, filename string) error {
	// Detect file type.
	fileType := detectFileType(filename)
	if fileType == "" {
		return fmt.Errorf("unsupported file type (supported: .prg, .crt, .d64, .d71, .d81, .g64, .g71)")
	}

	slog.Info("Detected file type", "type", fileType)
	// Upload and run based on type.
	switch fileType {
	case "prg":
		return client.runPRG(fileData)
	case "crt":
		return client.runCRT(fileData)
	case "d64", "d71", "d81", "g64", "g71":
		return client.runDiskImage(fileData, fileType, filepath.Base(filename))
	default:
		return fmt.Errorf("unsupported file type: %s", fileType)
	}
}

// parsePoke parses a POKE address and value.
func parsePoke(addressStr, valueStr string) (string, byte, error) {
	// Parse address.
	// C64 Ultimate API expects hex address without 0x or $.
	// User might provide 53280, 0xD020, $D020.
	var address int
	var err error

	// Handle $ prefix for hex.
	if strings.HasPrefix(addressStr, "$") {
		addressStr = "0x" + addressStr[1:]
	}

	// Try parsing. auto-detect base (0x for hex, else decimal).
	_, err = fmt.Sscanf(addressStr, "%v", &address)
	if err != nil {
		// Re-attempt as hex if initial parse failed (e.g. "D020")
		_, errHex := fmt.Sscanf(addressStr, "%x", &address)
		if errHex != nil {
			return "", 0, fmt.Errorf("invalid address '%s': %v", addressStr, err)
		}
	}

	// Format address as hex string for API (without 0x).
	addressHex := fmt.Sprintf("%x", address)

	// Parse value.
	var value int
	// Handle $ prefix
	if strings.HasPrefix(valueStr, "$") {
		valueStr = "0x" + valueStr[1:]
	}
	_, err = fmt.Sscanf(valueStr, "%v", &value)
	if err != nil {
		// Re-attempt as hex (e.g. "FF")
		_, errHex := fmt.Sscanf(valueStr, "%x", &value)
		if errHex != nil {
			return "", 0, fmt.Errorf("invalid value '%s': %v", valueStr, err)
		}
	}

	if value < 0 || value > 255 {
		return "", 0, fmt.Errorf("value must be 0-255 (byte), got %d", value)
	}

	return addressHex, byte(value), nil
}

func printUsage() {
	fmt.Fprintf(os.Stderr, "Usage: c64uploader <command> [options] [arguments]\n\n")
	fmt.Fprintf(os.Stderr, "Commands:\n")
	fmt.Fprintf(os.Stderr, "  tui                       Launch the Terminal UI browser\n")
	fmt.Fprintf(os.Stderr, "  load <filename>           Upload and run a file (PRG, CRT, D64, etc.)\n")
	fmt.Fprintf(os.Stderr, "  ftp <filename> <dest>     Upload a file via FTP to C64 Ultimate\n")
	fmt.Fprintf(os.Stderr, "  poke <address>,<value>    Issue a POKE command to C64 memory\n")
	fmt.Fprintf(os.Stderr, "  server                    Start the C64 protocol server\n")
	fmt.Fprintf(os.Stderr, "  dbgen                     Generate JSON database from Assembly64\n\n")
	fmt.Fprintf(os.Stderr, "Run 'c64uploader <command> -help' for command-specific options.\n")
}

// loadIndex loads the search index, trying JSON database first unless legacy mode is forced.
func loadIndex(assembly64Path, dbPath string, forceLegacy bool) (*SearchIndex, error) {
	// Expand ~ to home directory.
	if strings.HasPrefix(assembly64Path, "~/") {
		home, err := os.UserHomeDir()
		if err != nil {
			return nil, fmt.Errorf("failed to get home directory: %w", err)
		}
		assembly64Path = filepath.Join(home, assembly64Path[2:])
	}

	// Try JSON database first (unless legacy mode forced).
	if !forceLegacy && dbPath != "" {
		if _, err := os.Stat(dbPath); err == nil {
			return LoadIndexFromJSON(dbPath, assembly64Path)
		}
		slog.Info("JSON database not found, falling back to legacy loading", "path", dbPath)
	}

	// Fall back to legacy .releaselog.json loading.
	return loadAssembly64Index(assembly64Path)
}

func runTUI(args []string) {
	fs := flag.NewFlagSet("tui", flag.ExitOnError)
	host := fs.String("host", "c64u", "C64 Ultimate hostname or IP address")
	verbose := fs.Bool("v", false, "Enable verbose debug logging")
	assembly64Path := fs.String("assembly64", "~/Downloads/assembly64", "Path to Assembly64 data directory")
	dbPath := fs.String("db", "games.json", "Path to JSON database file")
	legacy := fs.Bool("legacy", false, "Force legacy .releaselog.json loading")
	fs.Parse(args)

	// Set log level.
	if *verbose {
		slog.SetLogLoggerLevel(slog.LevelDebug)
	}

	// Disable slog output in TUI mode to avoid interfering with the display.
	slog.SetDefault(slog.New(slog.NewTextHandler(io.Discard, nil)))

	index, err := loadIndex(*assembly64Path, *dbPath, *legacy)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: Failed to load index: %v\n", err)
		os.Exit(1)
	}

	// Expand assembly64Path for TUI (needed for file operations).
	a64Path := *assembly64Path
	if strings.HasPrefix(a64Path, "~/") {
		home, _ := os.UserHomeDir()
		a64Path = filepath.Join(home, a64Path[2:])
	}

	// Determine if we're in legacy mode (JSON not found or -legacy flag).
	legacyMode := *legacy
	if !legacyMode {
		if _, err := os.Stat(*dbPath); os.IsNotExist(err) {
			legacyMode = true
		}
	}

	// Create API client.
	client := NewAPIClient(*host)

	// Launch TUI.
	p := tea.NewProgram(NewModel(index, client, a64Path, legacyMode), tea.WithAltScreen())
	if _, err := p.Run(); err != nil {
		fmt.Fprintf(os.Stderr, "TUI error: %v\n", err)
		os.Exit(1)
	}
}

func runLoad(args []string) {
	fs := flag.NewFlagSet("load", flag.ExitOnError)
	host := fs.String("host", "c64u", "C64 Ultimate hostname or IP address")
	verbose := fs.Bool("v", false, "Enable verbose debug logging")
	fs.Parse(args)

	// Set log level.
	if *verbose {
		slog.SetLogLoggerLevel(slog.LevelDebug)
	}

	if fs.NArg() < 1 {
		fmt.Fprintf(os.Stderr, "Error: filename or URL required\n")
		fmt.Fprintf(os.Stderr, "Usage: c64uploader load [options] <filename|url>\n")
		os.Exit(1)
	}

	input := fs.Arg(0)

	// Load data from URL or local file.
	var fileData []byte
	var err error

	if isURL(input) {
		slog.Info("Detected URL", "url", input)
		fileData, err = downloadURL(input)
		if err != nil {
			slog.Error("Failed to download URL", "error", err)
			os.Exit(1)
		}
	} else {
		slog.Info("Reading local file", "path", input)
		fileData, err = os.ReadFile(input)
		if err != nil {
			slog.Error("Failed to read file", "error", err)
			os.Exit(1)
		}
	}

	// Create API client.
	client := NewAPIClient(*host)

	slog.Info("Connecting to C64 Ultimate", "host", *host)
	slog.Info("Uploading file", "path", input, "size", len(fileData))

	if err := uploadAndRunFile(client, fileData, input); err != nil {
		slog.Error("Failed to upload and run file", "error", err)
		os.Exit(1)
	}

	slog.Info("Success! Program uploaded and running")
}

func runPoke(args []string) {
	fs := flag.NewFlagSet("poke", flag.ExitOnError)
	host := fs.String("host", "c64u", "C64 Ultimate hostname or IP address")
	verbose := fs.Bool("v", false, "Enable verbose debug logging")
	fs.Parse(args)

	// Set log level.
	if *verbose {
		slog.SetLogLoggerLevel(slog.LevelDebug)
	}

	if fs.NArg() < 1 {
		fmt.Fprintf(os.Stderr, "Error: address and value required\n")
		fmt.Fprintf(os.Stderr, "Usage: c64uploader poke [options] <address>,<value>\n")
		fmt.Fprintf(os.Stderr, "Examples:\n")
		fmt.Fprintf(os.Stderr, "  c64uploader poke 53280,0      # Decimal address and value\n")
		fmt.Fprintf(os.Stderr, "  c64uploader poke 0xD020,0     # Hex address (0x prefix)\n")
		fmt.Fprintf(os.Stderr, "  c64uploader poke $D020,0      # Hex address ($ prefix)\n")
		fmt.Fprintf(os.Stderr, "  c64uploader poke D020,0       # Hex address (no prefix)\n")
		os.Exit(1)
	}

	// Join all arguments to handle "poke address, value" vs "poke address,value" etc.
	rawArgs := strings.Join(fs.Args(), "")
	parts := strings.Split(rawArgs, ",")

	if len(parts) != 2 {
		fmt.Fprintln(os.Stderr, "Error: Invalid format. Use: <address>,<value>")
		os.Exit(1)
	}

	addressStr := strings.TrimSpace(parts[0])
	valueStr := strings.TrimSpace(parts[1])

	addressHex, value, err := parsePoke(addressStr, valueStr)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}

	// Create API client.
	client := NewAPIClient(*host)

	if err := client.WriteMemory(addressHex, []byte{value}); err != nil {
		fmt.Fprintf(os.Stderr, "Failed to poke: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("POKE %s,%d OK\n", addressStr, value)
}

func runFTP(args []string) {
	fs := flag.NewFlagSet("ftp", flag.ExitOnError)
	host := fs.String("host", "c64u", "C64 Ultimate hostname or IP address")
	verbose := fs.Bool("v", false, "Enable verbose debug logging")
	fs.Parse(args)

	// Set log level.
	if *verbose {
		slog.SetLogLoggerLevel(slog.LevelDebug)
	}

	if fs.NArg() < 2 {
		fmt.Fprintf(os.Stderr, "Error: filename/URL and destination required\n")
		fmt.Fprintf(os.Stderr, "Usage: c64uploader ftp [options] <filename|url> <destination>\n")
		fmt.Fprintf(os.Stderr, "Example: c64uploader ftp ~/games/game.prg /Temp/game.prg\n")
		fmt.Fprintf(os.Stderr, "Example: c64uploader ftp https://example.com/game.prg /Temp/game.prg\n")
		os.Exit(1)
	}

	input := fs.Arg(0)
	destination := fs.Arg(1)

	// Load data from URL or local file.
	var fileData []byte
	var err error

	if isURL(input) {
		slog.Info("Detected URL", "url", input)
		fileData, err = downloadURL(input)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error downloading URL: %v\n", err)
			os.Exit(1)
		}
	} else {
		slog.Info("Reading local file", "path", input)
		fileData, err = os.ReadFile(input)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error reading file: %v\n", err)
			os.Exit(1)
		}
	}

	// Create API client.
	client := NewAPIClient(*host)

	slog.Info("Connecting to C64 Ultimate FTP server", "host", *host)
	slog.Info("Uploading file", "source", input, "destination", destination, "size", len(fileData))

	// Use the existing FTP upload method but with custom destination.
	ftpAddr := fmt.Sprintf("%s:21", *host)
	conn, err := client.ftpConnect(ftpAddr)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to connect to FTP server: %v\n", err)
		os.Exit(1)
	}
	defer conn.Quit()

	if err := client.ftpUpload(conn, fileData, destination); err != nil {
		fmt.Fprintf(os.Stderr, "Failed to upload file: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("File uploaded successfully to %s\n", destination)
}

func runServer(args []string) {
	fs := flag.NewFlagSet("server", flag.ExitOnError)
	host := fs.String("host", "c64u", "C64 Ultimate hostname or IP address")
	verbose := fs.Bool("v", false, "Enable verbose debug logging")
	assembly64Path := fs.String("assembly64", "~/Downloads/assembly64", "Path to Assembly64 data directory")
	dbPath := fs.String("db", "games.json", "Path to JSON database file")
	legacy := fs.Bool("legacy", false, "Force legacy .releaselog.json loading")
	port := fs.Int("port", 6465, "C64 protocol server port")
	fs.Parse(args)

	// Set log level.
	if *verbose {
		slog.SetLogLoggerLevel(slog.LevelDebug)
	}

	index, err := loadIndex(*assembly64Path, *dbPath, *legacy)
	if err != nil {
		slog.Error("Failed to load index", "error", err)
		os.Exit(1)
	}

	// Expand assembly64Path for server (needed for file operations).
	a64Path := *assembly64Path
	if strings.HasPrefix(a64Path, "~/") {
		home, _ := os.UserHomeDir()
		a64Path = filepath.Join(home, a64Path[2:])
	}

	// Create API client.
	apiClient := NewAPIClient(*host)

	// Start C64 protocol server (blocking).
	if err := StartC64Server(*port, index, apiClient, a64Path); err != nil {
		slog.Error("C64 server error", "error", err)
		os.Exit(1)
	}

	// Block forever
	select {}
}

func runDBGen(args []string) {
	fs := flag.NewFlagSet("dbgen", flag.ExitOnError)
	assembly64Path := fs.String("assembly64", "", "Path to Assembly64 data directory (required)")
	outputPath := fs.String("output", "games.json", "Output JSON file path")
	fs.Parse(args)

	if *assembly64Path == "" {
		fmt.Fprintf(os.Stderr, "Error: -assembly64 path is required\n")
		fmt.Fprintf(os.Stderr, "Usage: c64uploader dbgen -assembly64 <path> [-output <file>]\n")
		fmt.Fprintf(os.Stderr, "Example: c64uploader dbgen -assembly64 /home/user/assembly64/Data -output games.json\n")
		os.Exit(1)
	}

	// Expand ~ to home directory.
	path := *assembly64Path
	if strings.HasPrefix(path, "~/") {
		home, err := os.UserHomeDir()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: failed to get home directory: %v\n", err)
			os.Exit(1)
		}
		path = filepath.Join(home, path[2:])
	}

	// Check if path exists.
	if _, err := os.Stat(path); os.IsNotExist(err) {
		fmt.Fprintf(os.Stderr, "Error: path does not exist: %s\n", path)
		os.Exit(1)
	}

	if err := GenerateGamesDB(path, *outputPath); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}

func main() {
	if len(os.Args) < 2 {
		printUsage()
		os.Exit(1)
	}

	command := os.Args[1]

	switch command {
	case "tui":
		runTUI(os.Args[2:])
	case "load":
		runLoad(os.Args[2:])
	case "ftp":
		runFTP(os.Args[2:])
	case "poke":
		runPoke(os.Args[2:])
	case "server":
		runServer(os.Args[2:])
	case "dbgen":
		runDBGen(os.Args[2:])
	case "-h", "-help", "--help", "help":
		printUsage()
	default:
		fmt.Fprintf(os.Stderr, "Error: unknown command '%s'\n\n", command)
		printUsage()
		os.Exit(1)
	}
}
