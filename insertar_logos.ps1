$mg = (Get-Content 'C:\Users\pichi\mg_logo_b64.txt' -Raw).Trim()
$mm = (Get-Content 'C:\Users\pichi\mm_logo_b64.txt' -Raw).Trim()
$html = [System.IO.File]::ReadAllText('C:\Users\pichi\propuesta_mediamarkt.html')

# NAV: logo Mangrove (blanco sobre fondo oscuro -> filtro invert)
$oldNav = '<div class="nav-logo">MANGROVE <span>LOGISTICS</span></div>'
$newNav = '<div class="nav-logo"><img src="data:image/png;base64,' + $mg + '" alt="Mangrove Logistics" style="height:32px;width:auto;filter:brightness(0) invert(1);" /></div>'
$html = $html.Replace($oldNav, $newNav)

# HERO: logo Mangrove (color original sobre caja oscura)
$oldMG = '<div class="brand-box brand-mangrove">MANGROVE LOGISTICS</div>'
$newMG = '<div class="brand-box brand-mangrove" style="background:rgba(255,255,255,0.06);border:1px solid rgba(255,255,255,0.12);border-radius:10px;padding:14px 24px;"><img src="data:image/png;base64,' + $mg + '" alt="Mangrove Logistics" style="height:54px;width:auto;" /></div>'
$html = $html.Replace($oldMG, $newMG)

# HERO: logo Media Markt (sobre caja blanca)
$oldMM = '<div class="brand-box brand-mm">MEDIA MARKT</div>'
$newMM = '<div class="brand-box brand-mm" style="background:#fff;border:2px solid #e2001a;border-radius:10px;padding:14px 24px;"><img src="data:image/png;base64,' + $mm + '" alt="Media Markt" style="height:54px;width:auto;" /></div>'
$html = $html.Replace($oldMM, $newMM)

# FOOTER: logo Mangrove (blanco)
$oldFoot = '<div class="footer-logo">MANGROVE LOGISTICS</div>'
$newFoot = '<div class="footer-logo"><img src="data:image/png;base64,' + $mg + '" alt="Mangrove Logistics" style="height:42px;width:auto;" /></div>'
$html = $html.Replace($oldFoot, $newFoot)

[System.IO.File]::WriteAllText('C:\Users\pichi\propuesta_mediamarkt.html', $html, [System.Text.UTF8Encoding]::new($false))
Write-Host ('Guardado. Tamanio: ' + [math]::Round($html.Length/1024,1) + ' KB')
Write-Host ('Nav OK:    ' + $html.Contains('nav-logo'))
Write-Host ('Hero MG:   ' + $html.Contains('hero-brands'))
Write-Host ('Hero MM:   ' + $html.Contains('brand-mm'))
Write-Host ('Footer OK: ' + $html.Contains('footer-logo'))
