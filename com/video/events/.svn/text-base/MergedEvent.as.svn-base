package org.bytearray.video.events
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public final class MergedEvent extends Event
	{
		public var time:Number;
		public var stream:ByteArray;
		
		public static const COMPLETE:String = "mergeComplete";
		
		public function MergedEvent(type:String, stream:ByteArray, duration:Number)
		{
			super(type, false, false);
			this.stream = stream;
			this.time = duration;
		}
		
		public override function toString ():String
		{	
			return "[MergdEvent duration="+time+"]";	
		} 
	}
}