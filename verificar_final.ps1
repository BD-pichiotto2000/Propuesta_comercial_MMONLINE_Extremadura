$lines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
Write-Host "CSV total filas: $($lines.Count - 1)"

$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')
$msHtml = [regex]::Matches($html, "prov:'")
Write-Host "HTML entradas municipios: $($msHtml.Count)"

# Verificar algunos de los nuevos
$test = @('10748','10857','10650','06329','06439')
foreach ($cp in $test) {
    $found = $lines | Where-Object { ($_ -split ';')[2].Trim() -eq ($cp -replace '^0+','') }
    if ($found) {
        $p = $found[0] -split ';'
        Write-Host "CSV $cp : $($p[1]) - Zona $($p[4]) - Dist $($p[3])km - $($p[8])"
    }
    $idx = $html.IndexOf("cp:'$cp'")
    if ($idx -ge 0) {
        $start = $html.LastIndexOf('{', $idx)
        $end = $html.IndexOf('}', $idx)
        $obj = $html.Substring($start, $end - $start + 1)
        $m = [regex]::Match($obj, "mun:'([^']+)'")
        Write-Host "HTML $cp : $($m.Groups[1].Value)"
    } else {
        Write-Host "HTML $cp : NO ENCONTRADO"
    }
}

# CPs sin dato restantes
$sinDato = $lines | Where-Object { $_ -match 'SIN DATO' }
Write-Host ""
Write-Host "CPs con SIN DATO en CSV: $($sinDato.Count)"
