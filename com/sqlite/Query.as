package com.sqlite
{
	import flash.data.*;
	import flash.events.*;
	
	[Event(name="result", type="flash.events.SQLEvent")]
	[Event(name="error", type="flash.events.SQLErrorEvent")]
	
	public class Query extends EventDispatcher
	{
		
		private var _connection:SQLConnection;
		private var _statement:SQLStatement;
		private var _sql:String;
		private var _parameters:Array;
		private var _data:Array;
		
		public function Query()
		{
			super();
		}
		
		[Bindable]
		public function get connection():SQLConnection
		{
			return _connection;
		}
		public function set connection(value:SQLConnection):void
		{
			_connection = value;
		}
		
		[Bindable]
		public function get sql():String
		{
			return _sql;
		}
		public function set sql(value:String):void
		{
			_sql = value;
		}
		
		[Bindable]
		public function get parameters():Array
		{
			return _parameters;
		}
		public function set parameters(params:Array):void
		{
			_parameters = params;
		}
		
		[Bindable]
		public function get data():Array
		{
			return _data;
		}
		public function set data(result:Array):void
		{
			_data = result;
		}
		
		public function execute(sql:String=''):void
		{
			if(sql != null && sql != ''){
				this.sql = sql;
			}
			
			_statement = new SQLStatement();
			_statement.sqlConnection = _connection;
			_statement.text = _sql;
			if(_parameters) {
				for(var i:int=0; i<_parameters.length; i++)
				{
					_statement.parameters[i] = _parameters[i];
				}
			}
			_statement.addEventListener(SQLEvent.RESULT, onQueryResult, false, 0, true);
			_statement.addEventListener(SQLErrorEvent.ERROR, onQueryError, false, 0, true);
			_statement.execute();
		}
		
		private function onQueryResult(event:SQLEvent):void
		{
			var r:Object = _statement.getResult();
			_data = r == null ? null : r.data;
			
			dispatchEvent(event);
		}
		
		private function onQueryError(event:SQLErrorEvent):void
		{
			dispatchEvent(event);
		}
		
	}
	
}