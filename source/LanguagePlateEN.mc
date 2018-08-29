using Toybox.System as Sys;


class LanguagePlateEN {

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

	function selectTimeWords(hours, minutes) {
	    var clockTime = Sys.getClockTime();
		
		var timeWords = [];
		
		timeWords.add("it");
		timeWords.add("is");
		
		// Round the minutes to a multiple og five
		var t = minutes % 5;
		if (t <= 2) {
			minutes -= t;
			if (t != 0) {
				timeWords.add("just");
				timeWords.add("past_min");
			}
		} else {
			minutes += 5 - t;
			timeWords.add("almost");
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
		timeWords.add(hourNames[hours]);
	
		switch (minutes) {
		case 0:
			timeWords.add("oclock");
			break;
	
		case 30:
			timeWords.add("half"); 
			break;
	
		case 15:
		case 45:
			timeWords.add("a");
			timeWords.add("quarter");
			break;
	
		case 25:
		case 35:
			timeWords.add("twenty");
		case 5:
		case 55:
			timeWords.add("five_min");
			break;
			
		case 20:
		case 40: 
			timeWords.add("twenty");
			break;
			
		case 10:
		case 50:
			timeWords.add("ten_min");
			break;
		}
		
		if (minutes > 0 && minutes <= 30){
			timeWords.add("past");
		} else if (minutes > 30 ){
			timeWords.add("to");
		}
		return timeWords;
	}
		
}