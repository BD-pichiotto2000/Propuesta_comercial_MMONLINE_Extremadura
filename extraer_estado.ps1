# Extraer todos los municipios del HTML con sus coordenadas actuales
$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')
$ms = [regex]::Matches($html, "\{prov:'([^']+)',\s*mun:'([^']+)',\s*cp:'([^']+)',\s*dist:(\d+),\s*zona:'([^']+)',\s*lat:([\d\.\-]+),\s*lon:([\d\.\-]+)")
Write-Host "cp;municipio;prov;lat;lon"
foreach ($m in $ms) {
    $g = $m.Groups
    Write-Host "$($g[3].Value);$($g[2].Value);$($g[1].Value);$($g[6].Value);$($g[7].Value)"
}
