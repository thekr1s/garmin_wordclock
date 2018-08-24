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
        letterplate = new LetterplateEN();
        letterplate.applySettings();
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

    // Update the view
    function onUpdate(dc) {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;

        if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (App.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Update the view
//        var view = View.findDrawableById("TimeLabel");
//        view.setColor(App.getApp().getProperty("ForegroundColor"));
//        view.setText(timeString + "U");
		
        // Call the parent onUpdate function to redraw the layout
        letterplate.drawTime(dc);
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
		letterplate.applySettings();
	}
}
