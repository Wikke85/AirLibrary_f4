package com.encoders
{

	import com.encoders.components.ZipCompression;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	import mx.core.UIComponent;

	public class ExportManager extends EventDispatcher {

		// Singleton Implementation:
		// =========================
		private static var _instance:ExportManager;
		public static function get instance(): ExportManager {
			if(!_instance) _instance = new ExportManager();
			return _instance;
		}

		// Fields:
		// =======
		protected var jpgEncoder:JPGEncoder;
		protected var pngEncoder:PNGEncoder;
		protected var bmpEncoder:BMPEncoder;
		protected var gifEncoder:GIFEncoder;
		protected var zipEncoder:ZIPEncoder;

		// Properties:
		// ===========
		private var _jpgQuality:Number = 80;
		public function get jpgQuality(): Number { return _jpgQuality; }
		public function set jpgQuality(value:Number): void {
			if(_jpgQuality != value) {
				_jpgQuality = value;
				jpgEncoder = new JPGEncoder(value);
			}
		}

		// Constructor:
		// ============
		public function ExportManager(target:IEventDispatcher=null) {
			super(target);
			if(_instance) throw new Error("Singleton Exception: An instance of 'ExportManager' already exists.");
			jpgEncoder = new JPGEncoder(jpgQuality);
			pngEncoder = new PNGEncoder();
			bmpEncoder = new BMPEncoder();
			gifEncoder = new GIFEncoder();
		}

		// Public Methods:
		// ===============

		// Jpeg Encoding:
		public function getComponentAsJPG(comp:UIComponent,quality:Number=-1): ByteArray {
			var data:BitmapData = new BitmapData(comp.width,comp.height);
			data.draw(comp);
			return getBitmapDataAsJPG(data,quality);
		}
		public function getBitmapDataAsJPG(data:BitmapData,quality:Number=-1): ByteArray {
			var encoder:JPGEncoder = jpgEncoder;
			if((quality > -1) && (quality != jpgQuality)) encoder = new JPGEncoder(quality);
			return encoder.encode(data);
		}

		// Png Encoding:
		public function getComponentAsPNG(comp:UIComponent): ByteArray {
			var data:BitmapData = new BitmapData(comp.width,comp.height);
			data.draw(comp);
			return getBitmapDataAsPNG(data);
		}
		public function getBitmapDataAsPNG(data:BitmapData): ByteArray {
			return pngEncoder.encode(data);
		}

		// Bmp Encoding:
		public function getComponentAsBMP(comp:UIComponent): ByteArray {
			var data:BitmapData = new BitmapData(comp.width,comp.height);
			data.draw(comp);
			return getBitmapDataAsBMP(data);
		}
		public function getBitmapDataAsBMP(data:BitmapData): ByteArray {
			return bmpEncoder.encode(data);
		}

		// Gif Encoding:
		public function getComponentAsGIF(comp:UIComponent): ByteArray {
			var data:BitmapData = new BitmapData(comp.width,comp.height);
			data.draw(comp);
			return getBitmapDataAsGIF(data);
		}
		public function getBitmapDataAsGIF(data:BitmapData): ByteArray {
			gifEncoder.start();
			gifEncoder.addFrame(data);
			gifEncoder.finish();
			return gifEncoder.stream;
		}

		// Zip Encoding:
		private var mainZipDir:String;
		public function createZipFile(mainDirName:String): void {
			mainZipDir = mainDirName;
			zipEncoder = new ZIPEncoder(ZipCompression.GZIP);
			zipEncoder.addDirectory(mainDirName);
		}
		public function addDirectoryToZipFile(dirName:String): void {
			dirName = mainZipDir + "/" + dirName;
			zipEncoder.addDirectory(dirName);
		}
		public function addFileToZipFile(bytes:ByteArray,dirName:String): void {
			dirName = mainZipDir + "/" + dirName;
			zipEncoder.addFile(bytes,dirName);
		}
		public function addCommentToZipFile(): void {
			zipEncoder.addComment("comment");
		}
		public function getZipFile(): ByteArray {
			return zipEncoder.saveZIP();
		}

	}

}