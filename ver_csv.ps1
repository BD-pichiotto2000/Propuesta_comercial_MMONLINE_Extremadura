$lines = Get-Content 'C:\Users\pichi\excel_voluminosa.csv' -Encoding UTF8
Write-Host "Total lineas: $($lines.Count)"
for ($i = 0; $i -le 14; $i++) { Write-Host $lines[$i] }
Write-Host "..."
for ($i = $lines.Count - 4; $i -lt $lines.Count; $i++) { Write-Host $lines[$i] }
# Estadisticas de dias
$dias = @{}
foreach ($l in $lines[1..($lines.Count-1)]) {
    $parts = $l -split ';'
    if ($parts.Count -ge 3) {
        $dia = $parts[2].Trim().ToUpper()
        if ($dia -ne '') {
            if (-not $dias.ContainsKey($dia)) { $dias[$dia] = 0 }
            $dias[$dia]++
        }
    }
}
Write-Host "`n--- Distribucion por dia (VOLUMINOSA) ---"
$dias.GetEnumerator() | Sort-Object Name | ForEach-Object { Write-Host "$($_.Key): $($_.Value) CPs" }
