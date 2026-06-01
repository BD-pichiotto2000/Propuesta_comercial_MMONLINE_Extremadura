$lines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
Write-Host "Total: $($lines.Count)"
$found = $lines | Where-Object { $_ -match '10748' }
Write-Host "Matches 10748: $($found.Count)"
foreach ($f in $found) { Write-Host "[$f]" }
Write-Host ""
# Ver ultimas 5 lineas
Write-Host "=== Ultimas 5 lineas ==="
$lines[($lines.Count-5)..($lines.Count-1)] | ForEach-Object { Write-Host "[$_]" }
