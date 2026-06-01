# Cedillo (Caceres) - lat 39.633, lon -7.450 -> dist ~93km, Zona D
# CP: 10513, Dia: LUNES

# === Actualizar CSV ===
$lines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
$out = [System.Collections.Generic.List[string]]::new()
$updated = $false

foreach ($line in $lines) {
    if ($line -match '^C[aá]ceres;Cedillo;') {
        # Corregir distancia y zona
        $out.Add('Caceres;Cedillo;10513;93;D;33,00;6,93;39,93;LUNES')
        $updated = $true
        Write-Host "CSV actualizado: Cedillo dist=93, Zona D, 39,93 EUR, LUNES"
    } else {
        $out.Add($line)
    }
}

if (-not $updated) {
    $out.Add('Caceres;Cedillo;10513;93;D;33,00;6,93;39,93;LUNES')
    Write-Host "CSV: Cedillo anadido nuevo"
}

[System.IO.File]::WriteAllLines('C:\Users\pichi\extremadura_zonas_completo.csv', $out, [System.Text.UTF8Encoding]::new($false))

# === Agregar al HTML ===
$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')

# Verificar que no existe ya
if ($html.Contains("cp:'10513'")) {
    Write-Host "HTML: cp 10513 ya existe, no se anade"
} else {
    $entrada = "  {prov:'C" + [char]0x00E1 + "ceres',  mun:'Cedillo',  cp:'10513', dist:93, zona:'D', lat:39.633, lon:-7.450},"

    # Insertar antes del cierre del array
    $startIdx = $html.IndexOf('const municipios = [')
    $endIdx   = $html.IndexOf('];', $startIdx)

    $antes   = $html.Substring(0, $endIdx)
    $despues = $html.Substring($endIdx)

    $htmlNuevo = $antes + "`n" + $entrada + "`n" + $despues
    [System.IO.File]::WriteAllText('C:\Users\pichi\extremadura_mapa_zonas.html', $htmlNuevo, [System.Text.UTF8Encoding]::new($false))

    # Verificar
    $html2 = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')
    $count = [regex]::Matches($html2.Substring($html2.IndexOf('const municipios = ['), $html2.IndexOf('];', $html2.IndexOf('const municipios = [')) - $html2.IndexOf('const municipios = [')), "prov:'").Count
    Write-Host "HTML: Cedillo anadido. Total entradas: $count"
}

# Agregar a cpDias si no existe
if (-not $html.Contains("'10513'")) {
    # cpDias esta en el HTML, agregar entrada
    $cpDiasKey = "'10513':'LUNES'"
    $idxCpDias = $html.IndexOf('const cpDias = {')
    if ($idxCpDias -ge 0) {
        Write-Host "Nota: agregar manualmente '10513':'LUNES' a cpDias si se usa popup"
    }
}
