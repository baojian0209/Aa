Add-Type -AssemblyName System.Drawing

function New-AppIcon {
  param([int]$Size, [string]$OutFile, [bool]$Maskable)

  $bmp = New-Object System.Drawing.Bitmap($Size, $Size)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $g.Clear([System.Drawing.Color]::Transparent)

  $green = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 31, 122, 90))

  # Rounded-square background (maskable version uses the same shape, smaller text)
  $radius = [int]($Size * 0.22)
  $d = $radius * 2
  $gp = New-Object System.Drawing.Drawing2D.GraphicsPath
  $gp.AddArc(0, 0, $d, $d, 180, 90)
  $gp.AddArc($Size - $d, 0, $d, $d, 270, 90)
  $gp.AddArc($Size - $d, $Size - $d, $d, $d, 0, 90)
  $gp.AddArc(0, $Size - $d, $d, $d, 90, 90)
  $gp.CloseFigure()
  $g.FillPath($green, $gp)
  $gp.Dispose()

  # Centered "bai" character, positioned by measuring the text
  $ch = [string][char]0x767E
  $fontSize = if ($Maskable) { [single]($Size * 0.30) } else { [single]($Size * 0.52) }
  $font = New-Object System.Drawing.Font("Microsoft YaHei", $fontSize, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $m = $g.MeasureString($ch, $font)
  $x = [single](($Size - $m.Width) / 2)
  $y = [single](($Size - $m.Height) / 2)
  $g.DrawString($ch, $font, [System.Drawing.Brushes]::White, $x, $y)
  Write-Output ("  size=" + $Size + " char=" + $ch + " font=" + $font.Name + " measured=" + [math]::Round($m.Width, 1) + "x" + [math]::Round($m.Height, 1))

  $g.Dispose()
  $bmp.Save($OutFile, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  $font.Dispose(); $green.Dispose()
}

$root = Split-Path -Parent $PSScriptRoot
New-AppIcon -Size 192 -OutFile (Join-Path $root "icon-192.png") -Maskable $false
New-AppIcon -Size 512 -OutFile (Join-Path $root "icon-512.png") -Maskable $false
New-AppIcon -Size 512 -OutFile (Join-Path $root "icon-512-maskable.png") -Maskable $true
Write-Output "done"
