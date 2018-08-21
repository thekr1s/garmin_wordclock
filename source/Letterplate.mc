using Toybox.System as Sys;


class Letterplate {
	const width = 11;
	const height = 11;
	const marginPixels = 20;
	const letters = [
		"HETLISEBYNA",
		"NUSKWARTIEN",
		"VIJFXRVOORN",
		"OVERQZHALFD",
		"ZESTWAALFSE",
		"DRIEVIEREEN",
		"TWEEEWACHTR",
		"ZEVENEGENBM",
		"TIENELFVIJF",
		"CUURLBYPRMW",
		"ALGEWEESTKP"
		];
		
	const NAME_IDX = 0;
	const ROW_IDX = 1;
	const COL_IDX = 2;
	const WIDTH_IDX = 3;
	const klockWords_11x11 = [  
		["het",  10, 0, 3],
		["is",  10, 4, 2],
		["vijf_min",  8, 0, 4],
		["tien_min",  9, 7, 4],
		["kwart",  9, 3, 5],
		["half",  7, 6, 4],
		["voor",  8, 6, 4],
		["over",  7, 0, 4],


		["een",  5, 8, 3],
		["twee",  4, 0, 4],
		["drie",  5, 0, 4],
		["vier",  5, 4, 4],
		["vijf",  2, 7, 4],
		["zes",  6, 0, 3],
		["zeven",  3, 0, 5],
		["acht",  4, 6, 4],
		["negen",  3, 4, 5],
		["tien",  2, 0, 4],
		["elf",  2, 4, 3],
		["twaalf",  6, 3, 6],	
		
		["uur",  1, 1, 3],	

		["bijna",  10, 7, 4],	
		["nu",  9, 0, 2],	
		["geweest",  0, 2, 7],	


		["wacht",  4, 5, 5],
		["even",  3, 1, 4],

		["by",  1, 5, 2],
		["rmw",  1, 8, 3],
		
		["he",  10, 0, 2],
		["lise",  10, 3, 4],
		["en",  9, 9, 2],
		["ha",  7, 3, 2],
		["evi",  5, 3, 3],


		["am",  0, 0, 1],
		["pm",  0, 10, 1],  

		
		["",0,0,0]
	];		
	const hourNames = [
		"twaalf",
		"een",
		"twee",
		"drie",
		"vier",
		"vijf",
		"zes",
		"zeven",
		"acht",
		"negen",
		"tien",
		"elf",
		"twaalf"
	];
	var highlightedWords = [0, 1, 2, 6, 9, 23, -1];
    var fgColor = null;
    var iaColor = null;
    var bgColor = null;
    var font = null;
    
    function applySettings() {
    	var fontSelection = Application.getApp().getProperty("Font");
    	if (fontSelection == null) {
    		fontSelection = 0;
    	}
    	Sys.println(fontSelection);
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
			if (klockWords_11x11[wordIdx][ROW_IDX] == row) { 
				if (col >= klockWords_11x11[wordIdx][COL_IDX]) {
					if (col < klockWords_11x11[wordIdx][COL_IDX] + klockWords_11x11[wordIdx][WIDTH_IDX]) {
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
		var w = klockWords_11x11[idx];
		var found = false;
		while (!found and !w[NAME_IDX].equals("")) {
			if (w[NAME_IDX].equals(word)) {
				found = true;
			} else {
				idx++;
				w = klockWords_11x11[idx];
			}
		}
		if (found) {
			highlightedWords[highlightedWords.size() - 1] = idx;
			highlightedWords.add(-1);
		} 
	}
	
	function selectCurrentTimeWords() {
	    var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;
        var minutes = clockTime.min;
	
		selectWord("het");
		selectWord("is");
		
		// Round the minutes to a multiple og five
		var t = minutes % 5;
		if (t <= 2) {
			minutes -= t;
			if (t == 0) {
				selectWord("nu");
			} else {
				selectWord("geweest");
			}
		} else {
			minutes += 5 - t;
			selectWord("bijna");
			if (minutes == 60){
				minutes = 0;
				hours += 1;
				hours %= 12;
			}
		}
	
		// Display the current hour up to quarter past... After that show the next hour
		if (minutes > 15) {
			hours += 1;
		}
	
		hours %= 12;
		selectWord(hourNames[hours]);
	
		switch (minutes) {
		case 0:
			selectWord("uur");
			break;
	
		case 30:
			selectWord("half");
			break;
	
		case 15:
		case 45:
			selectWord("kwart");
			break;
	
		case 25:
		case 35:
			selectWord("half");
		case 5:
		case 55:
			selectWord("vijf_min");
			break;
			
		case 20:
		case 40: 
			selectWord("half");
		case 10:
		case 50:
			selectWord("tien_min");
			break;
		}
		
		if ((minutes > 0 && minutes <= 15) ||
			(minutes > 30 && minutes <= 40)){
			selectWord("over");
		} 
		if ((minutes > 15 && minutes < 30) ||
			(minutes >= 45 && minutes <= 55)){
			selectWord("voor");
		}
	}
		
	
	function drawTime(dc) {
		var charSpaceX = (dc.getWidth() - 2 * marginPixels) / 11;
		var charSpaceY = (dc.getHeight() - 2 * marginPixels) / 11;
		var posY = marginPixels + charSpaceY / 2;

		clearSelectedWords();
		selectCurrentTimeWords();
        dc.setColor(bgColor, bgColor);
        dc.clear();
		
		for (var li = 0; li < height; li++) { // LineIndex
			var posX = marginPixels + charSpaceX / 2;
			for (var ci = 0; ci < width; ci++) { // CharacterIndex
				var s = letters[li].substring(ci,ci + 1);
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