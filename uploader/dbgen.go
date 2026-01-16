// Database generator for Assembly64 collections.
// Scans directory structure and generates JSON database files.
package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
	"time"
)

// DBEntry represents a single entry in our JSON database.
type DBEntry struct {
	ID          int       `json:"id"`
	Category    string    `json:"category"`
	Title       string    `json:"title"`
	ReleaseName string    `json:"releaseName"`
	Group       string    `json:"group"`
	Top200Rank  *int      `json:"top200Rank,omitempty"`
	Is4k        bool      `json:"is4k,omitempty"`
	Path        string    `json:"path"`
	Files       []DBFile  `json:"files"`
	PrimaryFile string    `json:"primaryFile"`
	FileType    string    `json:"fileType"`
	Crack       *CrackInfo `json:"crack,omitempty"`
	Language    string    `json:"language,omitempty"`
	Region      string    `json:"region,omitempty"`
	Engine      string    `json:"engine,omitempty"`
	IsPreview   bool      `json:"isPreview,omitempty"`
	Version     string    `json:"version,omitempty"`
}

// DBFile represents a file within a release.
type DBFile struct {
	Name string `json:"name"`
	Type string `json:"type"`
	Size int64  `json:"size"`
}

// CrackInfo contains parsed crack/trainer information.
type CrackInfo struct {
	IsCracked bool     `json:"isCracked"`
	Trainers  int      `json:"trainers"`
	Flags     []string `json:"flags,omitempty"`
}

// Database represents the complete JSON database structure.
type Database struct {
	Version      string    `json:"version"`
	Generated    string    `json:"generated"`
	Source       string    `json:"source"`
	TotalEntries int       `json:"totalEntries"`
	Entries      []DBEntry `json:"entries"`
}

// Supported file extensions for C64 programs.
var supportedExtensions = map[string]bool{
	".prg": true, ".PRG": true,
	".d64": true, ".D64": true,
	".t64": true, ".T64": true,
	".tap": true, ".TAP": true,
	".crt": true, ".CRT": true,
	".d71": true, ".D71": true,
	".d81": true, ".D81": true,
	".g64": true, ".G64": true,
}

// File type priority for selecting primary file.
var fileTypePriority = []string{".d64", ".prg", ".crt", ".t64", ".tap", ".d71", ".d81", ".g64"}

// Regex patterns for parsing release names.
var (
	trainerPattern  = regexp.MustCompile(`\+(\d*)([DFHPTIGRS]*)`)
	languagePattern = regexp.MustCompile(`\[(german|french|english|spanish|italian|dutch|swedish|polish|hungarian|english\+german)\]`)
	enginePattern   = regexp.MustCompile(`\[(seuck|gkgm|bdck|shoot)\]`)
	versionPattern  = regexp.MustCompile(`[Vv](\d+\.?\d*)`)
	regionPattern   = regexp.MustCompile(`\b(NTSC|PAL)\b`)
	previewPattern  = regexp.MustCompile(`(?i)\bpreview\b`)
)

// Flag code to name mapping.
var flagNames = map[byte]string{
	'D': "docs",
	'F': "fastload",
	'H': "highscore",
	'P': "palntscfix",
	'T': "tape",
	'I': "intro",
	'G': "gfx",
	'R': "trainer",
	'S': "save",
}

// parseCrackInfo extracts crack/trainer information from release name.
func parseCrackInfo(releaseName string) *CrackInfo {
	if !strings.Contains(releaseName, "+") {
		return nil
	}

	info := &CrackInfo{
		IsCracked: true,
		Trainers:  0,
		Flags:     []string{},
	}

	matches := trainerPattern.FindStringSubmatch(releaseName)
	if len(matches) >= 2 {
		if matches[1] != "" {
			info.Trainers, _ = strconv.Atoi(matches[1])
		}
		if len(matches) >= 3 && matches[2] != "" {
			for _, c := range matches[2] {
				if name, ok := flagNames[byte(c)]; ok {
					info.Flags = append(info.Flags, name)
				}
			}
		}
	}

	// Check for multi-disk indicators.
	diskPattern := regexp.MustCompile(`(\d)D\b`)
	if diskMatch := diskPattern.FindStringSubmatch(releaseName); len(diskMatch) >= 2 {
		info.Flags = append(info.Flags, diskMatch[1]+"disk")
	}

	if len(info.Flags) == 0 {
		info.Flags = nil
	}

	return info
}

// parseLanguage extracts language from release name.
func parseLanguage(releaseName string) string {
	if match := languagePattern.FindStringSubmatch(releaseName); len(match) >= 2 {
		return match[1]
	}
	return ""
}

// parseEngine extracts game engine from release name.
func parseEngine(releaseName string) string {
	if match := enginePattern.FindStringSubmatch(releaseName); len(match) >= 2 {
		return match[1]
	}
	return ""
}

// parseVersion extracts version from release name.
func parseVersion(releaseName string) string {
	if match := versionPattern.FindStringSubmatch(releaseName); len(match) >= 2 {
		return match[1]
	}
	return ""
}

// parseRegion extracts region (PAL/NTSC) from release name.
func parseRegion(releaseName string) string {
	if match := regionPattern.FindStringSubmatch(releaseName); len(match) >= 2 {
		return match[1]
	}
	return ""
}

// isPreview checks if release is a preview.
func isPreview(releaseName string) bool {
	return previewPattern.MatchString(releaseName)
}

// scanReleaseFolder scans a release folder and returns file information.
func scanReleaseFolder(folderPath string) ([]DBFile, string, string) {
	var files []DBFile
	var primaryFile string
	var fileType string

	entries, err := os.ReadDir(folderPath)
	if err != nil {
		return nil, "", ""
	}

	// Collect all supported files.
	for _, entry := range entries {
		if entry.IsDir() {
			continue
		}

		ext := filepath.Ext(entry.Name())
		if !supportedExtensions[ext] {
			continue
		}

		info, err := entry.Info()
		if err != nil {
			continue
		}

		files = append(files, DBFile{
			Name: entry.Name(),
			Type: strings.ToLower(strings.TrimPrefix(ext, ".")),
			Size: info.Size(),
		})
	}

	if len(files) == 0 {
		return nil, "", ""
	}

	// Select primary file by priority.
	for _, ext := range fileTypePriority {
		for _, f := range files {
			if strings.EqualFold("."+f.Type, ext) {
				primaryFile = f.Name
				fileType = f.Type
				break
			}
		}
		if primaryFile != "" {
			break
		}
	}

	// Fallback to first file.
	if primaryFile == "" && len(files) > 0 {
		primaryFile = files[0].Name
		fileType = files[0].Type
	}

	return files, primaryFile, fileType
}

// buildTop200Map scans Top200 folder and returns a map of title -> rank.
func buildTop200Map(basePath string) map[string]int {
	top200Map := make(map[string]int)
	top200Path := filepath.Join(basePath, "Games", "CSDB", "Top200")

	entries, err := os.ReadDir(top200Path)
	if err != nil {
		return top200Map
	}

	rankPattern := regexp.MustCompile(`^(\d+)\s*[-_\.]\s*(.+)$`)

	for _, entry := range entries {
		if !entry.IsDir() {
			continue
		}

		name := entry.Name()
		if match := rankPattern.FindStringSubmatch(name); len(match) >= 3 {
			rank, _ := strconv.Atoi(match[1])
			title := strings.TrimSpace(match[2])
			top200Map[strings.ToLower(title)] = rank
		}
	}

	return top200Map
}

// build4kMap scans 4k folder and returns a set of titles.
func build4kMap(basePath string) map[string]bool {
	fourKMap := make(map[string]bool)
	fourKPath := filepath.Join(basePath, "Games", "CSDB", "4k")

	// Walk through the 4k directory structure.
	filepath.WalkDir(fourKPath, func(path string, d os.DirEntry, err error) error {
		if err != nil {
			return nil
		}

		// Skip non-directories and root.
		if !d.IsDir() || path == fourKPath {
			return nil
		}

		rel, _ := filepath.Rel(fourKPath, path)
		parts := strings.Split(rel, string(os.PathSeparator))

		// Title is at level 2 (Letter/Title).
		if len(parts) == 2 {
			fourKMap[strings.ToLower(parts[1])] = true
		}

		return nil
	})

	return fourKMap
}

// GenerateGamesDB generates the games.json database file.
func GenerateGamesDB(basePath, outputPath string) error {
	fmt.Println("Scanning Games/CSDB/All...")

	// Build metadata maps from Top200 and 4k folders.
	fmt.Println("Building Top200 rank map...")
	top200Map := buildTop200Map(basePath)
	fmt.Printf("  Found %d Top200 entries\n", len(top200Map))

	fmt.Println("Building 4k games map...")
	fourKMap := build4kMap(basePath)
	fmt.Printf("  Found %d 4k entries\n", len(fourKMap))

	// Scan the main Games/CSDB/All directory.
	allPath := filepath.Join(basePath, "Games", "CSDB", "All")

	var entries []DBEntry
	entryID := 1

	// Walk through: Letter / Range / Title / Group / ReleaseName
	err := filepath.WalkDir(allPath, func(path string, d os.DirEntry, err error) error {
		if err != nil {
			return nil
		}

		if !d.IsDir() {
			return nil
		}

		// Get relative path from All directory.
		rel, _ := filepath.Rel(allPath, path)
		if rel == "." {
			return nil
		}

		parts := strings.Split(rel, string(os.PathSeparator))

		// We want release folders at level 5: Letter/Range/Title/Group/ReleaseName
		if len(parts) != 5 {
			return nil
		}

		// Extract metadata from path.
		title := parts[2]       // Title folder
		group := parts[3]       // Group folder
		releaseName := parts[4] // Release name folder

		// Scan the release folder for files.
		files, primaryFile, fileType := scanReleaseFolder(path)
		if len(files) == 0 {
			return nil
		}

		// Build the relative path from assembly64 root.
		relPath := filepath.Join("Games", "CSDB", "All", rel)

		// Check Top200 rank.
		var top200Rank *int
		if rank, ok := top200Map[strings.ToLower(title)]; ok {
			top200Rank = &rank
		}

		// Check if 4k game.
		is4k := fourKMap[strings.ToLower(title)]

		// Parse release name metadata.
		entry := DBEntry{
			ID:          entryID,
			Category:    "games",
			Title:       title,
			ReleaseName: releaseName,
			Group:       group,
			Top200Rank:  top200Rank,
			Is4k:        is4k,
			Path:        relPath,
			Files:       files,
			PrimaryFile: primaryFile,
			FileType:    fileType,
			Crack:       parseCrackInfo(releaseName),
			Language:    parseLanguage(releaseName),
			Region:      parseRegion(releaseName),
			Engine:      parseEngine(releaseName),
			IsPreview:   isPreview(releaseName),
			Version:     parseVersion(releaseName),
		}

		entries = append(entries, entry)
		entryID++

		if entryID%10000 == 0 {
			fmt.Printf("  Processed %d entries...\n", entryID-1)
		}

		return nil
	})

	if err != nil {
		return fmt.Errorf("failed to scan directory: %w", err)
	}

	fmt.Printf("  Total entries: %d\n", len(entries))

	// Build database structure.
	db := Database{
		Version:      "1.0",
		Generated:    time.Now().UTC().Format(time.RFC3339),
		Source:       "csdb",
		TotalEntries: len(entries),
		Entries:      entries,
	}

	// Write JSON file.
	fmt.Printf("Writing %s...\n", outputPath)

	jsonData, err := json.Marshal(db)
	if err != nil {
		return fmt.Errorf("failed to marshal JSON: %w", err)
	}

	if err := os.WriteFile(outputPath, jsonData, 0644); err != nil {
		return fmt.Errorf("failed to write file: %w", err)
	}

	fmt.Printf("Done! Generated %s (%d bytes, %d entries)\n", outputPath, len(jsonData), len(entries))

	return nil
}
