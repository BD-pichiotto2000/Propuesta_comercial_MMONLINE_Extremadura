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
        $data += $mun
        $row++
    }
    $wb.Close($false)
    return $data
}

$munBad = Read-Municipios 'C:\Users\pichi\Downloads\11codmun06.xls'
$munCac = Read-Municipios 'C:\Users\pichi\Downloads\11codmun10.xls'
$excel.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null

# Normalizar: quitar acentos, ü->u, guion->espacio, "X, La"->"La X"
function Norm($s) {
    $r = $s
    # Invertir formato "X, La/El/Los/Las" -> "La/El/Los/Las X"
    if ($r -match '^(.+),\s+(La|El|Los|Las|Lo)$') { $r = "$($Matches[2]) $($Matches[1])" }
    # Quitar acentos
    $r = $r.Replace([char]0x00E1,'a').Replace([char]0x00E9,'e').Replace([char]0x00ED,'i').Replace([char]0x00F3,'o').Replace([char]0x00FA,'u')
    $r = $r.Replace([char]0x00C1,'A').Replace([char]0x00C9,'E').Replace([char]0x00CD,'I').Replace([char]0x00D3,'O').Replace([char]0x00DA,'U')
    $r = $r.Replace([char]0x00F1,'n').Replace([char]0x00D1,'N')
    # u-umlaut -> u
    $r = $r.Replace([char]0x00FC,'u').Replace([char]0x00DC,'U')
    # Guiones -> espacio
    $r = $r -replace '-', ' '
    # Multiple spaces -> one
    $r = $r -replace '\s+', ' '
    return $r.Trim().ToLower()
}

# Construir sets oficiales
$ofBad = @{}; foreach ($m in $munBad) { $ofBad[(Norm $m)] = $m }
$ofCac = @{}; foreach ($m in $munCac) { $ofCac[(Norm $m)] = $m }

Write-Host "Oficial Badajoz: $($ofBad.Count), Caceres: $($ofCac.Count)"

# === Filtrar CSV (rehacerlo desde el estado actual) ===
$lines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
$out   = [System.Collections.Generic.List[string]]::new()
$out.Add($lines[0])
$eliminados = 0; $conservados = 0

foreach ($line in $lines[1..($lines.Count-1)]) {
    $p = $line -split ';'
    if ($p.Count -lt 2) { continue }
    $prov = $p[0].Trim()
    $mun  = $p[1].Trim()
    $munN = Norm $mun

    $oficial = $false
    if ($prov -like '*adajoz*') {
        $oficial = $ofBad.ContainsKey($munN)
    } elseif ($prov -like '*aceres*' -or $prov -eq 'Caceres') {
        $oficial = $ofCac.ContainsKey($munN)
    }

    if ($oficial) {
        # Actualizar nombre a la forma oficial (sin INE format)
        $nombreOficial = if ($prov -like '*adajoz*') { $ofBad[$munN] } else { $ofCac[$munN] }
        # Convertir "X, La" -> "La X" en el nombre oficial si aplica
        if ($nombreOficial -match '^(.+),\s+(La|El|Los|Las|Lo)$') {
            $nombreOficial = "$($Matches[2]) $($Matches[1])"
        }
        # Reemplazar el nombre en la línea
        if ($nombreOficial -ne $mun -and $mun -ne 'Badajoz' -and $mun -ne 'Caceres') {
            $p[1] = $nombreOficial
        }
        $out.Add($p -join ';')
        $conservados++
    } else {
        Write-Host "  ELIMINAR: $prov | $mun"
        $eliminados++
    }
}

[System.IO.File]::WriteAllLines('C:\Users\pichi\extremadura_zonas_completo.csv', $out, [System.Text.UTF8Encoding]::new($false))
Write-Host ""
Write-Host "CSV: $eliminados eliminados, $conservados conservados"

# === Filtrar HTML ===
$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')
$startIdx = $html.IndexOf('const municipios = [')
$endIdx   = $html.IndexOf('];', $startIdx)
$bloque   = $html.Substring($startIdx + 'const municipios = ['.Length, $endIdx - $startIdx - 'const municipios = ['.Length)

$pat      = '\{prov:''([^'']+)'',\s+mun:''([^'']+)'',\s+cp:''[^'']*''[^\}]*\}'
$matches2 = [regex]::Matches($bloque, $pat)
Write-Host ""
Write-Host "HTML: $($matches2.Count) entradas antes de filtrar"

$htmlBloqueNuevo = $bloque
$htmlEliminados = 0

foreach ($m in $matches2) {
    $prov = $m.Groups[1].Value
    $mun  = $m.Groups[2].Value
    $munN = Norm $mun

    $oficial = $false
    if ($prov -like '*adajoz*') { $oficial = $ofBad.ContainsKey($munN) }
    else { $oficial = $ofCac.ContainsKey($munN) }

    if (-not $oficial) {
        $entryEscaped = [regex]::Escape($m.Value)
        $htmlBloqueNuevo = [regex]::Replace($htmlBloqueNuevo, "\s*$entryEscaped,?", '')
        $htmlEliminados++
    }
}

$htmlNuevo = $html.Substring(0, $startIdx) + 'const municipios = [' + $htmlBloqueNuevo + '];' + $html.Substring($endIdx + 2)
[System.IO.File]::WriteAllText('C:\Users\pichi\extremadura_mapa_zonas.html', $htmlNuevo, [System.Text.UTF8Encoding]::new($false))

$bloque2 = [regex]::Matches($htmlBloqueNuevo, "prov:'")
Write-Host "HTML: $htmlEliminados eliminados. Quedan $($bloque2.Count) entradas"
