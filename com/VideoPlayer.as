package mx.players
{
	import flash.events.Event;
	
	import mx.controls.VideoDisplay;
	import mx.events.VideoEvent;
	
	[Event(name="play", type="mx.events.VideoEvent")]
	[Event(name="pause", type="mx.events.VideoEvent")]
	[Event(name="stop", type="mx.events.VideoEvent")]
	[Event(name="skipForward", type="mx.events.VideoEvent")]
	[Event(name="skipBack", type="mx.events.VideoEvent")]
	
	
	public class VideoPlayer extends VideoDisplay
	{
		
		public function VideoPlayer()
		{
			super();
			
			addEventListener('rewind', onMovieRewind, false, 0, true);
			addEventListener('stateChange', onMovieStateChange, false, 0, true);
			addEventListener('playheadUpdate', updatePlay, false, 0, true);
			addEventListener('ready', onReady, false, 0, true);
		}
		
		
		/**
		 * Amount of seconds to skip when calling skipForward() or skipBack()
		 * */
		[Bindable] public var skipAmount:int = 5;
		
		
		[Bindable] public var totalTime:Number = 0;
		
		[Bindable] public var playing:Boolean = false;
		[Bindable] public var paused:Boolean = false;
		[Bindable] public var stopped:Boolean = true;
		
		
		
		/**
		 * Toggle Playing/Paused mode
		 * */
		public function playPause(): void {
			playing ? pause() : play();
		}
		
		
		/**
		 * Play current movie
		 * */
		override public function play(): void {
			
			super.play();
			playing = true;
			paused = false;
			stopped = false;
			
			dispatchEvent(new VideoEvent('play'));
			//movie.volume = volume / 100;
		}
		
		/**
		 * Pause current movie
		 * */
		override public function pause():void {
			super.pause();
			playing = false;
			paused = true;
			stopped = false;
			
			volume = 0;
			dispatchEvent(new VideoEvent('pause'));
		}
		
		/**
		 * Stop playing current movie
		 * */
		override public function stop(): void {
			
			if(playing){
				super.stop();
				playing = false;
				paused = false;
				stopped = true;
				
				dispatchEvent(new VideoEvent('stop'));
			}
			
			//if(movie.state != VideoEvent.DISCONNECTED) {
				close();
				source = null;
			//}
		}
		
		/**
		 * Skip amount of 'skipAmount' seconds forward (if possible, else, skip to end)
		 * */
		public function skipForward():void {
			if(totalTime > skipAmount){
				playheadTime = Math.min(playheadTime + skipAmount, totalTime);
				dispatchEvent(new VideoEvent('skipForward'));
			}
		}
		
		/**
		 * Skip amount of 'skipAmount' seconds back (if possible, else, skip to beginning)
		 * */
		public function skipBack():void {
			if(playheadTime - skipAmount > 0){
				playheadTime -= skipAmount;
			}
			else {
				playheadTime = 0;
			}
			dispatchEvent(new VideoEvent('skipBack'));
		}
		
		
		
		
		private function onMovieStateChange(event:VideoEvent): void {
			if(event.state == VideoEvent.BUFFERING || event.state == VideoEvent.PLAYING) {
				
			}
		}
		
		private function onMovieRewind(event:Event): void {
			
		}
		
		
		private function updatePlay(event:VideoEvent=null):void {
			
		}
		
		private function onReady(event:VideoEvent):void {
			
		}
		
	}
}