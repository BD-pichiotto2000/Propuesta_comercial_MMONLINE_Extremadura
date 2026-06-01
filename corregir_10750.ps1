# --- Corregir CSV ---
$lines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
$out = [System.Collections.Generic.List[string]]::new()
$banoAdded = $false

foreach ($line in $lines) {
    $p = $line -split ';'
    if ($p.Count -ge 3 -and $p[2].Trim() -eq '10750') {
        # Solo añadir una vez: Baños de Montemayor
        if (-not $banoAdded) {
            $out.Add('Caceres;Baños de Montemayor;10750;165;F;40,00;8,40;48,40;LUNES')
            $banoAdded = $true
        }
        # Saltar todas las entradas incorrectas de 10750
    } else {
        $out.Add($line)
    }
}
[System.IO.File]::WriteAllLines('C:\Users\pichi\extremadura_zonas_completo.csv', $out, [System.Text.UTF8Encoding]::new($false))
Write-Host "CSV: 10750 corregido -> Baños de Montemayor"

# --- Corregir HTML ---
$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')

# Eliminar todas las entradas del array municipios con cp:'10750'
$html = [regex]::Replace($html, "\s*\{prov:'Cáceres',\s+mun:'[^']+',\s+cp:'10750',[^\}]+\},?", '')

# Añadir la entrada correcta justo antes de Baños de Montemayor cp:'10710'
$html = $html -replace "(  \{prov:'Cáceres',  mun:'Baños de Montemayor',  cp:'10710')",
    "  {prov:'Cáceres',  mun:'Baños de Montemayor',  cp:'10750', dist:165, zona:'F', lat:40.302, lon:-5.862, dia:'LUNES'},`n  `$1"

[System.IO.File]::WriteAllText('C:\Users\pichi\extremadura_mapa_zonas.html', $html, [System.Text.UTF8Encoding]::new($false))
Write-Host "HTML: entradas 10750 corregidas"

# Verificar
$check = [regex]::Matches($html, "cp:'10750'")
Write-Host "Entradas cp:10750 restantes: $($check.Count)"
$check2 = [regex]::Matches($html, "Baños de Montemayor")
Write-Host "Entradas Baños de Montemayor: $($check2.Count)"
