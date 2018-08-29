using Toybox.System as Sys;

class LanguagePlateNL {
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
    
	function selectTimeWords(hours, minutes) {
	    var clockTime = Sys.getClockTime();
		var timeWords = [];
		timeWords.add("het");
		timeWords.add("is");
		
		// Round the minutes to a multiple og five
		var t = minutes % 5;
		if (t <= 2) {
			minutes -= t;
			if (t == 0) {
				timeWords.add("nu");
			} else {
				timeWords.add("geweest");
			}
		} else {
			minutes += 5 - t;
			timeWords.add("bijna");
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
		timeWords.add(hourNames[hours]);
	
		switch (minutes) {
		case 0:
			timeWords.add("uur");
			break;
	
		case 30:
			timeWords.add("half");
			break;
	
		case 15:
		case 45:
			timeWords.add("kwart");
			break;
	
		case 25:
		case 35:
			timeWords.add("half");
		case 5:
		case 55:
			timeWords.add("vijf_min");
			break;
			
		case 20:
		case 40: 
			timeWords.add("half");
		case 10:
		case 50:
			timeWords.add("tien_min");
			break;
		}
		
		if ((minutes > 0 && minutes <= 15) ||
			(minutes > 30 && minutes <= 40)){
			timeWords.add("over");
		} 
		if ((minutes > 15 && minutes < 30) ||
			(minutes >= 45 && minutes <= 55)){
			timeWords.add("voor");
		}
		return timeWords;
	}
		
	
}