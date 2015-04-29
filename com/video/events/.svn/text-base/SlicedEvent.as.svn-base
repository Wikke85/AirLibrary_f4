package org.bytearray.video.events
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public final class SlicedEvent extends Event
	{
		public var start:int;
		public var end:int;
		public var time:Number;
		public var stream:ByteArray;
		
		public static const COMPLETE:String = "sliceComplete";
		
		public function SlicedEvent(type:String, stream:ByteArray, start:int, end:int)
		{
			super(type, false, false);
			this.stream = stream;
			this.start = start;
			this.end = end;
			this.time = end - start;
		}
		
		public override function toString ():String
		{	
			return "[SlicedEvent start="+start+" end="+end+" time="+time+"]";	
		} 
	}
}