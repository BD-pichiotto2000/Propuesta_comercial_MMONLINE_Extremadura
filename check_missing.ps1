# CPs en Excel
$voluminosa = @{}
$excelLines = Get-Content 'C:\Users\pichi\excel_voluminosa.csv' -Encoding UTF8
foreach ($line in $excelLines[1..($excelLines.Count-1)]) {
    $parts = $line -split ';'
    if ($parts.Count -ge 3) {
        $cp = $parts[0].Trim().PadLeft(5,'0')
        $pob = $parts[1].Trim()
        $dia = $parts[2].Trim()
        $voluminosa[$cp] = @{pob=$pob; dia=$dia}
    }
}

# CPs en CSV zonas
$zonaCPs = @{}
$zonaLines = Get-Content 'C:\Users\pichi\extremadura_zonas_tarifa.csv' -Encoding UTF8
foreach ($line in $zonaLines[1..($zonaLines.Count-1)]) {
    $parts = $line -split ';'
    if ($parts.Count -ge 3) {
        $cp = $parts[2].Trim().PadLeft(5,'0')
        $zonaCPs[$cp] = $true
    }
}

Write-Host "=== CPs en Excel pero NO en zonas CSV (primeros 60) ==="
$count = 0
foreach ($cp in ($voluminosa.Keys | Sort-Object)) {
    if (-not $zonaCPs.ContainsKey($cp)) {
        $d = $voluminosa[$cp]
        Write-Host "$cp | $($d.pob.PadRight(35)) | $($d.dia)"
        $count++
    }
}
Write-Host "Total faltantes en zonas: $count"

Write-Host "`n=== CPs en zonas CSV pero NO en Excel ==="
$count2 = 0
foreach ($cp in ($zonaCPs.Keys | Sort-Object)) {
    if (-not $voluminosa.ContainsKey($cp)) {
        $count2++
    }
}
Write-Host "Total sin dia de reparto: $count2"
