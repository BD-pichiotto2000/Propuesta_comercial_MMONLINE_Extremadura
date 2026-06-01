$oficial = @{}
$ofLines = [System.IO.File]::ReadAllLines('C:\Users\pichi\cp_oficial.csv')
foreach ($line in $ofLines[1..($ofLines.Count-1)]) {
    $p = $line -split ';'
    if ($p.Count -ge 2) { $oficial[$p[0].Trim()] = $p[1].Trim() }
}

$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')
$corregidos = 0

foreach ($cp in $oficial.Keys) {
    $munNuevo = $oficial[$cp] -replace "'", "\'"
    # Reemplazar mun:'cualquier cosa' cuando cp:'XXXXX' está en la misma línea {…}
    $pattern  = "(\{[^\}]*cp:'$cp'[^\}]*)mun:'([^']*)'"
    $matches  = [regex]::Matches($html, $pattern)
    foreach ($m in $matches) {
        $munViejo = $m.Groups[2].Value
        if ($munViejo -ne $munNuevo) {
            $nuevo = $m.Value -replace "mun:'[^']*'", "mun:'$munNuevo'"
            $html  = $html.Replace($m.Value, $nuevo)
            $corregidos++
        }
    }
    # También cubrir formato con cp antes de mun
    $pattern2 = "(mun:'[^']*'[^\}]*cp:'$cp')"
    $matches2 = [regex]::Matches($html, $pattern2)
    foreach ($m in $matches2) {
        $munViejo = [regex]::Match($m.Value, "mun:'([^']*)'").Groups[1].Value
        if ($munViejo -ne $munNuevo) {
            $nuevo = $m.Value -replace "mun:'[^']*'", "mun:'$munNuevo'"
            $html  = $html.Replace($m.Value, $nuevo)
            $corregidos++
        }
    }
}

[System.IO.File]::WriteAllText('C:\Users\pichi\extremadura_mapa_zonas.html', $html, [System.Text.UTF8Encoding]::new($false))
Write-Host "Entradas corregidas en mapa: $corregidos"
