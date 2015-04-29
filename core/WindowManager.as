package core
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	public class WindowManager
	{
		
		private var sort:Sort;
		
		public function WindowManager()
		{
			sort = new Sort;
			sort.fields = [new SortField('priority', true, false, true)];
		}
		
		private static var _instance:WindowManager;
		public static function get instance():WindowManager {
			if(_instance == null){
				_instance = new WindowManager;
			}
			return _instance;
		}
		
		
		private var windows:ArrayCollection = new ArrayCollection;
		
		public function addWindow(window:WindowXT):void {
			var alreadyInList:Boolean = false;
			for(var i:int=0; i<windows.length; i++){
				if(windows[i] == window){
					alreadyInList = true;
					break;
				}
			}
			if(!alreadyInList){
				windows.addItem(window);
			}
			
		}
		
		public function disposeAll():void {
			for(var i:int=0; i<windows.length; i++){
				WindowXT(windows[i]).dispose();
			}
		}
		
		
		public function setFocusOnOpenWindow():void {
			var highestWindow:WindowXT;
			var currentWindow:WindowXT;
			
			/*for(var i:int=0; i<windows.length; i++){
				currentWindow = windows[i] as WindowXT;
				
				if(highestWindow == null || currentWindow.priority >= highestWindow.priority){
					highestWindow = currentWindow;
				}
			}
			
			if(highestWindow != null && highestWindow.opened) highestWindow.regetFocus(null);*/
			
			
			windows.sort = sort;
			windows.refresh();
			
			for(var i:int=0; i<windows.length; i++){
				currentWindow = windows[i] as WindowXT;
				if(currentWindow.visible){
					currentWindow.regetFocus(null);
				}
			}
			
		}
		
		
		public function showAllOpenDialogs(event:Event):void {
			for(var i:int=0; i<windows.length; i++){
				if((windows[i] as WindowXT).opened){
					(windows[i] as WindowXT).visible = true;
				}
			}
		}
		
		public function hideAllOpenDialogs(event:Event):void {
			for(var i:int=0; i<windows.length; i++){
				if((windows[i] as WindowXT).opened){
					(windows[i] as WindowXT).visible = false;
				}
			}
		}
		
		
		
		
	}
}