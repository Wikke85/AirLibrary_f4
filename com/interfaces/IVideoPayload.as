package com.interfaces
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	public interface IVideoPayload
	{
		function make($bitmapData:BitmapData):ByteArray;
	}
}