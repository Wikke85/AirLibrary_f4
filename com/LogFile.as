package com
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	
	/**
	 * Logs a text to a file, separated by newline character
	 * Adds a timestamp and a tab in front of the line
	 * 	The timestamp format is specified in the constructor, and follows the DateFormatter notation
	 * 
	 * function log(text:String):
	 * 	appends the given string directly to the file.
	 * 
	 * parameters:
	 * 	filename: the file to write the log entries to
	 * 	dateFormat: format of the date in front of each line
	 * 	maxFileSize: maximum file size in kilobytes. if the logfile exists, and exceeds this number, the logfile will be copied
	 * 				to a new file with a suffix: '.YYYYMMDD.HHNN[._n].old' 
	 * 				default: -1, no limit
	 * */
	public class LogFile
	{
		
		public static const DEFAULT_DATEFORMAT:String = 'YYYY/MM/DD HH:NN:SS';
		
		public static const LEVEL_INFO:int = 0;
		public static const LEVEL_WARNING:int = 1;
		public static const LEVEL_ERROR:int = 2;
		
		//private var logs:ArrayCollection;
		private var logFile:File;
		private var df:DateFormatter;
		private var logLevel:int = -1;
		
		public function LogFile(file:Object, dateFormat:String = DEFAULT_DATEFORMAT, maxFileSize:Number = -1, logLevel:int = -1)
		{
			df = new DateFormatter;
			df.formatString = 'YYYYMMDD';
			
			this.logLevel = logLevel;
			
			if(file is File){
				logFile = file as File;
			}
			else {
				logFile = new File(String(file));
			}
			
			if(maxFileSize > 0 && logFile.exists && logFile.size >= (maxFileSize*1024) ){
				var i:int = 0;
				var nf:File = new File(logFile.nativePath + '.'+df.format(new Date)+'_0.old');
				while(nf.exists){
					nf = new File(logFile.nativePath + '.'+df.format(new Date)+'._'+i+'.old');
					i++;
				}
				logFile.moveTo(nf);
				if(logFile.exists) logFile.deleteFile();
			}
			
			df.formatString = dateFormat;
		}
		
		public function log(text:String, level:int=-1):void {
			
			var date:Date = new Date;
			
			/*logs.addItem({
				text:	text,
				date:	df.format(date)
			});*/
			
			if(level >= logLevel){
				
				var fs:FileStream = new FileStream;
				
				if(logFile.exists){
					fs.open(logFile, FileMode.APPEND);
				}
				else {
					fs.open(logFile, FileMode.WRITE);
				}
				
				var levelstr:String = '';
				switch(level){
					case LEVEL_INFO:
						levelstr = 'INFO	';
						break;
					case LEVEL_WARNING:
						levelstr = 'WARNING	';
						break;
					case LEVEL_ERROR:
						levelstr = 'ERROR	';
						break;
				}
				
				//fs.writeUTF(str);
				fs.writeMultiByte
				(
					levelstr + 
					df.format(date) + 
					'	' + 
					text + 
					"\n",
					File.systemCharset //'iso-8859-1'
				);
				
				fs.close();
				
			}
		}
		
		/*public function flush():void {
			var str:String = '';
			for(var i:int=0; i<logs.length; i++){
				str += '' + logs[i].date + '	' + logs[i].text + "\n";
			}
			
			logs = new ArrayCollection;
			
			var fs:FileStream = new FileStream;
			fs.openAsync(logFile, FileMode.WRITE);
			
			//fs.writeUTF(str);
			fs.writeMultiByte(str, 'iso-8859-1');
			
			fs.close();
		}*/
		
	}
}