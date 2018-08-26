using Toybox.System as Sys;


class LetterplateEN {
	const width = 11;
	const height = 11;
	const marginPixels = 20;
	const letters = [
		"SIT'SEJUSTW",
		"PASTALMOSTO",
		"HALFQUARTER",
		"ITWENTYFIVE",
		"TENTPASTOSE",
		"STWONELEVEN",
		"THREEIGHTEN",
		"ISEVENINEXT",
		"FOURFIVESIX",
		"YTWELVERMWE",
		"AGO'CLOCKRW"
		];
		
	const NAME_IDX = 0;
	const ROW_IDX = 1;
	const COL_IDX = 2;
	const WIDTH_IDX = 3;
	const klockWords_11x11 = [  
		["it",  10, 1, 2],
		["is",  10, 3, 2],
		["just",  10, 6, 4],
		["past_min",  9, 0, 4],
		["almost",  9, 4, 6],
		["five_min",  7, 7, 4],
		["ten_min",  6, 0, 3],
		["a",  8, 1, 1],
		["quarter",  8, 4, 7],
		["twenty",  7, 1, 6],
		["half",  8, 0, 4],
		["to",  6, 7, 2],
		["past",  6, 4, 4],
		


		["one",  5, 3, 3],
		["two",  5, 1, 3],
		["three",  4, 0, 5],
		["four",  2, 0, 4],
		["five",  2, 4, 4],
		["six",  2, 8, 3],
		["seven",  3, 1, 5],
		["eight",  4, 4, 5],
		["nine",  3, 5, 4],
		["ten",  4, 8, 3],
		["eleven",  5, 5, 6],
		["twelve",  1, 1, 6],	
		
		["oclock",  0, 2, 7],	

		["by",  1, 8, 2],
		["rmw",  0, 8, 3],
		
		["",0,0,0]
	];		
	const hourNames = [
		"twelve",
		"one",
		"two",
		"three",
		"four",
		"five",
		"six",
		"seven",
		"eight",
		"nine",
		"ten",
		"eleven",
		"twelve"
	];
	var highlightedWords = [0, 1, 2, 6, 9, 10, -1];
    var fgColor = null;
    var iaColor = null;
    var bgColor = null;
    var font = null;
    
    function applySettings() {
    	var fontSelection = Application.getApp().getProperty("Font");
    	if (fontSelection == null) {
    		fontSelection = 0;
    	}
    	
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
	
	function selectTimeWords(hours, minutes) {
	    var clockTime = Sys.getClockTime();
	
		selectWord("it");
		selectWord("is");
		
		// Round the minutes to a multiple og five
		var t = minutes % 5;
		if (t <= 2) {
			minutes -= t;
			if (t != 0) {
				selectWord("just");
				selectWord("past_min");
			}
		} else {
			minutes += 5 - t;
			selectWord("almost");
			if (minutes == 60){
				minutes = 0;
				hours += 1;
				hours %= 12;
			}
		}
	
		// Display the current hour up to quarter past... After that show the next hour
		if (minutes > 30) {
			hours += 1;
		}
	
		hours %= 12;
		selectWord(hourNames[hours]);
	
		switch (minutes) {
		case 0:
			selectWord("oclock");
			break;
	
		case 30:
			selectWord("half"); 
			break;
	
		case 15:
		case 45:
			selectWord("a");
			selectWord("quarter");
			break;
	
		case 25:
		case 35:
			selectWord("twenty");
		case 5:
		case 55:
			selectWord("five_min");
			break;
			
		case 20:
		case 40: 
			selectWord("twenty");
			break;
			
		case 10:
		case 50:
			selectWord("ten_min");
			break;
		}
		
		if (minutes > 0 && minutes <= 30){
			selectWord("past");
		} else if (minutes > 30 ){
			selectWord("to");
		}
	}
		
	
	function drawTime(dc, hours, minutes) {
		var charSpaceX = (dc.getWidth() - 2 * marginPixels) / 11;
		var charSpaceY = (dc.getHeight() - 2 * marginPixels) / 11;
		var posY = marginPixels + charSpaceY / 2;

		clearSelectedWords();
		selectTimeWords(hours, minutes);
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