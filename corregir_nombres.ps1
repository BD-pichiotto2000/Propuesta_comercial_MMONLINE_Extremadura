# Cargar datos oficiales CP -> Municipio
$oficial = @{}
$ofLines = [System.IO.File]::ReadAllLines('C:\Users\pichi\cp_oficial.csv')
foreach ($line in $ofLines[1..($ofLines.Count-1)]) {
    $p = $line -split ';'
    if ($p.Count -ge 2) { $oficial[$p[0].Trim()] = $p[1].Trim() }
}

# Corregir CSV principal
$lines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
$out   = [System.Collections.Generic.List[string]]::new()
$out.Add($lines[0])
$corregidos = 0; $noEncontrados = 0

foreach ($line in $lines[1..($lines.Count-1)]) {
    $p = $line -split ';'
    if ($p.Count -lt 3) { $out.Add($line); continue }
    $cp     = $p[2].Trim().PadLeft(5,'0')
    $munAnt = $p[1].Trim()
    if ($oficial.ContainsKey($cp)) {
        $munNuevo = $oficial[$cp]
        if ($munNuevo -ne $munAnt) {
            Write-Host "  $cp : '$munAnt' -> '$munNuevo'"
            $p[1] = $munNuevo
            $corregidos++
        }
        $out.Add($p -join ';')
    } else {
        $out.Add($line)
        $noEncontrados++
    }
}

[System.IO.File]::WriteAllLines('C:\Users\pichi\extremadura_zonas_completo.csv', $out, [System.Text.UTF8Encoding]::new($false))
Write-Host ""
Write-Host "Municipios corregidos : $corregidos"
Write-Host "CPs no en oficial     : $noEncontrados"
Write-Host "Total filas           : $($out.Count - 1)"
