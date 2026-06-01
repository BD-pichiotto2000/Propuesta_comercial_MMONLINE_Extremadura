function Get-Zona([int]$km) {
    if     ($km -le 25)  { return "A" }
    elseif ($km -le 50)  { return "B" }
    elseif ($km -le 75)  { return "C" }
    elseif ($km -le 120) { return "D" }
    elseif ($km -le 160) { return "E" }
    elseif ($km -le 200) { return "F" }
    elseif ($km -le 250) { return "G" }
    else                  { return "H" }
}
function Get-Precio($zona) {
    switch ($zona) {
        "A" { return @{base=25; iva="5,25";  total="30,25"} }
        "B" { return @{base=28; iva="5,88";  total="33,88"} }
        "C" { return @{base=31; iva="6,51";  total="37,51"} }
        "D" { return @{base=34; iva="7,14";  total="41,14"} }
        "E" { return @{base=37; iva="7,77";  total="44,77"} }
        "F" { return @{base=40; iva="8,40";  total="48,40"} }
        "G" { return @{base=43; iva="9,03";  total="52,03"} }
        "H" { return @{base=45; iva="9,45";  total="54,45"} }
    }
}

$excelData = @{}
$excelLines = Get-Content "C:\Users\pichi\excel_completo.csv" -Encoding UTF8
foreach ($line in $excelLines[1..($excelLines.Count-1)]) {
    $p = $line -split ";"
    if ($p.Count -ge 4) {
        $cp = $p[0].Trim()
        $excelData[$cp] = @{pob=$p[1].Trim(); km=$p[2].Trim(); dia=$p[3].Trim()}
    }
}
Write-Host "CPs en Excel: $($excelData.Count)"

$zonaLines = Get-Content "C:\Users\pichi\extremadura_zonas_tarifa.csv" -Encoding UTF8
$cpEnZonas = @{}
foreach ($line in $zonaLines[1..($zonaLines.Count-1)]) {
    $p = $line -split ";"
    if ($p.Count -ge 3) { $cpEnZonas[$p[2].Trim().PadLeft(5,"0")] = $true }
}

$output = [System.Collections.Generic.List[string]]::new()
$output.Add("Provincia;Municipio;Codigo Postal;Distancia km;Zona;Tarifa Base;IVA 21pct;Tarifa Total;Dia Reparto Voluminosa")

foreach ($line in $zonaLines[1..($zonaLines.Count-1)]) {
    if ($line.Trim() -eq "") { continue }
    $p = $line -split ";"
    if ($p.Count -lt 3) { continue }
    $cp = $p[2].Trim().PadLeft(5,"0")
    $dia = if ($excelData.ContainsKey($cp)) { $excelData[$cp].dia } else { "-" }
    $output.Add($line + ";" + $dia)
}

$nuevos = 0
foreach ($cp in ($excelData.Keys | Sort-Object)) {
    if ($cpEnZonas.ContainsKey($cp)) { continue }
    if (-not ($cp.StartsWith("06") -or $cp.StartsWith("10"))) { continue }
    $cpNum = [int]$cp
    if ($cpNum -ge 6030 -and $cpNum -le 6050) { continue }
    $d = $excelData[$cp]
    $kmStr = $d.km
    $kmVal = 0
    if ($kmStr -match "^\d+") { $kmVal = [int]$kmStr }
    if ($kmVal -eq 0) { continue }
    $zona = Get-Zona $kmVal
    $precio = Get-Precio $zona
    $prov = if ($cp.StartsWith("06")) { "Badajoz" } else { "Caceres" }
    $newline = "$prov;$($d.pob);$cp;$kmVal;$zona;$($precio.base);$($precio.iva);$($precio.total);$($d.dia)"
    $output.Add($newline)
    $nuevos++
}

[System.IO.File]::WriteAllLines("C:\Users\pichi\extremadura_zonas_completo.csv", $output, [System.Text.UTF8Encoding]::new($false))
Write-Host "Filas base CSV: $($zonaLines.Count - 1)"
Write-Host "CPs nuevos del Excel: $nuevos"
Write-Host "Total final: $($output.Count - 1)"

$dias = @{}
$sinDia = 0
foreach ($line in $output[1..($output.Count-1)]) {
    $p = $line -split ";"
    if ($p.Count -ge 9) {
        $dia = $p[8].Trim().ToUpper()
        if ($dia -eq "-" -or $dia -eq "") { $sinDia++ }
        else {
            if (-not $dias.ContainsKey($dia)) { $dias[$dia] = 0 }
            $dias[$dia]++
        }
    }
}
Write-Host ""
Write-Host "--- Dias de reparto (Voluminosa) ---"
$dias.GetEnumerator() | Sort-Object Name | ForEach-Object {
    Write-Host "  $($_.Key.PadRight(36)): $($_.Value) CPs"
}
Write-Host "  Sin dato de reparto: $sinDia CPs"
