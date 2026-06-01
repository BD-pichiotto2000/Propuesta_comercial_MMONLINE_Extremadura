$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')

# Encontrar el bloque const municipios = [...]
$startIdx = $html.IndexOf('const municipios = [')
if ($startIdx -lt 0) { Write-Host "ERROR: no se encontro const municipios"; exit }

# Encontrar el cierre ]; del array (primer ]; despues de const municipios)
$endIdx = $html.IndexOf('];', $startIdx)
if ($endIdx -lt 0) { Write-Host "ERROR: no se encontro el cierre del array"; exit }

Write-Host "Array municipios: posicion $startIdx - $endIdx"
Write-Host "Contenido final del array (ultimos 300 chars):"
Write-Host $html.Substring([Math]::Max($startIdx, $endIdx - 300), [Math]::Min(300, $endIdx - $startIdx))

# Contar entradas actuales en el array
$bloque = $html.Substring($startIdx, $endIdx - $startIdx)
$count = [regex]::Matches($bloque, "prov:'").Count
Write-Host "Entradas actuales en array: $count"

# Las nuevas entradas estan fuera del array - buscarlas despues del cierre ];
$afterArray = $html.Substring($endIdx + 2)  # despues de ];
$nuevasMatch = [regex]::Matches($afterArray, "  \{prov:'[^']+',  mun:'[^']+',  cp:'[^']+', dist:\d+, zona:'[^']+', lat:[\d\.\-]+, lon:[\d\.\-]+\},")
Write-Host ""
Write-Host "Entradas nuevas fuera del array: $($nuevasMatch.Count)"
if ($nuevasMatch.Count -gt 0) {
    Write-Host "Primera: $($nuevasMatch[0].Value.Substring(0,80))..."
}
