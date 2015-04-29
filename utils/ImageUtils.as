package utils {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.core.BitmapAsset;
	

	public class ImageUtils  {

		public function ImageUtils() {
			super();
		}

		public static function getPixels(data:BitmapData,rect:Rectangle): ByteArray {
			// return data.getPixels(rect); // ==> Contains a bug.
			var pixels:ByteArray = new ByteArray();
			for(var i:uint = rect.x; i < (rect.x + rect.width); i++) {
				for(var j:uint = rect.y; j < (rect.y + rect.height); j++) {
					pixels.writeUnsignedInt(data.getPixel32(i,j));
				}
			}
			return pixels;
		}
		public static function setPixels(data:BitmapData,rect:Rectangle,inputByteArray:ByteArray): BitmapData {
			// return data.setPixels(rect,inputByteArray); // ==> Contains a bug.
			inputByteArray.position = 0;
			for(var i:uint = rect.x; i < (rect.x + rect.width); i++) {
				for(var j:uint = rect.y; j < (rect.y + rect.height); j++) {
					data.setPixel32(i,j,inputByteArray.readUnsignedInt());
				}
			}    
			return data;
		}
		
		
		/* Image smoothing 
		
		smoothing image with maintainAspectRatio = true
		this function prevents pixelized images
		call this function on image 'complete' event
		*/
		public static function smoothImage(event:Event):void {
			if(event.target.content != null){
				event.target.source = new BitmapAsset( (event.target.content as Bitmap).bitmapData, 'auto', true );
			}
		}
		
		
	}

}