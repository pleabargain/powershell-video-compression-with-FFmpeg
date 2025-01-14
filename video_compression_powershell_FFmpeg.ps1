# Video Compression Script
# Requires FFmpeg to be installed and accessible in PATH

param (
    [Parameter(Mandatory=$false)]
    [string]$InputFolder = ".",
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("low", "medium", "high")]
    [string]$Quality = "medium",
    
    [Parameter(Mandatory=$false)]
    [string]$FilePattern = "*.mp4"
)

# Quality presets
$QualityPresets = @{
    "low" = @{
        crf = "28"
        preset = "faster"
    }
    "medium" = @{
        crf = "23"
        preset = "medium"
    }
    "high" = @{
        crf = "18"
        preset = "slow"
    }
}

function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

# Check if FFmpeg is installed
try {
    $null = Get-Command ffmpeg -ErrorAction Stop
} catch {
    Write-ColorOutput Red "Error: FFmpeg is not installed or not in PATH"
    Write-Output "Please install FFmpeg and make sure it's added to your system's PATH"
    exit 1
}

# Get all video files
$videos = Get-ChildItem -Path $InputFolder -Filter $FilePattern

if ($videos.Count -eq 0) {
    Write-ColorOutput Yellow "No videos found in $InputFolder matching pattern $FilePattern"
    exit 0
}

Write-ColorOutput Cyan "Found $($videos.Count) videos to compress"
Write-ColorOutput Cyan "Using $Quality quality preset"

$currentPreset = $QualityPresets[$Quality]

foreach ($video in $videos) {
    # Create output filename in the same directory with proper escaping
    $outputPath = Join-Path $video.DirectoryName ($video.BaseName + "_compressed" + $video.Extension)
    
    Write-ColorOutput Yellow "Processing: $($video.Name)"
    
    try {
        # Wrap paths in quotes to handle spaces and special characters
        $process = & ffmpeg -i `"$($video.FullName)`" -c:v libx264 -crf $($currentPreset.crf) -preset $($currentPreset.preset) -c:a aac -b:a 128k -y `"$outputPath`" 2>&1
        
        # Check if output file exists to verify success
        if (Test-Path $outputPath) {
            $originalSize = (Get-Item $video.FullName).Length / 1MB
            $compressedSize = (Get-Item $outputPath).Length / 1MB
            $savings = (1 - ($compressedSize / $originalSize)) * 100
            
            Write-ColorOutput Green "Successfully compressed: $($video.Name)"
            Write-Output "Original size: $($originalSize.ToString('0.00')) MB"
            Write-Output "Compressed size: $($compressedSize.ToString('0.00')) MB"
            Write-Output "Space savings: $($savings.ToString('0.00'))%"
        } else {
            Write-ColorOutput Red "Error compressing $($video.Name)"
            Write-ColorOutput Red $process
        }
    } catch {
        Write-ColorOutput Red "Error processing $($video.Name): $_"
        Write-ColorOutput Red $process
    }
    
    Write-Output ""
}

Write-ColorOutput Green "Compression complete!"