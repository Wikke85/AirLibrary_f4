package com.events
{
	
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import xt.menu.NativeMenuXT;

	public class NativeMenuEvent extends Event
	{
		
		public var menu:NativeMenuXT = null;
		public var menuItem:NativeMenuItem = null;
		public var label:String = '';
		public var action:String = '';
		public var data:Object = null;
		
		public function NativeMenuEvent
		(	
			type:String,
			bubbles:Boolean = false,
			cancelable:Boolean = true, 
			menu:NativeMenuXT = null,
			menuItem:NativeMenuItem = null,
			label:String = '',
			action:String = '',
			data:Object = null
		)
		{
			super(type, bubbles, cancelable);
			this.menu		= menu;
			this.menuItem	= menuItem;
			this.label		= label;
			this.action		= action;
			this.data		= data;
		}
		
	}
}