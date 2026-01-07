// Remote control client for the C64 Ultimate.
// It supports uploading and running various file formats including PRG, CRT, and D64 disk images.
// The application can run in either CLI mode (single file upload) or TUI mode (interactive browser for Assembly64).
package main

import (
	"flag"
	"fmt"
	"io"
	"log/slog"
	"os"
	"path/filepath"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
)

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
func uploadAndRunFile(client *APIClient, filename string) error {
	// Read file.
	fileData, err := os.ReadFile(filename)
	if err != nil {
		return fmt.Errorf("reading file: %w", err)
	}

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

// handlePokeCommand parses arguments and issues a POKE command.
func handlePokeCommand(client *APIClient, args []string) {
	// Join all remaining arguments to handle "poke address, value" vs "poke address,value" etc.
	rawArgs := strings.Join(args, "")
	parts := strings.Split(rawArgs, ",")

	if len(parts) != 2 {
		fmt.Fprintln(os.Stderr, "Usage: c64uploader poke <address>,<value>")
		os.Exit(1)
	}

	addressStr := strings.TrimSpace(parts[0])
	valueStr := strings.TrimSpace(parts[1])

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
			fmt.Fprintf(os.Stderr, "Invalid address '%s': %v\n", parts[0], err)
			os.Exit(1)
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
			fmt.Fprintf(os.Stderr, "Invalid value '%s': %v\n", parts[1], err)
			os.Exit(1)
		}
	}

	if value < 0 || value > 255 {
		fmt.Fprintf(os.Stderr, "Value must be 0-255 (byte), got %d\n", value)
		os.Exit(1)
	}

	if err := client.WriteMemory(addressHex, []byte{byte(value)}); err != nil {
		fmt.Fprintf(os.Stderr, "Failed to poke: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("POKE %s,%d OK\n", addressStr, value)
}

func main() {
	// Parse command-line flags.
	host := flag.String("host", "c64u", "C64 Ultimate hostname or IP address")
	verbose := flag.Bool("v", false, "Enable verbose debug logging")
	assembly64Path := flag.String("assembly64", "~/Downloads/assembly64", "Path to Assembly64 database")
	flag.Parse()

	// Set log level.
	if *verbose {
		slog.SetLogLoggerLevel(slog.LevelDebug)
	}

	// Create API client.
	client := NewAPIClient(*host)

	// Check if we have a file argument (CLI mode) or should launch TUI.
	if flag.NArg() > 0 {
		// Check for "poke" command.
		if flag.Arg(0) == "poke" {
			// Pass arguments after "poke"
			handlePokeCommand(client, flag.Args()[1:])
			return
		}

		// CLI mode: run single file.
		filename := flag.Arg(0)
		slog.Info("Connecting to C64 Ultimate", "host", *host)
		slog.Info("Uploading file", "path", filename)

		if err := uploadAndRunFile(client, filename); err != nil {
			slog.Error("Failed to upload and run file", "error", err)
			os.Exit(1)
		}

		slog.Info("Success! Program uploaded and running")
	} else {
		// TUI mode: launch interactive browser.
		// Disable slog output in TUI mode to avoid interfering with the display.
		slog.SetDefault(slog.New(slog.NewTextHandler(io.Discard, nil)))

		index, err := loadAssembly64Index(*assembly64Path)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: Failed to load Assembly64 database from %s\n", *assembly64Path)
			fmt.Fprintf(os.Stderr, "Make sure the path is correct and .releaselog.json files exist.\n")
			os.Exit(1)
		}

		// Launch TUI.
		p := tea.NewProgram(NewModel(index, client, *assembly64Path), tea.WithAltScreen())
		if _, err := p.Run(); err != nil {
			fmt.Fprintf(os.Stderr, "TUI error: %v\n", err)
			os.Exit(1)
		}
	}
}
