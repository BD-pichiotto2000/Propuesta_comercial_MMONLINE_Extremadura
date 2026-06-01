# Actualizaciones de dias de reparto
$updates = @{
    'Trasierra'         = 'MIERCOLES'
    'Peraleda del Zaucejo' = 'MIERCOLES'
}
# Montemolin tiene varias entradas, todas = MIERCOLES
$updatesByMun = $updates

# === Actualizar CSV ===
$lines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
$out = [System.Collections.Generic.List[string]]::new()
$out.Add($lines[0])
$csvActualizado = 0

foreach ($line in $lines[1..($lines.Count-1)]) {
    $p = $line -split ';'
    if ($p.Count -lt 9) { $out.Add($line); continue }
    $mun = $p[1].Trim()
    $cp  = $p[2].Trim()
    $matched = $false

    # Trasierra y Peraleda del Zaucejo
    foreach ($k in $updatesByMun.Keys) {
        if ($mun -eq $k) {
            if ($p[8].Trim() -ne $updatesByMun[$k]) {
                $p[8] = $updatesByMun[$k]
                $csvActualizado++
            }
            $matched = $true
        }
    }
    # Montemolin - CPs: 06291, 06294, 06908 (sin acento)
    if ($mun -like '*ontemol*') {
        if ($p[8].Trim() -ne 'MIERCOLES') { $p[8] = 'MIERCOLES'; $csvActualizado++ }
    }
    # Valencia de Alcantara CP 10500
    if ($cp -eq '10500') {
        if ($p[8].Trim() -ne 'LUNES Y VIERNES') { $p[8] = 'LUNES Y VIERNES'; $csvActualizado++ }
    }
    $out.Add($p -join ';')
}

[System.IO.File]::WriteAllLines('C:\Users\pichi\extremadura_zonas_completo.csv', $out, [System.Text.UTF8Encoding]::new($false))
Write-Host "CSV: $csvActualizado filas actualizadas"

# === Actualizar HTML (cpDias) ===
$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')
$htmlMods = 0

# Obtener CPs de Trasierra, Peraleda del Zaucejo y Montemolin del CSV
$cpsTrasierra  = $out | Where-Object { ($_ -split ';')[1].Trim() -eq 'Trasierra' }      | ForEach-Object { ($_ -split ';')[2].Trim().PadLeft(5,'0') }
$cpsPeraleda   = $out | Where-Object { ($_ -split ';')[1].Trim() -eq 'Peraleda del Zaucejo' } | ForEach-Object { ($_ -split ';')[2].Trim().PadLeft(5,'0') }
$cpsMontemolin = $out | Where-Object { ($_ -split ';')[1].Trim() -like '*ontemol*' }    | ForEach-Object { ($_ -split ';')[2].Trim().PadLeft(5,'0') }
$cpsValencia   = @('10500')

function Update-CpDia($html, $cps, $newDia) {
    $count = 0
    foreach ($cp in $cps) {
        # Patron: '06291':'...'  ->  '06291':'MIERCOLES'
        $pattern = "('$cp'\s*:\s*')([^']*)(')";
        $m = [regex]::Match($html, $pattern)
        if ($m.Success -and $m.Groups[2].Value -ne $newDia) {
            $html = $html.Replace($m.Value, "$($m.Groups[1].Value)$newDia$($m.Groups[3].Value)")
            $count++
        }
    }
    return @{html=$html; count=$count}
}

$r = Update-CpDia $html $cpsTrasierra 'MIERCOLES'
$html = $r.html; $htmlMods += $r.count

$r = Update-CpDia $html $cpsPeraleda 'MIERCOLES'
$html = $r.html; $htmlMods += $r.count

$r = Update-CpDia $html $cpsMontemolin 'MIERCOLES'
$html = $r.html; $htmlMods += $r.count

$r = Update-CpDia $html $cpsValencia 'LUNES Y VIERNES'
$html = $r.html; $htmlMods += $r.count

# También actualizar campo dia: en el array municipios para Valencia de Alcantara
$html = $html -replace "(cp:'10500'[^\}]*dia:')[^']*(')","${1}LUNES Y VIERNES${2}"

[System.IO.File]::WriteAllText('C:\Users\pichi\extremadura_mapa_zonas.html', $html, [System.Text.UTF8Encoding]::new($false))
Write-Host "HTML cpDias: $htmlMods entradas actualizadas"

# Mostrar CPs encontrados
Write-Host "CPs Trasierra: $($cpsTrasierra -join ', ')"
Write-Host "CPs Peraleda del Zaucejo: $($cpsPeraleda -join ', ')"
Write-Host "CPs Montemolin: $($cpsMontemolin -join ', ')"
