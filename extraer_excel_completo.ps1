$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$wb = $excel.Workbooks.Open('C:\Users\pichi\Downloads\Reparto de CP y Camiones CI.xlsx')
$sh = $wb.Sheets.Item(1)

$output = [System.Collections.Generic.List[string]]::new()
$output.Add('CP;POBLACION;KM_BADAJOZ;DIA_VOLUMINOSA')

for ($r = 9; $r -le 1398; $r++) {
    try {
        $cp  = [string]$sh.Cells($r, 1).Value2
        $pob = [string]$sh.Cells($r, 2).Value2
        $km  = [string]$sh.Cells($r, 4).Value2
        $dia = [string]$sh.Cells($r, 6).Value2
        $cp  = $cp.Trim()
        if ($cp -ne '' -and $cp -ne 'null' -and $cp -match '^\d{4,5}$') {
            $output.Add($cp.PadLeft(5,'0') + ';' + $pob.Trim() + ';' + $km.Trim() + ';' + $dia.Trim())
        }
    } catch { }
}

[System.IO.File]::WriteAllLines(
    'C:\Users\pichi\excel_completo.csv',
    $output,
    [System.Text.UTF8Encoding]::new($false)
)
Write-Host "Exportadas: $($output.Count - 1) filas"
$wb.Close($false)
$excel.Quit()
