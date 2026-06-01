$lines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
$output = [System.Collections.Generic.List[string]]::new()
$output.Add('Provincia;Municipio;Codigo Postal;Distancia (km);Zona;Dia Reparto (Voluminosa)')

foreach ($line in $lines[1..($lines.Count-1)]) {
    $p = $line -split ';'
    if ($p.Count -ge 9) {
        $dia = $p[8].Trim()
        if ($dia -eq 'SIN DATO' -or $dia -eq '-' -or $dia -eq '') {
            $output.Add("$($p[0]);$($p[1]);$($p[2]);$($p[3]);$($p[4]);")
        }
    }
}

[System.IO.File]::WriteAllLines('C:\Users\pichi\cp_sin_dato.csv', $output, [System.Text.UTF8Encoding]::new($false))
Write-Host "CPs sin dato exportados: $($output.Count - 1)"
