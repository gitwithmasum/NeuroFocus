Add-Type -AssemblyName System.Drawing

# -----------------------------------------------------------------------------
# 1. GENERATE FUTURISTIC NEUROFOCUS ICON (512x512)
# -----------------------------------------------------------------------------
$iconSize = 512
$iconBmp = New-Object System.Drawing.Bitmap($iconSize, $iconSize)
$g = [System.Drawing.Graphics]::FromImage($iconBmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

# Background dark radial gradient
$rect = New-Object System.Drawing.Rectangle(0, 0, $iconSize, $iconSize)
$p1 = New-Object System.Drawing.Point(0, 0)
$p2 = New-Object System.Drawing.Point($iconSize, $iconSize)
$bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $p1, $p2,
    [System.Drawing.Color]::FromArgb(255, 4, 8, 20),
    [System.Drawing.Color]::FromArgb(255, 1, 3, 8)
)
$g.FillRectangle($bgBrush, $rect)

# Draw subtle neural cyber grid
$gridPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(25, 0, 240, 255), 1)
for ($i = 0; $i -lt $iconSize; $i += 32) {
    $g.DrawLine($gridPen, $i, 0, $i, $iconSize)
    $g.DrawLine($gridPen, 0, $i, $iconSize, $i)
}

# Outer HUD Corner Brackets
$hudPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 0, 240, 255), 3)
$bLen = 35
# TL
$g.DrawLine($hudPen, 24, 24, 24 + $bLen, 24)
$g.DrawLine($hudPen, 24, 24, 24, 24 + $bLen)
# TR
$g.DrawLine($hudPen, $iconSize - 24, 24, $iconSize - 24 - $bLen, 24)
$g.DrawLine($hudPen, $iconSize - 24, 24, $iconSize - 24, 24 + $bLen)
# BL
$g.DrawLine($hudPen, 24, $iconSize - 24, 24 + $bLen, $iconSize - 24)
$g.DrawLine($hudPen, 24, $iconSize - 24, 24, $iconSize - 24 - $bLen)
# BR
$g.DrawLine($hudPen, $iconSize - 24, $iconSize - 24, $iconSize - 24 - $bLen, $iconSize - 24)
$g.DrawLine($hudPen, $iconSize - 24, $iconSize - 24, $iconSize - 24, $iconSize - 24 - $bLen)

[float]$cx = [float]($iconSize / 2)
[float]$cy = [float]($iconSize / 2 - 18)

# Glowing Cyber Eye / Neural Reticle
# Outer Glow Rings
for ($glow = 5; $glow -ge 1; $glow--) {
    $alpha = [int](30 / $glow)
    $glowPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb($alpha, 0, 240, 255), ($glow * 6))
    $r = [float](140.0 + $glow * 4)
    $g.DrawEllipse($glowPen, [float]($cx - $r), [float]($cy - $r), [float]($r * 2), [float]($r * 2))
}

# Outer Neural Orbit Ring
$orbitPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 0, 240, 255), 3)
$g.DrawEllipse($orbitPen, [float]($cx - 135), [float]($cy - 135), 270.0, 270.0)

# Secondary Violet Ring (Dashed)
$violetPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 157, 0, 255), 2)
$violetPen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
$g.DrawEllipse($violetPen, [float]($cx - 105), [float]($cy - 105), 210.0, 210.0)

# Cyber Iris Polygon (Hexagonal Lens)
[System.Drawing.PointF[]]$hexPts = @(
    (New-Object System.Drawing.PointF($cx, [float]($cy - 85))),
    (New-Object System.Drawing.PointF([float]($cx + 74), [float]($cy - 42))),
    (New-Object System.Drawing.PointF([float]($cx + 74), [float]($cy + 42))),
    (New-Object System.Drawing.PointF($cx, [float]($cy + 85))),
    (New-Object System.Drawing.PointF([float]($cx - 74), [float]($cy + 42))),
    (New-Object System.Drawing.PointF([float]($cx - 74), [float]($cy - 42)))
)

$hexBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.PointF($cx, [float]($cy - 85))),
    (New-Object System.Drawing.PointF($cx, [float]($cy + 85))),
    [System.Drawing.Color]::FromArgb(255, 12, 28, 60),
    [System.Drawing.Color]::FromArgb(255, 4, 8, 20)
)
$g.FillPolygon($hexBrush, $hexPts)

$hexPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 0, 240, 255), 2.5)
$g.DrawPolygon($hexPen, $hexPts)

# Central Neural Pupil (Deep Focus Beam)
$pupilPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 0, 127), 2)
$g.DrawEllipse($pupilPen, [float]($cx - 45), [float]($cy - 45), 90.0, 90.0)

$coreCyan = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 240, 255))
$g.FillEllipse($coreCyan, [float]($cx - 20), [float]($cy - 20), 40.0, 40.0)

$coreWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255, 255))
$g.FillEllipse($coreWhite, [float]($cx - 7), [float]($cy - 7), 14.0, 14.0)

# Neural Crosshairs
$crossPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 0, 240, 255), 2)
$g.DrawLine($crossPen, [float]($cx - 150), $cy, [float]($cx - 30), $cy)
$g.DrawLine($crossPen, [float]($cx + 30), $cy, [float]($cx + 150), $cy)
$g.DrawLine($crossPen, $cx, [float]($cy - 150), $cx, [float]($cy - 30))
$g.DrawLine($crossPen, $cx, [float]($cy + 30), $cx, [float]($cy + 150))

# Bottom Futuristic Typography
$labelFont = New-Object System.Drawing.Font("Arial Black", 14, [System.Drawing.FontStyle]::Bold)
$labelBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 240, 255))
$strFormat = New-Object System.Drawing.StringFormat
$strFormat.Alignment = [System.Drawing.StringAlignment]::Center
$g.DrawString("NEUROFOCUS", $labelFont, $labelBrush, $cx, [float]($iconSize - 60), $strFormat)

$subFont = New-Object System.Drawing.Font("Consolas", 8, [System.Drawing.FontStyle]::Bold)
$subBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 140, 160, 200))
$g.DrawString("// ADHD & DEEP FOCUS DIMMER //", $subFont, $subBrush, $cx, [float]($iconSize - 38), $strFormat)

New-Item -ItemType Directory -Force -Path "assets" | Out-Null
$iconBmp.Save("assets/icon.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$iconBmp.Dispose()
Write-Output "SUCCESS: Generated assets/icon.png (512x512)"


# -----------------------------------------------------------------------------
# 2. GENERATE FUTURISTIC NEUROFOCUS BANNER (1200x420)
# -----------------------------------------------------------------------------
$bWidth = 1200
$bHeight = 420
$bannerBmp = New-Object System.Drawing.Bitmap($bWidth, $bHeight)
$gb = [System.Drawing.Graphics]::FromImage($bannerBmp)
$gb.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$gb.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gb.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

# Deep Cyber Gradient
$bannerRect = New-Object System.Drawing.Rectangle(0, 0, $bWidth, $bHeight)
$bp1 = New-Object System.Drawing.Point(0, 0)
$bp2 = New-Object System.Drawing.Point($bWidth, $bHeight)
$bgBannerBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $bp1, $bp2,
    [System.Drawing.Color]::FromArgb(255, 2, 4, 12),
    [System.Drawing.Color]::FromArgb(255, 6, 12, 30)
)
$gb.FillRectangle($bgBannerBrush, $bannerRect)

# Perspective Grid Floor
$pPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(28, 0, 240, 255), 1)
for ($y = 260; $y -lt $bHeight; $y += 24) {
    $gb.DrawLine($pPen, 0, $y, $bWidth, $y)
}
for ($x = 0; $x -lt $bWidth; $x += 60) {
    $gb.DrawLine($pPen, $x, 260, [int]($bWidth / 2 + ($x - $bWidth / 2) * 1.5), $bHeight)
}

# Top Glowing Cyber Beam
$topGlowPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 0, 240, 255), 2.5)
$gb.DrawLine($topGlowPen, 0, 1, $bWidth, 1)

# Tech Accent Corners
$cornerPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 0, 240, 255), 3)
$cSize = 40
# TL
$gb.DrawLine($cornerPen, 20, 20, 20 + $cSize, 20)
$gb.DrawLine($cornerPen, 20, 20, 20, 20 + $cSize)
# TR
$gb.DrawLine($cornerPen, $bWidth - 20, 20, $bWidth - 20 - $cSize, 20)
$gb.DrawLine($cornerPen, $bWidth - 20, 20, $bWidth - 20, 20 + $cSize)
# BL
$gb.DrawLine($cornerPen, 20, $bHeight - 20, 20 + $cSize, $bHeight - 20)
$gb.DrawLine($cornerPen, 20, $bHeight - 20, 20, $bHeight - 20 - $cSize)
# BR
$gb.DrawLine($cornerPen, $bWidth - 20, $bHeight - 20, $bWidth - 20 - $cSize, $bHeight - 20)
$gb.DrawLine($cornerPen, $bWidth - 20, $bHeight - 20, $bWidth - 20, $bHeight - 20 - $cSize)

# LEFT SIDE: Giant Holographic Focus Beam Reticle
[float]$scx = 190.0
[float]$scy = 205.0

# Glow rings
for ($r = 135; $r -ge 55; $r -= 35) {
    $ringPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(40, 0, 240, 255), 1.5)
    $gb.DrawEllipse($ringPen, [float]($scx - $r), [float]($scy - $r), [float]($r * 2), [float]($r * 2))
}

$bOrbitPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 0, 240, 255), 3)
$gb.DrawEllipse($bOrbitPen, [float]($scx - 110), [float]($scy - 110), 220.0, 220.0)

$bIrisPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 0, 127), 2)
$bIrisPen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
$gb.DrawEllipse($bIrisPen, [float]($scx - 65), [float]($scy - 65), 130.0, 130.0)

$bCore = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 240, 255))
$gb.FillEllipse($bCore, [float]($scx - 18), [float]($scy - 18), 36.0, 36.0)

$bWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255, 255))
$gb.FillEllipse($bWhite, [float]($scx - 6), [float]($scy - 6), 12.0, 12.0)

$bCross = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 0, 240, 255), 1.8)
$gb.DrawLine($bCross, [float]($scx - 120), $scy, [float]($scx + 120), $scy)
$gb.DrawLine($bCross, $scx, [float]($scy - 120), $scx, [float]($scy + 120))

# RIGHT SIDE: Typography & Telemetry
[float]$tx = 350.0

# Telemetry Header Tag
$hudHeaderFont = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)
$hudTagBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 0, 240, 255))
$gb.DrawString("// TELEMETRY: ACTIVE COGNITIVE FOCUS // ZERO-DISTRACTION DIMMER", $hudHeaderFont, $hudTagBrush, $tx, 65.0)

# Giant Title: NEUROFOCUS
$titleFont = New-Object System.Drawing.Font("Arial Black", 44, [System.Drawing.FontStyle]::Bold)
$tp1 = New-Object System.Drawing.PointF($tx, 85.0)
$tp2 = New-Object System.Drawing.PointF(($tx + 480.0), 85.0)
$titleBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $tp1, $tp2,
    [System.Drawing.Color]::FromArgb(255, 0, 240, 255),
    [System.Drawing.Color]::FromArgb(255, 170, 50, 255)
)
$gb.DrawString("NEUROFOCUS", $titleFont, $titleBrush, $tx, 85.0)

# Subtitle
$subTitleFont = New-Object System.Drawing.Font("Segoe UI", 15, [System.Drawing.FontStyle]::Bold)
$subTitleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 230, 240, 255))
$gb.DrawString("ADHD & Deep-Focus Code Dimmer for Visual Studio Code", $subTitleFont, $subTitleBrush, $tx, 168.0)

# Body Description
$descFont = New-Object System.Drawing.Font("Segoe UI", 11.5, [System.Drawing.FontStyle]::Regular)
$descBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 160, 185, 220))
$gb.DrawString("Illuminates your active function while fading surrounding visual noise into deep space.", $descFont, $descBrush, $tx, 206.0)
$gb.DrawString("Designed for ADHD minds, massive files (500+ lines), and uninterrupted cognitive flow.", $descFont, $descBrush, $tx, 230.0)

# Futuristic Telemetry Badges
function Draw-CyberBadge($graphics, [float]$bx, [float]$by, $text, $color) {
    $bFont = New-Object System.Drawing.Font("Consolas", 8.5, [System.Drawing.FontStyle]::Bold)
    $bSize = $graphics.MeasureString($text, $bFont)
    $pad = 10.0
    $bw = $bSize.Width + $pad * 2.0
    $bh = 24.0
    
    $bgBrd = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(35, $color.R, $color.G, $color.B))
    $penBrd = New-Object System.Drawing.Pen($color, 1.2)
    $textBrd = New-Object System.Drawing.SolidBrush($color)
    
    $graphics.FillRectangle($bgBrd, $bx, $by, $bw, $bh)
    $graphics.DrawRectangle($penBrd, $bx, $by, $bw, $bh)
    $graphics.DrawString($text, $bFont, $textBrd, [float]($bx + $pad), [float]($by + 4.0))
    
    return [float]($bw + 10.0)
}

[float]$badgeX = $tx
$badgeX += Draw-CyberBadge $gb $badgeX 278.0 "COGNITIVE FOCUS: ARMED" ([System.Drawing.Color]::FromArgb(255, 0, 255, 102))
$badgeX += Draw-CyberBadge $gb $badgeX 278.0 "FUNCTION / BLOCK SCOPE" ([System.Drawing.Color]::FromArgb(255, 0, 240, 255))
$badgeX += Draw-CyberBadge $gb $badgeX 278.0 "BUTTER-SMOOTH 60FPS" ([System.Drawing.Color]::FromArgb(255, 255, 0, 127))
$badgeX += Draw-CyberBadge $gb $badgeX 278.0 "ZERO VISUAL CLUTTER" ([System.Drawing.Color]::FromArgb(255, 255, 170, 0))

# Tech ruler line
$rulePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(50, 0, 240, 255), 1)
$gb.DrawLine($rulePen, $tx, 330.0, [float]($bWidth - 40), 330.0)

$coordFont = New-Object System.Drawing.Font("Consolas", 8, [System.Drawing.FontStyle]::Regular)
$coordBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(120, 100, 130, 160))
$gb.DrawString("NEUROFOCUS PROTOCOL // OPTICAL ISOLATION: ACTIVE // REPRESS VISUAL BRAIN FATIGUE", $coordFont, $coordBrush, $tx, 342.0)

$bannerBmp.Save("assets/banner.png", [System.Drawing.Imaging.ImageFormat]::Png)
$gb.Dispose()
$bannerBmp.Dispose()
Write-Output "SUCCESS: Generated assets/banner.png (1200x420)"
