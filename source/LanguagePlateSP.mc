using Toybox.System as Sys;


class LanguagePlateSP {

	const letters = [
		"AESONBLASCD",
		"UNADOSATRES",
		"CUATROCINCO",
		"SEISBSIETEC",
		"OCHONUEVEPM",
		"LADIEZSONCE",
		"DOCEDYMENOS",
		"EVEINTEDIEZ",
		"VEINTICINCO",
		"VBCUARTOMMR",
		"GFTMEDIAEGL"
		];

	const klockWords_11x11 = [  
		["es",  10, 1, 2],
		["son",  10, 2, 3],
		["la",  10, 6, 2],
		["las",  10, 6, 3],
		["y",  4, 5, 1],
		["menos",  4, 6, 5],
		["ten",  3, 7, 4],
		["veinte",  3, 1, 6],
		["veinticinco",  2, 0, 11],
		["five",  2, 6, 5],
		["media",  0, 3, 5],
		["cuarto",  1, 2, 6],

		["una",  9, 0, 3],
		["dos",  9, 3, 3],
		["tres",  9, 7, 4],
		["cuatro",  8, 0, 6],
		["cinco",  8, 6, 5],
		["seis",  7, 0, 4],
		["siete",  7, 5, 5],
		["ocho",  6, 0, 4],
		["nueve",  6, 4, 5],
		["diez",  5, 2, 4],
		["once",  5, 7, 4],
		["doce",  4, 0, 4],	
		
		["mmr",  0, 8, 3],
		
		["",0,0,0]
	];		
	const hourNames = [
		"doce",
		"una",
		"dos",
		"tres",
		"cuatro",
		"cinco",
		"seis",
		"siete",
		"ocho",
		"nueve",
		"diez",
		"once",
		"doce"
	];

	function selectTimeWords(hours, minutes) {
	    var clockTime = Sys.getClockTime();
		
		var timeWords = [];

		//Round the minutes to a multiple og five
		var t = minutes % 5;
		if (t <= 2) {
			minutes -= t;
			if (t != 0) {
			}
		} else {
			minutes += 5 - t;
			if (minutes == 60){
				minutes = 0;
				hours += 1;
				hours %= 12;
			}
		}

		if (minutes <= 30) {
		hours %= 12;
		if (hours == 1) {
			timeWords.add("es");
			timeWords.add("la");
		} else {
		timeWords.add("son");
		timeWords.add("las");
		}
		timeWords.add(hourNames[hours]);
		switch (minutes) {
		
		case 0:
		break;
		
		case 5:
		timeWords.add("y");
		timeWords.add("five");
		break;
		
		case 10:
		timeWords.add("y");
		timeWords.add("ten");
		break;	
		
		case 15:
		timeWords.add("y");
		timeWords.add("cuarto");
		break;			

		case 20:
		timeWords.add("y");
		timeWords.add("veinte");
		break;

		case 25:
		timeWords.add("y");
		timeWords.add("veinticinco");
		break;

		case 30:
		timeWords.add("y");
		timeWords.add("media");
		break;
		}
	}

		if (minutes > 30) {
			hours += 1;
	
		hours %= 12;
		if (hours == 1) {
			timeWords.add("es");
			timeWords.add("la");
		} else {
		timeWords.add("son");
		timeWords.add("las");
		}
		timeWords.add(hourNames[hours]);
	
		switch (minutes) {
	
		case 35:
		timeWords.add("menos");
		timeWords.add("veinticinco");
		break;
	
		case 40:
		timeWords.add("menos");
		timeWords.add("veinte");
		break;
	
		case 45:
		timeWords.add("menos");
		timeWords.add("cuarto");
		break;

		case 50:
		timeWords.add("menos");
		timeWords.add("ten");
		break;
			
		case 55:
		timeWords.add("menos");
		timeWords.add("five");
		break;
		}
		}
		return timeWords;
	}
		
}