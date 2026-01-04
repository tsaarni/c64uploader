// D64 disk image parsing and extraction functionality.
// It supports reading directory entries and extracting PRG files from D64 disk images.
package main

import (
	"fmt"
	"log/slog"
)

// D64 disk image constants.
const (
	// Standard D64 has 35 tracks.
	d64Tracks35 = 35
	d64Tracks40 = 40

	// Directory is always on track 18.
	directoryTrack  = 18
	directorySector = 1

	// Bytes per sector.
	bytesPerSector = 256

	// File type constants (from directory entry).
	fileTypeDEL = 0
	fileTypeSEQ = 1
	fileTypePRG = 2
	fileTypeUSR = 3
	fileTypeREL = 4
)

// Sector offsets for different track zones.
var sectorsPerTrack = []int{
	21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, // Tracks 1-17
	19, 19, 19, 19, 19, 19, 19, // Tracks 18-24
	18, 18, 18, 18, 18, 18, // Tracks 25-30
	17, 17, 17, 17, 17, // Tracks 31-35
}

// getSectorOffset calculates the byte offset for a given track and sector.
func getSectorOffset(track, sector int) int {
	if track < 1 || track > len(sectorsPerTrack) {
		return -1
	}

	offset := 0
	// Sum sectors from all previous tracks.
	for t := 1; t < track; t++ {
		offset += sectorsPerTrack[t-1] * bytesPerSector
	}

	// Add sectors within the current track.
	offset += sector * bytesPerSector

	return offset
}

// directoryEntry represents a file entry in the D64 directory.
type directoryEntry struct {
	fileType byte
	track    byte
	sector   byte
	filename string
}

// parseDirectoryEntry parses a 32-byte directory entry.
func parseDirectoryEntry(data []byte) *directoryEntry {
	if len(data) < 32 {
		return nil
	}

	// Byte 0x00: File type (bits 0-3 = type, bit 7 = closed flag).
	fileType := data[0x00] & 0x0F

	// Bytes 0x01-0x02: Track/sector of first file block.
	track := data[0x01]
	sector := data[0x02]

	// Bytes 0x03-0x12: Filename (16 bytes, PETSCII, padded with 0xA0).
	filename := ""
	for i := 0x03; i <= 0x12; i++ {
		if data[i] == 0xA0 || data[i] == 0x00 {
			break
		}
		// Convert PETSCII to ASCII (basic conversion).
		ch := data[i]
		if ch >= 0xC1 && ch <= 0xDA { // Shifted A-Z
			ch = ch - 0x80 // Convert to normal ASCII
		}
		// A-Z remains unchanged.
		filename += string(ch)
	}

	return &directoryEntry{
		fileType: fileType,
		track:    track,
		sector:   sector,
		filename: filename,
	}
}

// findFirstPRGInDirectory scans D64 directory sectors to find the first PRG file entry.
func findFirstPRGInDirectory(d64Data []byte) (*directoryEntry, error) {
	currentTrack := directoryTrack
	currentSector := directorySector

	for {
		offset := getSectorOffset(currentTrack, currentSector)
		if offset < 0 || offset+bytesPerSector > len(d64Data) {
			break
		}

		sectorData := d64Data[offset : offset+bytesPerSector]
		nextTrack := sectorData[0x00]
		nextSector := sectorData[0x01]

		// Check 8 directory entries in this sector.
		if entry := scanDirectorySector(sectorData); entry != nil {
			return entry, nil
		}

		// Move to next directory sector.
		if nextTrack == 0 {
			break
		}
		currentTrack = int(nextTrack)
		currentSector = int(nextSector)
	}

	return nil, fmt.Errorf("no PRG files found in D64 image")
}

// scanDirectorySector scans a single directory sector for PRG files.
func scanDirectorySector(sectorData []byte) *directoryEntry {
	for i := 0; i < 8; i++ {
		entryOffset := 0x02 + (i * 32)
		if entryOffset+32 > len(sectorData) {
			break
		}

		entry := parseDirectoryEntry(sectorData[entryOffset : entryOffset+32])
		if entry != nil && entry.track != 0 {
			slog.Debug("Found file in D64", "filename", entry.filename, "type", entry.fileType, "track", entry.track, "sector", entry.sector)
			if entry.fileType == fileTypePRG {
				slog.Info("Found PRG file in D64", "filename", entry.filename, "track", entry.track, "sector", entry.sector)
				return entry
			}
		}
	}
	return nil
}

// extractFileData follows the sector chain to extract file data from D64.
func extractFileData(d64Data []byte, startTrack, startSector int) ([]byte, error) {
	var fileData []byte
	currentTrack := startTrack
	currentSector := startSector

	for {
		offset := getSectorOffset(currentTrack, currentSector)
		if offset < 0 || offset+bytesPerSector > len(d64Data) {
			return nil, fmt.Errorf("invalid sector chain at track %d, sector %d", currentTrack, currentSector)
		}

		sectorData := d64Data[offset : offset+bytesPerSector]
		nextTrack := sectorData[0x00]
		nextSector := sectorData[0x01]

		// Determine how many bytes to read from this sector.
		if nextTrack == 0 {
			// Last sector: nextSector indicates number of bytes used (1-255).
			bytesToRead := int(nextSector)
			if bytesToRead == 0 || bytesToRead > 255 {
				bytesToRead = 254 // Default to nearly full sector.
			}
			fileData = append(fileData, sectorData[2:2+bytesToRead]...)
			break
		}

		// Not last sector: use all 254 bytes of data.
		fileData = append(fileData, sectorData[2:256]...)

		// Safety check to prevent infinite loops.
		if len(fileData) > 1024*1024 {
			return nil, fmt.Errorf("file too large (>1MB), possible corrupt sector chain")
		}

		// Move to next sector.
		currentTrack = int(nextTrack)
		currentSector = int(nextSector)
	}

	return fileData, nil
}

// validateD64Size validates that the D64 data has a correct size.
func validateD64Size(d64Data []byte) error {
	expectedSize35 := 174848 // 35 tracks
	expectedSize40 := 196608 // 40 tracks
	if len(d64Data) != expectedSize35 && len(d64Data) != expectedSize40 {
		return fmt.Errorf("invalid D64 size: %d bytes (expected %d or %d)", len(d64Data), expectedSize35, expectedSize40)
	}
	return nil
}

// extractFirstPRG extracts the first PRG file from a D64 disk image.
func extractFirstPRG(d64Data []byte) ([]byte, string, error) {
	// Validate D64 size.
	if err := validateD64Size(d64Data); err != nil {
		return nil, "", err
	}

	// Find first PRG in directory.
	firstPRG, err := findFirstPRGInDirectory(d64Data)
	if err != nil {
		return nil, "", err
	}

	// Extract file data by following sector chain.
	prgData, err := extractFileData(d64Data, int(firstPRG.track), int(firstPRG.sector))
	if err != nil {
		return nil, "", err
	}

	slog.Info("Extracted PRG from D64", "filename", firstPRG.filename, "size", len(prgData))
	return prgData, firstPRG.filename, nil
}
