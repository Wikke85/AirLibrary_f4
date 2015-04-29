package xt
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.ProgressBar;
	import mx.core.mx_internal;
	use namespace mx_internal;
	
	/**
	 * ProgressBarXT enables to see the current transfer speed.
	 * read-only property bytesPerSecond gives the current transfer speed in bytes
	 * 	and is recalculated at every interval
	 * */
	public class ProgressBarXT extends ProgressBar
	{
		
		private const interval:Number = 1000;	// milliseconds
		
		private var t:Timer;
		private var previousValue:Number = 0;
		
		private var _bytesPerSecond:Number = 0;
		private var _avgBytesPerSecond:Number = 0;
		private var _seconds:Number = 0;
		
		private var timeOutCounter:int = 0;
		
		public function ProgressBarXT()
		{
			super();
			t = new Timer( interval );
			t.addEventListener(TimerEvent.TIMER, onTick, false, 0, true);
			
			
			addEventListener(Event.CHANGE, onChange, false, 0, true);
		}
		
		
		
		[Bindable('bytesChanged')]
		[Bindable('change')]
		public function get bytesPerSecond():Number {
			return _bytesPerSecond;
		}
		
		
		/* very inaccurate !! */
		[Bindable('bytesChanged')]
		[Bindable('change')]
		public function get avgBytesPerSecond():Number {
			return _avgBytesPerSecond;
		}
		
		
		
		private function onChange(event:Event):void
		{
			//if(!t.running) t.start();
			
		}	
		
		
		private function onTick(event:Event):void {
			
			/*
			seconds	previousValue	value	bytesPerSecond
			1)		0				5		5
			2)		5				9		4
			3)		9				16		7
			...
			*/
			_bytesPerSecond = (value - previousValue) * (1000 / interval);
			
			_seconds += (interval / 1000);
			
			_avgBytesPerSecond = value / _seconds;
			
			
			if(value == previousValue /*&& timeOutCounter < 50*/){
				timeOutCounter ++;
				trace('oh oh');
			}
			else {
				timeOutCounter = 0;
				dispatchEvent(new Event('bytesChanged'));
				previousValue = value;
			}
			
		}
		
		[Bindable]
		public function set value(_value:Number):void {
			setProgress(_value, maximum);
		}
		override public function get value():Number {
			return super.value;
		}
		
		
	}
}