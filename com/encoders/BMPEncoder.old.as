/*
	Source Code License Agreement
	Copyright(c) 2007 Rutger van den Brink.
	Info: devshed@britec.nl
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL I
	OR MY SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package export
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import export.encoderClasses.RGBPixel;
	
	/**
	 * Class that converts BitmapData into a 24BPP Windows Bitmap
	 */	
	public class BMPEncoder
	{

		private var byteout:ByteArray;
		private var rgbPixel:RGBPixel = new RGBPixel();

		private function writeByte(value:int):void
		{
			byteout.writeByte(value);
		}
	
		private function writeWord(value:int):void
		{
			writeByte((value>>8)&0xFF);
			writeByte((value   )&0xFF);
		}
		
		private function writeHeader(height:int, width:int):void
		{
			//header
			writeWord(0x424D); // Magic identifier ('BM')
			writeWord(0x0000); // File size in bytes
			writeWord(0x0000); // File size in bytes
			writeWord(0x0000); // reserved1
			writeWord(0x0000); // reserved2
			writeWord(0x3600); // Offset to image data, bytes

			writeByte(0x00); //2bytepad!

			//information
			writeWord(0x0028); //Header size in bytes

			writeWord(0x0000); // imWidth
			writeWord(width);  // imWidth
			writeWord(0x0000); // imHeight
			writeWord(height); // imHeight

			writeWord(0x0000); // unknown
			writeWord(0x0001); // biPlanes
			writeWord(0x0018); // biBitCount
			writeWord(0x0000); // biCompression
			writeWord(0x0000); // biCompression
			writeWord(0x0000); // biSizeImage
			writeWord(0x0000); // biSizeImage
			writeWord(0x0000); // biXPelsPerMeter
			writeWord(0x0000); // biXPelsPerMeter
			writeWord(0x0000); // biYPelsPerMeter
			writeWord(0x0000); // biYPelsPerMeter
			writeWord(0x0000); // biClrUsed
			writeWord(0x0000); // biClrUsed
			writeWord(0x0000); // biClrImportant
			writeWord(0x0000); // biClrImportant

			writeByte(0x00); //2bytepad!			
		}

		private function processPixel(pixeldata:uint=0):void
		{
			//extract individual RGB pixeldata
			rgbPixel.r = ((pixeldata >> 16) & 0xFF);
			rgbPixel.g = ((pixeldata >> 8) & 0xFF);
			rgbPixel.b = (pixeldata & 0xFF);
		}

		/**
		 * Constructor for BMPEncoder class
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 */		
		public function BMPEncoder()
		{
			//constructor
		}

		/**
		 * Create a BMP image from the specified BitmapData
		 *
		 * @param The BitmapData that will be converted into the BMP format.
		 * @return a ByteArray representing the BMP encoded image data.
		 */	
		public function encode(image:BitmapData):ByteArray
		{
			byteout = new ByteArray();
			var rowpad:int = image.width % 4;

			//header
			writeHeader(image.height,image.width);

			//data
			//bmpfiledata is encoded in reverse
 			for (var y:int=image.height-1; y >= 0; y--)
			{
				for (var x:int=0; x < image.width; x++)
				{
					processPixel(image.getPixel(x,y));
					writeByte(rgbPixel.b); //Blue
					writeByte(rgbPixel.g); //Green
					writeByte(rgbPixel.r); //Red
				}
				
				//padding: each row should be a multiple of 4!
				for (var p:int = 0; p < rowpad; p++)
				{
					writeByte(0x00);					
				}
			}
			return byteout;
		}
	}
}