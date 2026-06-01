# Leer datos del Excel (voluminosa)
$voluminosa = @{}
$excelLines = Get-Content 'C:\Users\pichi\excel_voluminosa.csv' -Encoding UTF8
foreach ($line in $excelLines[1..($excelLines.Count-1)]) {
    $parts = $line -split ';'
    if ($parts.Count -ge 3) {
        # Normalizar CP a 5 digitos con cero a la izquierda
        $cp = $parts[0].Trim().PadLeft(5,'0')
        $dia = $parts[2].Trim()
        $voluminosa[$cp] = $dia
    }
}
Write-Host "CPs en Excel: $($voluminosa.Count)"

# Leer CSV de zonas
$zonaLines = Get-Content 'C:\Users\pichi\extremadura_zonas_tarifa.csv' -Encoding UTF8
$output = [System.Collections.Generic.List[string]]::new()

# Nueva cabecera con columna de dia
$cabecera = $zonaLines[0] + ';Día Reparto (Voluminosa)'
$output.Add($cabecera)

$matches = 0
$noMatch = 0

foreach ($line in $zonaLines[1..($zonaLines.Count-1)]) {
    if ($line.Trim() -eq '') { continue }
    $parts = $line -split ';'
    if ($parts.Count -lt 3) { continue }

    # Normalizar CP del CSV a 5 digitos
    $cp = $parts[2].Trim().PadLeft(5,'0')

    if ($voluminosa.ContainsKey($cp)) {
        $dia = $voluminosa[$cp]
        $matches++
    } else {
        $dia = '-'
        $noMatch++
    }
    $output.Add($line + ';' + $dia)
}

[System.IO.File]::WriteAllLines(
    'C:\Users\pichi\extremadura_zonas_completo.csv',
    $output,
    [System.Text.UTF8Encoding]::new($false)
)

Write-Host "Total filas: $($output.Count - 1)"
Write-Host "Con dia de reparto: $matches"
Write-Host "Sin correspondencia: $noMatch"

# Estadisticas por zona + dia
Write-Host "`n--- Muestra de filas con dia ---"
$count = 0
foreach ($line in $output[1..30]) {
    $p = $line -split ';'
    if ($p.Count -ge 9 -and $p[8] -ne '-') {
        Write-Host "$($p[2].PadLeft(5,'0')) | $($p[1].PadRight(30)) | Zona $($p[4]) | $($p[8])"
        $count++
        if ($count -ge 12) { break }
    }
}
