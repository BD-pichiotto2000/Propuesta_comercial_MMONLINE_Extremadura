function Expandir-Dia($abrev) {
    $d = $abrev.Trim().ToUpper()

    # Mapeo de abreviaturas a nombres completos
    $map = @{
        'L-M-X-J-V' = 'LUNES A VIERNES'
        'L-M-X-J'   = 'LUNES, MARTES, MIERCOLES Y JUEVES'
        'L-X-V'     = 'LUNES, MIERCOLES Y VIERNES'
        'L-M-J'     = 'LUNES, MARTES Y JUEVES'
        'L-J-V'     = 'LUNES, JUEVES Y VIERNES'
        'M-J-V'     = 'MARTES, JUEVES Y VIERNES'
        'L-M-V'     = 'LUNES, MARTES Y VIERNES'
        'X-J-V'     = 'MIERCOLES, JUEVES Y VIERNES'
        'M-X-J'     = 'MARTES, MIERCOLES Y JUEVES'
        'L-M-X'     = 'LUNES, MARTES Y MIERCOLES'
        'L-M'       = 'LUNES Y MARTES'
        'L-X'       = 'LUNES Y MIERCOLES'
        'L-J'       = 'LUNES Y JUEVES'
        'L-V'       = 'LUNES Y VIERNES'
        'M-X'       = 'MARTES Y MIERCOLES'
        'M-J'       = 'MARTES Y JUEVES'
        'M-V'       = 'MARTES Y VIERNES'
        'X-J'       = 'MIERCOLES Y JUEVES'
        'X-V'       = 'MIERCOLES Y VIERNES'
        'J-V'       = 'JUEVES Y VIERNES'
        'L'         = 'LUNES'
        'M'         = 'MARTES'
        'X'         = 'MIERCOLES'
        'J'         = 'JUEVES'
        'V'         = 'VIERNES'
        ''          = 'SIN DATO'
        '-'         = 'SIN DATO'
    }

    if ($map.ContainsKey($d)) { return $map[$d] }
    # Si ya viene como texto completo, normalizarlo
    $d = $d -replace "MI.RCOLES", "MIERCOLES"
    return $d
}

# Cargar datos del fichero devuelto
$nuevos = @{}
$sinDatoLines = [System.IO.File]::ReadAllLines('C:\Users\pichi\cp_sin_dato.csv')
$actualizados = 0
$vacios = 0

foreach ($line in $sinDatoLines[1..($sinDatoLines.Count-1)]) {
    $p = $line -split ';'
    if ($p.Count -ge 6) {
        $cp  = $p[2].Trim().PadLeft(5,'0')
        $dia = $p[5].Trim()
        if ($dia -ne '' -and $dia -ne '-') {
            $nuevos[$cp] = Expandir-Dia $dia
            $actualizados++
        } else {
            $vacios++
        }
    }
}
Write-Host "CPs con dia nuevo: $actualizados  |  Sin rellenar: $vacios"

# Cargar CSV principal y actualizar
$mainLines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
$output = [System.Collections.Generic.List[string]]::new()
$output.Add($mainLines[0])  # cabecera

$fusionados = 0
foreach ($line in $mainLines[1..($mainLines.Count-1)]) {
    if ($line.Trim() -eq '') { continue }
    $p = $line -split ';'
    $cp = $p[2].Trim().PadLeft(5,'0')

    if ($nuevos.ContainsKey($cp) -and ($p[8].Trim() -eq 'SIN DATO' -or $p[8].Trim() -eq '-' -or $p[8].Trim() -eq '')) {
        $p[8] = $nuevos[$cp]
        $output.Add($p -join ';')
        $fusionados++
    } else {
        $output.Add($line)
    }
}

[System.IO.File]::WriteAllLines('C:\Users\pichi\extremadura_zonas_completo.csv', $output, [System.Text.UTF8Encoding]::new($false))
Write-Host "Filas actualizadas en CSV: $fusionados"
Write-Host "Total filas CSV: $($output.Count - 1)"

# Estadisticas finales
$dias = @{}; $sinDato = 0
foreach ($line in $output[1..($output.Count-1)]) {
    $p = $line -split ';'
    if ($p.Count -ge 9) {
        $dia = $p[8].Trim()
        if ($dia -eq 'SIN DATO' -or $dia -eq '' -or $dia -eq '-') { $sinDato++ }
        else {
            if (-not $dias.ContainsKey($dia)) { $dias[$dia] = 0 }
            $dias[$dia]++
        }
    }
}
Write-Host ""
Write-Host "=== DISTRIBUCION FINAL POR DIA ==="
$dias.GetEnumerator() | Sort-Object Name | ForEach-Object {
    Write-Host "  $($_.Key.PadRight(36)): $($_.Value) CPs"
}
Write-Host "  $('SIN DATO'.PadRight(36)): $sinDato CPs"
