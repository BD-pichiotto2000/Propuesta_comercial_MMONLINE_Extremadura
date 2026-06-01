$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false; $excel.DisplayAlerts = $false

function Read-All($path) {
    $wb = $excel.Workbooks.Open($path)
    $ws = $wb.Sheets.Item(1)
    $data = @()
    $row = 4
    while ($row -le 500) {
        $mun = $ws.Cells.Item($row, 4).Text.Trim()
        if ([string]::IsNullOrWhiteSpace($mun)) { break }
        $data += $mun
        $row++
    }
    $wb.Close($false)
    return $data
}

$bad = Read-All 'C:\Users\pichi\Downloads\11codmun06.xls'
$cac = Read-All 'C:\Users\pichi\Downloads\11codmun10.xls'
$excel.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null

Write-Host "=== BADAJOZ ($($bad.Count)) ==="
$bad | Sort-Object | ForEach-Object { Write-Host "  [$_]" }
Write-Host ""
Write-Host "=== CACERES ($($cac.Count)) ==="
$cac | Sort-Object | ForEach-Object { Write-Host "  [$_]" }
