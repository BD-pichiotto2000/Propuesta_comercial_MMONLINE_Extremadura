# Check Badajoz CPs in CSV - look for any 6xxx entries
$lines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
Write-Host "=== CPs Badajoz 06xxx en CSV ==="
$badajoz = $lines | Where-Object { $_ -match ';0?6\d{3};' } | Select-Object -First 10
foreach ($l in $badajoz) { Write-Host $l }

Write-Host ""
Write-Host "=== Buscar 06110 de cualquier forma ==="
$found = $lines | Where-Object { $_ -match '6110' }
foreach ($l in $found) { Write-Host $l }

Write-Host ""
Write-Host "=== Primeras 5 lineas CSV ==="
$lines[0..4] | ForEach-Object { Write-Host $_ }

# Check HTML format for cp entries
$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')
Write-Host ""
Write-Host "=== HTML: formato cp Badajoz ==="
$ms = [regex]::Matches($html, "\{[^\}]*cp:'06\d{3}'[^\}]*\}")
Write-Host "Encontrados: $($ms.Count)"
if ($ms.Count -gt 0) { Write-Host $ms[0].Value }

Write-Host ""
Write-Host "=== HTML: buscar 06110 ==="
$idx = $html.IndexOf("06110")
if ($idx -ge 0) { Write-Host $html.Substring([Math]::Max(0,$idx-50), 150) }
else { Write-Host "06110 no encontrado en HTML" }
