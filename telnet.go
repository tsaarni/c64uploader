// Telnet server for browsing Assembly64 collections remotely.
// Allows connecting from CCGMS on C64 Ultimate or standard telnet clients.
package main

import (
	"fmt"
	"log/slog"
	"net"
	"os"
	"path/filepath"
	"strings"
	"sync/atomic"
	"time"
)

// Plain text mode for C64 Ultimate compatibility (no ANSI codes).
// For screen "clear", we output enough newlines to push old content off.
var (
	ansiReset   = ""
	ansiBold    = ""
	ansiReverse = ""
	ansiMagenta = ""
	ansiCyan    = ""
	ansiGray    = ""
	ansiRed     = ""
	ansiGreen   = ""
	ansiClear   = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n----------------------------------------\r\n"
)

// Server limits.
const (
	maxConnections = 10              // Maximum concurrent connections
	readTimeout    = 5 * time.Minute // Idle timeout per connection
)

// TelnetModel holds state for a telnet session.
type TelnetModel struct {
	index            *SearchIndex
	apiClient        *APIClient
	searchQuery      string
	selectedCategory string
	filteredResults  []int
	cursor           int
	scrollOffset     int
	width            int
	height           int
	statusMessage    string
	err              error
	assembly64Path   string
}

// NewTelnetModel creates a new telnet session model.
// Defaults to C64 screen dimensions (40x25) for authentic experience.
func NewTelnetModel(index *SearchIndex, apiClient *APIClient, assembly64Path string) *TelnetModel {
	m := &TelnetModel{
		index:            index,
		apiClient:        apiClient,
		assembly64Path:   assembly64Path,
		selectedCategory: "All",
		searchQuery:      "",
		filteredResults:  make([]int, 0),
		width:            40,
		height:           25,
	}
	m.applyFilters()
	return m
}

// applyFilters filters entries based on category and search query.
func (m *TelnetModel) applyFilters() {
	m.filteredResults = make([]int, 0)
	query := strings.ToLower(m.searchQuery)

	for i, entry := range m.index.Entries {
		// Category filter.
		if m.selectedCategory != "All" && entry.CategoryName != m.selectedCategory {
			continue
		}

		// Search filter.
		if query != "" {
			nameMatch := strings.Contains(strings.ToLower(entry.Name), query)
			groupMatch := strings.Contains(strings.ToLower(entry.Group), query)
			if !nameMatch && !groupMatch {
				continue
			}
		}

		m.filteredResults = append(m.filteredResults, i)
	}

	// Reset cursor if out of bounds.
	if m.cursor >= len(m.filteredResults) {
		m.cursor = 0
		m.scrollOffset = 0
	}
}

// adjustScroll adjusts scroll offset to keep cursor visible.
func (m *TelnetModel) adjustScroll() {
	viewHeight := m.height - 10
	if viewHeight < 5 {
		viewHeight = 5
	}

	if m.cursor < m.scrollOffset {
		m.scrollOffset = m.cursor
	} else if m.cursor >= m.scrollOffset+viewHeight {
		m.scrollOffset = m.cursor - viewHeight + 1
	}
}

// handleNavigation handles cursor navigation.
func (m *TelnetModel) handleNavigation(action string) {
	// Guard against empty results.
	if len(m.filteredResults) == 0 {
		m.cursor = 0
		m.scrollOffset = 0
		return
	}

	switch action {
	case "up":
		if m.cursor > 0 {
			m.cursor--
			m.adjustScroll()
		}
	case "down":
		if m.cursor < len(m.filteredResults)-1 {
			m.cursor++
			m.adjustScroll()
		}
	case "pgup":
		m.cursor = max(0, m.cursor-10)
		m.adjustScroll()
	case "pgdown":
		m.cursor = min(len(m.filteredResults)-1, m.cursor+10)
		m.adjustScroll()
	case "home":
		m.cursor = 0
		m.scrollOffset = 0
	case "end":
		m.cursor = max(0, len(m.filteredResults)-1)
		m.adjustScroll()
	}
}

// loadSelectedEntry loads the selected entry to C64 Ultimate.
func (m *TelnetModel) loadSelectedEntry() error {
	if len(m.filteredResults) == 0 {
		return fmt.Errorf("no entry selected")
	}

	entry := m.index.Entries[m.filteredResults[m.cursor]]

	// Read file.
	data, err := os.ReadFile(entry.FullPath)
	if err != nil {
		return fmt.Errorf("failed to read file: %w", err)
	}

	// Call appropriate API based on file type.
	switch entry.FileType {
	case "d64", "d71", "d81", "g64", "g71":
		err = m.apiClient.runDiskImage(data, entry.FileType, filepath.Base(entry.FullPath))
	case "prg":
		err = m.apiClient.runPRG(data)
	case "crt":
		err = m.apiClient.runCRT(data)
	default:
		return fmt.Errorf("unsupported file type: %s", entry.FileType)
	}

	if err != nil {
		return fmt.Errorf("failed to load: %w", err)
	}

	m.statusMessage = fmt.Sprintf("Loaded: %s", entry.Name)
	m.err = nil
	return nil
}

// refreshIndex reloads the Assembly64 index from disk.
func (m *TelnetModel) refreshIndex() error {
	index, err := loadAssembly64Index(m.assembly64Path)
	if err != nil {
		return fmt.Errorf("failed to refresh index: %w", err)
	}
	m.index = index
	m.statusMessage = "Index refreshed"
	m.err = nil
	m.cursor = 0
	m.scrollOffset = 0
	m.applyFilters()
	return nil
}

// startTelnetServer starts the telnet server.
func startTelnetServer(c64Host string, port int, assembly64Path string) error {
	// Validate port.
	if port < 1 || port > 65535 {
		return fmt.Errorf("invalid port %d: must be between 1 and 65535", port)
	}

	// Load the Assembly64 index once at startup.
	index, err := loadAssembly64Index(assembly64Path)
	if err != nil {
		return fmt.Errorf("failed to load Assembly64 database from %s: %w", assembly64Path, err)
	}
	slog.Info("Loaded Assembly64 index", "entries", len(index.Entries))

	// Create TCP listener.
	listener, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
	if err != nil {
		return fmt.Errorf("failed to start listener: %w", err)
	}
	defer listener.Close()

	slog.Info("Telnet server listening", "port", port)
	fmt.Printf("Telnet server listening on :%d\n", port)

	// Track active connections.
	var activeConns int32

	// Accept connections.
	for {
		conn, err := listener.Accept()
		if err != nil {
			slog.Error("Accept error", "error", err)
			continue
		}

		// Check connection limit.
		if atomic.LoadInt32(&activeConns) >= maxConnections {
			slog.Warn("Connection rejected: max connections reached", "remote", conn.RemoteAddr())
			conn.Write([]byte("Server busy, try again later.\r\n"))
			conn.Close()
			continue
		}

		atomic.AddInt32(&activeConns, 1)
		slog.Info("Client connected", "remote", conn.RemoteAddr(), "active", atomic.LoadInt32(&activeConns))

		go func(c net.Conn) {
			defer atomic.AddInt32(&activeConns, -1)
			handleConnection(c, index, c64Host, assembly64Path)
		}(conn)
	}
}

// handleConnection handles a single telnet connection.
func handleConnection(conn net.Conn, index *SearchIndex, c64Host string, assembly64Path string) {
	defer conn.Close()
	defer slog.Info("Client disconnected", "remote", conn.RemoteAddr())

	// Send telnet negotiation for character mode.
	// IAC WILL ECHO (255, 251, 1) - server will echo
	// IAC WILL SGA (255, 251, 3) - suppress go ahead for character-at-a-time
	// IAC WONT LINEMODE (255, 252, 34) - disable line mode
	if _, err := conn.Write([]byte{255, 251, 1}); err != nil {
		return
	}
	if _, err := conn.Write([]byte{255, 251, 3}); err != nil {
		return
	}
	if _, err := conn.Write([]byte{255, 252, 34}); err != nil {
		return
	}

	// Create per-connection API client and model.
	apiClient := NewAPIClient(c64Host)
	model := NewTelnetModel(index, apiClient, assembly64Path)

	// Main loop.
	// Initial render.
	if err := renderScreen(conn, model); err != nil {
		slog.Debug("Write error", "error", err)
		return
	}

	for {
		// Set read deadline.
		conn.SetReadDeadline(time.Now().Add(readTimeout))

		// Read input.
		action, err := readInput(conn)
		if err != nil {
			if netErr, ok := err.(net.Error); ok && netErr.Timeout() {
				slog.Debug("Connection timed out", "remote", conn.RemoteAddr())
			} else {
				slog.Debug("Read error", "error", err)
			}
			return
		}

		// Skip empty actions (IAC sequences, etc.) - don't redraw.
		if action == "" {
			continue
		}

		// Handle input.
		if !handleInput(model, action, conn) {
			return // quit
		}

		// Render screen after handling input.
		if err := renderScreen(conn, model); err != nil {
			slog.Debug("Write error", "error", err)
			return
		}
	}
}

// renderScreen renders the full UI to the connection.
// Adapts layout for 40-column (C64) vs 80-column terminals.
func renderScreen(conn net.Conn, m *TelnetModel) error {
	var b strings.Builder

	// Clear screen and reset cursor to top-left.
	b.WriteString(ansiClear)

	// Title (shorter for 40-col).
	b.WriteString(ansiBold + ansiMagenta)
	if m.width <= 40 {
		b.WriteString("Assembly64 Browser")
	} else {
		b.WriteString("C64 Ultimate - Assembly64 Browser")
	}
	b.WriteString(ansiReset)
	b.WriteString("\r\n")

	// Category (compact for 40-col).
	if m.width <= 40 {
		b.WriteString(ansiCyan + "[" + m.selectedCategory + "]" + ansiReset)
	} else {
		b.WriteString(ansiBold + ansiCyan + "Category: " + ansiReset)
		for i, cat := range m.index.CategoryOrder {
			if cat == m.selectedCategory {
				b.WriteString(ansiReverse + ansiBold + "[" + cat + "]" + ansiReset)
			} else {
				b.WriteString(ansiCyan + cat + ansiReset)
			}
			if i < len(m.index.CategoryOrder)-1 {
				b.WriteString(" ")
			}
		}
	}
	b.WriteString("\r\n")

	// Search line.
	if m.width <= 40 {
		b.WriteString(ansiCyan + ">" + ansiReset)
	} else {
		b.WriteString(ansiBold + ansiCyan + "Search: " + ansiReset)
	}
	if m.searchQuery == "" {
		if m.width > 40 {
			b.WriteString(ansiGray + "(type to search)" + ansiReset)
		}
	} else {
		b.WriteString(m.searchQuery)
		b.WriteString(ansiReverse + " " + ansiReset)
	}
	b.WriteString("\r\n")

	// Results list.
	viewHeight := m.height - 8
	if viewHeight < 5 {
		viewHeight = 5
	}

	if len(m.filteredResults) == 0 {
		b.WriteString(ansiGray + "No results" + ansiReset + "\r\n")
	} else {
		start := m.scrollOffset
		end := min(start+viewHeight, len(m.filteredResults))

		for i := start; i < end; i++ {
			entry := m.index.Entries[m.filteredResults[i]]
			line := formatEntryTelnet(entry, i == m.cursor, m.width)
			b.WriteString(line)
			b.WriteString("\r\n")
		}
	}

	// Result count.
	b.WriteString(ansiGray)
	b.WriteString(fmt.Sprintf("[%d]", len(m.filteredResults)))
	b.WriteString(ansiReset)

	// Status/error message.
	if m.err != nil {
		b.WriteString(" " + ansiRed)
		// Truncate error for narrow screens.
		errStr := m.err.Error()
		maxErr := m.width - 10
		if maxErr > 0 && len(errStr) > maxErr {
			errStr = errStr[:maxErr]
		}
		b.WriteString(errStr)
		b.WriteString(ansiReset)
	} else if m.statusMessage != "" {
		b.WriteString(" " + ansiGreen + m.statusMessage + ansiReset)
	}
	b.WriteString("\r\n")

	// Help line (compact for 40-col).
	b.WriteString(ansiGray)
	if m.width <= 40 {
		b.WriteString("Arr Tab Ent Q")
	} else {
		b.WriteString("Arrows Tab Enter Q:Quit")
	}
	b.WriteString(ansiReset)

	_, err := conn.Write([]byte(b.String()))
	return err
}

// formatEntryTelnet formats a single entry for telnet display.
// Adapts layout based on terminal width (40 for C64, 80+ for modern).
func formatEntryTelnet(entry ReleaseEntry, selected bool, width int) string {
	cursor := " "
	if selected {
		cursor = ">"
	}

	ext := "." + entry.FileType
	name := entry.Name

	var line string
	if width <= 40 {
		// 40-col: ">Name.ext" - compact, no metadata.
		maxNameLen := width - 2 - len(ext) // 1 cursor, 1 space
		if maxNameLen < 8 {
			maxNameLen = 8
		}
		if len(name) > maxNameLen {
			name = name[:maxNameLen-2] + ".."
		}
		line = fmt.Sprintf("%s%s%s", cursor, name, ext)
	} else {
		// 80-col: "> Name                (Group, Year)  .ext"
		maxNameLen := 30
		if len(name) > maxNameLen {
			name = name[:maxNameLen-3] + "..."
		}
		meta := ""
		if entry.Group != "" || entry.Year != "" {
			meta = fmt.Sprintf("(%s, %s)", entry.Group, entry.Year)
		}
		line = fmt.Sprintf("%s %-32s %-25s %s", cursor, name, meta, ext)
	}

	if selected {
		return ansiBold + ansiMagenta + line + ansiReset
	}
	return line
}

// readInput reads input from the connection and returns an action string.
func readInput(conn net.Conn) (string, error) {
	buf := make([]byte, 32)
	n, err := conn.Read(buf)
	if err != nil {
		return "", err
	}

	if n == 0 {
		return "", nil
	}

	data := buf[:n]

	// Debug: log raw bytes received.
	slog.Debug("readInput: raw bytes", "count", n, "hex", fmt.Sprintf("%x", data), "ascii", string(data))

	// Handle telnet IAC sequences.
	// C64U sends bytes one at a time, so we need to handle partial sequences.
	// IAC (255) starts a command sequence.
	if data[0] == 255 {
		// Read more bytes to complete the IAC sequence.
		conn.SetReadDeadline(time.Now().Add(100 * time.Millisecond))
		more := make([]byte, 8)
		n2, _ := conn.Read(more)
		conn.SetReadDeadline(time.Time{}) // Reset deadline.
		if n2 > 0 {
			data = append(data, more[:n2]...)
			slog.Debug("readInput: IAC sequence", "hex", fmt.Sprintf("%x", data))
		}
		// Skip the entire IAC sequence (return empty to get next input).
		return "", nil
	}

	// Skip any stray IAC command bytes (251-254) that arrived separately.
	// These are WILL/WONT/DO/DONT without the IAC prefix.
	if data[0] >= 251 && data[0] <= 254 {
		slog.Debug("readInput: skipping stray IAC command byte", "byte", data[0])
		return "", nil
	}

	// Handle common control characters BEFORE IAC option check.
	// These are valid user inputs, not IAC option bytes.
	// Note: We don't handle Ctrl+C (3) here because it conflicts with
	// telnet SGA option code. Use 'q' to quit instead.
	switch data[0] {
	case '\t': // Tab (9)
		return "tab", nil
	case '\r', '\n': // Enter (13, 10)
		return "enter", nil
	case 127, 8: // DEL or Backspace
		return "backspace", nil
	case 12: // Ctrl+L
		return "refresh", nil
	}

	// Skip option codes (0-50 range) that follow WILL/WONT/DO/DONT.
	// But exclude control chars we already handled above.
	// Common: 1=ECHO, 3=SGA, 34=LINEMODE.
	if len(data) == 1 && data[0] <= 50 {
		slog.Debug("readInput: skipping IAC option byte", "byte", data[0])
		return "", nil
	}

	// Parse escape sequences.
	if data[0] == 27 { // ESC
		// If we only got ESC, we need to check if more data is coming.
		// Wait briefly for the rest of an escape sequence.
		if len(data) == 1 {
			// Set a short deadline to see if more data arrives.
			conn.SetReadDeadline(time.Now().Add(50 * time.Millisecond))
			more := make([]byte, 8)
			n2, _ := conn.Read(more)
			if n2 > 0 {
				data = append(data, more[:n2]...)
			} else {
				// No more data - it's a standalone ESC.
				return "quit", nil
			}
		}

		if len(data) >= 3 && data[1] == '[' {
			switch data[2] {
			case 'A':
				return "up", nil
			case 'B':
				return "down", nil
			case 'C':
				return "right", nil
			case 'D':
				return "left", nil
			case 'H':
				return "home", nil
			case 'F':
				return "end", nil
			case '5':
				if len(data) >= 4 && data[3] == '~' {
					return "pgup", nil
				}
			case '6':
				if len(data) >= 4 && data[3] == '~' {
					return "pgdown", nil
				}
			case '1':
				if len(data) >= 4 && data[3] == '~' {
					return "home", nil
				}
			case '4':
				if len(data) >= 4 && data[3] == '~' {
					return "end", nil
				}
			}
		}
		return "", nil // Ignore unknown escape sequences
	}

	// Single character commands (for escape sequence fallthrough).
	switch data[0] {
	case 'q', 'Q':
		return "quit", nil
	}

	// Printable character.
	if data[0] >= 32 && data[0] <= 126 {
		return string(data[0]), nil
	}

	// Debug: unrecognized input.
	slog.Debug("readInput: unrecognized", "byte", data[0], "hex", fmt.Sprintf("%02x", data[0]))
	return "", nil
}

// handleInput processes user input and returns false to quit.
func handleInput(m *TelnetModel, action string, conn net.Conn) bool {
	// Clear previous status on new action.
	if action != "" && action != "enter" {
		m.statusMessage = ""
		m.err = nil
	}

	switch action {
	case "quit":
		return false

	case "up", "down", "pgup", "pgdown", "home", "end":
		m.handleNavigation(action)

	case "tab":
		// Cycle through categories.
		currentIdx := -1
		for i, cat := range m.index.CategoryOrder {
			if cat == m.selectedCategory {
				currentIdx = i
				break
			}
		}
		nextIdx := (currentIdx + 1) % len(m.index.CategoryOrder)
		m.selectedCategory = m.index.CategoryOrder[nextIdx]
		m.cursor = 0
		m.scrollOffset = 0
		m.applyFilters()

	case "enter":
		m.statusMessage = "Loading..."
		m.err = nil
		renderScreen(conn, m)
		if err := m.loadSelectedEntry(); err != nil {
			m.err = err
			m.statusMessage = ""
		}

	case "backspace":
		if len(m.searchQuery) > 0 {
			m.searchQuery = m.searchQuery[:len(m.searchQuery)-1]
			m.cursor = 0
			m.scrollOffset = 0
			m.applyFilters()
		}

	case "refresh":
		m.statusMessage = "Refreshing..."
		m.err = nil
		renderScreen(conn, m)
		if err := m.refreshIndex(); err != nil {
			m.err = err
			m.statusMessage = ""
		}

	default:
		// Printable character for search.
		if len(action) == 1 && action[0] >= 32 && action[0] <= 126 {
			m.searchQuery += action
			m.cursor = 0
			m.scrollOffset = 0
			m.applyFilters()
		}
	}

	return true
}
