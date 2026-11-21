# Generates the app / home-screen icons for FridaTal from the artwork in art/: icon.png (the 512 px icon)
# and icon-maskable.png (the same with the content inside the maskable safe zone).
# The artwork is only 512 px, so icon-1024.png is an upscale.
# Run with Windows PowerShell (System.Drawing):  powershell -File tools\make-icons.ps1
param(
    [string]$OutDir = (Join-Path $PSScriptRoot "..\src\FridaTal\wwwroot\icons"),
    [string]$Art = (Join-Path $PSScriptRoot "..\art\icon.png"),
    [string]$MaskableArt = (Join-Path $PSScriptRoot "..\art\icon-maskable.png"),
    # The front page (KidsGames) shows each game's 512 px icon; pass its billeder folder to update it too.
    [string]$FrontPageDir = (Join-Path $PSScriptRoot "..\..\KidsGames\billeder")
)

Add-Type -AssemblyName System.Drawing
New-Item -ItemType Directory -Force $OutDir | Out-Null

$icon = [System.Drawing.Image]::FromFile((Resolve-Path $Art))
$maskable = [System.Drawing.Image]::FromFile((Resolve-Path $MaskableArt))

function Save-Icon([System.Drawing.Image]$source, [int]$size, [string]$file) {
    $bmp = New-Object System.Drawing.Bitmap $size, $size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = 'HighQualityBicubic'
    $g.PixelOffsetMode = 'HighQuality'
    $g.SmoothingMode = 'AntiAlias'
    # Tile-flip mode keeps the edge pixels from fading to transparent when scaling.
    $attr = New-Object System.Drawing.Imaging.ImageAttributes
    $attr.SetWrapMode([System.Drawing.Drawing2D.WrapMode]::TileFlipXY)
    $g.DrawImage($source, (New-Object System.Drawing.Rectangle 0, 0, $size, $size), 0, 0, $source.Width, $source.Height, 'Pixel', $attr)
    $g.Dispose()
    $bmp.Save((Join-Path $OutDir $file), [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "  $file"
}

Write-Host "Writing icons to $OutDir"
Save-Icon $icon 180  'apple-touch-icon.png'
Save-Icon $icon 167  'apple-touch-icon-167.png'
Save-Icon $icon 152  'apple-touch-icon-152.png'
Save-Icon $icon 192  'icon-192.png'
Copy-Item $Art (Join-Path $OutDir 'icon-512.png')            # already 512 px: copied as is
Save-Icon $icon 1024 'icon-1024.png'
Copy-Item $MaskableArt (Join-Path $OutDir 'icon-512-maskable.png')
Save-Icon $icon 32   'favicon-32.png'
$icon.Dispose()
$maskable.Dispose()

if (Test-Path $FrontPageDir) {
    Copy-Item (Join-Path $OutDir 'icon-512.png') (Join-Path $FrontPageDir 'fridatal.png')
    Write-Host "Copied icon-512.png to $FrontPageDir\fridatal.png"
}
