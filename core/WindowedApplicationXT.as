package core
{
	import adobe.utils.ProductManager;
	
	import com.LogFile;
	import com.data.Cookie;
	import com.events.NativeMenuEvent;
	import com.prosteps.Dialog;
	
	import dialogs.About;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.NotificationType;
	import flash.desktop.SystemTrayIcon;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindowDisplayState;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.events.NativeWindowDisplayStateEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import mx.controls.Image;
	import mx.core.WindowedApplication;
	import mx.events.AIREvent;
	import mx.events.FlexEvent;
	
	import utils.FileUtils;
	import utils.WindowUtils;
	
	import xt.menu.NativeMenuXT;
	
	/**
	 * Fired when the user selects a menu item from either the tray menu or the main menu
	 * */
	[Event(name="menuSelect", type="com.events.NativeMenuEvent")]
	
	/**
	 * Fired when the source for the main menu is changed
	 * */
	[Event(name="mainMenuChanged", type="flash.events.Event")]
	
	/**
	 * Fired when the source for the tray menu is changed
	 * */
	[Event(name="trayMenuChanged", type="flash.events.Event")]
	
	/**
	 * Fired when the tooltip for the tray menu is changed
	 * */
	[Event(name="trayTooltipChanged", type="flash.events.Event")]
	
	/**
	 * Fired when the icon for the tray menu is changed
	 * */
	[Event(name="trayIconChanged", type="flash.events.Event")]
	
	
	
	/**
	 * Fired when the application is run for the first time
	 * */
	[Event(name="firstLaunched", type="flash.events.Event")]
	
	/**
	 * Fired when the application is recently updated
	 * */
	[Event(name="versionUpdated", type="flash.events.Event")]
	
	
	
	/**
	 * Pass the stage.keyDown event to the application
	 * */
	[Event(name="stageKeyDown", type="flash.events.KeyboardEvent")]
	
	/**
	 * Pass the stage.keyUp event to the application
	 * */
	[Event(name="stageKeyUp", type="flash.events.KeyboardEvent")]
	
	
	/**
	 * Fired when the native window is hidden 
	 * */
	[Event(name="docked", type="flash.events.Event")]
	
	/**
	 * Fired when the native window is shown 
	 * */
	[Event(name="undocked", type="flash.events.Event")]
	
	
	public class WindowedApplicationXT extends WindowedApplication
	{
		
		/**
		 * When opening/closing the application, restore the window to it's values from previous close (if exist and valid)
		 * */
		[Inspectable(category="Core")]
		[Bindable] public var rememberWindowState:Boolean = true;
		
		
		
		/**
		 * Object containing all the parameters from the first encountered settings XML file
		 * */
		[Bindable] public var applicationSettingRaw:Object;
		
		/**
		 * Object containing all the parameters from the first encountered settings XML file
		 * */
		[Bindable] public var applicationSettings:ApplicationSettings;
		
		
		
		
		
		private var _applicationId:String = '';				// required
		private var _applicationVersion:String = '';		// required
		private var _applicationFilename:String = '';		// required
		private var _applicationName:String = '';			// optional
		private var _applicationDescription:String = '';	// optional
		private var _applicationCopyright:String = '';		// optional
		
		
		/**
		 * Values from application descriptor file
		 * */
		public function get applicationId():String {				return _applicationId;	}
		public function get applicationVersion():String {		return _applicationVersion;	}
		public function get applicationFilename():String {		return _applicationFilename;	}
		public function get applicationName():String {			return _applicationName;	}
		public function get applicationDescription():String {	return _applicationDescription;	}
		public function get applicationCopyright():String {		return _applicationCopyright;	}
		
		
		
		
		
		public function WindowedApplicationXT()
		{
			super();
			addEventListener(FlexEvent.APPLICATION_COMPLETE, onApplicationComplete, false, 0, true);
			addEventListener(Event.CLOSING, onClosing, false, 0, true);
			addEventListener(Event.CLOSE, onClose, false, 0, true);
			addEventListener(Event.NETWORK_CHANGE, onNetworkChange, false, 0, true);
			
			addEventListener(MouseEvent.MOUSE_DOWN, setFocusOnOpenWindow, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OVER, setFocusOnOpenWindow, false, 0, true);
			//addEventListener(AIREvent.APPLICATION_ACTIVATE, setFocusOnOpenWindow, false, 0, true);
			//addEventListener(AIREvent.WINDOW_ACTIVATE, setFocusOnOpenWindow, false, 0, true);
			addEventListener(Event.ACTIVATE, setFocusOnOpenWindow, false, 0, true);
			addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, setFocusOnOpenWindow, false, 0, true);
			
			addEventListener(AIREvent.APPLICATION_ACTIVATE, WindowManager.instance.showAllOpenDialogs, false, 0, true);
			addEventListener(AIREvent.APPLICATION_DEACTIVATE, WindowManager.instance.hideAllOpenDialogs, false, 0, true);
			
			Dialog.instance.addEventListener('showDialog', setFocusOnOpenWindow, false, 0, true);
			Dialog.instance.addEventListener('hideDialog', setFocusOnOpenWindow, false, 0, true);
			
			/*addEventListener(InvokeEvent.INVOKE, onApplicationComplete, false, 0, true);
			addEventListener(, onApplicationComplete, false, 0, true);
			addEventListener(, onApplicationComplete, false, 0, true);
			addEventListener(, onApplicationComplete, false, 0, true);
			addEventListener(, onApplicationComplete, false, 0, true);
			addEventListener(, onApplicationComplete, false, 0, true);
			addEventListener(, onApplicationComplete, false, 0, true);*/
			
			// get data from descriptor xml file
			/*var appXml:XML = nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			
			_applicationId = appXml.ns::id[0];	// required
			_applicationVersion = appXml.ns::version[0];	// required
			_applicationFilename = _applicationName = appXml.ns::filename[0];	// filename = required, name = optional
			
			try {
				_applicationName = appXml.ns::name[0];	// optional
			}
			catch(e:Error){}
			
			try {
				_applicationDescription = appXml.ns::description[0];	// optional
			}
			catch(e:Error){}
			
			try {
				_applicationCopyright = appXml.ns::copyright[0];	// optional
			}
			catch(e:Error){}*/
			
			readSettings();
			getProperties(this);
			
			dispatchEvent(new Event('descriptorLoaded'));
			
			
			/*var settingFiles:File = File.applicationDirectory.resolvePath('data/');
			if(settingFiles.exists){
				var sf:Array = settingFiles.getDirectoryListing();
				sf = sf.sortOn('name');
				for(var i:int=0; i<sf.length; i++){
					// if file is 'settings.xml', 'settings_local.xml', ...
					// NOT '_settings.xml', 'settings.xml.old'
					if((sf[i] as File).extension.toLowerCase() == 'xml' && (sf[i] as File).name.indexOf('settings') == 0){
						applicationSettingRaw = FileUtils.readXmlFile('', sf[i]);
						break;
					}
				}
			}
			
			// Read version info
			// determine if application is run for the first time,
			// or if it is recently updated
			var versionLog:File = File.applicationStorageDirectory.resolvePath('version.txt');
			var loggedVersion:String = '';
			
			if(versionLog.exists){
				loggedVersion = FileUtils.readFile('', versionLog, true);
				loggedVersion.replace(/|\n|\r|\t|\0/g, '');
			}
			
			var url:String = '';
			if(applicationSettingRaw != null){
				url = String(applicationSettingRaw.updater.logger);
				
				applicationSettings = new ApplicationSettings;
				
				applicationSettings.application.url					= String(applicationSettingRaw.application.url);
				applicationSettings.application.sessionProperties	= String(applicationSettingRaw.application.sessionProperties);
				
				applicationSettings.webservices.destination	= String(applicationSettingRaw.webservices.destination);
				applicationSettings.webservices.endpoint	= String(applicationSettingRaw.webservices.endpoint);
				applicationSettings.webservices.source		= String(applicationSettingRaw.webservices.source);
				
				applicationSettings.updater.url		= String(applicationSettingRaw.updater.url);
				applicationSettings.updater.logger	= String(applicationSettingRaw.updater.logger);
				
			}*/
			
			
			// Read version info
			// determine if application is run for the first time,
			// or if it is recently updated
			var versionLog:File = File.applicationStorageDirectory.resolvePath('version.txt');
			var loggedVersion:String = '';
			
			if(versionLog.exists){
//TODO:					loggedVersion = FileUtils.readFile('', versionLog, true);
				loggedVersion.replace(/|\n|\r|\t|\0/g, '');
			}
			
			
			var url:String = '';
			if(applicationSettings != null){
				url = applicationSettings.updater.logger;
			}
			
			
			var v:String = '';
			
			if(!versionLog.exists){
				// first run
				dispatchEvent(new Event('firstLaunched'));
//TODO:				FileUtils.writeFile(applicationVersion, '', versionLog);
				v = 'New';
			}
			else if(versionLog.exists && loggedVersion != applicationVersion){
				// updated
				_previousVersion = loggedVersion;
				dispatchEvent(new Event('versionUpdated'));
				// set new version in file
//TODO:					FileUtils.writeFile(applicationVersion, '', versionLog);
				v = 'Updated from '+loggedVersion;
			}
			else {
				// all fine
			}
			
			// log install/update
			if(v != '' && url != '' && url != 'null'){
				var logUrl:URLLoader = new URLLoader();
				logUrl.load(new URLRequest(url + '?appid=' + applicationId +  '&oldversion=' + v + '&version=' + applicationVersion));
			}
			
		}
		
		private function onApplicationComplete(event:FlexEvent):void {
			if(rememberWindowState){
				loadWindowStatus();
			}
			invalidateMenus(true);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, onStageKeyUp, false, 0, true);
		}
		
		private function onStageKeyDown(event:KeyboardEvent):void {
			var e:KeyboardEvent = new KeyboardEvent(
				'stageKeyDown',false,false,event.charCode,event.keyCode,event.keyLocation,event.ctrlKey,event.altKey,
				event.shiftKey,event.controlKey,event.commandKey);
			dispatchEvent(e);
		}
		
		private function onStageKeyUp(event:KeyboardEvent):void {
			var e:KeyboardEvent = new KeyboardEvent(
				'stageKeyUp',false,false,event.charCode,event.keyCode,event.keyLocation,event.ctrlKey,event.altKey,
				event.shiftKey,event.controlKey,event.commandKey);
			dispatchEvent(e);
		}
		
		
		/**
		 * Restart the current application.
		 * This is done by calling the air installer with the current application's ID which then launches the app :-)
		 * allowBrowserInvocation must be "true" (in the descriptor xml file)
		 * */
		public function restart():void {
			var mgr:ProductManager = new ProductManager("airappinstaller");
			mgr.launch("-launch " + nativeApplication.applicationID + " " + nativeApplication.publisherID);
			close();
		}
		
		
		public function setFocusOnOpenWindow(event:Event):void {
			event.stopImmediatePropagation();
			event.preventDefault();
			
			WindowManager.instance.setFocusOnOpenWindow();
		}
		
		private function onClosing(event:Event):void {
			event.preventDefault();
			
			setProperties(this);
			
			if(closeToTray && NativeApplication.supportsSystemTrayIcon && _trayIcon != null){
				dock();
			}
			else {
				if(nativeApplication.icon != null){
					nativeApplication.icon.bitmaps = [];
				}
				
				if(rememberWindowState){
					saveWindowStatus();
				}
				
				WindowManager.instance.disposeAll();
				
				//stage.nativeWindow.close();
				exit();
			}
			
		}
		
		private function onClose(event:Event):void {
			/*for(var i:int=nativeApplication.openedWindows.length; i>=0; i--){
				nativeApplication.openedWindows[i].close();
			}*/
		}
		
		private function onNetworkChange(event:Event):void {
			
		}
		
		
		/**
		 * enables WindowedApplicationXT to go fullscreen,
		 * this didn't work when you call the code natively in your application if it's inherited from WindowedApplicationXT
		 * */
		public function fullScreen():void {
			if(systemManager.stage == null || !WindowUtils.statusLoaded) callLater(fullScreen);
			else systemManager.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		
		
		/**
		 * enables WindowedApplicationXT to go fullscreen if in normal mode, 
		 * or to go normal if in fullscreen
		 * */
		public function toggleFullScreen():void {
			if(systemManager.stage == null || !WindowUtils.statusLoaded) callLater(toggleFullScreen);
			else systemManager.stage.displayState = 
					systemManager.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE
						? StageDisplayState.NORMAL
						: StageDisplayState.FULL_SCREEN_INTERACTIVE
				;
		}
		
		
		
		
		
		private var dlgAbout:About;
		
		/**
		 * show a window with version nr, application name
		 * when 'details' is given, the string is shown on the dialog.
		 * 	can be html text
		 * */
		public function about(details:String=''):void {
			if(dlgAbout == null){
				dlgAbout = new About;
			}
			dlgAbout.details = details;
			dlgAbout.open();
		}
		
		
		
		
		/**
		 * When closed, the program doesn't exit, but minimizes to tray
		 * (only when trayIcon is set!)
		 * */
		[Inspectable(category="Core")]
		[Bindable] public var closeToTray:Boolean = false;
		
		
		
		private var _previousVersion:String = '';
		
		/**
		 * previous version of application after update (if available)
		 * */
		[Bindable('descriptorLoaded')] public function get previousVersion():String {	return _previousVersion;	}
		
		
		
		public var mainMenu:NativeMenuXT;
		
		private var mainMenuSourceChanged:Boolean = false;
		
		/**
		 * source for main menubar
		 * can be of the following types:
		 * 	- File
		 * 	- String (path)
		 * 	- XML
		 * */
		private var _mainMenuSource:Object;
		
		[Inspectable(category="Core", format="File")]
		[Bindable]
		public function set mainMenuSource(value:Object):void {
			if(_mainMenuSource != value){
				_mainMenuSource = value;
				mainMenuSourceChanged = true;
				invalidateMenus();
			}
		}
		public function get mainMenuSource():Object {
			return _mainMenuSource;
		}
		
		
		
		
		//[Bindable] public var trayMenu:NativeMenuXT;
		[Bindable] public var trayMenuDocked:NativeMenuXT;
		[Bindable] public var trayMenuUndocked:NativeMenuXT;
		
		private var trayMenuSourceChanged:Boolean = false;
		
		/**
		 * source for tray menu
		 * can be of the following types:
		 * 	- File
		 * 	- String (path)
		 * 	- XML
		 * */
		private var _trayMenuSource:Object;
		
		[Inspectable(category="Core", format="File")]
		[Bindable]
		public function set trayMenuSource(value:Object):void {
			if(_trayMenuSource != value){
				_trayMenuSource = value;
				trayMenuSourceChanged = true;
				invalidateMenus();
			}
		}
		public function get trayMenuSource():Object {
			return _trayMenuSource;
		}
		
		
		private var trayIconChanged:Boolean = false;
		private var trayIconData:BitmapData;
		
		/**
		 * source for tray menu icon
		 * can be of the following types:
		 * 	- File
		 * 	- String (path)
		 * 	- Image
		 * 	- BitmapData
		 * 	- Bitmap
		 * */
		private var _trayIcon:Object;
		
		[Inspectable(category="Core", format="File")]
		[Bindable]
		public function set trayIcon(value:Object):void {
			if(_trayIcon != value){
				_trayIcon = value;
				trayIconChanged = true;
				invalidateMenus();
			}
		}
		public function get trayIcon():Object {
			return _trayIcon;
		}
		
		
		private var trayToolTipChanged:Boolean = false;
		
		/**
		 * value for tray menu tooltip (max length: 63)
		 * */
		private var _trayToolTip:String;
		
		[Inspectable(category="Core")]
		[Bindable]
		public function set trayToolTip(value:String):void {
			if(_trayToolTip != value){
				_trayToolTip = value;
				trayToolTipChanged = true;
				invalidateMenus();
			}
		}
		public function get trayToolTip():String {
			return _trayToolTip;
		}
		
		
		
		
		
		
		
		private var showTrayIconWhenUndockedChanged:Boolean = false;
		
		/**
		 * When undocking the application, or in default startup mode, show the tray icon.
		 * Else, the icon only shows when the application is docked.
		 * */
		private var _showTrayIconWhenUndocked:Boolean;
		
		[Inspectable(category="Core")]
		[Bindable]
		public function set showTrayIconWhenUndocked(value:Boolean):void {
			if(_showTrayIconWhenUndocked != value){
				_showTrayIconWhenUndocked = value;
				showTrayIconWhenUndockedChanged = true;
				invalidateMenus();
			}
		}
		public function get showTrayIconWhenUndocked():Boolean {
			return _showTrayIconWhenUndocked;
		}
		
		
		
		
		[Bindable] public var trayIconTogglesDocking:Boolean = false;
		
		
		/**
		 * let the taskbar entry of the application blink; like msn when you receive a message
		 * property critical:
		 * 	true:	keeps blinking
		 * 	false:	blinks once, then continuesly lights up
		 */
		public function notify(critical:Boolean=false):void {
			var type:String;
			if (critical) {
			    type = NotificationType.CRITICAL;//keeps blinking
			} else { 
			    type = NotificationType.INFORMATIONAL;//blink once, then continue light up
			}
			
			nativeApplication.activeWindow.notifyUser(type);
			
		}
		
		
		
		/**
		 * hide application to system tray (minimize)
		 * */
		public function dock(event:Event = null):void {
			if(trayIconData != null && trayMenuDocked != null){
				stage.nativeWindow.visible = false;
			}
			
			if (NativeApplication.supportsSystemTrayIcon){
				SystemTrayIcon(nativeApplication.icon).menu = trayMenuDocked; //createSystrayRootMenu(false);
				SystemTrayIcon(nativeApplication.icon).menu.addEventListener(Event.SELECT, onMenuSelect, false, 0, true);
				
				if(trayIconTogglesDocking){
					SystemTrayIcon(NativeApplication.nativeApplication.icon).removeEventListener(MouseEvent.CLICK, dock);
					SystemTrayIcon(NativeApplication.nativeApplication.icon).addEventListener(MouseEvent.CLICK, undock, false, 0, true);
				}
			}
			
			nativeApplication.icon.bitmaps = [trayIconData];
			
			dispatchEvent(new Event('docked'));
		}
		
		
		/**
		 * remove application from system tray (maximize)
		 * */
		public function undock(event:Event = null):void {
			stage.nativeWindow.visible = true;
			
			if (NativeApplication.supportsSystemTrayIcon){
				SystemTrayIcon(nativeApplication.icon).menu = trayMenuUndocked; //createSystrayRootMenu(true);
				SystemTrayIcon(nativeApplication.icon).menu.addEventListener(Event.SELECT, onMenuSelect, false, 0, true);
				
				if(trayIconTogglesDocking){
					SystemTrayIcon(NativeApplication.nativeApplication.icon).removeEventListener(MouseEvent.CLICK, undock);
					SystemTrayIcon(NativeApplication.nativeApplication.icon).addEventListener(MouseEvent.CLICK, dock, false, 0, true);
				}
			}
			
			stage.nativeWindow.orderToFront();
			activate();
			
			//if(Factory.Settings.hide_tray_icon_while_maximized){
			if(!showTrayIconWhenUndocked){
				nativeApplication.icon.bitmaps = [];
			}
			
			dispatchEvent(new Event('undocked'));
		}
		
		
		[Bindable('docked')]
		[Bindable('undocked')]
		public function get isDocked():Boolean {
			return stage.nativeWindow.visible;
		}
		
		
		private var statusTimer:Timer;
		
		/**
		 * set the text at the statusbar (bottom of screen)
		 * the text is cleared after the given time-out (in seconds)
		 * if timeout is smaller than or equal to zero (0), the text remains till it's updated again
		 * */
		public function setStatus(text:String, timeOut:int = 2):void {
			status = text;
			if(statusTimer == null){
				statusTimer = new Timer(timeOut * 1000, 1);
				statusTimer.addEventListener(TimerEvent.TIMER, onStatusTimerTick, false, 0, true);
			}
			if(timeOut > 0){
				statusTimer.delay = timeOut;
				statusTimer.start();
			}
		}
		
		private function onStatusTimerTick(event:TimerEvent):void {
			status = '';
			//statusTimer.stop();
		}
		
		
		
		/*
		private var progressDialog:ProgressDialog;
		
		/**
		 * show a small dialog with 'loading...' and percentage
		 * * /
		public function showLoader(value:Number, total:Number=100, disableApp:Boolean = true, indeterminate:Boolean=false):void {
			if(progressDialog == null){
				progressDialog = new ProgressDialog;
			}
			progressDialog.open();
			progressDialog.centerWindow();
			progressDialog.message = 'Loading...';
			progressDialog.title = 'Loading';
			
			progressDialog.pb.indeterminate = indeterminate;
			if(!indeterminate){
				progressDialog.pb.setProgress(value, total);
			}
		}
		
		public function loaderProgress(event:ProgressEvent):void {
			progressDialog.pb.setProgress(event.bytesLoaded, event.bytesTotal);
		}
		
		/**
		 * hide the loader dialog
		 * * /
		public function hideLoader():void {
			progressDialog.close();
		}*/
		
		
		
		
		// initial xml data structure to save the window status
		// the values given here will be overwritten in setWindowXmlValues()
		/*private var xmlWindowData:XML = XML(
			'<root>' + 
			'	<screen xpos="10" ypos="10" width="100" height="100"/>' + 
			'	<displayState maximized="false" />' + 
			'</root>'
		);*/
		
		/**
		 * loadWindowStatus() loads the initial screen position/size if set
		 * this data is stored in the application's storage dir / preferences.xml
		 * */
		public function loadWindowStatus():void {
			/*if(nativeApplication.activeWindow == null){
				callLater(loadWindowStatus);
			}
			else {
				var f:File = getWindowPreferencesFile();
				if(f.exists){
					
					var s:FileStream = new FileStream();
					s.open(f, FileMode.READ);
					
					var xml:XML = new XML(s.readUTFBytes(s.bytesAvailable));
					nativeApplication.activeWindow.x = int(xml.screen.@xpos);
					nativeApplication.activeWindow.y = int(xml.screen.@ypos);
					
					if( int(xml.screen.@width) > 0)
						nativeApplication.activeWindow.width = int(xml.screen.@width);
					if( int(xml.screen.@height) > 0)
						nativeApplication.activeWindow.height = int(xml.screen.@height);
					
					if(String(xml.displayState.@maximized).toLowerCase() == 'true')
						nativeApplication.activeWindow.maximize();
					
					s.close();
				}
				
			}*/
			
			if(nativeApplication.activeWindow == null){
				callLater(loadWindowStatus);
			}
			else {
				WindowUtils.loadWindowStatus();
			}
		}
		
		/**
		 * store window position / size in the application's storage dir / preferences.xml
		 * when window is resized, moved
		 * */
		public function saveWindowStatus():void {
			/*var f:File = getWindowPreferencesFile();
			var s:FileStream = new FileStream;
			
			s.open(f, FileMode.WRITE);
			
			setWindowXmlValues();
			
			s.writeUTFBytes(xmlWindowData);
			s.close();*/
			
			if(nativeApplication.activeWindow == null){
				callLater(saveWindowStatus);
			}
			else {
				WindowUtils.saveWindowStatus();
			}
		}
		
		/*private function getWindowPreferencesFile():File {
			var f:File = File.applicationStorageDirectory;
			f = f.resolvePath('preferences.xml');
			return f;
		}
		
		private function setWindowXmlValues():void {
			if(nativeApplication.activeWindow == null){
				callLater(setWindowXmlValues);
			}
			else {
				
				var appXml:XML = nativeApplication.applicationDescriptor;
				var ns:Namespace = appXml.namespace();
				
				var initialWidth:int = 640;
				try {
					initialWidth = int(appXml.ns::initialWindow.width[0]) == 0 ? initialWidth : int(appXml.ns::initialWindow.width[0]);
				}
				catch(e:Error){}
				
				var initialHeight:int = 480;
				try {
					initialHeight = int(appXml.ns::initialWindow.height[0]) == 0 ? initialHeight : int(appXml.ns::initialWindow.height[0]);
				}
				catch(e:Error){}
				
				var initialX:int = 20;
				try {
					initialX = int(appXml.ns::initialWindow.x[0]);
				}
				catch(e:Error){}
				
				var initialY:int = 20;
				try {
					initialY = int(appXml.ns::initialWindow.y[0]);
				}
				catch(e:Error){}
				
				
				if(nativeApplication.activeWindow.displayState == 'maximized'){
					xmlWindowData.displayState.@maximized = true;
					xmlWindowData.screen.@xpos = initialX;
					xmlWindowData.screen.@ypos = initialY;
					
					xmlWindowData.screen.@width  = initialWidth;
					xmlWindowData.screen.@height = initialHeight;
				}
				else {
					xmlWindowData.displayState.@maximized = false;
					xmlWindowData.screen.@xpos = nativeApplication.activeWindow.x;
					xmlWindowData.screen.@ypos = nativeApplication.activeWindow.y;
					
					xmlWindowData.screen.@width  = nativeApplication.activeWindow.width;
					xmlWindowData.screen.@height = nativeApplication.activeWindow.height;
				}
			}
		}*/
		
		
		
		
		
		
		
		
		private function invalidateMenus(initial:Boolean = false):void {
			if(nativeWindow == null){
				callLater(invalidateMenus,[initial]);
			}
			else {
				
				// 
				// Main Menu
				// 
				if(mainMenuSourceChanged){
					
					if(nativeWindow.menu != null){
						nativeWindow.menu.removeEventListener(Event.SELECT, onMenuSelect, false);
					}
					
					if(_mainMenuSource == null || _mainMenuSource == 'null' || _mainMenuSource == ''){
						mainMenu = null;
					}
					else if(_mainMenuSource is File){
						mainMenu = new NativeMenuXT( readXmlFile('', _mainMenuSource as File) );
					}
					else if(_mainMenuSource is XML){
						mainMenu = new NativeMenuXT(_mainMenuSource as XML);
					}
					else {
						mainMenu = new NativeMenuXT( readXmlFile(_mainMenuSource as String) );
					}
					
					nativeWindow.menu = mainMenu;
					if(mainMenu != null){
						nativeWindow.menu.addEventListener(Event.SELECT, onMenuSelect, false, 0, true);
					}
					mainMenuSourceChanged = false;
					dispatchEvent(new Event('mainMenuChanged'));
				}
				
				// 
				// Tray Menu
				// 
				if(trayMenuSourceChanged){
					/*
					if(SystemTrayIcon(nativeApplication.icon).menu != null){
						SystemTrayIcon(nativeApplication.icon).menu.removeEventListener(Event.SELECT, onMenuSelect, false);
					}
					
					if(_trayMenuSource == null || _trayMenuSource == 'null' || _trayMenuSource == ''){
						trayMenu = null;
					}
					else if(_trayMenuSource is File){
						trayMenu = new NativeMenuXT( readXmlFile('', _trayMenuSource as File) );
					}
					else if(_trayMenuSource is XML){
						trayMenu = new NativeMenuXT(_trayMenuSource as XML);
					}
					else {
						trayMenu = new NativeMenuXT( readXmlFile(_trayMenuSource as String) );
					}
					
					if (NativeApplication.supportsSystemTrayIcon){
						
				        // set tray icon menu
						SystemTrayIcon(nativeApplication.icon).menu = trayMenu;
						if(trayMenu != null){
							SystemTrayIcon(nativeApplication.icon).menu.addEventListener(Event.SELECT, onMenuSelect, false, 0, true);
						}
					}
					trayMenuSourceChanged = false;
					dispatchEvent(new Event('trayMenuChanged'));
					*/
				}
				
				// 
				// Tray Tooltip
				// 
				if(trayToolTipChanged || initial){
					SystemTrayIcon(nativeApplication.icon).tooltip = _trayToolTip;
					trayToolTipChanged = false;
					if(trayToolTipChanged){
						dispatchEvent(new Event('trayTooltipChanged'));
					}
				}
				
				// 
				// Tray Icon
				// 
				if(trayIconChanged){
					if(_trayIcon == null || _trayIcon == 'null' || _trayIcon == ''){
						setTrayIconData(null);
					}
					else if(_trayIcon is BitmapData){
						setTrayIconData(_trayIcon as BitmapData);
					}
					else if(_trayIcon is Bitmap){
						setTrayIconData( (_trayIcon as Bitmap).bitmapData );
					}
					else if(_trayIcon is Image){
						setTrayIconData( ((_trayIcon as Image).content as Bitmap).bitmapData );
					}
					else {	//	File, String
						var loader:Loader = new Loader();
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onTrayIconLoaded, false, 0, true);
						
						if(_trayIcon is File){
							loader.load(new URLRequest((_trayIcon as File).nativePath));
						}
						else {	// String
							loader.load(new URLRequest(_trayIcon as String));
						}
					}
					trayIconChanged = false;
					dispatchEvent(new Event('trayIconChanged'));
				}
				
				if(showTrayIconWhenUndockedChanged){
					
					showTrayIconWhenUndockedChanged = false;
				}
				
			}
		}
		
		private function onTrayIconLoaded(event:Event):void {
			setTrayIconData(event.target.content.bitmapData);
		}
		
		private function setTrayIconData(data:BitmapData):void {
			trayIconData = data;
			
			if(stage == null){
				callLater(setTrayIconData, [data]);
			}
			else {
				if(trayIconData != null){
					//if(_showTrayIconWhenUndocked && ){
						nativeApplication.icon.bitmaps = [trayIconData];
					/*}
					else {
						nativeApplication.icon.bitmaps = [];
					}*/
					
					
			  		//For windows systems we can set the systray props
			  		//(there's also an implementation for mac's, it's similar and you can find it on the net... ;) )
					if (NativeApplication.supportsSystemTrayIcon){
						
						//Text to show when hovering of the docked application icon       
						//SystemTrayIcon(NativeApplication.nativeApplication.icon).tooltip = applicationName;	//TODO: set tooltip property
						//We want to be able to open the application after it has been docked
						SystemTrayIcon(NativeApplication.nativeApplication.icon).addEventListener(MouseEvent.CLICK, undock, false, 0, true);
						//Listen to the display state changing of the window, so that we can catch the minimize       
						stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, nwMinimized, false, 0, true); 
						
					}
				}
				else {
					nativeApplication.icon.bitmaps = [];
				}
			}
		}
		
		private function nwMinimized(displayStateEvent:NativeWindowDisplayStateEvent):void {
			//TODO: check
			if(displayStateEvent.afterDisplayState == NativeWindowDisplayState.MINIMIZED) {
				displayStateEvent.preventDefault();
				dock();
			}
		}
		
		
		/*private function setSystemTrayProperties():void{
			//We want to be able to open the application after it has been docked
			SystemTrayIcon(NativeApplication.nativeApplication.icon).addEventListener(MouseEvent.CLICK, undock, false, 0, true);
			//Listen to the display state changing of the window, so that we can catch the minimize       
			stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, nwMinimized, false, 0, true); 
			
		}*/
		
		
		private function onMenuSelect(event:Event):void {
			var action:String;
			var menuItem:NativeMenuItem = NativeMenuItem(event.target);
			
			if(menuItem != null){
				action = menuItem.data != null ? menuItem.data.action : null;
				
				if(action == null)							trace('Menu action is not declared! ("'+menuItem.label+'")');
				else if(action.split(' ').join('') == '')	trace('Menu action is empty! ("'+menuItem.label+'")');
				else 
				{
					action = action.toLowerCase();
					
					dispatchEvent(new NativeMenuEvent('menuSelect', false, true, menuItem.menu as NativeMenuXT, menuItem, menuItem.label, action, menuItem.data));
				}
			}
		}
		
		
		
		
		/**
		 * Initiate logger if wanted.
		 * just set to new LogFile('path/to/file.ext');
		 * */
		[Inspectable(category="Core")]
		[Bindable] public var logger:LogFile;
		
		/**
		 * log a string with timestamp to logfile if logger is set
		 * */
		public function log(text:String, level:int=-1):void {
			if(logger != null){
				logger.log(text, level);
			}
		}
		
		
		
		
		public function readSettings():void {
			
			// get data from descriptor xml file
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			
			_applicationId = appXml.ns::id[0];	// required
			_applicationVersion = appXml.ns::versionNumber[0];	// required
			_applicationFilename = _applicationName = appXml.ns::filename[0];	// filename = required, name = optional
			
			try {
				_applicationName = appXml.ns::name[0];	// optional
			}
			catch(e:Error){}
			
			try {
				_applicationDescription = appXml.ns::description[0];	// optional
			}
			catch(e:Error){}
			
			try {
				_applicationCopyright = appXml.ns::copyright[0];	// optional
			}
			catch(e:Error){}
			
			
			var settingFiles:File = File.applicationDirectory.resolvePath('data/');
			if(settingFiles.exists){
				var sf:Array = settingFiles.getDirectoryListing();
				sf = sf.sortOn('name');
				for(var i:int=0; i<sf.length; i++){
					// if file is 'settings.xml', 'settings_local.xml', ...
					// NOT '_settings.xml', 'settings.xml.old'
					if((sf[i] as File).extension.toLowerCase() == 'xml' && (sf[i] as File).name.indexOf('settings') == 0){
						//applicationSettingRaw = FileUtils.readXmlFile('', sf[i] as File);
						
						var fileStream:FileStream = new FileStream();
						fileStream.open(sf[i] as File, FileMode.READ);
						applicationSettingRaw = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
						fileStream.close();
						
						break;
					}
				}
			}
			
			if(applicationSettingRaw != null){
				
				applicationSettings = new ApplicationSettings;
				
				applicationSettings.application.url			= String(applicationSettingRaw.application.url);
				applicationSettings.application.info		= String(applicationSettingRaw.application.info);
				applicationSettings.application.useStratus	= String(applicationSettingRaw.application.useStratus).toLowerCase() == 'true';
				applicationSettings.application.stratusKey	= String(applicationSettingRaw.application.stratusKey);
				applicationSettings.application.stratusUrl	= String(applicationSettingRaw.application.stratusUrl);
				
				var sp:String = String(applicationSettingRaw.application.sessionProperties).replace(/\n|\r|\t|\0| /g, '').replace(/;/g, ',');
				if(sp != ''){
					applicationSettings.application.sessionProperties = sp.split(',');
				}
				else {
					applicationSettings.application.sessionProperties = [];
				}
				
				sessionPropertiesCookie.read();
				sessionProperties = sessionPropertiesCookie.data;
				
				
				applicationSettings.webservices.destination	= String(applicationSettingRaw.webservices.destination);
				applicationSettings.webservices.endpoint	= String(applicationSettingRaw.webservices.endpoint);
				applicationSettings.webservices.source		= String(applicationSettingRaw.webservices.source);
				
				applicationSettings.updater.url		= String(applicationSettingRaw.updater.url);
				applicationSettings.updater.logger	= String(applicationSettingRaw.updater.logger);
				
				// Load additional (application-specific) settings
				/*if(applicationSettingRaw.additional){
					applicationSettings.additional = {};
					for(var xi:int=0; xi<XML(applicationSettingRaw.additional).children().length(); xi++){
						applicationSettings.additional[String(XML(applicationSettingRaw.additional).children()[xi].name())] = XML(applicationSettingRaw.additional).children()[xi].toString();
					}
					
				}*/
				
			}
			
		}
		
		
		
		private var sessionPropertiesCookie:Cookie = new Cookie('application_sessionProperties');
		private var sessionProperties:Object = {};
		
		public function getProperties(parent:Object):Object {
			if(sessionProperties != null){
				for(var s:String in sessionProperties){
					if(parent.hasOwnProperty(s)){
						parent[s] = sessionProperties[s];
					}
				}
			}
			return sessionProperties;
		}
		
		public function setProperties(parent:Object):void {
			if(parent != null
				&& applicationSettings != null
				&& applicationSettings.application.sessionProperties != null){
				
				if(sessionProperties == null){
					sessionProperties = {};
				}
				
				for(var i:int=0; i<applicationSettings.application.sessionProperties.length; i++){
					var prop:String = applicationSettings.application.sessionProperties[i];
					if(parent.hasOwnProperty(prop)){
						sessionProperties[prop] = parent[prop];
					}
					else {
						//throw new Error('Property '+prop+' not found on '+parent+'. Please make sure that the property exists and that it is public');
						trace('Property '+prop+' not found on '+parent+'. Please make sure that the property exists and that it is public');
					}
				}
				sessionPropertiesCookie.data = sessionProperties;
				sessionPropertiesCookie.save();
			}
		}
		
		
		
		
		public function get currentOSUser():String{
			// XP & Vista only.
			/*var userDirectory:String = File.userDirectory.nativePath;
			var startIndex:Number = userDirectory.lastIndexOf("\\") + 1
			var stopIndex:Number = userDirectory.length;
			var user = userDirectory.substring(startIndex, stopIndex);
			return user;*/
			
			var userDir:String = File.userDirectory.nativePath;
			var userName:String = userDir.substr(userDir.lastIndexOf(File.separator) + 1);
			return userName;
		}
		
		
		
		
		/**
		 * read the structure of an xml file.
		 * the xml file can be given either 
		 * 	- as a string to a file on the application directory, or
		 * 	- as a File object
		 * */
		public function readXmlFile(filename:String, fileObj:File = null):XML {
			var fileStream:FileStream = new FileStream();
			if(fileObj == null){
				var file:File = File.applicationDirectory.resolvePath(filename);
				fileStream.open(file, FileMode.READ);
			}
			else {
				fileStream.open(fileObj, FileMode.READ);
			}
			var resultXML:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			return resultXML;
		}
		
		
		
		
	}
	
}