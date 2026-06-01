$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')

# Buscar bloque de Caceres - primeros 500 chars despues de "Zarza de Granadilla"
$idx = $html.IndexOf('Zarza de Granadilla')
if ($idx -ge 0) {
    Write-Host "=== Zarza de Granadilla entry ==="
    Write-Host $html.Substring([Math]::Max(0,$idx-20), 200)
}

# Buscar con regex simple
Write-Host ""
Write-Host "=== Intentando regex simple para Caceres ==="
$m1 = [regex]::Matches($html, "prov:'[^']*aceres'")
Write-Host "Entradas Caceres: $($m1.Count)"
if ($m1.Count -gt 0) { Write-Host "Primera: $($m1[0].Value)" }

# Contar total de entradas en municipios
Write-Host ""
$total = [regex]::Matches($html, "prov:'")
Write-Host "Total entradas prov: $($total.Count)"

# Ver las primeras lineas del array municipios
$startIdx = $html.IndexOf('const municipios')
if ($startIdx -ge 0) {
    Write-Host ""
    Write-Host "=== Inicio array municipios ==="
    Write-Host $html.Substring($startIdx, 500)
}
