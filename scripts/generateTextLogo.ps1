Add-Type -AssemblyName System.Drawing

# =============================================================================
# GENERATE PURE TEXT-TYPE FUTURISTIC LOGO (512x512)
# =============================================================================
$iconSize = 512
$iconBmp = New-Object System.Drawing.Bitmap($iconSize, $iconSize)
$g = [System.Drawing.Graphics]::FromImage($iconBmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

# Deep Cyber Dark Background
$rect = New-Object System.Drawing.Rectangle(0, 0, $iconSize, $iconSize)
$bp1 = New-Object System.Drawing.Point(0, 0)
$bp2 = New-Object System.Drawing.Point($iconSize, $iconSize)
$bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $bp1, $bp2,
    [System.Drawing.Color]::FromArgb(255, 3, 5, 14),
    [System.Drawing.Color]::FromArgb(255, 1, 2, 6)
)
$g.FillRectangle($bgBrush, $rect)

# Subtle Cyber Grid
$gridPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(20, 0, 240, 255), 1)
for ($i = 0; $i -lt $iconSize; $i += 24) {
    $g.DrawLine($gridPen, $i, 0, $i, $iconSize)
    $g.DrawLine($gridPen, 0, $i, $iconSize, $i)
}

# Outer HUD Corner Framing
$hudPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 0, 240, 255), 3)
$cLen = 45
# TL
$g.DrawLine($hudPen, 22, 22, 22 + $cLen, 22)
$g.DrawLine($hudPen, 22, 22, 22, 22 + $cLen)
# TR
$g.DrawLine($hudPen, $iconSize - 22, 22, $iconSize - 22 - $cLen, 22)
$g.DrawLine($hudPen, $iconSize - 22, 22, $iconSize - 22, 22 + $cLen)
# BL
$g.DrawLine($hudPen, 22, $iconSize - 22, 22 + $cLen, $iconSize - 22)
$g.DrawLine($hudPen, 22, $iconSize - 22, 22, $iconSize - 22 - $cLen)
# BR
$g.DrawLine($hudPen, $iconSize - 22, $iconSize - 22, $iconSize - 22 - $cLen, $iconSize - 22)
$g.DrawLine($hudPen, $iconSize - 22, $iconSize - 22, $iconSize - 22, $iconSize - 22 - $cLen)

[float]$cx = [float]($iconSize / 2)

# Top Telemetry Header Tag
$topFont = New-Object System.Drawing.Font("Consolas", 10.5, [System.Drawing.FontStyle]::Bold)
$topBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 240, 255))
$strCenter = New-Object System.Drawing.StringFormat
$strCenter.Alignment = [System.Drawing.StringAlignment]::Center
$g.DrawString("// COGNITIVE_PROTOCOL: ACTIVE //", $topFont, $topBrush, $cx, 68.0, $strCenter)

# Main Wordmark Typography: NEURO (Row 1) & FOCUS (Row 2)
$textFont = New-Object System.Drawing.Font("Arial Black", 58, [System.Drawing.FontStyle]::Bold)

# Multi-pass Neon Glow for NEURO
for ($gCount = 5; $gCount -ge 1; $gCount--) {
    $alpha = [int](32 / $gCount)
    $neuroGlow = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($alpha, 0, 240, 255))
    $g.DrawString("NEURO", $textFont, $neuroGlow, [float]($cx + $gCount), [float](105.0 + $gCount), $strCenter)
    $g.DrawString("NEURO", $textFont, $neuroGlow, [float]($cx - $gCount), [float](105.0 - $gCount), $strCenter)
}

# Main Gradient for NEURO (Cyan to Ice White)
$neuroBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.PointF(($cx - 150), 105.0)),
    (New-Object System.Drawing.PointF(($cx + 150), 105.0)),
    [System.Drawing.Color]::FromArgb(255, 0, 240, 255),
    [System.Drawing.Color]::FromArgb(255, 230, 255, 255)
)
$g.DrawString("NEURO", $textFont, $neuroBrush, $cx, 105.0, $strCenter)

# Central Laser Splitter Line with Center Diamond
$linePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 0, 240, 255), 2)
$g.DrawLine($linePen, [float]($cx - 180), 225.0, [float]($cx - 25), 225.0)
$g.DrawLine($linePen, [float]($cx + 25), 225.0, [float]($cx + 180), 225.0)

# Center Diamond Accent
[System.Drawing.PointF[]]$diamondPts = @(
    (New-Object System.Drawing.PointF($cx, 217.0)),
    (New-Object System.Drawing.PointF([float]($cx + 12), 225.0)),
    (New-Object System.Drawing.PointF($cx, 233.0)),
    (New-Object System.Drawing.PointF([float]($cx - 12), 225.0))
)
$diamondBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 0, 128))
$g.FillPolygon($diamondBrush, $diamondPts)
$g.DrawPolygon($linePen, $diamondPts)

# Multi-pass Neon Glow for FOCUS (Row 2)
for ($gCount = 5; $gCount -ge 1; $gCount--) {
    $alpha = [int](32 / $gCount)
    $focusGlow = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($alpha, 255, 0, 128))
    $g.DrawString("FOCUS", $textFont, $focusGlow, [float]($cx + $gCount), [float](235.0 + $gCount), $strCenter)
    $g.DrawString("FOCUS", $textFont, $focusGlow, [float]($cx - $gCount), [float](235.0 - $gCount), $strCenter)
}

# Main Gradient for FOCUS (Electric Magenta to Neon Violet)
$focusBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.PointF(($cx - 150), 235.0)),
    (New-Object System.Drawing.PointF(($cx + 150), 235.0)),
    [System.Drawing.Color]::FromArgb(255, 255, 0, 128),
    [System.Drawing.Color]::FromArgb(255, 160, 50, 255)
)
$g.DrawString("FOCUS", $textFont, $focusBrush, $cx, 235.0, $strCenter)

# Bottom Cyber Telemetry Box
$badgeRect = New-Object System.Drawing.RectangleF([float]($cx - 165), 370.0, 330.0, 34.0)
$badgeBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 0, 240, 255))
$badgePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 0, 240, 255), 1.5)
$g.FillRectangle($badgeBg, $badgeRect)
$g.DrawRectangle($badgePen, $badgeRect.X, $badgeRect.Y, $badgeRect.Width, $badgeRect.Height)

$badgeFont = New-Object System.Drawing.Font("Consolas", 10.5, [System.Drawing.FontStyle]::Bold)
$badgeTextBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 240, 255))
$g.DrawString("[ DEEP FOCUS // ADHD CODE DIMMER ]", $badgeFont, $badgeTextBrush, $cx, 378.0, $strCenter)

# Sub-status line at the very bottom
$statusFont = New-Object System.Drawing.Font("Consolas", 8.5, [System.Drawing.FontStyle]::Regular)
$statusBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(160, 140, 170, 210))
$g.DrawString("VS CODE EXTENSION // 60FPS OPTICAL MATRIX", $statusFont, $statusBrush, $cx, 424.0, $strCenter)

# Save
$iconBmp.Save("assets/icon.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$iconBmp.Dispose()
Write-Output "SUCCESS: Generated Pure Text-Type Futuristic assets/icon.png (512x512)"
