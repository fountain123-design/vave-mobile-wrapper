Add-Type -AssemblyName System.Drawing

function Create-Icon {
    param([string]$path, [int]$size)
    $bmp = New-Object System.Drawing.Bitmap $size, $size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::FromArgb(2, 144, 213))
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $fontSize = [int]($size * 0.4)
    if ($fontSize -lt 8) { $fontSize = 8 }
    $font = New-Object System.Drawing.Font('Arial', $fontSize, [System.Drawing.FontStyle]::Bold)
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $rect = New-Object System.Drawing.RectangleF(0, 0, $size, $size)
    $g.DrawString('V', $font, $brush, $rect, $sf)
    $g.Dispose()
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "Created: $path"
}

$base = 'C:/Users/fountain xie/Desktop/vave-mobile-wrapper/android/app/src/main/res'
Create-Icon "$base/mipmap-mdpi/ic_launcher.png" 48
Create-Icon "$base/mipmap-hdpi/ic_launcher.png" 72
Create-Icon "$base/mipmap-xhdpi/ic_launcher.png" 96
Create-Icon "$base/mipmap-xxhdpi/ic_launcher.png" 144
Create-Icon "$base/mipmap-xxxhdpi/ic_launcher.png" 192
Write-Host 'All icons created!'
