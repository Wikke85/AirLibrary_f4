package com.events
{
	import flash.events.Event;

	public class FilterEvent extends Event
	{
		
		public static const FILTER_SELECT:String = 'filterSelect';
		
		private var _dataField:String = '';
		private var _value:String = '';
		
		public function FilterEvent(type:String, dataField:String, value:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_dataField	= dataField;
			_value		= value;
		}
		
		public function get dataField():String { return _dataField; }
		public function get value():String { return _value; }
		
	}
}