$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')

# Contar entradas reales en municipios
$startMun = $html.IndexOf('const municipios')
$endMun   = $html.IndexOf('];', $startMun)
$bloque   = $html.Substring($startMun, $endMun - $startMun)
$entries  = [regex]::Matches($bloque, "prov:'")
Write-Host "Entradas en array municipios: $($entries.Count)"

# Verificar algunas nuevas
$test = @('10748','10857','10650','10628','06329','06439')
foreach ($cp in $test) {
    $idx = $html.IndexOf("cp:'$cp'")
    if ($idx -ge 0) {
        $s = $html.LastIndexOf('{', $idx)
        $e = $html.IndexOf('}', $idx)
        $obj = $html.Substring($s, $e - $s + 1)
        $mun = [regex]::Match($obj, "mun:'([^']+)'").Groups[1].Value
        $lat = [regex]::Match($obj, "lat:([\d\.\-]+)").Groups[1].Value
        $lon = [regex]::Match($obj, "lon:([\d\.\-]+)").Groups[1].Value
        Write-Host "  $cp : $mun @ ($lat,$lon)"
    } else {
        Write-Host "  $cp : NO ENCONTRADO"
    }
}

# Verificar cpDias tiene las nuevas entradas
Write-Host ""
$cpDiasIdx = $html.IndexOf('const cpDias')
$cpDiasEnd = $html.IndexOf('};', $cpDiasIdx)
$cpDiasBlk = $html.Substring($cpDiasIdx, $cpDiasEnd - $cpDiasIdx)
$cpDiasCount = [regex]::Matches($cpDiasBlk, "'\d{5}'").Count
Write-Host "Entradas en cpDias: $cpDiasCount"
$test2 = @('10748','10857','06329')
foreach ($cp in $test2) {
    $m = [regex]::Match($cpDiasBlk, "'$cp':'([^']*)'")
    if ($m.Success) { Write-Host "  cpDias[$cp] = $($m.Groups[1].Value)" }
    else { Write-Host "  cpDias[$cp] : NO ENCONTRADO" }
}
