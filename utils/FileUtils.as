package utils
{
	
	import com.data.Cookie;
	
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	
	public class FileUtils
	{
		
		public function FileUtils(){
			
		}
		
		private static var cookie:Cookie = new Cookie('last_selected_dir');
		
		private static var file:File = File.documentsDirectory;
		
		/**
		 * Get the last selected directory
		 * or, if not yet set, get the documents directory by default
		 * 
		 * */
		public static function lastSelectedDirectory():File {
			if(cookie.data != null && cookie.data.hasOwnProperty('path')){
				file = new File(cookie.data.path);
			}
			file.addEventListener(Event.SELECT, onFileSelect, false, 0, true);
			// check if the returned file is a directory, if not: get parent
			return file.isDirectory ? file : file.parent;
			//return lastSelectedFile();
		}
		
		
		/**
		 * Get the last selected file
		 * or, if not yet set, get the documents directory by default
		 * */
		public static function lastSelectedFile():File {
			if(cookie.data != null && cookie.data.hasOwnProperty('path')){
				file = new File(cookie.data.path);
			}
			file.addEventListener(Event.SELECT, onFileSelect, false, 0, true);
			// file can be a directory or a file
			return file;
		}
		
		
		// save the path of the last selected file, this can be a directory or a file
		private static function onFileSelect(event:Event):void {
			if(event is FileListEvent){
				
			}
			else {
				file = event.target as File;
				cookie.data.path = file.nativePath;
				cookie.save();
				file.removeEventListener(Event.SELECT, onFileSelect);
			}
		}
		
		
		
		/* *
		 * Set the last selected directory
		 * 
		 * Used in 'select' event handler: setLastSelectedFile(event.target as File)
		 * * /
		public static function setLastSelectedFile(selectedFile:File):void {
			file = selectedFile;
			cookie.data.path = selectedFile.nativePath.substring(0, selectedFile.nativePath.lastIndexOf(File.separator)+1);
			cookie.save();
		}
		/* */
		
		
		/**
		 * read the structure of an xml file.
		 * the xml file can be given either 
		 * 	- as a string to a file on the application directory, or
		 * 	- as a File object
		 * */
		public static function readXmlFile(filename:String, fileObj:File = null):XML {
			var fileStream:FileStream = new FileStream();
			if(fileObj == null){
				var file:File = File.applicationDirectory.resolvePath(filename);
				fileStream.open(file, FileMode.READ);
			}
			else {
				fileStream.open(fileObj, FileMode.READ);
			}
			var resultXML:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			return resultXML;
		}
		
		
		
		
		/**
		 * read a file as string
		 * the file can be given either 
		 * 	- as a string to a file on the application directory, or
		 * 	- as a File object
		 * */
		public static function readFile(filename:String, fileObj:File = null, clearLineBreaks:Boolean = false, utf8:Boolean = true):String {
			var fileStream:FileStream = new FileStream();
			if(fileObj == null){
				var file:File = File.applicationStorageDirectory.resolvePath(filename);
				if(file.exists){
					fileStream.open(file, FileMode.READ);
				}
			}
			else {
				if(fileObj.exists){
					fileStream.open(fileObj, FileMode.READ);
				}
			}
			var result:String = '';
			try {
				if(utf8){
					result = fileStream.readUTFBytes(fileStream.bytesAvailable);
				}
				else {
					result = fileStream.readMultiByte(fileStream.bytesAvailable, 'iso-8859-1');
					
					if(result.indexOf('ÿþ') == 0){
						fileStream.position = 0;
						result = fileStream.readMultiByte(fileStream.bytesAvailable, 'unicode');
					}
					//result = fileStream.readMultiByte(fileStream.bytesAvailable, 'unicode');	//utf-16
					//result = fileStream.readMultiByte(fileStream.bytesAvailable, 'unicodeFFFE');	//Unicode (Big-Endian)
					
					//result = fileStream.readMultiByte(fileStream.bytesAvailable, 'macintosh');	// Western European (Mac)
					//result = fileStream.readMultiByte(fileStream.bytesAvailable, 'Windows-1252');	// Western European (Windows)
					
				}
				fileStream.close();
			}
			catch(e:Error){}
			
			if(clearLineBreaks){
				result = result.split('\r').join('\n');
				while(result.indexOf('\n\n') > -1){
					result = result.split('\n\n').join('\n');
				}
			}
			
			return result;
		}
		
		/**
		 * writes a string or byte array to a file
		 * the file can be given either 
		 * 	- as a string to a file on the application directory, or
		 * 	- as a File object
		 * */
		public static function writeFile(value:Object, filename:String, fileObj:File = null, utf8:Boolean = true):void {
			var fileStream:FileStream = new FileStream();
			if(fileObj == null){
				var file:File = File.applicationStorageDirectory.resolvePath(filename);
				fileStream.openAsync(file, FileMode.WRITE);
			}
			else {
				fileStream.openAsync(fileObj, FileMode.WRITE);
			}
			
			if(value is ByteArray) {
				fileStream.writeBytes(value as ByteArray, 0, (value as ByteArray).length);
			}
			else if(utf8){
				fileStream.writeUTFBytes(value.toString());
			}
			else {
				
				/*var ba:ByteArray = new ByteArray;
				ba.writeObject(value);
				fileStream.writeBytes(ba, 0, ba.length);*/
				
				fileStream.writeMultiByte(value.toString(), File.systemCharset /*"iso-8859-1"*/);
			}
			fileStream.close();
		}
		
		
		public static function readDirectory(directory:File, target:ArrayCollection, recursive:Boolean = false):void {
			var tmp:ArrayCollection = new ArrayCollection(directory.getDirectoryListing());
			for(var i:int=0; i<tmp.length; i++){
				if((tmp[i] as File).name != '.' && (tmp[i] as File).name != '..'){
					target.addItem(tmp[i]);
					if(recursive && (tmp[i] as File).isDirectory){
						readDirectory(tmp[i], target, recursive);
					}
				}
			}
		}
		
		
		public static function filterModifiedAfter(fileList:ArrayCollection, date:Date, excludeDirectories:Boolean = true):ArrayCollection {
			var values:ArrayCollection = new ArrayCollection;
			var dateNum:Number = Number(FormatUtils.formatDate(date, 'yyyymmddhhmiss'));
			
			for(var i:int=0; i<fileList.length; i++){
				if( 
					(
						excludeDirectories && !(fileList[i] as File).isDirectory
						||
						!excludeDirectories
					)
					&&
					Number(FormatUtils.formatDate((fileList[i] as File).modificationDate, 'yyyymmddhhmiss')) > dateNum 
				){
					values.addItem(fileList[i]);
				}
			}
			return values;
		}
		
		
		/**
		 * This string contains all the characters which are forbidden
		 * */
		public static const forbiddenChars:String = '<>:"/\\\\|?*';
		
		
	}
}