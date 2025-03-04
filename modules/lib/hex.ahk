AreRGBsSimiliar(colorR, colorG, colorB, expectedR, expectedB, expectedG, tolerance)
{
	differenceR := Abs(colorR - expectedR)
	differenceG := Abs(colorG - expectedG)
	differenceB := Abs(colorB - expectedB)

	if ((differenceR <= tolerance) and (differenceG <= tolerance) and (differenceB <= tolerance)){
		return True
	}
}

HexToRGB(hex, hexValues)
{
    if (SubStr(hex, 1, 1) = "#")
        hex := SubStr(hex, 2)
    else if (SubStr(hex, 1, 2) = "0x")
        hex := SubStr(hex, 3)
		
    rHex := SubStr(hex, 1, 2)
	gHex := SubStr(hex, 3, 2)
	bHex := SubStr(hex, 5, 2)

	; Tworzymy obiekt dla wartości hex
    
    ; Rozdzielamy na dwie cyfry
	digit1r := SubStr(rHex, 1, 1)
	digit2r := SubStr(rHex, 2, 1)
    
	digit1g := SubStr(gHex, 1, 1)
	digit2g := SubStr(gHex, 2, 1)
    
	digit1b := SubStr(bHex, 1, 1)
	digit2b := SubStr(bHex, 2, 1)

	if not (RegExMatch(digit1r, "^[0-9]$"))
		digit1r := hexValues[digit1r]
	
	if not (RegExMatch(digit2r, "^[0-9]$"))
		digit2r := hexValues[digit2r]
	
	if not (RegExMatch(digit1g, "^[0-9]$"))
		digit1g := hexValues[digit1g]
	
	if not (RegExMatch(digit2g, "^[0-9]$"))
		digit2g := hexValues[digit2g]
	
	if not (RegExMatch(digit1b, "^[0-9]$"))
		digit1b := hexValues[digit1b]
	
	if not (RegExMatch(digit2g, "^[0-9]$"))
		digit2b := hexValues[digit2b]
	
	; Obliczenie wartości dziesiętnej
	r := digit1r * 16 + digit2r
	g := digit1g * 16 + digit2g
	b := digit1b * 16 + digit2b

    ; Zwracamy obiekt zawierający wartości RGB
    return {r: r, g: g, b: b}
}