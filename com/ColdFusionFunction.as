package com
{
	import mx.collections.ArrayCollection;
	
	public class ColdFusionFunction extends ArrayCollection
	{
		
		public static const TYPE_ANY:String			= 'any';	// cf_sql_varchar
		public static const TYPE_ARRAY:String		= 'array';
		public static const TYPE_BINARY:String		= 'binary';	//
		public static const TYPE_BOOLEAN:String		= 'boolean';	// cf_sql_bit
		public static const TYPE_DATE:String		= 'date';	//cf_sql_date
		public static const TYPE_GUID:String		= 'guid';
		public static const TYPE_NUMERIC_INT:String		= 'numeric_int';	// cf_sql_integer
		public static const TYPE_NUMERIC_FLOAT:String	= 'numeric_float';	// cf_sql_float
		public static const TYPE_QUERY:String		= 'query';
		public static const TYPE_STRING:String		= 'string';	// cf_sql_varchar
		public static const TYPE_STRUCT:String		= 'struct';
		public static const TYPE_UUID:String		= 'uuid';
		public static const TYPE_XML:String			= 'xml';	// cf_sql_varchar
		
		public var name:String = '';
		public var returnType:String = '';
		public var access:String = '';
		
		private var query:String = '';
		private var storedProc:String = '';
		
		public function ColdFusionFunction(arguments:Array, name:String, returnType:String='query', access:String='remote')
		{
			super(arguments);
			
			this.name = name;
			this.returnType = returnType;
			this.access = access;
			
		}
		
		public function addArgument(name:String, type:String='string', required:Boolean=true, defaultVal:String=''):void {
			var sqlType:String = 'cf_sql_varchar';
			switch(type){
				case TYPE_BOOLEAN:			sqlType = 'cf_sql_bit';		break;
				case TYPE_DATE:				sqlType = 'cf_sql_date';	break;
				case TYPE_NUMERIC_INT:		sqlType = 'cf_sql_integer';	break;
				case TYPE_NUMERIC_FLOAT:	sqlType = 'cf_sql_float';	break;
				
			}
			
			addItem({
				name: name,
				type: type,
				sqlType: sqlType,
				required: required,
				defaultVal: defaultVal
			});
		}
		
		public function setSqlQueryToRun(query:String):void {
			this.query = query;
		}
		
		public function setStoredProcToRun(storedProc:String):void {
			this.storedProc = storedProc;
		}
		
		public function getCode():String {
			
			var ret:String = '\t<cffunction name="'+name+'" access="'+access+'" returntype="'+returnType+'">\n';
			
			var spParams:String = '';
			
			for(var i:int=0; i<source.length; i++){
				
				var type:String = String(source[i].type).toLowerCase();
				if(type.indexOf('numeric') != -1) type = 'numeric';
				
				if(source[i].required){
					ret += '\t\t<cfargument name="'+source[i].name+'" type="'+type+'">\n';
				}
				else {
					ret += '\t\t<cfargument name="'+source[i].name+'" type="'+type+'" required="false" default="'+source[i].defaultVal+'">\n';
				}
				spParams += '\t\t\t<cfprocparam value="#'+source[i].name+'#" cfsqltype="'+source[i].sqlType+'">\n';
			}
			
			if(query != null && query != ''){
				ret += '\t\t<cfquery name="'+name+'_result" datasource="#connectionString#" dbtype="ODBC">\n';
				ret += query + '\n';
				ret += '\t\t</cfquery>\n';
				ret += '\t\t<cfreturn '+name+'_result>\n';
			}
			else if(storedProc != null && storedProc != ''){
				ret += '\t\t<cfstoredproc procedure="'+storedProc+'" datasource="#connectionString#">\n';
				ret += spParams + '\n';
				ret += '\t\t\t<cfprocresult name="'+name+'_result">\n';
				ret += '\t\t</cfstoredproc>\n';
				ret += '\t\t<cfreturn '+name+'_result>\n';
			}
			else {
				ret += '\t\t<cfreturn>\n';
			}
			
			
			ret += '\t</cffunction>\n\n';
			
			return ret;
		}
		
	}
}