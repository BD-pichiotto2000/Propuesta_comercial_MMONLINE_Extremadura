$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')

# Encontrar el array municipios
$startIdx = $html.IndexOf('const municipios = [')
$endIdx   = $html.IndexOf('];', $startIdx)

# Extraer el bloque dentro del array y el resto
$bloqueArray = $html.Substring($startIdx, $endIdx - $startIdx + 2)  # incluir ];
$antes        = $html.Substring(0, $startIdx)
$despues      = $html.Substring($endIdx + 2)

# Encontrar las entradas nuevas (fuera del array) - en $despues
$nuevasPattern = '  \{prov:''[^'']+'',  mun:''[^'']+'',  cp:''[^'']+'', dist:\d+, zona:''[^'']+'', lat:[\d\.\-]+, lon:[\d\.\-]+\},?\r?\n'
$nuevasEncontradas = [regex]::Matches($despues, $nuevasPattern)
Write-Host "Entradas nuevas fuera del array: $($nuevasEncontradas.Count)"

# Deduplicar por cp
$cpVistas = @{}
$nuevasUnicas = [System.Collections.Generic.List[string]]::new()
foreach ($m in $nuevasEncontradas) {
    $cpM = [regex]::Match($m.Value, "cp:'([^']+)'")
    if ($cpM.Success) {
        $cp = $cpM.Groups[1].Value
        if (-not $cpVistas.ContainsKey($cp)) {
            $cpVistas[$cp] = $true
            # Asegurar formato consistente (con coma al final)
            $entry = $m.Value.TrimEnd("`r`n")
            if (-not $entry.EndsWith(',')) { $entry += ',' }
            $nuevasUnicas.Add($entry)
        }
    }
}
Write-Host "Entradas unicas a insertar: $($nuevasUnicas.Count)"

# Limpiar todas las entradas nuevas del bloque 'despues'
$despuesLimpio = [regex]::Replace($despues, $nuevasPattern, '')

# Tambien limpiar posibles residuos (lineas vacias multiples)
$despuesLimpio = [regex]::Replace($despuesLimpio, '(\r?\n){3,}', "`n`n")

# Insertar dentro del array (antes del ]; final)
$nuevasStr = "`n" + ($nuevasUnicas -join "`n") + "`n"
$bloqueArrayNuevo = $bloqueArray -replace '\];$', "$nuevasStr];"

# Reconstruir HTML
$htmlNuevo = $antes + $bloqueArrayNuevo + $despuesLimpio

# Verificar
$startIdx2 = $htmlNuevo.IndexOf('const municipios = [')
$endIdx2   = $htmlNuevo.IndexOf('];', $startIdx2)
$bloque2   = $htmlNuevo.Substring($startIdx2, $endIdx2 - $startIdx2)
$count2    = [regex]::Matches($bloque2, "prov:'").Count
Write-Host "Entradas en array municipios NUEVO: $count2"

# Guardar
[System.IO.File]::WriteAllText('C:\Users\pichi\extremadura_mapa_zonas.html', $htmlNuevo, [System.Text.UTF8Encoding]::new($false))
Write-Host "HTML guardado"

# Verificar algunas entradas nuevas
$test = @('10748','10857','06329')
foreach ($cp in $test) {
    $idx = $htmlNuevo.IndexOf("cp:'$cp'")
    if ($idx -ge 0) {
        $s = $htmlNuevo.LastIndexOf('{', $idx)
        $e = $htmlNuevo.IndexOf('}', $idx)
        if ($s -lt $startIdx2 -or $s -gt $endIdx2) {
            Write-Host "  $cp : FUERA del array!"
        } else {
            $obj = $htmlNuevo.Substring($s, $e - $s + 1)
            $mun = [regex]::Match($obj, "mun:'([^']+)'").Groups[1].Value
            Write-Host "  $cp : $mun (DENTRO del array)"
        }
    }
}
