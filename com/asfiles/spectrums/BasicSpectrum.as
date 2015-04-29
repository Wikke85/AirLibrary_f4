package asfiles.spectrums
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.media.SoundMixer;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.errors.EOFError;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class BasicSpectrum extends Sprite
	{
		
		private var outputBitmap:BitmapData
		private var myBlur:BlurFilter;
		private var myBytes:ByteArray;
		private var myColorTransform:ColorTransform;
		private var screenSprite:Sprite;
		private var myPoint:Point;
		private var myRectangle:Rectangle;
		private var gradient:Array;
		private var mouseDown:Boolean;
		private var offset:int
		private var i:int;
		
		public function BasicSpectrum ( pWidth:Number, pHeight:Number, pAmplitude:Number ) 
		{			
			var myLegende:TextField = new TextField();
			
			myLegende.autoSize = TextFieldAutoSize.LEFT;
			
			myLegende.selectable = false;
			
			myLegende.textColor = 0x777777;
			
			myLegende.text = "basic computeSpectrum() - bytearray.org";
						
			myLegende.x = 360, myLegende.y = 375;
			
			outputBitmap = new BitmapData ( pWidth, pHeight, false, 0);
			
			myRectangle = new Rectangle (0, 0, 6, 0);
			
			myPoint = new Point (0, 0);
			
			screenSprite = new Sprite();
			
			screenSprite.addChild ( new Bitmap ( outputBitmap ) );
			
			addChild ( screenSprite );
															
			addChild ( myLegende );
			
			myBlur = new BlurFilter ( 0, 4, 2);
			
			myColorTransform = new ColorTransform (Math.random(), Math.random(), Math.random());
			
			myBytes = new ByteArray();
			
			gradient = generateRadient();
			
			addEventListener (Event.ADDED, onAdded);						
			addEventListener ( Event.REMOVED, onRemoved );
		}
				
		private function onAdded ( pEvt:Event ):void 
		{
			addEventListener (Event.ENTER_FRAME, drawEqualizer);
			
			stage.addEventListener (MouseEvent.MOUSE_DOWN, onClick );	
		}
			
		public function onRemoved( pEvt:Event ):void 
		{
			outputBitmap.dispose();
			
			removeEventListener (Event.ENTER_FRAME, drawEqualizer );
			
			stage.removeEventListener (MouseEvent.MOUSE_DOWN, onClick );	
		}
		
		private function drawEqualizer (pEvt:Event):void 
		{
			// computeSpectrum() to get a byteArray
			SoundMixer.computeSpectrum ( myBytes, mouseDown );
			
			i = 128;
			
			outputBitmap.colorTransform ( outputBitmap.rect, myColorTransform );
			
			while ( --i > -1 ) {
				
				// move the pointer so that it jump some bytes
				myBytes.position = i * 16;
				
				// get amplitude value
				offset = myBytes.readFloat()*200;

				// move the strike position
				myRectangle.x = (7 * i);
				
				if ( offset >= 0 ) {
					
					myRectangle.y = 200-offset;
					myRectangle.height = offset;
					
					// draw a strike with fillRect()
					outputBitmap.fillRect ( myRectangle, mouseDown ? gradient[i] : 0xFFFFFF );
					
				} else {
					
					myRectangle.y = 200;
					myRectangle.height = -offset;
					
					outputBitmap.fillRect ( myRectangle, mouseDown ? gradient[i] : 0xFFFFFF )
				};
			}
			
			// apply a blur filter to make it glowed
			outputBitmap.applyFilter ( outputBitmap,outputBitmap.rect, myPoint, myBlur ); 
		}
		
		private function onClick ( pEvt:MouseEvent ):void
		{
			myColorTransform = new ColorTransform (Math.random(), Math.random(), Math.random());

			mouseDown = !mouseDown	
		}
		
		// tks to andré for this one ;)
		private function generateRadient ():Array
		{	
			var gradient:Array = new Array();
			
			var shape:Shape = new Shape();
			var bitmapGradient:BitmapData = new BitmapData ( 256, 1, false, 0);
			
			var colors: Array = [ 0xff0000, 0xffff00, 0x00ff00];
			var alphas: Array = [ 100, 100, 100 ];
			var ratios: Array = [ 20, 128, 192 ]; 
			
			var matrix: Matrix = new Matrix();
			
			matrix.createGradientBox( 128, 1, 0, 0 );
			
			shape.graphics.beginGradientFill( 'linear', colors, alphas, ratios, matrix, SpreadMethod.REPEAT );
			shape.graphics.drawRect( 0, 0, 256, 1 );
			shape.graphics.endFill();
			
			bitmapGradient.draw( shape );
			
			for( var i: int = 0 ; i < 256 ; i++ ) gradient[i] = bitmapGradient.getPixel( i, 0 );
			
			return gradient;
		}
	}
}