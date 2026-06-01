$lines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
$out = [System.Collections.Generic.List[string]]::new()
$out.Add('Provincia;Municipio;CP;Distancia (km);Zona;Tarifa Total;Dia Reparto')
foreach ($line in $lines[1..($lines.Count-1)]) {
    $p = $line -split ';'
    if ($p.Count -ge 9 -and $p[8].Trim() -eq 'SIN DATO') {
        $out.Add("$($p[0]);$($p[1]);$($p[2]);$($p[3]);$($p[4]);$($p[7]);")
    }
}
[System.IO.File]::WriteAllLines('C:\Users\pichi\municipios_sin_dia.csv', $out, [System.Text.UTF8Encoding]::new($false))
Write-Host "Generado municipios_sin_dia.csv con $($out.Count - 1) entradas"
