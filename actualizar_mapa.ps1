# Leer CSV y construir lookup CP -> dia
$lines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
$lookup = @{}
foreach ($line in $lines[1..($lines.Count-1)]) {
    $p = $line -split ';'
    if ($p.Count -ge 9) {
        $cp  = $p[2].Trim().PadLeft(5,'0')
        $dia = $p[8].Trim()
        if ($dia -ne '') { $lookup[$cp] = $dia }
    }
}

# Construir bloque JS
$jsLines = [System.Collections.Generic.List[string]]::new()
$jsLines.Add('const cpDias = {')
foreach ($cp in ($lookup.Keys | Sort-Object)) {
    $dia = $lookup[$cp] -replace "'", "\'"
    $jsLines.Add("  '$cp':'$dia',")
}
$jsLines.Add('};')
$jsBlock = $jsLines -join "`n"

# Leer HTML como lineas
$html = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_mapa_zonas.html')
$out  = [System.Collections.Generic.List[string]]::new()

$inserted = $false
foreach ($line in $html) {
    # Insertar lookup justo antes de la primera linea de datos (const municipios)
    if (-not $inserted -and $line -match 'const municipios = \[') {
        $out.Add($jsBlock)
        $out.Add('')
        $inserted = $true
    }
    $out.Add($line)
}

# Ahora actualizar el campo dia en cada entrada del array municipios
# Reemplazar , dia:'CUALQUIER COSA'} o sin dia por el valor del lookup
$finalHtml = ($out -join "`n")

# Para cada CP conocido, reemplazar el campo dia en la linea correspondiente
foreach ($cp in $lookup.Keys) {
    $dia = $lookup[$cp] -replace "'", "\'"
    $cpPat5    = $cp
    $cpPatNoZ  = $cp.TrimStart('0')
    foreach ($cpPat in @($cpPat5, $cpPatNoZ)) {
        # Reemplazar: cp:'XXXXX',...,dia:'OLD'
        $finalHtml = [regex]::Replace($finalHtml,
            "(?<=cp:'$cpPat'[^}]{0,200})dia:'[^']*'",
            "dia:'$dia'")
    }
}

[System.IO.File]::WriteAllText(
    'C:\Users\pichi\extremadura_mapa_zonas.html',
    $finalHtml,
    [System.Text.UTF8Encoding]::new($false)
)
Write-Host "OK - CPs en lookup: $($lookup.Count)"
Write-Host "cpDias insertado: $inserted"
