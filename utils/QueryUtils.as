package utils
{
	
	public class QueryUtils
	{
		
		
		
		/**
		 * Check parameter type and make it valid against SQLite
		 * 
		 * strings with a quote: must be double quoted and enclosed with quotes
		 * date: specify right date format
		 * boolean: false -> 0, true -> 1
		 * NaN: 'null'
		 * */
		public static function safe(parameter:*, prefix:String="'", suffix:String="'"):* {
			
			if(parameter is Date){
				var ds:String = FormatUtils.formatDate(parameter as Date, 'yyyy-mm-dd');
				parameter = prefix + ds + suffix;
			}
			else if(parameter is String){
				// replace quotes with double quotes
				parameter = String(parameter).replace(/\'/g, "''"); //'
				
				// enclose with quotes (default)
				parameter = prefix + String(parameter) + suffix;
				
			}
			else if(parameter is Boolean){
				parameter = parameter == true ? 1 : 0;
			}
			else if(isNaN(Number(parameter))){
				parameter = 'null';
			}
			
			return parameter;
		}
		
		
		/**
		 * Sql Select query
		 * Change the fieldnames without aliases to fieldnames with aliases:
		 * 	t.fieldname, => t.fieldname as fieldname
		 * 
		 * in SQLite, a field without alias, but with a table shortcut prefix, includes this prefix in the fieldname:
		 * 	t.fieldname => t_fieldname
		 * */
		public static function aliases(query:String):String {
			//TODO: test
			
			// index of 'SELECT'
			var sIndex:int = query.toUpperCase().lastIndexOf('SELECT');
			// index of 'FROM'
			var fIndex:int = query.toUpperCase().lastIndexOf('FROM');
			
			var newQuery:String = '';
			
			if(sIndex > -1 && fIndex > sIndex){
				// get column selection list
				var cols:String = query.substring(sIndex + 6, fIndex);
				
				// if only '*' (select all): no aliases can be made
				if(cols.replace(/\n\r\t /g, '') == '*'){
					newQuery = query;
				}
				// column names are given, create aliases if necessary
				else {
					// parse columns: check for alias, if not present: create
					var tmpCols:Array = cols.split(',');
					for(var i:int=0; i<tmpCols.length; i++){
						// when no star: column name is given
						if(tmpCols[i].indexOf('*') == -1){
							// no alias present: create
							if(tmpCols[i].replace(/\n\r\t/g, ' ').toLowerCase().indexOf(' as ') == -1 && tmpCols[i].toLowerCase().indexOf('.') != -1){
								tmpCols[i] = tmpCols[i] + ' as ' + tmpCols[i].split('.')[tmpCols[i].split('.').length-1];
							}
							// alias already given: ignore
							else {
								
							}
						}
						// select all from 1 table: ignore
						else {
							
						}
					}
					
					// build new query
					newQuery = 'SELECT ' + tmpCols.join(',') + query.substr(fIndex);
				}
			}
			else {
				newQuery = query;
			}
			
			return newQuery;
		}
		
		
		
	}
}