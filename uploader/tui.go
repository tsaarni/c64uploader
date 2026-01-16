// Terminal user interface for browsing Assembly64 collections.
// The TUI allows users to search, filter by category, and upload files to C64 Ultimate.
package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strconv"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

// searchMode represents the current search mode.
type searchMode int

const (
	modeNormal searchMode = iota
	modeAdvanced
)

// advancedField represents a field in the advanced search form.
type advancedField int

const (
	fieldTitle advancedField = iota
	fieldGroup
	fieldLanguage
	fieldRegion
	fieldEngine
	fieldFileType
	fieldMinTrainers
	fieldMaxTrainers
	fieldTop200Only
	fieldIs4kOnly
	fieldHasDocs
	fieldHasFastload
	fieldCracked
	fieldCount // Sentinel for field count.
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

	cursorStyle = lipgloss.NewStyle().
			Bold(true).
			Reverse(true)

	formLabelStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("39")).
			Width(14)

	formInputStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("255"))

	formActiveStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color("170")).
			Bold(true)

	formToggleOnStyle = lipgloss.NewStyle().
				Foreground(lipgloss.Color("82")).
				Bold(true)

	formToggleOffStyle = lipgloss.NewStyle().
				Foreground(lipgloss.Color("241"))
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
	legacyMode       bool // True if using legacy .releaselog.json loading (enables refresh)

	// Advanced search state.
	mode           searchMode
	advSearch      AdvancedSearch
	activeField    advancedField
	advFieldValues [fieldCount]string // Text values for text input fields.
}

// NewModel creates a new TUI model.
func NewModel(index *SearchIndex, apiClient *APIClient, assembly64Path string, legacyMode bool) Model {
	m := Model{
		index:            index,
		apiClient:        apiClient,
		assembly64Path:   assembly64Path,
		legacyMode:       legacyMode,
		selectedCategory: "All",
		searchQuery:      "",
		filteredResults:  make([]int, 0),
		mode:             modeNormal,
		advSearch:        AdvancedSearch{MaxTrainers: -1},
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
	// Handle mode-specific keys.
	if m.mode == modeAdvanced {
		return m.handleAdvancedKeyMsg(msg)
	}
	return m.handleNormalKeyMsg(msg)
}

// handleNormalKeyMsg handles keys in normal search mode.
func (m Model) handleNormalKeyMsg(msg tea.KeyMsg) (Model, tea.Cmd) {
	switch msg.String() {
	case "ctrl+c", "q":
		m.quitting = true
		return m, tea.Quit

	case "esc":
		// Clear search query, or quit if empty.
		if m.searchQuery != "" {
			m.searchQuery = ""
			m.cursor = 0
			m.scrollOffset = 0
			m.applyFilters()
			return m, nil
		}
		m.quitting = true
		return m, tea.Quit

	case "/":
		// Enter advanced search mode (only in JSON database mode).
		if !m.legacyMode {
			m.mode = modeAdvanced
			m.activeField = fieldTitle
			// Copy current query to title field.
			m.advFieldValues[fieldTitle] = m.searchQuery
		}
		return m, nil

	case "ctrl+l":
		if m.legacyMode {
			// In legacy mode, reload the index from disk.
			return m, m.refreshIndex()
		}
		// In JSON database mode, reset search/filters to show all results.
		m.searchQuery = ""
		m.advSearch = AdvancedSearch{MaxTrainers: -1}
		m.advFieldValues = [fieldCount]string{}
		m.cursor = 0
		m.scrollOffset = 0
		m.applyFilters()
		m.statusMessage = "Search reset"
		return m, nil

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

// handleAdvancedKeyMsg handles keys in advanced search mode.
func (m Model) handleAdvancedKeyMsg(msg tea.KeyMsg) (Model, tea.Cmd) {
	switch msg.String() {
	case "ctrl+c":
		m.quitting = true
		return m, tea.Quit

	case "esc":
		// Exit advanced search mode without applying.
		m.mode = modeNormal
		return m, nil

	case "enter":
		// Apply advanced search and return to results.
		m.applyAdvancedSearch()
		m.mode = modeNormal
		m.cursor = 0
		m.scrollOffset = 0
		return m, nil

	case "up":
		if m.activeField > 0 {
			m.activeField--
		}
		return m, nil

	case "down", "tab":
		if m.activeField < fieldCount-1 {
			m.activeField++
		}
		return m, nil

	case "shift+tab":
		if m.activeField > 0 {
			m.activeField--
		}
		return m, nil

	case "backspace":
		// Handle backspace for text fields.
		if m.isTextField(m.activeField) {
			val := m.advFieldValues[m.activeField]
			if len(val) > 0 {
				m.advFieldValues[m.activeField] = val[:len(val)-1]
			}
		}
		return m, nil

	case " ":
		// Toggle boolean fields with space.
		if m.isToggleField(m.activeField) {
			m.toggleField(m.activeField)
			return m, nil
		}
		// Fall through to add space for text fields.
		fallthrough

	default:
		// Append printable characters to text fields.
		if m.isTextField(m.activeField) && len(msg.String()) == 1 {
			ch := msg.String()[0]
			if ch >= 32 && ch <= 126 {
				m.advFieldValues[m.activeField] += msg.String()
			}
		}
		return m, nil
	}
}

// isTextField returns true if the field accepts text input.
func (m *Model) isTextField(field advancedField) bool {
	switch field {
	case fieldTitle, fieldGroup, fieldLanguage, fieldRegion, fieldEngine, fieldFileType,
		fieldMinTrainers, fieldMaxTrainers:
		return true
	}
	return false
}

// isToggleField returns true if the field is a boolean toggle.
func (m *Model) isToggleField(field advancedField) bool {
	switch field {
	case fieldTop200Only, fieldIs4kOnly, fieldHasDocs, fieldHasFastload, fieldCracked:
		return true
	}
	return false
}

// toggleField toggles a boolean field value.
func (m *Model) toggleField(field advancedField) {
	switch field {
	case fieldTop200Only:
		m.advSearch.Top200Only = !m.advSearch.Top200Only
	case fieldIs4kOnly:
		m.advSearch.Is4kOnly = !m.advSearch.Is4kOnly
	case fieldHasDocs:
		m.advSearch.HasDocs = !m.advSearch.HasDocs
	case fieldHasFastload:
		m.advSearch.HasFastload = !m.advSearch.HasFastload
	case fieldCracked:
		// Cycle: nil -> true -> false -> nil.
		if m.advSearch.IsCracked == nil {
			t := true
			m.advSearch.IsCracked = &t
		} else if *m.advSearch.IsCracked {
			f := false
			m.advSearch.IsCracked = &f
		} else {
			m.advSearch.IsCracked = nil
		}
	}
}

// applyAdvancedSearch transfers form values to AdvancedSearch struct.
func (m *Model) applyAdvancedSearch() {
	m.advSearch.Title = m.advFieldValues[fieldTitle]
	m.advSearch.Group = m.advFieldValues[fieldGroup]
	m.advSearch.Language = m.advFieldValues[fieldLanguage]
	m.advSearch.Region = m.advFieldValues[fieldRegion]
	m.advSearch.Engine = m.advFieldValues[fieldEngine]
	m.advSearch.FileType = m.advFieldValues[fieldFileType]

	// Parse trainer counts.
	m.advSearch.MinTrainers = 0
	m.advSearch.MaxTrainers = -1
	if val := m.advFieldValues[fieldMinTrainers]; val != "" {
		if n, err := strconv.Atoi(val); err == nil {
			m.advSearch.MinTrainers = n
		}
	}
	if val := m.advFieldValues[fieldMaxTrainers]; val != "" {
		if n, err := strconv.Atoi(val); err == nil {
			m.advSearch.MaxTrainers = n
		}
	}

	m.applyAdvancedFilters()
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
		b.WriteString(cursorStyle.Render(" "))
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
	var helpText string
	if m.legacyMode {
		helpText = "↑/↓: Navigate  Tab: Category  Enter: Load  Ctrl+L: Refresh  Esc/Q: Quit"
	} else {
		helpText = "↑/↓: Navigate  Tab: Category  /: Advanced  Enter: Load  Ctrl+L: Reset  Esc/Q: Quit"
	}
	b.WriteString(helpStyle.Render(helpText))
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

	// Render advanced search form if in that mode.
	if m.mode == modeAdvanced {
		return m.renderAdvancedSearchForm()
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

// renderAdvancedSearchForm renders the advanced search form.
func (m Model) renderAdvancedSearchForm() string {
	var b strings.Builder

	b.WriteString(titleStyle.Render("Advanced Search"))
	b.WriteString("\n\n")

	// Field labels and types.
	fields := []struct {
		field advancedField
		label string
		hint  string
	}{
		{fieldTitle, "Title", "partial match"},
		{fieldGroup, "Group", "partial match"},
		{fieldLanguage, "Language", "german, french, english..."},
		{fieldRegion, "Region", "PAL, NTSC"},
		{fieldEngine, "Engine", "seuck, gkgm, bdck..."},
		{fieldFileType, "File Type", "d64, prg, crt..."},
		{fieldMinTrainers, "Min Trainers", "number"},
		{fieldMaxTrainers, "Max Trainers", "number (-1 = any)"},
		{fieldTop200Only, "Top 200 Only", "toggle"},
		{fieldIs4kOnly, "4K Only", "toggle"},
		{fieldHasDocs, "Has Docs", "toggle"},
		{fieldHasFastload, "Has Fastload", "toggle"},
		{fieldCracked, "Cracked", "any/yes/no"},
	}

	for _, f := range fields {
		isActive := m.activeField == f.field
		label := formLabelStyle.Render(f.label + ":")

		var value string
		if m.isTextField(f.field) {
			// Text input field.
			val := m.advFieldValues[f.field]
			if isActive {
				value = formActiveStyle.Render(val + "_")
			} else if val == "" {
				value = dimStyle.Render("(" + f.hint + ")")
			} else {
				value = formInputStyle.Render(val)
			}
		} else {
			// Toggle field.
			value = m.renderToggleValue(f.field, isActive)
		}

		cursor := "  "
		if isActive {
			cursor = "> "
		}

		b.WriteString(cursor + label + " " + value + "\n")
	}

	b.WriteString("\n")
	b.WriteString(helpStyle.Render("↑/↓/Tab: Navigate  Space: Toggle  Enter: Search  Esc: Cancel"))
	b.WriteString("\n")

	return b.String()
}

// renderToggleValue renders a toggle field value.
func (m Model) renderToggleValue(field advancedField, active bool) string {
	var val string
	var isOn bool

	switch field {
	case fieldTop200Only:
		isOn = m.advSearch.Top200Only
		val = boolToToggle(isOn)
	case fieldIs4kOnly:
		isOn = m.advSearch.Is4kOnly
		val = boolToToggle(isOn)
	case fieldHasDocs:
		isOn = m.advSearch.HasDocs
		val = boolToToggle(isOn)
	case fieldHasFastload:
		isOn = m.advSearch.HasFastload
		val = boolToToggle(isOn)
	case fieldCracked:
		if m.advSearch.IsCracked == nil {
			val = "[Any]"
			isOn = false
		} else if *m.advSearch.IsCracked {
			val = "[Yes]"
			isOn = true
		} else {
			val = "[No]"
			isOn = false
		}
	}

	if active {
		return formActiveStyle.Render(val)
	}
	if isOn {
		return formToggleOnStyle.Render(val)
	}
	return formToggleOffStyle.Render(val)
}

// boolToToggle converts a boolean to toggle display string.
func boolToToggle(v bool) string {
	if v {
		return "[X]"
	}
	return "[ ]"
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

// applyAdvancedFilters filters entries based on AdvancedSearch criteria.
func (m *Model) applyAdvancedFilters() {
	m.filteredResults = make([]int, 0)
	as := m.advSearch

	for i, entry := range m.index.Entries {
		// Category filter (still applies in advanced mode).
		if m.selectedCategory != "All" && entry.CategoryName != m.selectedCategory {
			continue
		}

		// Title filter.
		if as.Title != "" && !strings.Contains(strings.ToLower(entry.Name), strings.ToLower(as.Title)) {
			continue
		}

		// Group filter.
		if as.Group != "" && !strings.Contains(strings.ToLower(entry.Group), strings.ToLower(as.Group)) {
			continue
		}

		// Language filter (exact match).
		if as.Language != "" && !strings.EqualFold(entry.Language, as.Language) {
			continue
		}

		// Region filter (exact match).
		if as.Region != "" && !strings.EqualFold(entry.Region, as.Region) {
			continue
		}

		// Engine filter (exact match).
		if as.Engine != "" && !strings.EqualFold(entry.Engine, as.Engine) {
			continue
		}

		// File type filter (exact match).
		if as.FileType != "" && !strings.EqualFold(entry.FileType, as.FileType) {
			continue
		}

		// Top200 filter.
		if as.Top200Only && entry.Top200Rank == 0 {
			continue
		}

		// 4k filter.
		if as.Is4kOnly && !entry.Is4k {
			continue
		}

		// Crack-related filters.
		if as.IsCracked != nil {
			isCracked := entry.Crack != nil && entry.Crack.IsCracked
			if *as.IsCracked != isCracked {
				continue
			}
		}

		// Trainer count filters.
		if as.MinTrainers > 0 || as.MaxTrainers >= 0 || as.HasDocs || as.HasFastload {
			if entry.Crack == nil {
				continue
			}

			trainers := entry.Crack.Trainers

			if as.MinTrainers > 0 && trainers < as.MinTrainers {
				continue
			}
			if as.MaxTrainers >= 0 && trainers > as.MaxTrainers {
				continue
			}

			// Docs filter.
			if as.HasDocs {
				hasDocs := false
				for _, flag := range entry.Crack.Flags {
					if flag == "docs" {
						hasDocs = true
						break
					}
				}
				if !hasDocs {
					continue
				}
			}

			// Fastload filter.
			if as.HasFastload {
				hasFastload := false
				for _, flag := range entry.Crack.Flags {
					if flag == "fastload" {
						hasFastload = true
						break
					}
				}
				if !hasFastload {
					continue
				}
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
