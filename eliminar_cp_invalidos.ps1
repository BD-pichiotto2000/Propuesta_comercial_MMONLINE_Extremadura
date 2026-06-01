# Municipios a eliminar (CP duplicados - los que NO existen)
$eliminar = @(
    'Caceres|Villanueva de la Sierra',
    'Caceres|Navalvillar de Ibor',
    'Caceres|Caba' + [char]0x00F1 + 'as del Castillo',
    'Caceres|Alag' + [char]0x00F3 + 'n del R' + [char]0x00ED + 'o',
    'Caceres|La Granja',
    'Caceres|Monroy',
    'Caceres|Pedroso de Acim',
    'Badajoz|Almendral'
)

# Normalizar clave prov|mun
function Key($prov, $mun) { return "$prov|$mun" }

# === Limpiar CSV ===
$lines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
$out = [System.Collections.Generic.List[string]]::new()
$out.Add($lines[0])
$csvElim = 0

foreach ($line in $lines[1..($lines.Count-1)]) {
    $p = $line -split ';'
    if ($p.Count -lt 2) { continue }
    $k = Key $p[0].Trim() $p[1].Trim()
    if ($eliminar -contains $k) {
        Write-Host "  CSV ELIMINAR: $k"
        $csvElim++
    } else {
        $out.Add($line)
    }
}
[System.IO.File]::WriteAllLines('C:\Users\pichi\extremadura_zonas_completo.csv', $out, [System.Text.UTF8Encoding]::new($false))
Write-Host "CSV: $csvElim eliminados. Quedan $($out.Count - 1)"

# === Limpiar HTML ===
$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')
$startIdx = $html.IndexOf('const municipios = [')
$endIdx   = $html.IndexOf('];', $startIdx)
$bloque   = $html.Substring($startIdx + 'const municipios = ['.Length, $endIdx - $startIdx - 'const municipios = ['.Length)

$pat = "\{prov:'([^']+)',\s+mun:'([^']+)',\s+cp:'[^']*'[^\}]*\}"
$matches2 = [regex]::Matches($bloque, $pat)
$bloqueNuevo = $bloque
$htmlElim = 0

foreach ($m in $matches2) {
    $k = Key $m.Groups[1].Value $m.Groups[2].Value
    if ($eliminar -contains $k) {
        Write-Host "  HTML ELIMINAR: $k"
        $entryEscaped = [regex]::Escape($m.Value)
        $bloqueNuevo = [regex]::Replace($bloqueNuevo, "\s*$entryEscaped,?", '')
        $htmlElim++
    }
}

$htmlNuevo = $html.Substring(0, $startIdx) + 'const municipios = [' + $bloqueNuevo + '];' + $html.Substring($endIdx + 2)
[System.IO.File]::WriteAllText('C:\Users\pichi\extremadura_mapa_zonas.html', $htmlNuevo, [System.Text.UTF8Encoding]::new($false))

$count = [regex]::Matches($bloqueNuevo, "prov:'").Count
Write-Host "HTML: $htmlElim eliminados. Quedan $count entradas"
