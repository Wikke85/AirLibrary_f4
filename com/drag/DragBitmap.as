package com.drag
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.formatters.DateFormatter;
	
	public class DragBitmap
	{
		private var _displayObject:DisplayObject;
		private var dateFormatter:DateFormatter;
		
		public var dragIcon:BitmapData;
		
		public function DragBitmap()
		{
			var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
				function ():void
				{
					dragIcon = Bitmap(loader.content).bitmapData;
				}
			);
			loader.load(new URLRequest("icon_image.png"));
			dateFormatter = new DateFormatter();
			dateFormatter.formatString = "YYYY-MM-DD-HH-NN-SS";
		} 
		
		public function set displayObject(displayObject:DisplayObject):void
		{
			_displayObject = displayObject;
			_displayObject.addEventListener(MouseEvent.MOUSE_MOVE, startDragging);
		}
		
		private function startDragging(event:MouseEvent):void
		{
			if (!event.buttonDown) 
			{
				return;
			}

			var options:DragOptions = new DragOptions();
			
			options.allowCopy = true;
			options.allowLink = true;
			options.allowMove = false;

			var data:TransferableData = new TransferableData();
			data.addData(getBitmapData(), TransferableFormats.BITMAP_FORMAT, false);
			data.addData([createTempJPG()], TransferableFormats.FILE_LIST_FORMAT);

			DragManager.doDrag(_displayObject, data, dragIcon, null, options);
		}
			
		private function getBitmapData():BitmapData
		{
			var bd:BitmapData = new BitmapData(_displayObject.width, _displayObject.height);
			bd.draw(_displayObject);
			return bd;
		}

		private function createTempJPG():File
		{
			var file:File = File.createTempDirectory().resolve("data-"+dateFormatter.format(new Date())+".jpg");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(encodeJPG());
			fileStream.close();
			return file;
		}

		private function encodeJPG():ByteArray
		{
			var jpgEncoder:JPGEncoder = new JPGEncoder();
			var bytes:ByteArray = jpgEncoder.encode(getBitmapData());
			return bytes;
		}
		
	}
}