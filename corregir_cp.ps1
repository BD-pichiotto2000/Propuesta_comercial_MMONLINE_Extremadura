## Corregir CSV
$lines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
$out   = [System.Collections.Generic.List[string]]::new()
foreach ($line in $lines) {
    # CP 10620: Holguera -> Caminomorisco
    $fixed = $line -replace '^Caceres;Holguera;10620;', 'Caceres;Caminomorisco;10620;'
    $out.Add($fixed)
}
[System.IO.File]::WriteAllLines('C:\Users\pichi\extremadura_zonas_completo.csv', $out, [System.Text.UTF8Encoding]::new($false))
Write-Host "CSV corregido"

## Corregir HTML (nombre del municipio en el array municipios)
$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')

# Cambiar mun:'Holguera' cp:'10620' -> mun:'Caminomorisco' y coordenadas de Caminomorisco
$html = $html -replace "mun:'Holguera', cp:'10620', dist:135, zona:'E', lat:39\.865, lon:-6\.276", `
               "mun:'Caminomorisco', cp:'10620', dist:168, zona:'F', lat:40.301, lon:-6.402"

[System.IO.File]::WriteAllText('C:\Users\pichi\extremadura_mapa_zonas.html', $html, [System.Text.UTF8Encoding]::new($false))
Write-Host "HTML corregido"

# Verificar
$check = [regex]::Match($html, "cp:'10620'[^}]+mun:'([^']+)'")
Write-Host "CP 10620 ahora es: $($check.Groups[1].Value)"

# Buscar si queda algun Holguera en el array
$holg = [regex]::Matches($html, "mun:'Holguera'")
Write-Host "Entradas 'Holguera' restantes: $($holg.Count)"
