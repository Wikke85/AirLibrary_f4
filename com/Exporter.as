package com
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	[Event(name="fileExists", type="flash.events.Event")]
	
	
	public class Exporter extends EventDispatcher
	{
		public function Exporter()
		{
			super();
		}
		
		
		private var _file:File;
		
		public function get file():File {
			return _file;
		}
		
		public function set file(value:File):void {
			_file = value;
			
			if(_fileType == null){
				throw new Error('Please set the fileType before the file');
			}
			
			if(_file != null){
				if(_file.extension == null){
					_file = new File((_file.nativePath + _fileType).split('..').join('.'));
					
					// if file is changed and the new file exists already:
					if(_file.exists){
						dispatchEvent(new Event('fileExists'));
					}
				}
				else if(_file.extension.toLowerCase().split('.').join('') != _fileType.split('.').join('')){
					_file = new File(_file.nativePath.split(_file.extension).join(_fileType).split('..').join('.'));
					
					// if file is changed and the new file exists already:
					if(_file.exists){
						dispatchEvent(new Event('fileExists'));
					}
				}
				
				// removed from here: filename wasn't changed by the system
				// and, system prompts to overwrite if already exists
				/*if(_file.exists){
					dispatchEvent(new Event('fileExists'));
				}*/
			}
		}
		
		
		
		private var _fileType:String;
		
		public function get fileType():String {
			return _fileType;
		}
		public function set fileType(value:String):void {
			if(value == null){
				throw new Error('fileType must be set to the desired file extension');
			}
			_fileType = value.toLowerCase();
			if(_fileType.indexOf('.') == -1){
				_fileType = '.' + _fileType;
			}
		}
		
		
		
		
		
		
		/**
		 * Export an array to an excel file (html format)
		 * parameters:
		 * data:		the data to export
		 * dataFields:	specify which fields in the array that needs to be exported
		 * 					if not set or empty, the fields of the first row in 'data' is taken
		 * headerTexts:	specify the column names
		 * 					if not set, or empty, or insufficient (length), the fieldname is taken
		 * */
		public function exportExcel(data:Array, dataFields:Array = null, headerTexts:Array = null):void {
			var html:String;
			
			if(_file == null){
				throw new Error("Please set the 'file' property for Exporter before calling the exportArray() function");
			}
			
			
			if(data != null){
				
				
				if(dataFields == null){
					dataFields = [];
				}
				// fill in the datafields if not set
				if(dataFields.length == 0 && data.length > 0){
					for(var f:String in data[0]){
						dataFields.push(f);
					}
				}
				
				if(headerTexts == null){
					headerTexts = [];
				}
				// fill in headertexts if not set, or length is different than datafields length
				if(headerTexts.length == 0 || headerTexts.length < dataFields.length){
					for(var i:int=headerTexts.length; i<dataFields.length; i++){
						headerTexts.push(dataFields[i]);
					}
				}
				
				html = '<table border="1">';
				html += '<tr>';
				
				for (var h:int = 0; h<headerTexts.length; h++)
				{
					html += '<th>' + formatExcelValue(headerTexts[h]) + '</th>';
				}
				html += '</tr>\n';
				
				for (var d:int = 0; d<data.length; d++)
				{
					var row:Object = data[d];
					html += '<tr>';
					
					for (var f2:int = 0; f2<dataFields.length; f2++)
					{
						try {
							html += '<td>' + formatExcelValue(row[dataFields[f2]]) + '</td>';
						}
						catch(e:Error){
							html += '<td></td>';
						}
					}
					html += '</tr>\n';
				}
				
				html += '</table>';
				
				
				var fileStream:FileStream = new FileStream();
				fileStream.open(_file,FileMode.WRITE);
				fileStream.writeMultiByte(html, File.systemCharset);
				fileStream.close();
				
			}
			
		}
		
		
		private function formatExcelValue(value:String):String {
			value.replace(/\</g, '&lt;');
			value.replace(/\>/g, '&gt;');
			
			return value;
		}
		
		
		
		/**
		 * Export an array to a csv file
		 * parameters:
		 * data:		the data to export
		 * dataFields:	specify which fields in the array that needs to be exported
		 * 					if not set or empty, the fields of the first row in 'data' is taken
		 * headerTexts:	specify the column names
		 * 					if not set, or empty, or insufficient (length), the fieldname is taken
		 * */
		public function exportCsv(data:Array, dataFields:Array = null, headerTexts:Array = null, fieldSeparator:String=';'):void {
			var csv:String;
			
			if(_file == null){
				throw new Error("Please set the 'file' property for Exporter before calling the exportCsv() function");
			}
			
			
			if(data != null){
				
				
				if(dataFields == null){
					dataFields = [];
				}
				// fill in the datafields if not set
				if(dataFields.length == 0 && data.length > 0){
					for(var f:String in data[0]){
						dataFields.push(f);
					}
				}
				
				if(headerTexts == null){
					headerTexts = [];
				}
				// fill in headertexts if not set, or length is different than datafields length
				if(headerTexts.length == 0 || headerTexts.length < dataFields.length){
					for(var i:int=headerTexts.length; i<dataFields.length; i++){
						headerTexts.push(dataFields[i]);
					}
				}
				
				csv = '';
				
				for (var h:int = 0; h<headerTexts.length; h++)
				{
					csv += (h > 0 /*&& h < headerTexts.length-1*/ ? fieldSeparator : '') + formatCsvValue(headerTexts[h], fieldSeparator);
				}
				csv += '\n';
				
				for (var d:int = 0; d<data.length; d++)
				{
					var row:Object = data[d];
					
					for (var f2:int = 0; f2<dataFields.length; f2++)
					{
						csv += (f2 > 0 /*&& f2 < dataFields.length-1*/ ? fieldSeparator : '') + formatCsvValue(row[dataFields[f2]], fieldSeparator);
						
					}
					csv += '\n';
				}
				
				
				
				var fileStream:FileStream = new FileStream();
				fileStream.open(_file,FileMode.WRITE);
				fileStream.writeMultiByte(csv, File.systemCharset);
				fileStream.close();
				
			}
			
		}
		
		
		private function formatCsvValue(value:String, separator:String):String {
			// determint if field needs to be surrounded with double quotes
			var encapsulate:Boolean = false;
			
			if(value.indexOf('"') > -1){
				// double quotes are escaped with another double quote
				value = value.split('"').join('""');
				//value = value.split('\r').join('\n');
				
				encapsulate = true;
			}
			
			// if the field contains a comma: encapsulate
			if(value.indexOf(separator) > -1){
				encapsulate = true;
			}
			
			// if the field contains a newline: encapsulate
			if(value.indexOf('\n') > -1 || value.indexOf('\r') > -1){
				encapsulate = true;
			}
			
			if(encapsulate){
				value = '"' + value + '"';
			}
			
			// enters: remove, its html anyway
			/*if(value.indexOf('\n') > -1){
				value = value.split('\n').join(' ');
			}*/
			
			return value;
		}
		
	}
	
}
