package com.events
{
	import flash.events.Event;

	public class XmlMenuEvent extends Event
	{
		
		public static const MENU_ITEM_CLICK:String	= 'menuItemClick';
		
		public var view:String = '';
		//public var module:String = '';
		public var image:Object = null;
		public var state:String = '';
		
		public function XmlMenuEvent(type:String, view:String, state:String='', image:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.view	= view;
			//this.module	= module;
			this.image	= image;
			this.state	= state;
		}
		
	}
}