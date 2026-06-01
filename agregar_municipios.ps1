# Calcular distancia desde Badajoz
function Calc-Dist($lat, $lon) {
    $latBad = 38.879; $lonBad = -6.971
    $dlat = ($lat - $latBad) * 111
    $dlon = ($lon - $lonBad) * 86.4
    return [int][Math]::Round([Math]::Sqrt($dlat*$dlat + $dlon*$dlon))
}

function Get-Zona($dist) {
    if ($dist -le 25)  { return 'A' }
    if ($dist -le 50)  { return 'B' }
    if ($dist -le 75)  { return 'C' }
    if ($dist -le 120) { return 'D' }
    if ($dist -le 160) { return 'E' }
    if ($dist -le 200) { return 'F' }
    if ($dist -le 250) { return 'G' }
    return 'H'
}

function Get-Tarifa($zona) {
    $t = @{A=@{b='25,00';i='5,25';t='30,25'};B=@{b='27,00';i='5,67';t='32,67'};C=@{b='30,00';i='6,30';t='36,30'};D=@{b='33,00';i='6,93';t='39,93'};E=@{b='37,00';i='7,77';t='44,77'};F=@{b='40,00';i='8,40';t='48,40'};G=@{b='43,00';i='9,03';t='52,03'};H=@{b='45,00';i='9,45';t='54,45'}}
    return $t[$zona]
}

# Leer municipios nuevos
$nuevos = Import-Csv 'C:\Users\pichi\municipios_nuevos.csv' -Delimiter ';'
Write-Host "Municipios a agregar: $($nuevos.Count)"

# === Actualizar CSV ===
$csvLines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')

# Construir set de CPs ya existentes
$cpsExistentes = @{}
foreach ($line in $csvLines[1..($csvLines.Count-1)]) {
    $p = $line -split ';'
    if ($p.Count -ge 3) { $cpsExistentes[$p[2].Trim()] = $true }
}

$nuevasFilas = [System.Collections.Generic.List[string]]::new()
$agregados = 0

foreach ($n in $nuevos) {
    $cp   = $n.CP.Trim().TrimStart('0')  # CSV guarda sin cero inicial
    $lat  = [double]::Parse($n.Lat, [System.Globalization.CultureInfo]::InvariantCulture)
    $lon  = [double]::Parse($n.Lon, [System.Globalization.CultureInfo]::InvariantCulture)
    $dist = Calc-Dist $lat $lon
    $zona = Get-Zona $dist
    $tar  = Get-Tarifa $zona

    # Verificar si ya existe (por provincia+municipio o CP)
    $yaExiste = $false
    foreach ($line in $csvLines[1..($csvLines.Count-1)]) {
        $p = $line -split ';'
        if ($p.Count -ge 3 -and $p[2].Trim() -eq $cp -and $p[1].Trim() -eq $n.Municipio) {
            $yaExiste = $true; break
        }
    }

    if (-not $yaExiste) {
        $fila = "$($n.Provincia);$($n.Municipio);$cp;$dist;$zona;$($tar.b);$($tar.i);$($tar.t);$($n.DiaSemana)"
        $nuevasFilas.Add($fila)
        $agregados++
    }
}

# Añadir al CSV
$allLines = [System.Collections.Generic.List[string]]::new()
foreach ($l in $csvLines) { $allLines.Add($l) }
foreach ($l in $nuevasFilas) { $allLines.Add($l) }
[System.IO.File]::WriteAllLines('C:\Users\pichi\extremadura_zonas_completo.csv', $allLines, [System.Text.UTF8Encoding]::new($false))
Write-Host "CSV: $agregados municipios agregados. Total: $($allLines.Count - 1)"

# === Actualizar HTML ===
$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')

# Añadir al cpDias
$cpDiasNuevos = ''
foreach ($n in $nuevos) {
    $cp5 = $n.CP.Trim().PadLeft(5,'0')
    if ($html -notmatch "'$cp5'") {
        $cpDiasNuevos += "  '$cp5':'$($n.DiaSemana)',`n"
    }
}
if ($cpDiasNuevos -ne '') {
    $html = $html -replace "(const cpDias = \{)", "`$1`n$cpDiasNuevos"
    Write-Host "cpDias: nuevas entradas añadidas"
}

# Añadir al array municipios - justo antes del cierre "];"
$munNuevos = ''
foreach ($n in $nuevos) {
    $cp5  = $n.CP.Trim().PadLeft(5,'0')
    $lat  = [double]::Parse($n.Lat, [System.Globalization.CultureInfo]::InvariantCulture)
    $lon  = [double]::Parse($n.Lon, [System.Globalization.CultureInfo]::InvariantCulture)
    $dist = Calc-Dist $lat $lon
    $zona = Get-Zona $dist

    # Verificar si ya existe en el HTML
    if ($html -notmatch "cp:'$cp5'[^\}]*mun:'$([regex]::Escape($n.Municipio))'" -and
        $html -notmatch "mun:'$([regex]::Escape($n.Municipio))'[^\}]*cp:'$cp5'") {
        $dia = $n.DiaSemana
        $prov = $n.Provincia
        if ($prov -eq 'Caceres') { $prov = 'C' + [char]0x00E1 + 'ceres' }
        $munNuevos += "  {prov:'$prov',  mun:'$($n.Municipio)',  cp:'$cp5', dist:$dist, zona:'$zona', lat:$lat, lon:$lon},`n"
    }
}

if ($munNuevos -ne '') {
    # Insertar antes del cierre del array
    $html = $html -replace '(\];(\s*\/\/ FIN|\s*\nconst))', "$munNuevos`$1"
    # Si no funcionó el patron, intentar insertar antes del último ];
    if ($html -notmatch [regex]::Escape($munNuevos.Substring(0, [Math]::Min(50, $munNuevos.Length)))) {
        $idx = $html.LastIndexOf('];')
        if ($idx -gt 0) {
            $html = $html.Substring(0, $idx) + $munNuevos + $html.Substring($idx)
        }
    }
    Write-Host "Array municipios: nuevas entradas añadidas"
}

[System.IO.File]::WriteAllText('C:\Users\pichi\extremadura_mapa_zonas.html', $html, [System.Text.UTF8Encoding]::new($false))
Write-Host "Proceso completado"
