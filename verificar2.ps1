# Verificar correcciones en CSV (CPs sin cero inicial)
$lines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
Write-Host "=== VERIFICACION CSV ==="
Write-Host "Total filas: $($lines.Count - 1)"

$check = @('6110','6450','6750','6770','6870','6680','10710','10850','10891')
foreach ($cp in $check) {
    $found = $lines | Where-Object { $_.Split(';').Count -ge 3 -and $_.Split(';')[2].Trim() -eq $cp }
    if ($found) {
        $p = $found.Split(';')
        Write-Host "  $cp -> $($p[1]) | $($p[0])"
    } else {
        Write-Host "  $cp -> NO ENCONTRADO"
    }
}

# Verificar HTML con regex correcta (mun viene antes de cp)
$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')
Write-Host ""
Write-Host "=== VERIFICACION HTML ==="
$checkHtml = @('06110','06450','06750','06770','06870','06680','10710','10850','10891')
foreach ($cp in $checkHtml) {
    # Buscar objeto completo que contenga este cp
    $m = [regex]::Match($html, "\{[^\}]*cp:'$cp'[^\}]*\}")
    if (-not $m.Success) {
        # Intentar buscar sin restriccion de orden
        $idx = $html.IndexOf("cp:'$cp'")
        if ($idx -ge 0) {
            $start = $html.LastIndexOf('{', $idx)
            $end = $html.IndexOf('}', $idx)
            if ($start -ge 0 -and $end -ge 0) {
                $obj = $html.Substring($start, $end - $start + 1)
                $munM = [regex]::Match($obj, "mun:'([^']*)'")
                Write-Host "  $cp -> $($munM.Groups[1].Value)"
            }
        } else {
            Write-Host "  $cp -> NO EN HTML"
        }
    } else {
        $munM = [regex]::Match($m.Value, "mun:'([^']*)'")
        Write-Host "  $cp -> $($munM.Groups[1].Value)"
    }
}

Write-Host ""
Write-Host "=== CPs con SIN DATO en CSV ==="
$sinDato = $lines | Where-Object { $_ -match 'SIN DATO' }
Write-Host "Count: $($sinDato.Count)"
foreach ($l in $sinDato) {
    $p = $l.Split(';')
    Write-Host "  $($p[2]) $($p[1])"
}
