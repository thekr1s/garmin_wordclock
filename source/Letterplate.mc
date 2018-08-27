using Toybox.System as Sys;


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
    	case 1:
    		font = WatchUi.loadResource(Rez.Fonts.arialBlackFont);
    		break;
    	case 2:
    		font = Graphics.FONT_SMALL;
    		break;
    	default:
	    	font = WatchUi.loadResource(Rez.Fonts.taurusFont);
	    	break;
	    }
    	
    	fgColor = Application.getApp().getProperty("HighlightColor");
    	iaColor = Application.getApp().getProperty("InactiveColor");
    	bgColor = Application.getApp().getProperty("BackgroundColor");
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

		clearSelectedWords();
		var timeWords = languagePlate.selectTimeWords(hours, minutes);
		for (var i = 0; i < timeWords.size(); i++) {
			selectWord(timeWords[i]);
		}
        dc.setColor(bgColor, bgColor);
        dc.clear();
		
		for (var li = 0; li < height; li++) { // LineIndex
			var posX = marginPixels + charSpaceX / 2;
			for (var ci = 0; ci < width; ci++) { // CharacterIndex
				var s = languagePlate.letters[li].substring(ci,ci + 1);
				if (isHighlighted(li, ci)) {
					dc.setColor(fgColor, bgColor);
				} else {
					dc.setColor(iaColor, bgColor);
				}
				dc.drawText(posX, posY, font, s, Graphics.TEXT_JUSTIFY_CENTER);
				posX += charSpaceX;
			}
			posY += charSpaceY;
		}
	}
}