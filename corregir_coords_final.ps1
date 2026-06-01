$coords = @{}
function Set-C($mun, $lat, $lon) { $coords["Caceres|$mun"] = @{lat=$lat; lon=$lon} }
function Set-B($mun, $lat, $lon) { $coords["Badajoz|$mun"] = @{lat=$lat; lon=$lon} }

Set-B 'Badajoz' 38.879 -6.971
Set-B 'Villanueva del Fresno' 38.403 -7.091
Set-B 'Oliva de la Frontera' 38.433 -7.119
Set-B 'Zahinos' 38.394 -6.965
Set-B 'Valverde de Leganes' 38.470 -6.675
Set-B 'Alconchel' 38.519 -7.076
Set-B 'Higuera de Vargas' 38.428 -6.866
Set-B 'Taliga' 38.420 -7.076
Set-B 'Valencia del Mombuey' 38.205 -7.026
Set-B 'Cheles' 38.529 -7.234
Set-B 'Barcarrota' 38.516 -6.923
Set-B 'Salvatierra de los Barros' 38.489 -6.782
Set-B 'La Morera' 38.491 -6.827
Set-B 'Valle de Matamoros' 38.261 -6.912
Set-B 'Valle de Santa Ana' 38.286 -6.997
Set-B 'Almendralejo' 38.682 -6.408
Set-B 'Aceuchal' 38.639 -6.393
Set-B 'Villalba de los Barros' 38.558 -6.287
Set-B 'Torremejia' 38.789 -6.259
Set-B 'Villafranca de los Barros' 38.572 -6.330
Set-B 'Ribera del Fresno' 38.487 -6.263
Set-B 'Hinojosa del Valle' 38.159 -5.993
Set-B 'Llera' 38.369 -5.901
Set-B 'Hornachos' 38.380 -5.815
Set-B 'Puebla del Prior' 38.370 -6.127
Set-B 'Los Santos de Maimona' 38.453 -6.376
Set-B 'Fuente de Cantos' 38.170 -6.296
Set-B 'Calzadilla de los Barros' 38.249 -6.244
Set-B 'Bienvenida' 38.297 -6.196
Set-B 'Monesterio' 38.083 -6.265
Set-B 'Segura de Leon' 38.077 -6.547
Set-B 'Fuentes de Leon' 38.087 -6.556
Set-B 'Usagre' 38.349 -6.021
Set-B 'Montemolin' 38.279 -6.620
Set-B 'Calera de Leon' 38.168 -6.696
Set-B 'Cabeza la Vaca' 38.393 -6.591
Set-B 'Bodonal de la Sierra' 38.097 -6.635
Set-B 'Zafra' 38.422 -6.417
Set-B 'Puebla de Sancho Perez' 38.379 -6.349
Set-B 'Medina de las Torres' 38.337 -6.274
Set-B 'Atalaya' 38.267 -6.488
Set-B 'Valencia del Ventoso' 38.358 -6.278
Set-B 'Fregenal de la Sierra' 38.164 -6.657
Set-B 'Higuera la Real' 38.141 -6.713
Set-B 'Fuente del Maestre' 38.536 -6.425
Set-B 'Burguillos del Cerro' 38.375 -6.595
Set-B 'Valverde de Burguillos' 38.438 -6.682
Set-B 'Jerez de los Caballeros' 38.329 -6.774
Set-B 'La Lapa' 38.351 -6.564
Set-B 'Feria' 38.379 -6.541
Set-B 'Alconera' 38.437 -6.330
Set-B 'Don Benito' 38.956 -5.860
Set-B 'Guarena' 38.869 -5.930
Set-B 'Medellin' 38.962 -5.890
Set-B 'Mengabril' 38.984 -5.873
Set-B 'Castuera' 38.718 -5.540
Set-B 'Monterrubio de la Serena' 38.696 -5.441
Set-B 'Benquerencia de la Serena' 38.691 -5.567
Set-B 'Zalamea de la Serena' 38.659 -5.650
Set-B 'Esparragosa de la Serena' 38.754 -5.490
Set-B 'Malpartida de la Serena' 38.698 -5.497
Set-B 'Higuera de la Serena' 38.730 -5.493
Set-B 'Retamal de Llerena' 38.412 -5.997
Set-B 'Campillo de Llerena' 38.395 -5.872
Set-B 'Valencia de las Torres' 38.427 -5.894
Set-B 'Higuera de Llerena' 38.330 -5.977
Set-B 'Valle de la Serena' 38.863 -5.826
Set-B 'Campanario' 38.868 -5.607
Set-B 'Magacela' 38.878 -5.738
Set-B 'La Coronada' 38.892 -5.572
Set-B 'Villagonzalo' 38.882 -5.907
Set-B 'Valdetorres' 38.844 -5.894
Set-B 'Oliva de Merida' 38.761 -6.029
Set-B 'Palomas' 38.744 -6.138
Set-B 'Puebla de la Reina' 38.753 -6.059
Set-B 'Manchita' 38.905 -6.001
Set-B 'Cristina' 39.060 -5.634
Set-B 'Cordobilla de Lacara' 39.000 -6.516
Set-B 'Carmonita' 38.965 -6.487
Set-B 'Lobon' 38.852 -6.613
Set-B 'San Vicente de Alcantara' 39.362 -7.128
Set-B 'La Codosera' 39.336 -7.120
Set-B 'Cabeza del Buey' 38.713 -5.219
Set-B 'Penalsordo' 38.774 -5.108
Set-B 'Zarza Capilla' 38.698 -5.057
Set-B 'Capilla' 38.826 -5.019
Set-B 'Esparragosa de Lares' 39.076 -5.166
Set-B 'Puebla de Alcocer' 38.968 -5.261
Set-B 'Talarrubias' 39.032 -5.236
Set-B 'Siruela' 38.971 -5.035
Set-B 'Garlitos' 38.935 -5.158
Set-B 'Tamurejo' 38.926 -5.054
Set-B 'Baterno' 38.890 -4.975
Set-B 'Fuenlabrada de los Montes' 39.345 -4.925
Set-B 'Herrera del Duque' 39.169 -5.035
Set-B 'Villarta de los Montes' 39.245 -4.882
Set-B 'Castilblanco' 39.290 -5.198
Set-B 'Valdecaballeros' 39.208 -5.147
Set-B 'Garbayuela' 39.215 -5.025
Set-B 'Helechosa' 39.415 -5.018
Set-B 'Villanueva de la Serena' 38.979 -5.807
Set-B 'Don Alvaro' 38.867 -6.265
Set-B 'Zarza de Alange' 38.826 -6.312
Set-B 'Alange' 38.789 -6.233
Set-B 'Arroyo de San Servan' 38.905 -6.412
Set-B 'Esparragalejo' 38.908 -6.464
Set-B 'La Garrovilla' 38.932 -6.362
Set-B 'Valverde de Merida' 38.869 -6.244
Set-B 'Mirandilla' 38.892 -6.282
Set-B 'Trujillanos' 38.944 -6.297
Set-B 'San Pedro de Merida' 38.904 -6.319
Set-B 'Aljucen' 38.926 -6.416
Set-B 'Llerena' 38.236 -6.019
Set-B 'Puebla del Maestre' 38.189 -6.141
Set-B 'Trasierra' 38.186 -6.254
Set-B 'Granja de Torrehermosa' 38.352 -5.580
Set-B 'Peraleda del Zaucejo' 38.423 -5.499
Set-B 'Azuaga' 38.269 -5.675
Set-B 'Valverde de Llerena' 38.296 -5.974
Set-B 'Malcocinado' 38.242 -5.825
Set-B 'Berlanga' 38.282 -5.830
Set-B 'Maguilla' 38.314 -5.777
Set-B 'Ahillones' 38.318 -5.695
Set-B 'Villagarcia de la Torre' 38.353 -5.715
Set-B 'Casas de Reina' 38.185 -5.971
Set-B 'Reina' 38.181 -5.920
Set-B 'Fuente del Arco' 38.187 -5.899
Set-B 'Merida' 38.917 -6.340
Set-B 'Calamonte' 38.847 -6.352
Set-B 'Solana de los Barros' 38.637 -6.602
Set-B 'Torre de Miguel Sesmero' 38.608 -6.556
Set-B 'La Parra' 38.426 -6.448
Set-B 'Santa Marta de los Barros' 38.556 -6.447
Set-B 'Puebla de Obando' 39.033 -6.833
Set-B 'Novelda del Guadiana' 38.925 -6.720
Set-B 'San Francisco de Olivenza' 38.780 -6.912
Set-B 'Olivenza' 38.686 -7.102
Set-B 'La Albuera' 38.729 -6.839
Set-B 'Talavera la Real' 38.886 -6.745
Set-B 'Montijo' 38.912 -6.613
Set-B 'Pueblonuevo del Guadiana' 38.899 -6.588
Set-B 'Quintana de la Serena' 38.742 -5.673
Set-B 'Acedera' 38.962 -5.808
Set-B 'La Haba' 38.922 -5.867
Set-B 'Rena' 38.974 -5.744
Set-B 'Villar de Rena' 38.939 -5.722
Set-B 'Navalvillar de Pela' 38.985 -5.490
Set-B 'Orellana la Vieja' 38.969 -5.526
Set-B 'Orellana de la Sierra' 38.986 -5.541
Set-B 'Casas de Don Pedro' 39.131 -5.281
Set-B 'Alburquerque' 39.214 -7.000
Set-B 'Torremayor' 38.882 -6.479

Set-C 'Caceres' 39.476 -6.372
Set-C 'Miajadas' 39.152 -5.907
Set-C 'Madrigalejo' 39.128 -5.607
Set-C 'Logrosan' 39.340 -5.489
Set-C 'Cabanas del Castillo' 39.392 -5.461
Set-C 'Berzocana' 39.404 -5.516
Set-C 'Zorita' 39.297 -5.706
Set-C 'Valdemorales' 39.210 -6.120
Set-C 'Almoharin' 39.166 -5.966
Set-C 'Escurial' 39.135 -5.850
Set-C 'Canamero' 39.385 -5.414
Set-C 'Alia' 39.352 -5.218
Set-C 'Guadalupe' 39.452 -5.321
Set-C 'Alcuescar' 39.164 -6.187
Set-C 'Casas de Don Antonio' 39.199 -6.253
Set-C 'Valdesalor' 39.522 -6.430
Set-C 'Montanchez' 39.227 -6.152
Set-C 'Sierra de Fuentes' 39.411 -6.200
Set-C 'Torreorgaz' 39.370 -6.215
Set-C 'Torrequemada' 39.304 -6.207
Set-C 'Benquerencia' 39.247 -6.175
Set-C 'Torre de Santa Maria' 39.244 -6.064
Set-C 'Zarza de Montanchez' 39.177 -6.070
Set-C 'Casar de Caceres' 39.540 -6.398
Set-C 'Talavan' 39.645 -6.234
Set-C 'Aliseda' 39.425 -6.697
Set-C 'Santa Marta de Magasca' 39.401 -6.053
Set-C 'Trujillo' 39.461 -5.877
Set-C 'Madronera' 39.384 -5.766
Set-C 'Herguijuela' 39.352 -5.693
Set-C 'Conquista de la Sierra' 39.331 -5.571
Set-C 'Garciaz' 39.381 -5.682
Set-C 'Aldeacentenera' 39.398 -5.726
Set-C 'Torrecillas de la Tiesa' 39.419 -5.774
Set-C 'Santa Cruz de la Sierra' 39.417 -5.812
Set-C 'Robledillo de Trujillo' 39.450 -5.820
Set-C 'Abertura' 39.198 -5.841
Set-C 'Villamesias' 39.225 -5.869
Set-C 'Plasenzuela' 39.335 -5.862
Set-C 'Ruanes' 39.310 -5.899
Set-C 'Ibahernando' 39.290 -5.922
Set-C 'Navalmoral de la Mata' 39.890 -5.549
Set-C 'Talayuela' 39.858 -5.606
Set-C 'Bohonal de Ibor' 39.598 -5.464
Set-C 'Fresnedoso de Ibor' 39.566 -5.380
Set-C 'Valdecanas de Tajo' 39.639 -5.450
Set-C 'Villar del Pedroso' 39.674 -5.382
Set-C 'Valdelacasa de Tajo' 39.660 -5.372
Set-C 'Garvin' 39.662 -5.475
Set-C 'Peraleda de la Mata' 39.836 -5.457
Set-C 'Castanar de Ibor' 39.531 -5.394
Set-C 'Navalvillar de Ibor' 39.533 -5.352
Set-C 'Almaraz' 39.809 -5.698
Set-C 'Casas de Miravete' 39.703 -5.787
Set-C 'Deleitosa' 39.551 -5.668
Set-C 'Robledollano' 39.505 -5.533
Set-C 'Retamosa' 39.518 -5.658
Set-C 'Navezuelas' 39.508 -5.476
Set-C 'Jaraicejo' 39.737 -5.830
Set-C 'Saucedilla' 39.805 -5.730
Set-C 'Berrocalejo' 39.803 -5.471
Set-C 'Belvis de Monroy' 39.752 -5.627
Set-C 'Jaraiz de la Vera' 40.058 -5.678
Set-C 'Arroyomolinos de la Vera' 40.102 -5.720
Set-C 'Pasaron de la Vera' 40.141 -5.755
Set-C 'Garganta la Olla' 40.095 -5.732
Set-C 'Torremenga' 40.013 -5.760
Set-C 'Tejeda de Tietar' 40.139 -5.869
Set-C 'Cuacos de Yuste' 40.077 -5.697
Set-C 'Aldeanueva de la Vera' 40.043 -5.606
Set-C 'Jarandilla de la Vera' 40.132 -5.656
Set-C 'Guijo de Santa Barbara' 40.208 -5.635
Set-C 'Losar de la Vera' 40.095 -5.565
Set-C 'Villanueva de la Vera' 40.119 -5.581
Set-C 'Madrigal de la Vera' 40.141 -5.505
Set-C 'Valverde de la Vera' 40.173 -5.469
Set-C 'Talaveruela de la Vera' 40.154 -5.525
Set-C 'Viandar de la Vera' 40.179 -5.506
Set-C 'Robledillo de la Vera' 40.170 -5.522
Set-C 'Valencia de Alcantara' 39.415 -7.243
Set-C 'Santiago de Alcantara' 39.559 -7.105
Set-C 'Carbajo' 39.508 -7.061
Set-C 'Herrera de Alcantara' 39.562 -7.370
Set-C 'Cedillo' 39.583 -7.462
Set-C 'Serrejon' 39.840 -5.597
Set-C 'Majadas de Tietar' 39.822 -5.590
Set-C 'Serradilla' 39.835 -5.961
Set-C 'Mirabel' 39.875 -5.952
Set-C 'Herreruela' 39.508 -6.943
Set-C 'Salorino' 39.491 -7.050
Set-C 'Membrio' 39.534 -7.190
Set-C 'Toril' 39.830 -5.600
Set-C 'Casas de Millan' 39.742 -6.099
Set-C 'Plasencia' 40.031 -6.092
Set-C 'Cabezuela del Valle' 40.079 -5.968
Set-C 'Tornavacas' 40.185 -5.881
Set-C 'Jerte' 40.136 -5.855
Set-C 'Navaconcejo' 40.100 -5.916
Set-C 'Valdastillas' 40.070 -5.891
Set-C 'Piornal' 40.054 -5.857
Set-C 'Casas del Castanar' 40.063 -5.817
Set-C 'El Torno' 40.060 -5.797
Set-C 'Caminomorisco' 40.270 -6.290
Set-C 'Ladrillar' 40.292 -6.349
Set-C 'Nunomoral' 40.288 -6.374
Set-C 'Casares de las Hurdes' 40.285 -6.370
Set-C 'Pinofranqueado' 40.244 -6.516
Set-C 'Casar de Palomero' 40.262 -6.391
Set-C 'La Pesga' 40.073 -6.244
Set-C 'Ahigal' 40.093 -6.253
Set-C 'Palomero' 40.172 -6.261
Set-C 'Santa Cruz de Paniagua' 40.115 -6.254
Set-C 'Marchagaz' 40.122 -6.190
Set-C 'Cerezo' 40.119 -6.174
Set-C 'Mohedas de Granadilla' 40.189 -6.183
Set-C 'Guijo de Granadilla' 40.221 -6.109
Set-C 'Aceituna' 40.178 -6.313
Set-C 'Oliva de Plasencia' 40.116 -6.136
Set-C 'Carcaboso' 40.010 -6.176
Set-C 'Aldehuela de Jerte' 40.074 -6.091
Set-C 'Valdeobispo' 40.052 -6.109
Set-C 'Malpartida de Plasencia' 39.951 -6.146
Set-C 'Galisteo' 40.004 -6.147
Set-C 'Guijo de Galisteo' 40.016 -6.253
Set-C 'Riolobos' 39.959 -6.211
Set-C 'Torrejon el Rubio' 39.832 -5.975
Set-C 'Barrado' 40.071 -5.823
Set-C 'Hervas' 40.275 -5.855
Set-C 'Zarza de Granadilla' 40.197 -6.072
Set-C 'Villar de Plasencia' 40.189 -6.024
Set-C 'Cabezabellosa' 40.208 -6.021
Set-C 'Casas del Monte' 40.224 -5.937
Set-C 'Segura de Toro' 40.207 -5.920
Set-C 'Aldeanueva del Camino' 40.273 -5.907
Set-C 'Abadia' 40.241 -5.929
Set-C 'Gargantilla' 40.259 -5.942
Set-C 'Banos de Montemayor' 40.302 -5.862
Set-C 'La Garganta' 40.315 -5.899
Set-C 'Coria' 39.985 -6.533
Set-C 'Montehermoso' 40.068 -6.383
Set-C 'Villanueva de la Sierra' 40.127 -6.539
Set-C 'Pozuelo de Zarzon' 40.041 -6.504
Set-C 'Villa del Campo' 40.092 -6.452
Set-C 'Guijo de Coria' 40.100 -6.460
Set-C 'Calzadilla' 40.017 -6.588
Set-C 'Casas de Don Gomez' 40.033 -6.561
Set-C 'Portezuelo' 39.875 -6.421
Set-C 'Holguera' 39.955 -6.310
Set-C 'Torrejoncillo' 39.961 -6.482
Set-C 'Moraleja' 40.074 -6.653
Set-C 'Gata' 40.215 -6.567
Set-C 'Hoyos' 40.168 -6.741
Set-C 'Acebo' 40.225 -6.770
Set-C 'Villasbuenas de Gata' 40.221 -6.718
Set-C 'Santibanez el Alto' 40.214 -6.659
Set-C 'Torre de Don Miguel' 40.228 -6.618
Set-C 'Cadalso' 40.208 -6.630
Set-C 'Descargamaria' 40.238 -6.647
Set-C 'Robledillo de Gata' 40.192 -6.573
Set-C 'Hernan-Perez' 40.208 -6.576
Set-C 'Torrecilla de los Angeles' 40.235 -6.558
Set-C 'Ceclavin' 39.911 -6.612
Set-C 'Acehuche' 39.879 -6.567
Set-C 'Zarza la Mayor' 39.860 -6.809
Set-C 'Cachorrilla' 39.950 -6.685
Set-C 'Pescueza' 39.983 -6.657
Set-C 'Portaje' 39.999 -6.587
Set-C 'Valverde del Fresno' 40.227 -6.896
Set-C 'Eljas' 40.226 -6.903
Set-C 'Trevejo' 40.236 -6.848
Set-C 'Villamiel' 40.245 -6.857
Set-C 'Cilleros' 40.087 -6.791
Set-C 'Perales del Puerto' 40.155 -6.759
Set-C 'Malpartida de Caceres' 39.443 -6.521
Set-C 'Garrovillas de Alconetar' 39.584 -6.551
Set-C 'Villa del Rey' 39.668 -6.688
Set-C 'Alcantara' 39.689 -6.884

function Strip($s) {
    $r = $s
    $r = $r.Replace([char]0x00E1,'a').Replace([char]0x00E9,'e').Replace([char]0x00ED,'i').Replace([char]0x00F3,'o').Replace([char]0x00FA,'u')
    $r = $r.Replace([char]0x00C1,'A').Replace([char]0x00C9,'E').Replace([char]0x00CD,'I').Replace([char]0x00D3,'O').Replace([char]0x00DA,'U')
    $r = $r.Replace([char]0x00F1,'n').Replace([char]0x00D1,'N')
    return $r
}

$html = [System.IO.File]::ReadAllText('C:\Users\pichi\extremadura_mapa_zonas.html')
$actualizados = 0

# Extraer cada entrada del array con un enfoque mas robusto
# Buscar todas las ocurrencias de prov: en el contexto del array municipios
$startMun = $html.IndexOf('const municipios')
$endMun   = $html.IndexOf('];', $startMun)
$bloque   = $html.Substring($startMun, $endMun - $startMun)

# Regex para cada entrada - usando comillas simples dentro de dobles para evitar problemas de PS
$patStr = "\{prov:'([^']+)',\s+mun:'([^']+)',\s+cp:'[^']+',\s+dist:\d+,\s+zona:'[^']+',\s+lat:([\d.\-]+),\s+lon:([\d.\-]+)"
$matches2 = [regex]::Matches($bloque, $patStr)
Write-Host "Entradas encontradas en bloque municipios: $($matches2.Count)"

foreach ($m in $matches2) {
    $provRaw = $m.Groups[1].Value
    $munRaw  = $m.Groups[2].Value
    $latOld  = [double]::Parse($m.Groups[3].Value, [System.Globalization.CultureInfo]::InvariantCulture)
    $lonOld  = [double]::Parse($m.Groups[4].Value, [System.Globalization.CultureInfo]::InvariantCulture)

    $prov = Strip $provRaw
    $mun  = Strip $munRaw
    $key  = "$prov|$mun"

    if ($coords.ContainsKey($key)) {
        $c = $coords[$key]
        $latNew = $c.lat
        $lonNew = $c.lon
        $diffLat = [Math]::Abs($latOld - $latNew)
        $diffLon = [Math]::Abs($lonOld - $lonNew)
        if ($diffLat -gt 0.05 -or $diffLon -gt 0.05) {
            # Reemplazar lat y lon en la cadena original
            $viejo = "lat:$($m.Groups[3].Value), lon:$($m.Groups[4].Value)"
            $nuevo = "lat:$latNew, lon:$lonNew"
            # Solo reemplazar si el contexto incluye el municipio correcto
            $contexto = $m.Value
            $htmlNew = $html.Replace($contexto, $contexto.Replace($viejo, $nuevo))
            if ($htmlNew -ne $html) {
                $html = $htmlNew
                $actualizados++
                Write-Host "  [$prov] $munRaw : lat=$latOld,lon=$lonOld -> lat=$latNew,lon=$lonNew"
            }
        }
    }
}

[System.IO.File]::WriteAllText('C:\Users\pichi\extremadura_mapa_zonas.html', $html, [System.Text.UTF8Encoding]::new($false))
Write-Host ""
Write-Host "Coordenadas actualizadas: $actualizados"
