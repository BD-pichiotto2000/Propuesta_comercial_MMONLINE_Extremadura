$lines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
Write-Host "Total filas CSV: $($lines.Count - 1)"

$check = @('06110','06450','06750','06770','06870','10710','10850','10891')
foreach ($cp in $check) {
    $found = $lines | Where-Object { $_.Split(';').Count -ge 3 -and $_.Split(';')[2].Trim() -eq $cp }
    if ($found) {
        $p = $found.Split(';')
        Write-Host "$cp : $($p[1]) | $($p[0])"
    } else {
        Write-Host "$cp : NO ENCONTRADO"
    }
}

# Check HTML too
$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')
Write-Host ""
Write-Host "Verificando HTML..."
foreach ($cp in $check) {
    $m = [regex]::Match($html, "cp:'$cp'[^\}]*\}")
    if ($m.Success) {
        $mun = [regex]::Match($m.Value, "mun:'([^']+)'")
        Write-Host "$cp : $($mun.Groups[1].Value)"
    } else {
        $m2 = [regex]::Match($html, "cp:'$cp'")
        if ($m2.Success) { Write-Host "$cp : encontrado pero sin match completo" }
        else { Write-Host "$cp : NO EN HTML" }
    }
}
