Add-Type -AssemblyName System.Drawing

# =============================================================================
# 1. GENERATE ULTRA-FUTURISTIC NEUROFOCUS ICON (512x512)
# =============================================================================
$iconSize = 512
$iconBmp = New-Object System.Drawing.Bitmap($iconSize, $iconSize)
$g = [System.Drawing.Graphics]::FromImage($iconBmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

# Deep Dark Cyber Radial Background
$rect = New-Object System.Drawing.Rectangle(0, 0, $iconSize, $iconSize)
$bp1 = New-Object System.Drawing.Point(0, 0)
$bp2 = New-Object System.Drawing.Point($iconSize, $iconSize)
$bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $bp1, $bp2,
    [System.Drawing.Color]::FromArgb(255, 3, 6, 16),
    [System.Drawing.Color]::FromArgb(255, 1, 2, 6)
)
$g.FillRectangle($bgBrush, $rect)

# Draw Cyber Perspective Matrix Lines in background
$matrixPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(22, 0, 240, 255), 1)
for ($i = 0; $i -lt $iconSize; $i += 24) {
    $g.DrawLine($matrixPen, $i, 0, $i, $iconSize)
    $g.DrawLine($matrixPen, 0, $i, $iconSize, $i)
}

[float]$cx = [float]($iconSize / 2)
[float]$cy = [float]($iconSize / 2 - 16)

# Outer Sci-Fi HUD Bracket Frame
$bracketPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(240, 0, 240, 255), 3)
$cLen = 42
# TL
$g.DrawLine($bracketPen, 20, 20, 20 + $cLen, 20)
$g.DrawLine($bracketPen, 20, 20, 20, 20 + $cLen)
# TR
$g.DrawLine($bracketPen, $iconSize - 20, 20, $iconSize - 20 - $cLen, 20)
$g.DrawLine($bracketPen, $iconSize - 20, 20, $iconSize - 20, 20 + $cLen)
# BL
$g.DrawLine($bracketPen, 20, $iconSize - 20, 20 + $cLen, $iconSize - 20)
$g.DrawLine($bracketPen, 20, $iconSize - 20, 20, $iconSize - 20 - $cLen)
# BR
$g.DrawLine($bracketPen, $iconSize - 20, $iconSize - 20, $iconSize - 20 - $cLen, $iconSize - 20)
$g.DrawLine($bracketPen, $iconSize - 20, $iconSize - 20, $iconSize - 20, $iconSize - 20 - $cLen)

# Neural Circuit Traces branching from corners to center
$circuitPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(90, 0, 240, 255), 1.5)
$dotBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 240, 255))

$circuitPaths = @(
    @(20, 100, 70, 100, 110, 140),
    @(($iconSize - 20), 100, ($iconSize - 70), 100, ($iconSize - 110), 140),
    @(20, ($iconSize - 100), 70, ($iconSize - 100), 110, ($iconSize - 140)),
    @(($iconSize - 20), ($iconSize - 100), ($iconSize - 70), ($iconSize - 100), ($iconSize - 110), ($iconSize - 140))
)
foreach ($cp in $circuitPaths) {
    $g.DrawLine($circuitPen, $cp[0], $cp[1], $cp[2], $cp[3])
    $g.DrawLine($circuitPen, $cp[2], $cp[3], $cp[4], $cp[5])
    $g.FillEllipse($dotBrush, $cp[4] - 3, $cp[5] - 3, 6, 6)
}

# Massive Outer Cybernetic Energy Aura (Multi-pass Neon Glow)
for ($glow = 8; $glow -ge 1; $glow--) {
    $alpha = [int](38 / $glow)
    $glowPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb($alpha, 0, 240, 255), ($glow * 7))
    $r = [float](155.0 + $glow * 4.5)
    $g.DrawEllipse($glowPen, [float]($cx - $r), [float]($cy - $r), [float]($r * 2), [float]($r * 2))
}

# Heavy Outer Mechanical Bezel Ring
$outerBezelPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 0, 240, 255), 3.5)
$g.DrawEllipse($outerBezelPen, [float]($cx - 150), [float]($cy - 150), 300.0, 300.0)

# Secondary Violet Outer Energy Ring
$violetRingPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 170, 0, 255), 2)
$violetRingPen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
$g.DrawEllipse($violetRingPen, [float]($cx - 138), [float]($cy - 138), 276.0, 276.0)

# Caliper Degree Ticks around the perimeter (every 10 degrees)
$tickPenLong = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 0, 240, 255), 2)
$tickPenShort = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(150, 0, 240, 255), 1)
for ($deg = 0; $deg -lt 360; $deg += 10) {
    [double]$rad = ($deg * [Math]::PI) / 180.0
    $isMajor = ($deg % 30 -eq 0)
    $innerR = if ($isMajor) { 124.0 } else { 129.0 }
    $outerR = 136.0
    
    [float]$x1 = [float]($cx + [Math]::Cos($rad) * $innerR)
    [float]$y1 = [float]($cy + [Math]::Sin($rad) * $innerR)
    [float]$x2 = [float]($cx + [Math]::Cos($rad) * $outerR)
    [float]$y2 = [float]($cy + [Math]::Sin($rad) * $outerR)
    
    if ($isMajor) {
        $g.DrawLine($tickPenLong, $x1, $y1, $x2, $y2)
    } else {
        $g.DrawLine($tickPenShort, $x1, $y1, $x2, $y2)
    }
}

# 6-Faceted Sci-Fi Mechanical Aperture Blades (Cyber Iris)
[System.Drawing.PointF[]]$irisPts = @(
    (New-Object System.Drawing.PointF($cx, [float]($cy - 105))),
    (New-Object System.Drawing.PointF([float]($cx + 91), [float]($cy - 52))),
    (New-Object System.Drawing.PointF([float]($cx + 91), [float]($cy + 52))),
    (New-Object System.Drawing.PointF($cx, [float]($cy + 105))),
    (New-Object System.Drawing.PointF([float]($cx - 91), [float]($cy + 52))),
    (New-Object System.Drawing.PointF([float]($cx - 91), [float]($cy - 52)))
)
$irisBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.PointF($cx, [float]($cy - 105))),
    (New-Object System.Drawing.PointF($cx, [float]($cy + 105))),
    [System.Drawing.Color]::FromArgb(255, 14, 30, 65),
    [System.Drawing.Color]::FromArgb(255, 5, 10, 25)
)
$g.FillPolygon($irisBrush, $irisPts)

$irisBorder = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 0, 240, 255), 3)
$g.DrawPolygon($irisBorder, $irisPts)

# Mechanical Blade Partition Lines
$bladePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 0, 240, 255), 1.5)
for ($i = 0; $i -lt 6; $i++) {
    $pt1 = $irisPts[$i]
    [double]$rad = (($i * 60 + 30) * [Math]::PI) / 180.0
    [float]$ix = [float]($cx + [Math]::Cos($rad) * 35.0)
    [float]$iy = [float]($cy + [Math]::Sin($rad) * 35.0)
    $g.DrawLine($bladePen, $pt1.X, $pt1.Y, $ix, $iy)
}

# Inner Glowing Electric Violet Reticle
$innerVioletPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 0, 128), 2.5)
$g.DrawEllipse($innerVioletPen, [float]($cx - 55), [float]($cy - 55), 110.0, 110.0)

# Holographic Crosshairs with tick notches
$crossGlowPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 0, 240, 255), 2)
$g.DrawLine($crossGlowPen, [float]($cx - 165), $cy, [float]($cx - 35), $cy)
$g.DrawLine($crossGlowPen, [float]($cx + 35), $cy, [float]($cx + 165), $cy)
$g.DrawLine($crossGlowPen, $cx, [float]($cy - 165), $cx, [float]($cy - 35))
$g.DrawLine($crossGlowPen, $cx, [float]($cy + 35), $cx, [float]($cy + 165))

# Intense Blinding Cyan-White Arc Core (The "Neuro-Beam" Focus Point)
for ($flare = 5; $flare -ge 1; $flare--) {
    $flareBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb([int](50 / $flare), 0, 240, 255))
    $fr = [float](18.0 + $flare * 4.0)
    $g.FillEllipse($flareBrush, [float]($cx - $fr), [float]($cy - $fr), [float]($fr * 2), [float]($fr * 2))
}
$coreNeon = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 240, 255))
$g.FillEllipse($coreNeon, [float]($cx - 16), [float]($cy - 16), 32.0, 32.0)

$coreWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255, 255))
$g.FillEllipse($coreWhite, [float]($cx - 7), [float]($cy - 7), 14.0, 14.0)

# Cross-Star Lens Flare Lines
$flareStarPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 255, 255, 255), 1.5)
$g.DrawLine($flareStarPen, [float]($cx - 28), $cy, [float]($cx + 28), $cy)
$g.DrawLine($flareStarPen, $cx, [float]($cy - 28), $cx, [float]($cy + 28))

# Bottom Futuristic HUD Branding
$labelFont = New-Object System.Drawing.Font("Arial Black", 15, [System.Drawing.FontStyle]::Bold)
$labelBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.PointF(($cx - 120), [float]($iconSize - 62))),
    (New-Object System.Drawing.PointF(($cx + 120), [float]($iconSize - 62))),
    [System.Drawing.Color]::FromArgb(255, 0, 240, 255),
    [System.Drawing.Color]::FromArgb(255, 255, 0, 128)
)
$strFormat = New-Object System.Drawing.StringFormat
$strFormat.Alignment = [System.Drawing.StringAlignment]::Center
$g.DrawString("NEUROFOCUS", $labelFont, $labelBrush, $cx, [float]($iconSize - 60), $strFormat)

$subFont = New-Object System.Drawing.Font("Consolas", 8.5, [System.Drawing.FontStyle]::Bold)
$subBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 140, 170, 220))
$g.DrawString("// COGNITIVE OPTICAL MATRIX //", $subFont, $subBrush, $cx, [float]($iconSize - 36), $strFormat)

$iconBmp.Save("assets/icon.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$iconBmp.Dispose()
Write-Output "SUCCESS: Generated Ultra-Futuristic assets/icon.png (512x512)"


# =============================================================================
# 2. GENERATE ULTRA-FUTURISTIC NEUROFOCUS BANNER (1200x420)
# =============================================================================
$bWidth = 1200
$bHeight = 420
$bannerBmp = New-Object System.Drawing.Bitmap($bWidth, $bHeight)
$gb = [System.Drawing.Graphics]::FromImage($bannerBmp)
$gb.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$gb.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gb.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

# Deep Cyber Gradient with Horizon Light
$bannerRect = New-Object System.Drawing.Rectangle(0, 0, $bWidth, $bHeight)
$bp1 = New-Object System.Drawing.Point(0, 0)
$bp2 = New-Object System.Drawing.Point($bWidth, $bHeight)
$bgBannerBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $bp1, $bp2,
    [System.Drawing.Color]::FromArgb(255, 2, 4, 12),
    [System.Drawing.Color]::FromArgb(255, 8, 16, 38)
)
$gb.FillRectangle($bgBannerBrush, $bannerRect)

# 3D Cyber Perspective Grid Floor with Horizon Glow
$pPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(35, 0, 240, 255), 1)
for ($y = 240; $y -lt $bHeight; $y += 20) {
    $gb.DrawLine($pPen, 0, $y, $bWidth, $y)
}
for ($x = 0; $x -lt $bWidth; $x += 50) {
    $gb.DrawLine($pPen, $x, 240, [int]($bWidth / 2 + ($x - $bWidth / 2) * 1.6), $bHeight)
}

# Horizon Neon Beam Line
$horizonPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 0, 240, 255), 1.5)
$gb.DrawLine($horizonPen, 0, 240, $bWidth, 240)

# Top & Bottom Glowing Laser Border
$topGlowPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 0, 240, 255), 2.5)
$gb.DrawLine($topGlowPen, 0, 1, $bWidth, 1)

$bottomGlowPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 0, 128), 2)
$gb.DrawLine($bottomGlowPen, 0, $bHeight - 1, $bWidth, $bHeight - 1)

# High-Tech Corner Brackets with Telemetry Numbers
$cornerPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(240, 0, 240, 255), 3)
$cSize = 45
# TL
$gb.DrawLine($cornerPen, 18, 18, 18 + $cSize, 18)
$gb.DrawLine($cornerPen, 18, 18, 18, 18 + $cSize)
# TR
$gb.DrawLine($cornerPen, $bWidth - 18, 18, $bWidth - 18 - $cSize, 18)
$gb.DrawLine($cornerPen, $bWidth - 18, 18, $bWidth - 18, 18 + $cSize)
# BL
$gb.DrawLine($cornerPen, 18, $bHeight - 18, 18 + $cSize, $bHeight - 18)
$gb.DrawLine($cornerPen, 18, $bHeight - 18, 18, $bHeight - 18 - $cSize)
# BR
$gb.DrawLine($cornerPen, $bWidth - 18, $bHeight - 18, $bWidth - 18 - $cSize, $bHeight - 18)
$gb.DrawLine($cornerPen, $bWidth - 18, $bHeight - 18, $bWidth - 18, $bHeight - 18 - $cSize)

# LEFT SIDE: Giant Holographic Arc-Reactor Neural Lens
[float]$scx = 195.0
[float]$scy = 205.0

# Multi-layer Glowing Rings
for ($r = 145; $r -ge 55; $r -= 30) {
    $ringPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(45, 0, 240, 255), 1.5)
    $gb.DrawEllipse($ringPen, [float]($scx - $r), [float]($scy - $r), [float]($r * 2), [float]($r * 2))
}

$bHeavyRing = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 0, 240, 255), 3.5)
$gb.DrawEllipse($bHeavyRing, [float]($scx - 125), [float]($scy - 125), 250.0, 250.0)

$bVioletRing = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 0, 128), 2)
$bVioletRing.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
$gb.DrawEllipse($bVioletRing, [float]($scx - 95), [float]($scy - 95), 190.0, 190.0)

# Caliper degree marks around scanner
for ($deg = 0; $deg -lt 360; $deg += 15) {
    [double]$rad = ($deg * [Math]::PI) / 180.0
    [float]$x1 = [float]($scx + [Math]::Cos($rad) * 110.0)
    [float]$y1 = [float]($scy + [Math]::Sin($rad) * 110.0)
    [float]$x2 = [float]($scx + [Math]::Cos($rad) * 123.0)
    [float]$y2 = [float]($scy + [Math]::Sin($rad) * 123.0)
    $gb.DrawLine($tickPenShort, $x1, $y1, $x2, $y2)
}

# 6-Faceted Sci-Fi Iris Blade Core
[System.Drawing.PointF[]]$bHexPts = @(
    (New-Object System.Drawing.PointF($scx, [float]($scy - 70))),
    (New-Object System.Drawing.PointF([float]($scx + 60), [float]($cy - 35))),
    (New-Object System.Drawing.PointF([float]($scx + 60), [float]($cy + 35))),
    (New-Object System.Drawing.PointF($scx, [float]($scy + 70))),
    (New-Object System.Drawing.PointF([float]($scx - 60), [float]($cy + 35))),
    (New-Object System.Drawing.PointF([float]($scx - 60), [float]($cy - 35)))
)
$bHexBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.PointF($scx, [float]($scy - 70))),
    (New-Object System.Drawing.PointF($scx, [float]($scy + 70))),
    [System.Drawing.Color]::FromArgb(255, 14, 28, 62),
    [System.Drawing.Color]::FromArgb(255, 5, 10, 24)
)
$gb.FillPolygon($bHexBrush, $bHexPts)
$gb.DrawPolygon($bHeavyRing, $bHexPts)

# Central Neuro-Beam Flare
for ($flare = 4; $flare -ge 1; $flare--) {
    $fb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb([int](55 / $flare), 0, 240, 255))
    $fr = [float](16.0 + $flare * 4.0)
    $gb.FillEllipse($fb, [float]($scx - $fr), [float]($scy - $fr), [float]($fr * 2), [float]($fr * 2))
}
$bCoreNeon = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 240, 255))
$gb.FillEllipse($bCoreNeon, [float]($scx - 14), [float]($scy - 14), 28.0, 28.0)
$gb.FillEllipse($coreWhite, [float]($scx - 5), [float]($scy - 5), 10.0, 10.0)

# Crosshairs Cutting Through Scanner
$bCross = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 0, 240, 255), 1.8)
$gb.DrawLine($bCross, [float]($scx - 145), $scy, [float]($scx + 145), $scy)
$gb.DrawLine($bCross, $scx, [float]($scy - 145), $scx, [float]($scy + 145))


# RIGHT SIDE: Typography, Telemetry & Cyber HUD Cards
[float]$tx = 360.0

# Top Sci-Fi Telemetry Bar
$hudHeaderFont = New-Object System.Drawing.Font("Consolas", 10.5, [System.Drawing.FontStyle]::Bold)
$hudTagBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 240, 255))
$gb.DrawString("// PROTOCOL: OPTICAL_ISOLATION // COGNITIVE BANDWIDTH DEFENSE [● REC]", $hudHeaderFont, $hudTagBrush, $tx, 55.0)

# Giant Glowing Title: NEUROFOCUS (Neon Glow Effect using layered rendering)
$titleFont = New-Object System.Drawing.Font("Arial Black", 48, [System.Drawing.FontStyle]::Bold)

# Outer Neon Glow passes
for ($tGlow = 4; $tGlow -ge 1; $tGlow--) {
    $glowTBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb([int](30 / $tGlow), 0, 240, 255))
    $gb.DrawString("NEUROFOCUS", $titleFont, $glowTBrush, [float]($tx + $tGlow), [float](78.0 + $tGlow))
    $gb.DrawString("NEUROFOCUS", $titleFont, $glowTBrush, [float]($tx - $tGlow), [float](78.0 - $tGlow))
}

# Main Gradient Title
$tp1 = New-Object System.Drawing.PointF($tx, 78.0)
$tp2 = New-Object System.Drawing.PointF(($tx + 520.0), 78.0)
$titleBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $tp1, $tp2,
    [System.Drawing.Color]::FromArgb(255, 0, 240, 255),
    [System.Drawing.Color]::FromArgb(255, 255, 0, 128)
)
$gb.DrawString("NEUROFOCUS", $titleFont, $titleBrush, $tx, 78.0)

# Subtitle
$subTitleFont = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$subTitleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 240, 245, 255))
$gb.DrawString("ADHD & Deep-Focus Code Dimmer for Visual Studio Code", $subTitleFont, $subTitleBrush, $tx, 162.0)

# Body Description
$descFont = New-Object System.Drawing.Font("Segoe UI", 11.5, [System.Drawing.FontStyle]::Regular)
$descBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 170, 195, 230))
$gb.DrawString("Illuminates your active function while fading surrounding visual noise into deep space.", $descFont, $descBrush, $tx, 202.0)
$gb.DrawString("Designed for ADHD minds, massive files (500+ lines), and uninterrupted cognitive flow.", $descFont, $descBrush, $tx, 226.0)

# Futuristic Cyber Badges (High Contrast Neon Glowing Cards)
function Draw-CyberCard($graphics, [float]$bx, [float]$by, $label, $color) {
    $bFont = New-Object System.Drawing.Font("Consolas", 9, [System.Drawing.FontStyle]::Bold)
    $bSize = $graphics.MeasureString($label, $bFont)
    $pad = 12.0
    $bw = $bSize.Width + $pad * 2.0
    $bh = 26.0
    
    $bgBrd = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(45, $color.R, $color.G, $color.B))
    $penBrd = New-Object System.Drawing.Pen($color, 1.5)
    $textBrd = New-Object System.Drawing.SolidBrush($color)
    
    $graphics.FillRectangle($bgBrd, $bx, $by, $bw, $bh)
    $graphics.DrawRectangle($penBrd, $bx, $by, $bw, $bh)
    $graphics.DrawString($label, $bFont, $textBrd, [float]($bx + $pad), [float]($by + 5.0))
    
    return [float]($bw + 10.0)
}

[float]$badgeX = $tx
$badgeX += Draw-CyberCard $gb $badgeX 274.0 "COGNITIVE FOCUS: ARMED" ([System.Drawing.Color]::FromArgb(255, 0, 255, 102))
$badgeX += Draw-CyberCard $gb $badgeX 274.0 "SMART AST SCOPE" ([System.Drawing.Color]::FromArgb(255, 0, 240, 255))
$badgeX += Draw-CyberCard $gb $badgeX 274.0 "BUTTER-SMOOTH 60FPS" ([System.Drawing.Color]::FromArgb(255, 255, 0, 128))
$badgeX += Draw-CyberCard $gb $badgeX 274.0 "ZERO VISUAL CLUTTER" ([System.Drawing.Color]::FromArgb(255, 255, 170, 0))

# Bottom Tech Ruler & Matrix Status
$rulePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(60, 0, 240, 255), 1)
$gb.DrawLine($rulePen, $tx, 330.0, [float]($bWidth - 40), 330.0)

$coordFont = New-Object System.Drawing.Font("Consolas", 8.5, [System.Drawing.FontStyle]::Regular)
$coordBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(160, 120, 150, 190))
$gb.DrawString("NEUROFOCUS PROTOCOL // OPTICAL ISOLATION: ACTIVE // REPRESS VISUAL BRAIN FATIGUE", $coordFont, $coordBrush, $tx, 342.0)

$bannerBmp.Save("assets/banner.png", [System.Drawing.Imaging.ImageFormat]::Png)
$gb.Dispose()
$bannerBmp.Dispose()
Write-Output "SUCCESS: Generated Ultra-Futuristic assets/banner.png (1200x420)"
