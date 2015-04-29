package com.events
{
	import flash.events.Event;

	public class RowEvent extends Event
	{
		
		public static const COPY_CLICK:String	= 'copyClick';
		public static const DELETE_CLICK:String	= 'deleteClick';
		public static const EDIT_CLICK:String	= 'editClick';
		
		
		/* data object representing the row data from the row which dispatched the event */
		private var _data:Object;
		
		public function RowEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		public function get data():Object { return _data; }
		
	}
}