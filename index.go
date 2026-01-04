// Indexing and searching functionality for Assembly64 collections.
// It loads release metadata from JSON files and scans directories to build a searchable index.
package main

import (
	"encoding/json"
	"fmt"
	"log/slog"
	"os"
	"path/filepath"
	"strings"
)

// ReleaseEntry represents a single entry from a .releaselog.json file.
type ReleaseEntry struct {
	Name     string `json:"name"`
	Group    string `json:"group"`
	Year     string `json:"year"`
	Path     string `json:"path"`
	ID       string `json:"id"`
	Type     string `json:"type"`
	Category int    `json:"category"`

	// Computed fields.
	CategoryName string // "Games", "Demos", "Music", etc.
	FullPath     string // Absolute path to the file.
	FileType     string // "d64", "prg", "crt" - from extension.
}

// SearchIndex holds all entries organized for fast searching.
type SearchIndex struct {
	Entries       []ReleaseEntry
	ByCategory    map[string][]int // "Games" -> [indices].
	CategoryOrder []string         // Ordered list: ["All", "Games", "Demos", ...].
}

// processIndexPaths loads entries from .releaselog.json files.
func processIndexPaths(basePath string, indexPaths []struct {
	category string
	path     string
}, index *SearchIndex, foundCategories map[string]bool, categoryEntries map[string]int) {
	for _, indexPath := range indexPaths {
		fullPath := filepath.Join(basePath, indexPath.path)

		// Check if file exists.
		if _, err := os.Stat(fullPath); os.IsNotExist(err) {
			continue // Skip missing index files
		}

		entries, err := loadReleaseLog(fullPath, indexPath.category)
		if err != nil {
			slog.Debug("Failed to load index", "path", indexPath.path, "error", err)
			continue
		}

		// Add entries to index.
		startIdx := len(index.Entries)
		index.Entries = append(index.Entries, entries...)
		categoryEntries[indexPath.category] += len(entries)

		// Track category.
		if !foundCategories[indexPath.category] {
			foundCategories[indexPath.category] = true
			index.CategoryOrder = append(index.CategoryOrder, indexPath.category)
		}

		// Update ByCategory map.
		for i := startIdx; i < len(index.Entries); i++ {
			index.ByCategory[indexPath.category] = append(index.ByCategory[indexPath.category], i)
		}
	}
}

// processNoIndexDirs scans directories without .releaselog.json files.
func processNoIndexDirs(basePath string, noIndexDirs []struct {
	category string
	path     string
}, index *SearchIndex, foundCategories map[string]bool, categoryEntries map[string]int) {
	for _, dir := range noIndexDirs {
		dirPath := filepath.Join(basePath, dir.path)
		if _, err := os.Stat(dirPath); os.IsNotExist(err) {
			continue
		}

		entries := scanSingleDirectory(dirPath, dir.category)
		if len(entries) == 0 {
			continue
		}

		startIdx := len(index.Entries)
		index.Entries = append(index.Entries, entries...)
		categoryEntries[dir.category] += len(entries)

		if !foundCategories[dir.category] {
			foundCategories[dir.category] = true
			index.CategoryOrder = append(index.CategoryOrder, dir.category)
		}

		for i := startIdx; i < len(index.Entries); i++ {
			index.ByCategory[dir.category] = append(index.ByCategory[dir.category], i)
		}
	}
}

// loadAssembly64Index scans the Assembly64 directory and indexes all games/demos/etc.
func loadAssembly64Index(basePath string) (*SearchIndex, error) {
	// Expand ~ to home directory.
	if strings.HasPrefix(basePath, "~/") {
		home, err := os.UserHomeDir()
		if err != nil {
			return nil, fmt.Errorf("failed to get home directory: %w", err)
		}
		basePath = filepath.Join(home, basePath[2:])
	}

	slog.Info("Loading Assembly64 index", "path", basePath)

	index := &SearchIndex{
		Entries:       make([]ReleaseEntry, 0, 200000), // Pre-allocate.
		ByCategory:    make(map[string][]int),
		CategoryOrder: []string{"All"}, // Start with "All".
	}

	// Known index file paths - complete hardcoded list from actual assembly64 directory.
	// Format: {category, relative_path_to_releaselog}.
	indexPaths := []struct {
		category string
		path     string
	}{
		// Games
		{"Games", "Games/CSDB/All/.releaselog.json"},
		{"Games", "Games/CSDB/4k/.releaselog.json"},
		{"Games", "Games/C64com/.releaselog.json"},
		{"Games", "Games/Guybrush-german/.releaselog.json"},
		// Demos
		{"Demos", "Demos/CSDB/Onefile/.releaselog.json"},
		{"Demos", "Demos/Guybrush/.releaselog.json"},
		{"Demos", "Demos/C64com/.releaselog.json"},
		// Music
		{"Music", "Music/CSDB/All/.releaselog.json"},
		// Graphics
		{"Graphics", "Graphics/CSDB/All/.releaselog.json"},
		// Tools
		{"Tools", "Tools/CSDB/All/.releaselog.json"},
		{"Tools", "Tools/Guybrush/All-english/.releaselog.json"},
		{"Tools", "Tools/Guybrush/All-german/.releaselog.json"},
		// Intros
		{"Intros", "Intros/CSDB-intros/.releaselog.json"},
		// Discmags
		{"Discmags", "Discmags/CSDB/.releaselog.json"},
		// Misc
		{"Misc", "Misc/CSDB/Misc/.releaselog.json"},
		{"Misc", "Misc/CSDB/Easyflash/.releaselog.json"},
		{"Misc", "Misc/CSDB/REU/.releaselog.json"},
		{"Misc", "Misc/CSDB/C128/.releaselog.json"},
		{"Misc", "Misc/CSDB/Bbs/.releaselog.json"},
		{"Misc", "Misc/CSDB/Charts/.releaselog.json"},
		{"Misc", "Misc/Guybrush/.releaselog.json"},
	}

	foundCategories := make(map[string]bool)
	categoryEntries := make(map[string]int)

	// Load from index files.
	processIndexPaths(basePath, indexPaths, index, foundCategories, categoryEntries)

	// Directories without .releaselog.json - scan these directly.
	noIndexDirs := []struct {
		category string
		path     string
	}{
		{"Games", "Games/Gamebase"},
		{"Games", "Games/Guybrush"},
		{"Games", "Games/C64Tapes-org"},
		{"Games", "Games/Blast-from-the-past"},
		{"Games", "Games/SEUCK"},
		{"Games", "Games/Mayhem-crt"},
		{"Games", "Games/OneLoad64"},
		{"Games", "Games/Preservers"},
	}

	processNoIndexDirs(basePath, noIndexDirs, index, foundCategories, categoryEntries)

	// Log category summaries.
	for _, cat := range index.CategoryOrder {
		if cat != "All" {
			slog.Info("Loaded category", "category", cat, "entries", categoryEntries[cat])
		}
	}

	slog.Info("Index loaded", "total_entries", len(index.Entries), "categories", len(index.CategoryOrder)-1)
	return index, nil
}

// isSupportedExtension checks if a file extension is supported.
func isSupportedExtension(ext string) bool {
	supportedExts := []string{".d64", ".prg", ".crt", ".D64", ".PRG", ".CRT"}
	for _, supported := range supportedExts {
		if ext == supported {
			return true
		}
	}
	return false
}

// scanSingleDirectory scans a specific directory for loadable files (one level only, fast).
func scanSingleDirectory(dirPath, categoryName string) []ReleaseEntry {
	entries := make([]ReleaseEntry, 0, 5000)
	seen := make(map[string]bool, 5000)

	filepath.WalkDir(dirPath, func(path string, d os.DirEntry, err error) error {
		if err != nil || d.IsDir() {
			if d.IsDir() && d.Name()[0] == '.' {
				return filepath.SkipDir
			}
			return nil
		}

		if d.Name()[0] == '.' {
			return nil
		}

		name := d.Name()
		if len(name) < 5 {
			return nil
		}

		ext := name[len(name)-4:]
		if !isSupportedExtension(ext) {
			return nil
		}

		dir := filepath.Dir(path)
		if seen[dir] {
			return nil
		}
		seen[dir] = true

		entries = append(entries, ReleaseEntry{
			Name:         filepath.Base(dir),
			Group:        filepath.Base(filepath.Dir(dir)),
			CategoryName: categoryName,
			FullPath:     path,
			FileType:     strings.TrimPrefix(strings.ToLower(ext), "."),
		})
		return nil
	})

	return entries
}

// loadReleaseLog loads a single .releaselog.json file.
func loadReleaseLog(jsonFile, categoryName string) ([]ReleaseEntry, error) {
	data, err := os.ReadFile(jsonFile)
	if err != nil {
		return nil, fmt.Errorf("failed to read file: %w", err)
	}

	var entries []ReleaseEntry
	if err := json.Unmarshal(data, &entries); err != nil {
		return nil, fmt.Errorf("failed to parse JSON: %w", err)
	}

	// The .releaselog.json file directory is the base for relative paths.
	jsonDir := filepath.Dir(jsonFile)
	validEntries := make([]ReleaseEntry, 0, len(entries))

	for i := range entries {
		entries[i].CategoryName = categoryName
		fullPath := filepath.Join(jsonDir, entries[i].Path)

		// Check if path points to a directory - find first loadable file.
		if info, err := os.Stat(fullPath); err == nil && info.IsDir() {
			actualFile, fileErr := findLoadableFile(fullPath)
			if fileErr != nil {
				// Skip entries without loadable files.
				continue
			}
			fullPath = actualFile
		} else if err != nil {
			// File doesn't exist, skip.
			continue
		}

		entries[i].FullPath = fullPath
		entries[i].FileType = strings.TrimPrefix(strings.ToLower(filepath.Ext(fullPath)), ".")
		validEntries = append(validEntries, entries[i])
	}

	return validEntries, nil
}

// findLoadableFile finds the first loadable C64 file in a directory.
func findLoadableFile(dirPath string) (string, error) {
	entries, err := os.ReadDir(dirPath)
	if err != nil {
		return "", fmt.Errorf("failed to read directory: %w", err)
	}

	// Priority order: .d64, .prg, .crt, other disk images.
	exts := []string{".d64", ".prg", ".crt", ".d71", ".d81", ".g64", ".g71"}

	for _, ext := range exts {
		for _, entry := range entries {
			if !entry.IsDir() && strings.EqualFold(filepath.Ext(entry.Name()), ext) {
				return filepath.Join(dirPath, entry.Name()), nil
			}
		}
	}

	return "", fmt.Errorf("no loadable file found in directory")
}
