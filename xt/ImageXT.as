package xt
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.controls.Image;
	import mx.core.BitmapAsset;

	public class ImageXT extends Image
	{
		
		public function ImageXT()
		{
			super();
			addEventListener(Event.COMPLETE, smoothImage, false, 0, true);
		}
		
		
		
		private var _smoothing:Boolean;
		
		/**
		 * Image smoothing 
		 * smoothing image with scaleContent = true
		 * this prevents pixelized images
		 * */
		[Bindable]
		public function get smoothing():Boolean {
			return _smoothing;
		}
		public function set smoothing(value:Boolean):void {
			_smoothing = value;
		}
		
		
		
		
		
		public function getPixels(rect:Rectangle): ByteArray {
			// return data.getPixels(rect); // ==> Contains a bug.
			var pixels:ByteArray = new ByteArray();
			for(var i:uint = rect.x; i < (rect.x + rect.width); i++) {
				for(var j:uint = rect.y; j < (rect.y + rect.height); j++) {
					pixels.writeUnsignedInt((content as Bitmap).bitmapData.getPixel32(i,j));
				}
			}
			return pixels;
		}
		
		public function setPixels(rect:Rectangle,inputByteArray:ByteArray): BitmapData {
			// return data.setPixels(rect,inputByteArray); // ==> Contains a bug.
			inputByteArray.position = 0;
			for(var i:uint = rect.x; i < (rect.x + rect.width); i++) {
				for(var j:uint = rect.y; j < (rect.y + rect.height); j++) {
					(content as Bitmap).bitmapData.setPixel32(i,j,inputByteArray.readUnsignedInt());
				}
			}    
			return (content as Bitmap).bitmapData;
		}
		
		
		
		private function smoothImage(event:Event):void {
			if(_smoothing && content != null){
				source = new BitmapAsset( (content as Bitmap).bitmapData, 'auto', true );
			}
		}
		
	}
	
}
