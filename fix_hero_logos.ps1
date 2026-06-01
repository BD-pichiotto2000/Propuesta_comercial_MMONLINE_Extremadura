$html = [System.IO.File]::ReadAllText('C:\Users\pichi\propuesta_mediamarkt.html')

# Limpiar inline styles de las cajas - ambas quedan con fondo blanco limpio
# Caja Mangrove: quitar inline style sobreescrito
$old1 = '<div class="brand-box brand-mangrove" style="background:rgba(255,255,255,0.06);border:1px solid rgba(255,255,255,0.12);border-radius:10px;padding:14px 24px;">'
$new1 = '<div class="brand-box brand-mangrove">'
$html = $html.Replace($old1, $new1)

# Caja Media Markt: quitar inline style
$old2 = '<div class="brand-box brand-mm" style="background:#fff;border:2px solid #e2001a;border-radius:10px;padding:14px 24px;">'
$new2 = '<div class="brand-box brand-mm">'
$html = $html.Replace($old2, $new2)

# Ajustar tamaño de logos: Mangrove un poco mas grande
$html = $html -replace '(alt="Mangrove Logistics" style="height:54px)', 'alt="Mangrove Logistics" style="height:64px'
$html = $html -replace '(alt="Media Markt" style="height:54px)', 'alt="Media Markt" style="height:64px'

[System.IO.File]::WriteAllText('C:\Users\pichi\propuesta_mediamarkt.html', $html, [System.Text.UTF8Encoding]::new($false))
Write-Host 'Hero logos corregidos'
