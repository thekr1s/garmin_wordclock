using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;

class WatchFaceView extends Ui.WatchFace {
	var customFont = null;
	var letterplate = null;
	
    function initialize() { 
        WatchFace.initialize();
        settingsChanged();
        
    }

    // Load your resources here
    function onLayout(dc) {
//        customFont = Ui.loadResource(Rez.Fonts.taurusFont);
//        setLayout(Rez.Layouts.WatchFace(dc));                
//        var view = View.findDrawableById("HetIs");
//        view.setFont(customFont);
//        view = View.findDrawableById("Bijna");
//        view.setFont(customFont);
//        view = View.findDrawableById("Een");
//        view.setFont(customFont);
//        view = View.findDrawableById("Uur");
//        view.setFont(customFont);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    
    }

	var hours = 0;
	var minutes = 0;
	var demonstrationMode = false;

    // Update the view
    function onUpdate(dc) {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = Sys.getClockTime();
        
        if (demonstrationMode) {
//	        Sys.println("demonstrationMode");
			if (hours < 12) { hours += 1;}
			else {minutes += 1;}
			
			if (minutes == 60) {
				hours = 0;
				minutes = 0;
			}
        } else {
//	        Sys.println("no demonstrationMode");
	        hours = clockTime.hour;
	        minutes = clockTime.min;
		}
				
        // Call the parent onUpdate function to redraw the layout
        letterplate.drawTime(dc, hours, minutes);
//        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

	function settingsChanged() {
		var language = Application.getApp().getProperty("Language");
		switch (language) {
		case 0:
			letterplate = new LetterplateNL();
			break;
		case 1:
			letterplate = new LetterplateEN();
			break;
		default:
			break;
		}
		demonstrationMode = Application.getApp().getProperty("DemonstrationMode");
		hours = 0;
		minutes = 0;
		
		letterplate.applySettings();
	}
}
