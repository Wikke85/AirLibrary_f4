package com.events
{
	import flash.events.Event;

	public class MijnTuinEvent extends Event
	{
		
		public static var GOT_ACCESS_TOKEN:String = 'GOT_ACCESS_TOKEN';
		public static var DATA_RECEIVED:String = 'DATA_RECEIVED';
		public static var AUTHORIZED_TOKEN:String = 'AUTHORIZED_TOKEN';
		public static var GOT_REQUEST_TOKEN:String = 'GOT_REQUEST_TOKEN';
		
		public function MijnTuinEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}