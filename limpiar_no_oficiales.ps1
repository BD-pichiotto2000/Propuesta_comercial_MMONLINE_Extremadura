$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false; $excel.DisplayAlerts = $false

function Read-Municipios($path) {
    $wb = $excel.Workbooks.Open($path)
    $ws = $wb.Sheets.Item(1)
    $data = @()
    $row = 4
    while ($row -le 500) {
        $mun = $ws.Cells.Item($row, 4).Text.Trim()
        if ([string]::IsNullOrWhiteSpace($mun)) { break }
        # Convertir "Albuera, La" -> "La Albuera"
        if ($mun -match '^(.+),\s+(.+)$') { $mun = "$($Matches[2]) $($Matches[1])" }
        $data += $mun
        $row++
    }
    $wb.Close($false)
    return $data
}

Write-Host "Leyendo ficheros oficiales..."
$munCac = Read-Municipios 'C:\Users\pichi\Downloads\11codmun10.xls'
$munBad = Read-Municipios 'C:\Users\pichi\Downloads\11codmun06.xls'
$excel.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null

Write-Host "Municipios oficiales - Caceres: $($munCac.Count), Badajoz: $($munBad.Count)"

function Strip($s) {
    $r = $s
    $r = $r.Replace([char]0x00E1,'a').Replace([char]0x00E9,'e').Replace([char]0x00ED,'i').Replace([char]0x00F3,'o').Replace([char]0x00FA,'u')
    $r = $r.Replace([char]0x00C1,'A').Replace([char]0x00C9,'E').Replace([char]0x00CD,'I').Replace([char]0x00D3,'O').Replace([char]0x00DA,'U')
    $r = $r.Replace([char]0x00F1,'n').Replace([char]0x00D1,'N')
    return $r
}

# Normalizar listas oficiales
$ofCac = @{}; foreach ($m in $munCac) { $ofCac[(Strip $m).ToLower()] = $m }
$ofBad = @{}; foreach ($m in $munBad) { $ofBad[(Strip $m).ToLower()] = $m }

# === Filtrar CSV ===
$lines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
$out   = [System.Collections.Generic.List[string]]::new()
$out.Add($lines[0])
$eliminados = 0
$conservados = 0

foreach ($line in $lines[1..($lines.Count-1)]) {
    $p = $line -split ';'
    if ($p.Count -lt 2) { continue }
    $prov = $p[0].Trim()
    $mun  = $p[1].Trim()
    $munN = (Strip $mun).ToLower()

    $oficial = $false
    if ($prov -like '*adajoz*') {
        $oficial = $ofBad.ContainsKey($munN)
    } elseif ($prov -like '*aceres*' -or $prov -eq 'Caceres') {
        $oficial = $ofCac.ContainsKey($munN)
    }

    if ($oficial) {
        $out.Add($line)
        $conservados++
    } else {
        Write-Host "  ELIMINAR: $prov | $mun"
        $eliminados++
    }
}

[System.IO.File]::WriteAllLines('C:\Users\pichi\extremadura_zonas_completo.csv', $out, [System.Text.UTF8Encoding]::new($false))
Write-Host ""
Write-Host "CSV: $eliminados eliminados, $conservados conservados. Total: $conservados"

# === Filtrar HTML ===
$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')
$startIdx = $html.IndexOf('const municipios = [')
$endIdx   = $html.IndexOf('];', $startIdx)

$bloque = $html.Substring($startIdx + 'const municipios = ['.Length, $endIdx - $startIdx - 'const municipios = ['.Length)

# Parsear entradas individuales
$pat = '\{prov:''([^'']+)'',\s+mun:''([^'']+)'',\s+cp:''[^'']*''[^\}]*\}'
$matches2 = [regex]::Matches($bloque, $pat)
Write-Host ""
Write-Host "HTML: $($matches2.Count) entradas antes de filtrar"

$htmlEliminados = 0
$htmlBloqueNuevo = $bloque

foreach ($m in $matches2) {
    $prov = $m.Groups[1].Value
    $mun  = $m.Groups[2].Value
    $munN = (Strip $mun).ToLower()

    $oficial = $false
    if ($prov -like '*adajoz*') {
        $oficial = $ofBad.ContainsKey($munN)
    } else {
        $oficial = $ofCac.ContainsKey($munN)
    }

    if (-not $oficial) {
        # Eliminar esta entrada del bloque (con posible coma y newline)
        $entryEscaped = [regex]::Escape($m.Value)
        $htmlBloqueNuevo = [regex]::Replace($htmlBloqueNuevo, "\s*$entryEscaped,?", '')
        $htmlEliminados++
    }
}

$htmlNuevo = $html.Substring(0, $startIdx) + 'const municipios = [' + $htmlBloqueNuevo + '];' + $html.Substring($endIdx + 2)

# Tambien limpiar cpDias de CPs eliminados (opcional, no es critico)
[System.IO.File]::WriteAllText('C:\Users\pichi\extremadura_mapa_zonas.html', $htmlNuevo, [System.Text.UTF8Encoding]::new($false))

$bloque2 = [regex]::Matches($htmlBloqueNuevo, "prov:'")
Write-Host "HTML: $htmlEliminados eliminados. Quedan $($bloque2.Count) entradas"
