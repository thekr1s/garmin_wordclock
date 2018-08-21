using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class WatchFaceApp extends App.AppBase {

	var watchFaceView = null;
	
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    	watchFaceView = new WatchFaceView();
        return [ watchFaceView ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
    	watchFaceView.settingsChanged();
        Ui.requestUpdate();
    }

}