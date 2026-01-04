// Terminal user interface for browsing Assembly64 collections.
// The TUI allows users to search, filter by category, and upload files to C64 Ultimate.
package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

var (
	titleStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("205")).
			MarginBottom(1)

	headerStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color("39"))

	selectedStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("170")).
			Bold(true)

	categoryStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("86"))

	dimStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("241"))

	helpStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("241")).
			MarginTop(1)

	statusStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("205"))

	errorStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("196")).
			Bold(true)
)

// Model represents the TUI application state.
type Model struct {
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
	quitting         bool
	assembly64Path   string
}

// NewModel creates a new TUI model.
func NewModel(index *SearchIndex, apiClient *APIClient, assembly64Path string) Model {
	m := Model{
		index:            index,
		apiClient:        apiClient,
		assembly64Path:   assembly64Path,
		selectedCategory: "All",
		searchQuery:      "",
		filteredResults:  make([]int, 0),
	}
	m.applyFilters()
	return m
}

// Init initializes the model.
func (m Model) Init() tea.Cmd {
	return nil
}

// handleNavigation handles cursor navigation keys.
func (m *Model) handleNavigation(key string) {
	switch key {
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
		m.cursor = len(m.filteredResults) - 1
		m.adjustScroll()
	}
}

// handleKeyMsg processes keyboard messages.
func (m Model) handleKeyMsg(msg tea.KeyMsg) (Model, tea.Cmd) {
	switch msg.String() {
	case "ctrl+c", "esc", "q":
		m.quitting = true
		return m, tea.Quit

	case "ctrl+l":
		return m, m.refreshIndex()

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
		return m, nil

	case "up", "down", "pgup", "pgdown", "home", "end":
		m.handleNavigation(msg.String())
		return m, nil

	case "enter":
		return m, m.loadSelectedEntry()

	case "backspace":
		if len(m.searchQuery) > 0 {
			m.searchQuery = m.searchQuery[:len(m.searchQuery)-1]
			m.cursor = 0
			m.scrollOffset = 0
			m.applyFilters()
		}
		return m, nil

	default:
		// Append printable characters to search query.
		if len(msg.String()) == 1 && msg.String()[0] >= 32 && msg.String()[0] <= 126 {
			m.searchQuery += msg.String()
			m.cursor = 0
			m.scrollOffset = 0
			m.applyFilters()
		}
		return m, nil
	}
}

// Update handles messages and updates the model.
func (m Model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
		return m, nil

	case statusMsg:
		if msg.err != nil {
			m.err = msg.err
			m.statusMessage = ""
		} else {
			m.statusMessage = msg.message
			m.err = nil
		}
		return m, nil

	case refreshMsg:
		if msg.err != nil {
			m.err = msg.err
			m.statusMessage = ""
		} else {
			// Replace the index with the refreshed one.
			m.index = msg.index
			m.statusMessage = "✓ Index refreshed"
			m.err = nil
			// Re-apply filters to update the display.
			m.cursor = 0
			m.scrollOffset = 0
			m.applyFilters()
		}
		return m, nil

	case tea.KeyMsg:
		return m.handleKeyMsg(msg)
	}

	return m, nil
}

// renderHeader renders the title, category selector, and search input.
func (m Model) renderHeader() string {
	var b strings.Builder

	// Title.
	b.WriteString(titleStyle.Render("C64 Ultimate - Assembly64 Browser"))
	b.WriteString("\n\n")

	// Category selector.
	b.WriteString(headerStyle.Render("Category: "))
	for i, cat := range m.index.CategoryOrder {
		if cat == m.selectedCategory {
			b.WriteString(selectedStyle.Render("[" + cat + "]"))
		} else {
			b.WriteString(categoryStyle.Render(cat))
		}
		if i < len(m.index.CategoryOrder)-1 {
			b.WriteString(" ")
		}
	}
	b.WriteString("\n")

	// Search input.
	b.WriteString(headerStyle.Render("Search: "))
	if m.searchQuery == "" {
		b.WriteString(dimStyle.Render("(type to search)"))
	} else {
		b.WriteString(m.searchQuery)
		b.WriteString("_")
	}
	b.WriteString("\n\n")

	return b.String()
}

// renderResults renders the filtered results list.
func (m Model) renderResults(viewHeight int) string {
	var b strings.Builder

	if len(m.filteredResults) == 0 {
		b.WriteString(dimStyle.Render("No results found"))
		b.WriteString("\n")
	} else {
		// Render visible entries.
		start := m.scrollOffset
		end := min(start+viewHeight, len(m.filteredResults))

		for i := start; i < end; i++ {
			entry := m.index.Entries[m.filteredResults[i]]
			line := m.formatEntry(entry, i == m.cursor)
			b.WriteString(line)
			b.WriteString("\n")
		}

		// Result count.
		b.WriteString("\n")
		b.WriteString(dimStyle.Render(fmt.Sprintf("[%d results]", len(m.filteredResults))))
		b.WriteString("\n")
	}

	return b.String()
}

// renderFooter renders status messages and help text.
func (m Model) renderFooter() string {
	var b strings.Builder

	// Status/error message.
	if m.err != nil {
		b.WriteString(errorStyle.Render(fmt.Sprintf("Error: %v", m.err)))
		b.WriteString("\n")
	} else if m.statusMessage != "" {
		b.WriteString(statusStyle.Render(m.statusMessage))
		b.WriteString("\n")
	}

	// Help text.
	b.WriteString(helpStyle.Render("↑/↓: Navigate  Tab: Category  Enter: Load  Ctrl+L: Refresh  Backspace: Clear  Esc/Q: Quit"))
	b.WriteString("\n")

	// Selected file path.
	if len(m.filteredResults) > 0 && m.cursor < len(m.filteredResults) {
		entry := m.index.Entries[m.filteredResults[m.cursor]]
		path := entry.FullPath
		if m.width > 10 && len(path) > m.width-2 {
			truncLen := m.width - 5
			if truncLen > 0 && truncLen < len(path) {
				path = "..." + path[len(path)-truncLen:]
			}
		}
		b.WriteString(dimStyle.Render(path))
	}

	return b.String()
}

// View renders the UI.
func (m Model) View() string {
	if m.quitting {
		return ""
	}

	var b strings.Builder

	// Render header.
	b.WriteString(m.renderHeader())

	// Calculate view height.
	viewHeight := m.height - 12 // Reserve space for header/footer.
	if viewHeight < 5 {
		viewHeight = 5
	}

	// Render results.
	b.WriteString(m.renderResults(viewHeight))

	// Render footer.
	b.WriteString(m.renderFooter())

	return b.String()
}

// formatEntry formats a single entry for display.
func (m Model) formatEntry(entry ReleaseEntry, selected bool) string {
	// Format: "> Name                    (Group, Year)         .ext".
	cursor := "  "
	if selected {
		cursor = "> "
	}

	// Truncate name if too long.
	name := entry.Name
	maxNameLen := 30
	if len(name) > maxNameLen {
		name = name[:maxNameLen-3] + "..."
	}

	// Format group/year.
	meta := ""
	if entry.Group != "" || entry.Year != "" {
		meta = fmt.Sprintf("(%s, %s)", entry.Group, entry.Year)
	}

	// Format extension.
	ext := "." + entry.FileType

	line := fmt.Sprintf("%s%-32s  %-25s  %s", cursor, name, meta, ext)

	if selected {
		return selectedStyle.Render(line)
	}
	return line
}

// applyFilters filters entries based on category and search query.
func (m *Model) applyFilters() {
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
func (m *Model) adjustScroll() {
	viewHeight := m.height - 12
	if viewHeight < 5 {
		viewHeight = 5
	}

	if m.cursor < m.scrollOffset {
		m.scrollOffset = m.cursor
	} else if m.cursor >= m.scrollOffset+viewHeight {
		m.scrollOffset = m.cursor - viewHeight + 1
	}
}

// refreshIndex reloads the Assembly64 index from disk.
func (m *Model) refreshIndex() tea.Cmd {
	return func() tea.Msg {
		index, err := loadAssembly64Index(m.assembly64Path)
		if err != nil {
			return refreshMsg{err: fmt.Errorf("failed to refresh index: %w", err)}
		}
		return refreshMsg{index: index}
	}
}

// loadSelectedEntry loads the selected entry to C64 Ultimate.
func (m *Model) loadSelectedEntry() tea.Cmd {
	return func() tea.Msg {
		if len(m.filteredResults) == 0 {
			return statusMsg{err: fmt.Errorf("no entry selected")}
		}

		entry := m.index.Entries[m.filteredResults[m.cursor]]

		// Read file.
		data, err := os.ReadFile(entry.FullPath)
		if err != nil {
			return statusMsg{err: fmt.Errorf("failed to read file: %w", err)}
		}

		// Call appropriate API based on file type.
		var loadErr error
		switch entry.FileType {
		case "d64", "d71", "d81", "g64", "g71":
			// Use existing runDiskImage (auto-runs first PRG).
			loadErr = m.apiClient.runDiskImage(data, entry.FileType, filepath.Base(entry.FullPath))
		case "prg":
			loadErr = m.apiClient.runPRG(data)
		case "crt":
			loadErr = m.apiClient.runCRT(data)
		default:
			return statusMsg{err: fmt.Errorf("unsupported file type: %s", entry.FileType)}
		}

		if loadErr != nil {
			return statusMsg{err: fmt.Errorf("failed to load: %w", loadErr)}
		}

		return statusMsg{message: fmt.Sprintf("✓ Loaded: %s", entry.Name)}
	}
}

// statusMsg is a message for status updates.
type statusMsg struct {
	message string
	err     error
}

// refreshMsg is a message for index refresh results.
type refreshMsg struct {
	index *SearchIndex
	err   error
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}
