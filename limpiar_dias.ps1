$lines = Get-Content "C:\Users\pichi\extremadura_zonas_completo.csv" -Encoding UTF8

function Normalizar-Dia($dia) {
    $d = $dia.Trim().ToUpper()
    # Normalizar variantes de MIERCOLES
    $d = $d -replace "MI.RCOLES", "MIERCOLES"
    $d = $d -replace "MIE?RCOLES", "MIERCOLES"
    # Normalizar LUNES TODOS -> LUNES (L-V)
    $d = $d -replace "LUNES TODOS", "LUNES (L-V)"
    $d = $d -replace "TODOS LOS DIAS", "LUNES A VIERNES"
    # Separadores consistentes
    $d = $d -replace " Y ", ", "
    $d = $d -replace "MARTES, JUEVES", "MARTES Y JUEVES"
    $d = $d -replace "LUNES, JUEVES, VIERNES", "LUNES, JUEVES Y VIERNES"
    # --- = sin dato
    $d = $d -replace "^-{1,3}$", "SIN DATO"
    $d = $d -replace "^$", "SIN DATO"
    return $d
}

$output = [System.Collections.Generic.List[string]]::new()
# Nueva cabecera con tildes correctas via encoding
$output.Add("Provincia;Municipio;Codigo Postal;Distancia (km);Zona;Tarifa Base (EUR);IVA 21% (EUR);Tarifa Total (EUR);Dia Reparto (Voluminosa)")

foreach ($line in $lines[1..($lines.Count-1)]) {
    if ($line.Trim() -eq "") { continue }
    $p = $line -split ";"
    if ($p.Count -lt 9) {
        # Lineas que vinieron del CSV original sin dia
        $output.Add($line + ";SIN DATO")
        continue
    }
    $diaOriginal = $p[8]
    $diaNorm = Normalizar-Dia $diaOriginal
    $p[8] = $diaNorm
    $output.Add($p -join ";")
}

[System.IO.File]::WriteAllLines("C:\Users\pichi\extremadura_zonas_completo.csv", $output, [System.Text.UTF8Encoding]::new($false))
Write-Host "CSV final limpio: $($output.Count - 1) filas"

# Resumen por dia
$dias = @{}
foreach ($line in $output[1..($output.Count-1)]) {
    $p = $line -split ";"
    if ($p.Count -ge 9) {
        $dia = $p[8].Trim()
        if (-not $dias.ContainsKey($dia)) { $dias[$dia] = 0 }
        $dias[$dia]++
    }
}
Write-Host ""
Write-Host "Distribucion final por dia:"
$dias.GetEnumerator() | Sort-Object Name | ForEach-Object {
    Write-Host "  $($_.Key.PadRight(30)): $($_.Value)"
}
