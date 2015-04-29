package asfiles.document
{
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import asfiles.spectrums.SmoothSpectrum;
	import asfiles.spectrums.BasicSpectrum;
	
	public class Main extends Sprite
	{
		private var mySpectrum:Sprite;
		private var myChannel:SoundChannel;
		private var mySound:Sound;
		
		public function Main ( )
		{	
			mySound = new Sound();
			
			try 
			{
				mySound.load ( new URLRequest ("son.mp3") );
							
				myChannel = mySound.play();
				
			} catch ( e:SecurityError ) {}
			
			mySound.addEventListener (IOErrorEvent.IO_ERROR, loadError );
			
			mySpectrum = new SmoothSpectrum( 800, 400, 200);
			//mySpectrum = new BasicSpectrum( 900, 400, 200);
			
			addChild ( mySpectrum );
						
			var centerX = (stage.stageWidth - (mySpectrum as Sprite).width) /2;
			var centerY = (stage.stageHeight - (mySpectrum as Sprite).height) /2;
			
			mySpectrum.x = centerX;
			mySpectrum.y = centerY;
			
			stage.addEventListener (MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function loadError ( pEvt:IOErrorEvent ):void 
		{
			trace("error loading sound ;)");	
		}
		
		private function onMove ( pEvt:MouseEvent ):void 
		{
			setVolume ( 1 - ( pEvt.stageY / stage.stageHeight) ); 
			
			setPan ( (pEvt.stageX / ( stage.stageWidth / 2 ))-1 ); 	
		}
		
		private function setVolume ( pVolume:Number ):void 
		{
			var myTransform:SoundTransform = myChannel.soundTransform;
			
			myTransform.volume = pVolume;
			
			myChannel.soundTransform = myTransform;
		}
		
		private function setPan ( pPan:Number ):void 
		
		{
			
			var myTransform:SoundTransform = myChannel.soundTransform;
			
			myTransform.pan = pPan;
			
			myChannel.soundTransform = myTransform;
			
		}
		
	}
	
}