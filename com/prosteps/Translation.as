package com.prosteps {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	[Bindable("changed")]
	public class Translation /*extends EventDispatcher*/ {
		
		private static var texts:Dictionary = new Dictionary();
		
		public static var loaded:Boolean = false;
		
		public function Translation() {
			super();
		}

		public static function assign(aData:Object):void {
			texts = new Dictionary(true);
			
			for(var i:int=0; i<aData.length; i++){
				texts[aData[i].name] = aData[i].description;
				
			}
			loaded = true;
			
			//dispatchEvent( new Event('changed') );
		}
		
		
		[Bindable("changed")]
		public static function key(keyCode:String):String {
        	if(!loaded) return null;
			
			var value : String = texts[keyCode.toLowerCase()];
			if (value == null){
				trace("'" + keyCode.toLowerCase() + "' not found in translations!" );
				return keyCode.split('_').join(' ');
			}
			
            return value;
        }
        
        
	}
}