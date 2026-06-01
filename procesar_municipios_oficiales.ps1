$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

function Read-Municipios($path) {
    $wb = $excel.Workbooks.Open($path)
    $ws = $wb.Sheets.Item(1)
    $data = @()
    $row = 4  # Saltar cabeceras (filas 1-3)
    while ($row -le 500) {
        $cpro = $ws.Cells.Item($row, 1).Text.Trim()
        $mun  = $ws.Cells.Item($row, 4).Text.Trim()
        if ([string]::IsNullOrWhiteSpace($cpro) -and [string]::IsNullOrWhiteSpace($mun)) { break }
        if (-not [string]::IsNullOrWhiteSpace($mun)) {
            # Convertir formato "Albuera, La" -> "La Albuera"
            if ($mun -match '^(.+),\s+(.+)$') {
                $mun = "$($Matches[2]) $($Matches[1])"
            }
            $data += $mun
        }
        $row++
    }
    $wb.Close($false)
    return $data
}

Write-Host "Leyendo XLS..."
$munCaceres = Read-Municipios 'C:\Users\pichi\Downloads\11codmun10.xls'
$munBadajoz = Read-Municipios 'C:\Users\pichi\Downloads\11codmun06.xls'
$excel.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null

Write-Host "Municipios Caceres XLS: $($munCaceres.Count)"
Write-Host "Municipios Badajoz XLS: $($munBadajoz.Count)"

# Cargar datos existentes en CSV
$csvLines = [System.IO.File]::ReadAllLines('C:\Users\pichi\extremadura_zonas_completo.csv')
$munEnCSV = @{}
foreach ($line in $csvLines[1..($csvLines.Count-1)]) {
    $p = $line -split ';'
    if ($p.Count -ge 2) {
        $key = "$($p[0].Trim())|$($p[1].Trim())"
        $munEnCSV[$key] = $true
    }
}

# Cargar cp_oficial para buscar CPs
$cpOficial = @{}  # municipio (sin acento) -> @{cp=...; mun=...; prov=...}
$ofLines = [System.IO.File]::ReadAllLines('C:\Users\pichi\cp_oficial.csv')
foreach ($line in $ofLines[1..($ofLines.Count-1)]) {
    $p = $line -split ';'
    if ($p.Count -ge 3) {
        $key = $p[1].Trim()
        if (-not $cpOficial.ContainsKey($key)) {
            $cpOficial[$key] = @{cp=$p[0].Trim(); mun=$p[1].Trim(); prov=$p[2].Trim()}
        }
    }
}

function Strip($s) {
    $r = $s
    $r = $r.Replace([char]0x00E1,'a').Replace([char]0x00E9,'e').Replace([char]0x00ED,'i').Replace([char]0x00F3,'o').Replace([char]0x00FA,'u')
    $r = $r.Replace([char]0x00C1,'A').Replace([char]0x00C9,'E').Replace([char]0x00CD,'I').Replace([char]0x00D3,'O').Replace([char]0x00DA,'U')
    $r = $r.Replace([char]0x00F1,'n').Replace([char]0x00D1,'N')
    return $r
}

# Encontrar municipios que faltan en el CSV
Write-Host ""
Write-Host "=== MUNICIPIOS CACERES FALTANTES EN CSV ==="
$faltanC = 0
foreach ($mun in $munCaceres | Sort-Object) {
    # Buscar en CSV (con cualquier CP)
    $found = $false
    foreach ($k in $munEnCSV.Keys) {
        if ($k -like "Caceres|*") {
            $munCSV = ($k -split '\|')[1]
            if ((Strip $munCSV) -eq (Strip $mun)) { $found = $true; break }
        }
    }
    if (-not $found) {
        # Buscar CP en cp_oficial
        $cpInfo = $null
        foreach ($k in $cpOficial.Keys) {
            if ((Strip $k) -eq (Strip $mun)) { $cpInfo = $cpOficial[$k]; break }
        }
        $cpStr = if ($cpInfo) { $cpInfo.cp } else { '?????' }
        Write-Host "  FALTA: $mun (CP: $cpStr)"
        $faltanC++
    }
}
Write-Host "Total faltantes Caceres: $faltanC"

Write-Host ""
Write-Host "=== MUNICIPIOS BADAJOZ FALTANTES EN CSV ==="
$faltanB = 0
foreach ($mun in $munBadajoz | Sort-Object) {
    $found = $false
    foreach ($k in $munEnCSV.Keys) {
        if ($k -like "Badajoz|*") {
            $munCSV = ($k -split '\|')[1]
            if ((Strip $munCSV) -eq (Strip $mun)) { $found = $true; break }
        }
    }
    if (-not $found) {
        $cpInfo = $null
        foreach ($k in $cpOficial.Keys) {
            if ((Strip $k) -eq (Strip $mun)) { $cpInfo = $cpOficial[$k]; break }
        }
        $cpStr = if ($cpInfo) { $cpInfo.cp } else { '?????' }
        Write-Host "  FALTA: $mun (CP: $cpStr)"
        $faltanB++
    }
}
Write-Host "Total faltantes Badajoz: $faltanB"
