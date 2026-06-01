$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

function Read-XLS($path) {
    $wb = $excel.Workbooks.Open($path)
    $ws = $wb.Sheets.Item(1)
    $data = @()
    $row = 1
    # Leer hasta 500 filas
    while ($row -le 500) {
        $v1 = $ws.Cells.Item($row, 1).Text
        $v2 = $ws.Cells.Item($row, 2).Text
        $v3 = $ws.Cells.Item($row, 3).Text
        $v4 = $ws.Cells.Item($row, 4).Text
        if ([string]::IsNullOrWhiteSpace($v1) -and [string]::IsNullOrWhiteSpace($v2)) { break }
        $data += [PSCustomObject]@{C1=$v1; C2=$v2; C3=$v3; C4=$v4}
        $row++
    }
    $wb.Close($false)
    return $data
}

Write-Host "=== CACERES (11codmun10.xls) ==="
$cac = Read-XLS 'C:\Users\pichi\Downloads\11codmun10.xls'
Write-Host "Filas: $($cac.Count)"
$cac[0..9] | ForEach-Object { Write-Host "$($_.C1) | $($_.C2) | $($_.C3) | $($_.C4)" }

Write-Host ""
Write-Host "=== BADAJOZ (11codmun06.xls) ==="
$bad = Read-XLS 'C:\Users\pichi\Downloads\11codmun06.xls'
Write-Host "Filas: $($bad.Count)"
$bad[0..9] | ForEach-Object { Write-Host "$($_.C1) | $($_.C2) | $($_.C3) | $($_.C4)" }

$excel.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
