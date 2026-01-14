// C64 protocol server for C64 client.
// Simple line-based protocol optimized for low-bandwidth C64 communication.
package main

import (
	"bufio"
	"fmt"
	"log/slog"
	"net"
	"os"
	"strconv"
	"strings"
	"time"
)

// C64 protocol commands:
// CATS                    - List categories
// LIST <cat> <offset> <n> - List n entries from category starting at offset
// SEARCH <off> <n> <query>- Search entries (query can be multi-word)
// INFO <id>               - Get entry details
// RUN <id>                - Download and run entry
// QUIT                    - Close connection

const (
	c64ReadTimeout = 5 * time.Minute
	c64PageSize    = 20 // Default entries per page
)

// StartC64Server starts the C64 protocol server.
func StartC64Server(port int, index *SearchIndex, apiClient *APIClient, assembly64Path string) error {
	listener, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
	if err != nil {
		return fmt.Errorf("failed to start C64 server: %w", err)
	}

	slog.Info("C64 protocol server listening", "port", port)
	fmt.Printf("C64 protocol server listening on :%d\n", port)

	go func() {
		for {
			conn, err := listener.Accept()
			if err != nil {
				slog.Error("Accept error", "error", err)
				continue
			}
			go handleC64Connection(conn, index, apiClient, assembly64Path)
		}
	}()

	return nil
}

func handleC64Connection(conn net.Conn, index *SearchIndex, apiClient *APIClient, assembly64Path string) {
	defer conn.Close()

	remoteAddr := conn.RemoteAddr().String()
	slog.Info("C64 client connected", "remote", remoteAddr)

	// Send greeting
	conn.Write([]byte("OK Assembly64 Browser\n"))

	reader := bufio.NewReader(conn)

	for {
		conn.SetReadDeadline(time.Now().Add(c64ReadTimeout))

		line, err := reader.ReadString('\n')
		if err != nil {
			slog.Debug("C64 client disconnected", "remote", remoteAddr, "error", err)
			return
		}

		line = strings.TrimSpace(line)
		if line == "" {
			continue
		}

		slog.Debug("C64 command", "remote", remoteAddr, "cmd", line)

		response := handleC64Command(line, index, apiClient, assembly64Path, conn)
		if response == "QUIT" {
			conn.Write([]byte("OK Goodbye\n"))
			return
		}
		conn.Write([]byte(response))
	}
}

func handleC64Command(line string, index *SearchIndex, apiClient *APIClient, assembly64Path string, conn net.Conn) string {
	parts := strings.Fields(line)
	if len(parts) == 0 {
		return "ERR Empty command\n"
	}

	cmd := strings.ToUpper(parts[0])

	switch cmd {
	case "CATS":
		return handleCats(index)

	case "LIST":
		if len(parts) < 4 {
			return "ERR Usage: LIST <category> <offset> <count>\n"
		}
		category := parts[1]
		offset, _ := strconv.Atoi(parts[2])
		count, _ := strconv.Atoi(parts[3])
		return handleList(index, category, offset, count)

	case "SEARCH":
		if len(parts) < 4 {
			return "ERR Usage: SEARCH <offset> <count> <query>\n"
		}
		offset, _ := strconv.Atoi(parts[1])
		count, _ := strconv.Atoi(parts[2])
		// Query is all remaining parts joined with spaces
		query := strings.Join(parts[3:], " ")
		return handleSearch(index, query, offset, count)

	case "INFO":
		if len(parts) < 2 {
			return "ERR Usage: INFO <id>\n"
		}
		id, err := strconv.Atoi(parts[1])
		if err != nil {
			return "ERR Invalid ID\n"
		}
		return handleInfo(index, id)

	case "RUN":
		if len(parts) < 2 {
			return "ERR Usage: RUN <id>\n"
		}
		id, err := strconv.Atoi(parts[1])
		if err != nil {
			return "ERR Invalid ID\n"
		}
		return handleRun(index, apiClient, assembly64Path, id)

	case "QUIT":
		return "QUIT"

	default:
		return fmt.Sprintf("ERR Unknown command: %s\n", cmd)
	}
}

func handleCats(index *SearchIndex) string {
	var b strings.Builder
	b.WriteString(fmt.Sprintf("OK %d\n", len(index.CategoryOrder)))
	for _, cat := range index.CategoryOrder {
		count := len(index.ByCategory[cat])
		b.WriteString(fmt.Sprintf("%s|%d\n", cat, count))
	}
	b.WriteString(".\n")
	return b.String()
}

func handleList(index *SearchIndex, category string, offset, count int) string {
	// Find matching category (case-insensitive)
	var matchedCat string
	for _, cat := range index.CategoryOrder {
		if strings.EqualFold(cat, category) {
			matchedCat = cat
			break
		}
	}
	if matchedCat == "" {
		return fmt.Sprintf("ERR Unknown category: %s\n", category)
	}

	entries := index.ByCategory[matchedCat]
	total := len(entries)

	if offset >= total {
		return fmt.Sprintf("OK 0 %d\n.\n", total)
	}

	// If count is 0, return all results from offset
	end := offset + count
	if count == 0 || end > total {
		end = total
	}

	var b strings.Builder
	b.WriteString(fmt.Sprintf("OK %d %d\n", end-offset, total))

	for i := offset; i < end; i++ {
		idx := entries[i]
		entry := index.Entries[idx]
		// Format: ID|Name|Group|Year|Type
		b.WriteString(fmt.Sprintf("%d|%s|%s|%s|%s\n",
			idx, entry.Name, entry.Group, entry.Year, entry.FileType))
	}
	b.WriteString(".\n")
	return b.String()
}

func handleSearch(index *SearchIndex, query string, offset, count int) string {
	query = strings.ToLower(query)
	var results []int

	for i, entry := range index.Entries {
		if strings.Contains(strings.ToLower(entry.Name), query) ||
			strings.Contains(strings.ToLower(entry.Group), query) {
			results = append(results, i)
		}
	}

	total := len(results)
	if offset >= total {
		return fmt.Sprintf("OK 0 %d\n.\n", total)
	}

	// If count is 0, return all results from offset
	end := offset + count
	if count == 0 || end > total {
		end = total
	}

	var b strings.Builder
	b.WriteString(fmt.Sprintf("OK %d %d\n", end-offset, total))

	for i := offset; i < end; i++ {
		idx := results[i]
		entry := index.Entries[idx]
		b.WriteString(fmt.Sprintf("%d|%s|%s|%s|%s\n",
			idx, entry.Name, entry.Group, entry.Year, entry.FileType))
	}
	b.WriteString(".\n")
	return b.String()
}

func handleInfo(index *SearchIndex, id int) string {
	if id < 0 || id >= len(index.Entries) {
		return "ERR Invalid ID\n"
	}

	entry := index.Entries[id]
	var b strings.Builder
	b.WriteString("OK\n")
	b.WriteString(fmt.Sprintf("NAME|%s\n", entry.Name))
	b.WriteString(fmt.Sprintf("GROUP|%s\n", entry.Group))
	b.WriteString(fmt.Sprintf("YEAR|%s\n", entry.Year))
	b.WriteString(fmt.Sprintf("CAT|%s\n", entry.Category))
	b.WriteString(fmt.Sprintf("TYPE|%s\n", entry.FileType))
	b.WriteString(fmt.Sprintf("PATH|%s\n", entry.Path))
	b.WriteString(".\n")
	return b.String()
}

func handleRun(index *SearchIndex, apiClient *APIClient, assembly64Path string, id int) string {
	if id < 0 || id >= len(index.Entries) {
		return "ERR Invalid ID\n"
	}

	entry := index.Entries[id]

	// Use FullPath which was computed during indexing
	fullPath := entry.FullPath
	if fullPath == "" {
		return "ERR Entry has no file path\n"
	}

	// Read file
	fileData, err := readFile(fullPath)
	if err != nil {
		slog.Error("Failed to read file", "path", fullPath, "error", err)
		return fmt.Sprintf("ERR Cannot read file: %s\n", err)
	}

	// Run based on file type
	var runErr error
	switch strings.ToLower(entry.FileType) {
	case "prg":
		runErr = apiClient.runPRG(fileData)
	case "crt":
		runErr = apiClient.runCRT(fileData)
	case "d64", "g64", "d71", "d81":
		runErr = apiClient.runDiskImage(fileData, entry.FileType, entry.Name)
	default:
		return fmt.Sprintf("ERR Unsupported file type: %s\n", entry.FileType)
	}

	if runErr != nil {
		slog.Error("Failed to run file", "path", fullPath, "error", runErr)
		return fmt.Sprintf("ERR Run failed: %s\n", runErr)
	}

	slog.Info("Running entry", "name", entry.Name, "type", entry.FileType)
	return fmt.Sprintf("OK Running %s\n", entry.Name)
}

// readFile reads a file from disk.
func readFile(path string) ([]byte, error) {
	return os.ReadFile(path)
}
