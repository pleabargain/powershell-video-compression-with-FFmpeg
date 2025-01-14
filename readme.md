# Video Compression PowerShell Script

This script uses FFmpeg to compress video files in a specified folder.



# why
Had a file I wanted to pass via discord. Discord has a file size limit of 10mb. So I needed to compress the video. Ergo, this script. I 'wrote' it with Anthropic.

## Prerequisites

- **FFmpeg:** Ensure that FFmpeg is installed on your system and is added to your system's PATH environment variable. You can download FFmpeg from the official website or through a package manager.

## Script Parameters

The script accepts the following parameters:

- `-InputFolder`: Specifies the path to the folder containing the video files to compress. If not specified, the current directory is used.
- `-Quality`: Sets the compression quality. Available options are:
    - `low`: Lower quality, smaller file size (crf 28, preset faster).
    - `medium`: Medium quality, medium file size (crf 23, preset medium). This is the default.
    - `high`: Higher quality, larger file size (crf 18, preset slow).
- `-FilePattern`: Specifies the pattern to match video files in the input folder. The default is `*.mp4`.

## Usage

1. Save the script to a `.ps1` file (e.g., `video_compression.ps1`).
2. Open PowerShell.
3. Navigate to the directory where you saved the script.

### Basic Compression

To compress all `.mp4` files in the current directory with the default medium quality:

```powershell
.\video_compression_powershell_FFmpeg.ps1
```

### Specifying Input Folder

To compress video files in a specific folder:

```powershell
.\video_compression_powershell_FFmpeg.ps1 -InputFolder "path\to\your\videos"
```

Replace `"path\to\your\videos"` with the actual path to your video folder.

### Specifying Quality

To compress videos with low quality:

```powershell
.\video_compression_powershell_FFmpeg.ps1 -Quality "low"
```

To compress videos with high quality:

```powershell
.\video_compression_powershell_FFmpeg.ps1 -Quality "high"
```

### Specifying File Pattern

To compress only `.mov` files:

```powershell
.\video_compression_powershell_FFmpeg.ps1 -FilePattern "*.mov"
```

### Combining Parameters

You can combine parameters as needed:

```powershell
.\video_compression_powershell_FFmpeg.ps1 -InputFolder "path\to\your\videos" -Quality "high" -FilePattern "*.avi"
```

This command will compress all `.avi` files in the specified folder with high quality settings.

## Output

Compressed videos will be saved in the same directory as the original files, with `_compressed` added to the filename before the extension (e.g., `original.mp4` will become `original_compressed.mp4`).

## Error Handling

The script includes basic error handling:

- It checks if FFmpeg is installed and accessible in the system's PATH.
- It informs you if no video files are found matching the specified pattern in the input folder.
- It displays an error message if there's an issue during the compression of a specific video.
