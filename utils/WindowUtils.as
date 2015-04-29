package utils
{
	import flash.desktop.NativeApplication;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	
	public class WindowUtils
	{
		
		public function WindowUtils(){}
		
		
		/**
		 * indicates if status is loaded
		 * */
		public static var statusLoaded:Boolean = false;
		
		
		public static function fullScreen(stage:Stage, component:UIComponent = null):void {
			
			var p:Point = component.localToGlobal(new Point(component.x, component.y));
			trace(p.x + ' ' + p.y);
			stage.fullScreenSourceRect = new Rectangle(component.x, component.y, component.width, component.height);
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
		}
		
		
		
		// initial xml data structure to save the window status
		// the values given here will be overwritten in setWindowXmlValues()
		private static var xmlWindowData:XML = XML(
			'<root>' + 
			'	<screen xpos="10" ypos="10" width="100" height="100"/>' + 
			'	<displayState maximized="false" />' + 
			'</root>'
		);
		
		
		/**
		 * loadWindowStatus() loads the initial screen position/size if set
		 * this data is stored in the application's storage dir / preferences.xml
		 * */
		public static function loadWindowStatus():void {
			if(NativeApplication.nativeApplication.activeWindow == null){
				//callLater(loadWindowStatus);
			}
			else {
				var f:File = getWindowPreferencesFile();
				if(f.exists){
					
					var s:FileStream = new FileStream();
					s.open(f, FileMode.READ);
					
					var xml:XML = new XML(s.readUTFBytes(s.bytesAvailable));
					NativeApplication.nativeApplication.activeWindow.x = int(xml.screen.@xpos);
					NativeApplication.nativeApplication.activeWindow.y = int(xml.screen.@ypos);
					
					if( int(xml.screen.@width) > 0)
						NativeApplication.nativeApplication.activeWindow.width = int(xml.screen.@width);
					if( int(xml.screen.@height) > 0)
						NativeApplication.nativeApplication.activeWindow.height = int(xml.screen.@height);
					
					if(String(xml.displayState.@maximized).toLowerCase() == 'true')
						NativeApplication.nativeApplication.activeWindow.maximize();
					
					s.close();
				}
				
				statusLoaded = true;
				
				
			}
		}
		
		
		/**
		 * store window position / size in the application's storage dir / preferences.xml
		 * when window is resized, moved
		 * */
		public static function saveWindowStatus():void {
			var f:File = getWindowPreferencesFile();
			var s:FileStream = new FileStream;
			
			s.open(f, FileMode.WRITE);
			
			setWindowXmlValues();
			
			s.writeUTFBytes(xmlWindowData);
			s.close();
			
		}
		
		
		private static function getWindowPreferencesFile():File {
			var f:File = File.applicationStorageDirectory;
			f = f.resolvePath('preferences.xml');
			return f;
		}
		
		
		private static function setWindowXmlValues():void {
			if(NativeApplication.nativeApplication.activeWindow == null){
				//callLater(setWindowXmlValues);
			}
			else {
				
				var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
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
				
				
				if(NativeApplication.nativeApplication.activeWindow.displayState == 'maximized'){
					xmlWindowData.displayState.@maximized = true;
					xmlWindowData.screen.@xpos = initialX;
					xmlWindowData.screen.@ypos = initialY;
					
					xmlWindowData.screen.@width  = initialWidth;
					xmlWindowData.screen.@height = initialHeight;
				}
				else {
					xmlWindowData.displayState.@maximized = false;
					xmlWindowData.screen.@xpos = NativeApplication.nativeApplication.activeWindow.x;
					xmlWindowData.screen.@ypos = NativeApplication.nativeApplication.activeWindow.y;
					
					xmlWindowData.screen.@width  = NativeApplication.nativeApplication.activeWindow.width;
					xmlWindowData.screen.@height = NativeApplication.nativeApplication.activeWindow.height;
				}
			}
			
		}
		
		
		
		
	}
	
}
