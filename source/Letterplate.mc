using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class Letterplate {
	const width = 11;
	const height = 11;
	const marginPixels = 20;

	const NAME_IDX = 0;
	const ROW_IDX = 1;
	const COL_IDX = 2;
	const WIDTH_IDX = 3;

	var highlightedWords = [0, 1, 2, 6, 9, 23, -1];
    var fgColor = null;
    var iaColor = null;
    var bgColor = null;
    var font = null;
    
    var languagePlate = null;
    var showBattery = true;
    
    function applySettings() {
    	var fontSelection = Application.getApp().getProperty("Font");
    	if (fontSelection == null) {
    		fontSelection = 0;
    	}
    	var language = Application.getApp().getProperty("Language");
		switch (language) {
		case 0:
			languagePlate = new LanguagePlateNL();
			break;
		case 1:
		default:
			languagePlate = new LanguagePlateEN();
			break;
		}
    	
//    	Sys.println(fontSelection);
    	switch (fontSelection) {
    	case 0:
	    	font = WatchUi.loadResource(Rez.Fonts.taurusFont);
	    	break;
    	case 2:
    		font = WatchUi.loadResource(Rez.Fonts.arialBlackFont);
    		break;
    	case 3:
    		font = WatchUi.loadResource(Rez.Fonts.arialBlackXLFont);
    		break;
    	case 4:
    		font = Graphics.FONT_SYSTEM_XTINY;
    		break;
    	case 5:
    		font = Graphics.FONT_SYSTEM_TINY;
    		break;
    	case 6:
    		font = Graphics.FONT_SYSTEM_SMALL;
    		break;
    	default:
	    	font = WatchUi.loadResource(Rez.Fonts.taurusXLFont);
	    	break;
	    }
    	
    	fgColor = Application.getApp().getProperty("HighlightColor");
    	iaColor = Application.getApp().getProperty("InactiveColor");
    	bgColor = Application.getApp().getProperty("BackgroundColor");
    	showBattery = Application.getApp().getProperty("BatteryStatus");
    	
    }
    
	function isHighlighted(row, col) {
		row = height - 1 - row; // invert row, that's how it is.....
		var highlightedWordIdx = 0;
		var wordIdx = highlightedWords[highlightedWordIdx];
		
		while (wordIdx != -1) {			
			if (languagePlate.klockWords_11x11[wordIdx][ROW_IDX] == row) { 
				if (col >= languagePlate.klockWords_11x11[wordIdx][COL_IDX]) {
					if (col < languagePlate.klockWords_11x11[wordIdx][COL_IDX] + languagePlate.klockWords_11x11[wordIdx][WIDTH_IDX]) {
						return true;
					}
				}
			}
			highlightedWordIdx++;
			wordIdx = highlightedWords[highlightedWordIdx]; 
		}
		return false;
	}
	function clearSelectedWords() {
		highlightedWords = [-1];
	}
	
	function selectWord(word){
		var idx = 0;
		var w = languagePlate.klockWords_11x11[idx];
		var found = false;
		while (!found and !w[NAME_IDX].equals("")) {
			if (w[NAME_IDX].equals(word)) {
				found = true;
			} else {
				idx++;
				w = languagePlate.klockWords_11x11[idx];
			}
		}
		if (found) {
			highlightedWords[highlightedWords.size() - 1] = idx;
			highlightedWords.add(-1);
		} 
	}
	
	function drawTime(dc, hours, minutes) {
		var charSpaceX = (dc.getWidth() - 2 * marginPixels) / 11;
		var charSpaceY = (dc.getHeight() - 2 * marginPixels) / 11;
		var posY = marginPixels + charSpaceY / 2;

        dc.setColor(bgColor, bgColor);
        dc.clear();
        dc.setColor(iaColor, bgColor);
		
		clearSelectedWords();
		var timeWords = languagePlate.selectTimeWords(hours, minutes);
		for (var i = 0; i < timeWords.size(); i++) {
			selectWord(timeWords[i]);
		}
		for (var li = 0; li < height; li++) { // LineIndex
			var posX = marginPixels + charSpaceX / 2;
			for (var ci = 0; ci < width; ci++) { // CharacterIndex
				var s = languagePlate.letters[li].substring(ci,ci + 1);
				if (isHighlighted(li, ci)) {
					dc.setColor(fgColor, Gfx.COLOR_TRANSPARENT);
				} else {
					dc.setColor(iaColor, Gfx.COLOR_TRANSPARENT);
				}
				dc.drawText(posX, posY, font, s, Graphics.TEXT_JUSTIFY_CENTER);
				posX += charSpaceX;
			}
			posY += charSpaceY;
		}

		if (showBattery) {
			drawBattery(dc, iaColor, fgColor);
		}
	}
	
	const batt_width_rect = 40;
    const batt_height_rect = 10;
    const batt_width_rect_small = 3;
    const batt_height_rect_small = 5;
    const batt_y = 10;
	
	function drawBattery(dc, primaryColor, lowBatteryColor)
    {
        var battery = Sys.getSystemStats().battery;
        //set battery icon position
        var batt_x = (dc.getWidth() / 2) - (batt_width_rect/2) - (batt_width_rect_small/2);
        var batt_x_small = batt_x + batt_width_rect;
        var batt_y_small = batt_y + ((batt_height_rect - batt_height_rect_small) / 2);
        
        if(battery <= 20.0)
        {
            primaryColor = lowBatteryColor;
        }

        dc.setColor(primaryColor, Gfx.COLOR_TRANSPARENT);
        dc.drawRectangle(batt_x, batt_y, batt_width_rect, batt_height_rect);
        dc.setColor(bgColor, Gfx.COLOR_TRANSPARENT);
        dc.drawLine(batt_x_small-1, batt_y_small+1, batt_x_small-1, batt_y_small + batt_height_rect_small-1);

        dc.setColor(primaryColor, Gfx.COLOR_TRANSPARENT);
        dc.drawRectangle(batt_x_small, batt_y_small, batt_width_rect_small, batt_height_rect_small);
        dc.setColor(bgColor, Gfx.COLOR_TRANSPARENT);
        dc.drawLine(batt_x_small, batt_y_small+1, batt_x_small, batt_y_small + batt_height_rect_small-1);

        dc.setColor(primaryColor, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(batt_x, batt_y, (batt_width_rect * battery / 100), batt_height_rect);
        if(battery == 100.0)
        {
            dc.fillRectangle(batt_x_small, batt_y_small, batt_width_rect_small, batt_height_rect_small);
        }
    }
	
}