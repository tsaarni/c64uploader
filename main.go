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

// uploadAndRunGame uploads a game file and runs it based on file type.
func uploadAndRunGame(client *APIClient, filename string) error {
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
		// CLI mode: run single file.
		filename := flag.Arg(0)
		slog.Info("Connecting to C64 Ultimate", "host", *host)
		slog.Info("Uploading file", "path", filename)

		if err := uploadAndRunGame(client, filename); err != nil {
			slog.Error("Failed to upload and run game", "error", err)
			os.Exit(1)
		}

		slog.Info("Success! Game uploaded and running")
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
