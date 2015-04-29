package core
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.system.Capabilities;
	
	import mx.core.Window;
	
	[Event(name="windowOpened", type="flash.events.Event")]
	[Event(name="windowClosed", type="flash.events.Event")]
	
	public class WindowXT extends Window
	{
		
		public var created:Boolean = false;
		public var opened:Boolean = false;
		
		public var priority:int = -1;
		
		private var windowManager:WindowManager = WindowManager.instance;
		
		public function WindowXT()
		{
			super();
			
			addEventListener(Event.CLOSING, onClosing, false, 0, true);
			
			/*
			maximizable="false"
			minimizable="false"
			resizable="true"
			transparent="false"
			systemChrome="{NativeWindowSystemChrome.STANDARD}"
			type="utility"
			alwaysInFront="false"
			showStatusBar="false"
			*/
		}
		
		private function onClosing(event:Event):void {
			event.preventDefault();
			event.stopImmediatePropagation();
			
			visible = false;
		}
		
		
		override public function open(openWindowActive:Boolean = true):void {
			if(!created){
				super.open(openWindowActive);
				created = true;
				
				windowManager.addWindow(this);
				// WindowManager.invalidatePriorities();
			}
			visible = true;
			opened = true;
			stage.nativeWindow.orderToFront();
			
			dispatchEvent(new Event('windowOpened'));
		}
		
		
		/**
		 * align the WindowXT in the middle of the current screen
		 * */
		public function centerWindow():void {
			if(width < 10){
				callLater(centerWindow);
			}
			else {
				nativeWindow.x = Math.max(0, (Capabilities.screenResolutionX / 2) - (width / 2));
				nativeWindow.y = Math.max(0, (Capabilities.screenResolutionY / 2) - (height / 2));
			}
		}
		
		
		public function regetFocus(event:Event=null):void {
			if(visible && opened){
				if(event != null){
					event.preventDefault();
					event.stopImmediatePropagation();
				}
				this.setFocus();
				stage.nativeWindow.orderToFront();
				activate();
			}
		}
		
		
		
		
		override public function close():void {
			//super.close()
			visible = false;
			opened = false;
			
			dispatchEvent(new Event('windowClosed'));
		}
		
		public function dispose():void {
			super.close();
			stage.nativeWindow.close();
		}
		
	}
	
}