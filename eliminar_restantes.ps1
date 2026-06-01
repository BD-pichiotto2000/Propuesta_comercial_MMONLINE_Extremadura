# Eliminar filas con esos CP que tengan SIN DATO (los que no existen)
$cpsInvalidos = @('10760','10139','10176')
# Para 10193 y 10162 solo los SIN DATO (Talavén LUNES y Casas de Don Antonio VIERNES se conservan)

$lines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
$out = [System.Collections.Generic.List[string]]::new()
$out.Add($lines[0])
$elim = 0

foreach ($line in $lines[1..($lines.Count-1)]) {
    $p = $line -split ';'
    if ($p.Count -lt 9) { $out.Add($line); continue }
    $cp  = $p[2].Trim()
    $dia = $p[8].Trim()

    $borrar = $false
    if ($cpsInvalidos -contains $cp) { $borrar = $true }
    if (($cp -eq '10193' -or $cp -eq '10162') -and $dia -eq 'SIN DATO') { $borrar = $true }

    if ($borrar) {
        Write-Host "  ELIMINAR: $($p[0]);$($p[1]);$cp"
        $elim++
    } else {
        $out.Add($line)
    }
}

[System.IO.File]::WriteAllLines('C:\Users\pichi\extremadura_zonas_completo.csv', $out, [System.Text.UTF8Encoding]::new($false))
Write-Host "Eliminados: $elim. Quedan: $($out.Count - 1)"

# === Limpiar HTML por CP ===
$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')
$startIdx = $html.IndexOf('const municipios = [')
$endIdx   = $html.IndexOf('];', $startIdx)
$bloque   = $html.Substring($startIdx + 'const municipios = ['.Length, $endIdx - $startIdx - 'const municipios = ['.Length)

$pat = "\{prov:'([^']+)',\s+mun:'([^']+)',\s+cp:'([^']*)'[^\}]*\}"
$matches2 = [regex]::Matches($bloque, $pat)
$bloqueNuevo = $bloque
$htmlElim = 0

$todosCps = @('10760','10139','10176')

foreach ($m in $matches2) {
    $cp = $m.Groups[3].Value
    # Para 10193 y 10162: solo eliminar Alagun del Rio, La Granja, Monroy, Pedroso de Acim
    $munNorm = $m.Groups[2].Value -replace [char]0x00F3,'o' -replace [char]0x00ED,'i' -replace [char]0x00E1,'a' -replace [char]0x00E9,'e' -replace [char]0x00FA,'u' -replace [char]0x00F1,'n'
    $munNorm = $munNorm.ToLower()

    $borrar = $false
    if ($todosCps -contains $cp) { $borrar = $true }
    if ($cp -eq '10193' -and ($munNorm -match 'alag|monroy')) { $borrar = $true }
    if ($cp -eq '10162' -and ($munNorm -match 'granja|pedroso')) { $borrar = $true }

    if ($borrar) {
        Write-Host "  HTML ELIMINAR: $($m.Groups[1].Value)|$($m.Groups[2].Value) cp:$cp"
        $entryEscaped = [regex]::Escape($m.Value)
        $bloqueNuevo = [regex]::Replace($bloqueNuevo, "\s*$entryEscaped,?", '')
        $htmlElim++
    }
}

$htmlNuevo = $html.Substring(0, $startIdx) + 'const municipios = [' + $bloqueNuevo + '];' + $html.Substring($endIdx + 2)
[System.IO.File]::WriteAllText('C:\Users\pichi\extremadura_mapa_zonas.html', $htmlNuevo, [System.Text.UTF8Encoding]::new($false))
$count = [regex]::Matches($bloqueNuevo, "prov:'").Count
Write-Host "HTML: $htmlElim eliminados. Quedan $count entradas"
