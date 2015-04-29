package com
{
	import mx.utils.ObjectUtil;
	
	/**
	 * CSV parser
	 * 
	 * The decode function is converted from a PHP script at: http://minghong.blogspot.com/2006/07/csv-parser-for-php.html
	 * 
	 * */
	public class CSV
	{
		
		public function CSV()
		{
			super();
		}
		
		private var _separator:String = ',';
		private var _enclosure:String = '"';
		
		//private var _rawLines:Array;
		private var _headers:Array;
		private var _dataFields:Array;
		private var _data:Array;
		
		
		public function get separator():String { return _separator; }
		public function get enclosure():String { return _enclosure; }
		
		//public function get rawLines():Array { return _rawLines; }
		public function get headers():Array { return _headers; }
		public function get dataFields():Array { return _dataFields; }
		public function get data():Array { return _data; }
		
		
		
		
		/**
		 * Read raw CSV text and parse it to an Array of objects
		 * */
		public function decode(csvData:String):Array {
			
			// convert windows line delimiters to \n
			if(csvData.indexOf("\r\n") > -1){
				csvData = csvData.replace(/\r\n/g, '\n');
			}
			
			// convert mac delimiters to \n
			if(csvData.indexOf("\r") > -1 && csvData.indexOf("\n") == -1){
				csvData = csvData.replace(/\r/g, '\n');
			}
			
			// make sure the last char is \n
			if(csvData.charAt(csvData.length - 1) != "\n"){
				csvData += "\n"
			}
			
			_separator = ',';
			_dataFields = [];
			
			var row:Object = {};
			
			
			var doubleEclosure:RegExp = new RegExp(_enclosure+_enclosure, 'g');
			var spaces:RegExp = / /g;
			
			
			// Header
			_headers = csvData.split("\n")[0].split(_separator);
			
			// when fields are separated with a ';'
			// re-parse columns using ';' instead of ','
			if(_headers.length == 1){
				_separator = ';';
				_headers = csvData.split("\n")[0].split(_separator);
			}
			
			// remove first line (header)
			csvData = csvData.split("\n").slice(1).join("\n");
			
			
			for(var hi:int=0; hi<_headers.length; hi++){
				var field:String = String(_headers[hi]).toLowerCase().replace(spaces, '_');
				
				_dataFields.push(field);
			}
			// Header
			
			
			// Data
			var fieldIndex:int = 0;	// current field name from dataFields
			var quoted:Boolean = false;	// indicates if a field is surrounded with quotes or not
			
			for(var ti:int=0; ti<csvData.length; ti++){
				var char:String = csvData.charAt(ti);
				if(char == _enclosure){
					quoted = !quoted;
				}
				
				// End of line
				if(char == "\n" && !quoted){
					// Remove enclosure delimiters
					/*for(var k:int = 0; k<row.length; k++){
						if(row[k] != "" && row[k].charAt(0) == enclosure){
							row[k] = row[k].substr(1, row[k].length - 2);
						}
						row[k] = row[k].split(enclosure + enclosure).join(enclosure);
					}*/
					
					// row ended
					_data.push(ObjectUtil.copy(row));
					
					// reset
					row = {};
					fieldIndex = 0;
					
				}
				
				// End of field
				else if(char == _separator && !quoted){
					
					var cell:String = row[_dataFields[fieldIndex]];
					// remove beginning and end quotes
					if(cell.charAt(0) == _enclosure && cell.charAt(cell.length-1) == _enclosure){
						cell = cell.substring(1, cell.length-1);
					}
					
					// replace double quotes in string with single one
					row[_dataFields[fieldIndex]] = cell.replace(doubleEclosure, _enclosure);
					
					// create next field
					fieldIndex++;
					row[_dataFields[fieldIndex]] = '';
					
					
				}
				
				// Inside the field
				else {
					if(row.hasOwnProperty(_dataFields[fieldIndex])){
						row[_dataFields[fieldIndex]] += char;
					}
					else {
						row[_dataFields[fieldIndex]] = char;
					}
				}
			}
			
			return _data;
		}
		
		
		/* *
		 * Read raw CSV text and parse it to an Array of objects
		 * */
		/*public function decode(data:String):Array {
			//_rawLines = data.replace(/\r/g, '\n').replace(/\n\n/g, '\n').split('\n');
			
			var _line:String = '';
			var _headers:Array;
			
			_dataFields = [];
			var _tmpData:Object = {};
			
			//if(_lines.length > 1){
				
				// Header
				//_line = _lines[0];
				//_headers = _line.split(separator);
				_headers = _lines[0].split(separator);
				
				// when fields are separated with a ';'
				// re-parse columns using ';'
				if(_headers.length == 1){
					_separator = ';';
					//_headers = _line.split(separator);
					_headers = _lines[0].split(separator);
				}
				
				var doubleEclosure:RegExp = new RegExp(_enclosure+_enclosure, 'g');
				var spaces:RegExp = / /g;
				
				for(var hi:int=0; hi<_headers.length; hi++){
					var field:String = String(_headers[hi]);
					
					_dataFields.push(field);
				}
				// Header
				
				
				// Data
				for(var i:int=1; i<_lines.length; i++){
					//_line = _lines[i];
					
					//if(_line != ''){
						var fieldIndex:int = 0;	// current field name from dataFields
						var quoted:Boolean = false;	// indicates if a field is surrounded with quotes or not
						
						for(var li:int=0; li<_line.length; li++){
							var char:String = _line.charAt(li);
							if(char == enclosure){
								quoted = !quoted;
							}
							
							// End of line
							// /*line delimiter is never encountered, as we split the file on this (and thus is removed)
							// removing double quotes and begin/end quotes happens down below* /
							if(char == "\n" && !quoted){
								// Remove enclosure delimiters
								for(var k:int = 0; k<_line.length; k++){
									if(_line[k] != "" && _line[k].charAt(0) == enclosure){
										_line[k] = _line[k].substr(1, _line[k].length - 2);
									}
									_line[k] = _line[k].split(enclosure + enclosure).join(enclosure);
								}
								
								_line = [''];
								fieldIndex = 0;
							}
							
							// End of field
							else if(char == separator && !quoted){
								
								var cell:String = _tmpData[_dataFields[fieldIndex]];
								// remove beginning and end quotes
								if(cell.charAt(0) == enclosure && cell.charAt(cell.length-1) == enclosure){
									cell = cell.substring(1, cell.length-1);
								}
								
								// replace double quotes in string with single one
								_tmpData[_dataFields[fieldIndex]] = cell.replace(doubleEclosure, enclosure);
								
								// create next field
								fieldIndex++;
								_tmpData[_dataFields[fieldIndex]] = '';
							}
							
							// Inside the field
							else {
								if(_tmpData.hasOwnProperty(_dataFields[fieldIndex])){
									_tmpData[_dataFields[fieldIndex]] += char;
								}
								else {
									_tmpData[_dataFields[fieldIndex]] = char;
								}
							}
						}
						
						/*var cell:String;
						
						for(var ri:int=0; ri<row.length; ri++){
							cell = row[ri];
							
							if(cell.charAt(0) == enclosure && cell.charAt(cell.length-1) == enclosure){
								cell = cell.substring(1, cell.length-2);
							}
							
							data[dataFields[ri]] = cell.replace(doubleEclosure, enclosure);
						}* /
						
						if(!hasResultHandler){
							hasResultHandler = true;
							SRV.srvManagement.addResultHandler("setImportProduct", onSetImportProductResult);
						}
						SRV.srvManagement.send('setImportProduct', idImport, _tmpData);
						results++;
						
						_data.push(ObjectUtil.copy(_tmpData));	// copy _tmpData to prevent ending with an array full of nulls
						_tmpData = {};
						
					//}
					// Data
				}
			//}
			return _data;
		}*/
		
		/*
		// Source
		/**
		 * CSV file parser
		 * Currently the string matching doesn't work
		 * if the output encoding is not ASCII or UTF-8
		 * /
		class CsvFileParser
		{
		    var $delimiter;         // Field delimiter
		    var $enclosure;         // Field enclosure character
		    var $inputEncoding;     // Input character encoding
		    var $outputEncoding;    // Output character encoding
		    var $data;              // CSV data as 2D array
		
		    /**
		     * Constructor
		     * /
		    function CsvFileParser()
		    {
		        $this->delimiter = ",";
		        $this->enclosure = '"';
		        $this->inputEncoding = "ISO-8859-1";
		        $this->outputEncoding = "ISO-8859-1";
		        $this->data = array();
		    }
		
		    /**
		     * Parse CSV from file
		     * @param   content     The CSV filename
		     * @param   hasBOM      Using BOM or not
		     * @return Success or not
		     * /
		    function ParseFromFile( $filename, $hasBOM = false )
		    {
		        if ( !is_readable($filename) )
		        {
		            return false;
		        }
		        return $this->ParseFromString( file_get_contents($filename), $hasBOM );
		    }
		
		    /**
		     * Parse CSV from string
		     * @param   content     The CSV string
		     * @param   hasBOM      Using BOM or not
		     * @return Success or not
		     * /
		    function ParseFromString( $content, $hasBOM = false )
		    {
		        $content = iconv($this->inputEncoding, $this->outputEncoding, $content );
		        $content = str_replace( "\r\n", "\n", $content );
		        $content = str_replace( "\r", "\n", $content );
		        if ( $hasBOM )                                // Remove the BOM (first 3 bytes)
		        {
		            $content = substr( $content, 3 );
		        }
		        if ( $content[strlen($content)-1] != "\n" )   // Make sure it always end with a newline
		        {
		            $content .= "\n";
		        }
		
		        // Parse the content character by character
		        $row = array( "" );
		        $idx = 0;
		        $quoted = false;
		        for ( $i = 0; $i < strlen($content); $i++ )
		        {
		            $ch = $content[$i];
		            if ( $ch == $this->enclosure )
		            {
		                $quoted = !$quoted;
		            }
		
		            // End of line
		            if ( $ch == "\n" && !$quoted )
		            {
		                // Remove enclosure delimiters
		                for ( $k = 0; $k < count($row); $k++ )
		                {
		                    if ( $row[$k] != "" && $row[$k][0] == $this->enclosure )
		                    {
		                        $row[$k] = substr( $row[$k], 1, strlen($row[$k]) - 2 );
		                    }
		                    $row[$k] = str_replace( str_repeat($this->enclosure, 2), $this->enclosure, $row[$k] );
		                }
		
		                // Append row into table
		                $this->data[] = $row;
		                $row = array( "" );
		                $idx = 0;
		            }
		
		            // End of field
		            else if ( $ch == $this->delimiter && !$quoted )
		            {
		                $row[++$idx] = "";
		            }
		
		            // Inside the field
		            else
		            {
		                $row[$idx] .= $ch;
		            }
		        }
		
		        return true;
		    }
		}
		*/
		
		
		
		
		/**
		 * Build a raw CSV String from an Array
		 * parameters:
		 * data:		the data to export
		 * dataFields:	specify which fields in the array that needs to be exported
		 * 					if not set or empty, the fields of the first row in 'data' is taken
		 * headerTexts:	specify the column names
		 * 					if not set, or empty, or insufficient (length), the fieldname is taken
		 * */
		public function encode(data:Array, dataFields:Array = null, headerTexts:Array = null, fieldSeparator:String=';'):String {
			var csv:String;
			
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
				
				
			}
			return csv;
		}
		
		
		protected function formatCsvValue(value:String, separator:String):String {
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