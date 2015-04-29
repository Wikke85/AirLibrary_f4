package com
{
	import mx.collections.ArrayCollection;
	
	public class ColdFusionComponent extends ArrayCollection
	{
		
		public static const RETURNTYPE_ANY:String		= 'any';
		public static const RETURNTYPE_ARRAY:String		= 'array';
		public static const RETURNTYPE_BINARY:String	= 'binary';
		public static const RETURNTYPE_BOOLEAN:String	= 'boolean';
		public static const RETURNTYPE_DATE:String		= 'date';
		public static const RETURNTYPE_GUID:String		= 'guid';
		public static const RETURNTYPE_NUMERIC:String	= 'numeric';
		public static const RETURNTYPE_QUERY:String		= 'query';
		public static const RETURNTYPE_STRING:String	= 'string';
		public static const RETURNTYPE_STRUCT:String	= 'struct';
		public static const RETURNTYPE_UUID:String		= 'uuid';
		public static const RETURNTYPE_VOID:String		= 'void';
		
		public static const ACCESS_PRIVATE:String	= 'private';
		public static const ACCESS_PACKAGE:String	= 'package';
		public static const ACCESS_PUBLIC:String	= 'public';
		public static const ACCESS_REMOTE:String	= 'remote';
		
		public var fileName:String = '';
		public var connection:String = '';
		
		public function ColdFusionComponent(functions:Array, fileName:String, connection:String='')
		{
			super(functions);
			
			this.fileName = fileName;
			this.connection = connection;
			
		}
		
		public function addFunction(name:String, returnType:String='query', access:String='remote'):void {
			addItem( new ColdFusionFunction([], name, returnType, access) );
		}
		
		public function getCode():String {
			var ret:String = '<cfcomponent>\n';
			
			if(connection != null && connection != ''){
				ret += '\t<cfset connectionString = "'+connection+'">\n\n'
			}
			
			for(var i:int=0; i<source.length; i++){
				ret += ColdFusionFunction(source[i]).getCode();
			}
			
			//ret = ret.split('%mx_internal_connectionString_toreplace%').join(connection);
			
			ret += '</cfcomponent>';
			
			return ret;
		}
		
		
		
		
	}
}