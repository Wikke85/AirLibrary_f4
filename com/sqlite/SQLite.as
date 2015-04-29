package com.sqlite
{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.events.*;
	import flash.filesystem.File;
	
	[Event(name="open", type="flash.events.SQLEvent")]
	[Event(name="close", type="flash.events.SQLEvent")]
	[Event(name="error", type="flash.events.SQLErrorEvent")]
	
	public class SQLite
	{
		
		private var _connection:SQLConnection;
		private var _databaseFileName:String;	
		private var _databaseFile:File;
		private var _autoConnect:Boolean = false;
		
		public function SQLite(fileName:String='', autoConnect:Boolean=true)
		{
			_databaseFileName = fileName;
			_autoConnect = autoConnect;
			
			if(_autoConnect) connect();
		}
		
		[Bindable]
		public function get fileName():String
		{
			return _databaseFileName;
		}
		public function set fileName(filename:String):void
		{
			_databaseFileName = filename;
			if(_autoConnect) connect();
		}
		
		[Bindable]
		public function get file():File
		{
			return _databaseFile;
		}
		public function set file(value:File):void
		{
			_databaseFile = value;
			if(_autoConnect) connect();
		}
		
		[Bindable]
		public function get connection():SQLConnection
		{
			return _connection;
		}
		public function set connection(conn:SQLConnection):void
		{
			_connection = conn;
		}	
		
		public function connect():void
		{
			if(_databaseFile == null){
				if(_databaseFileName != null && _databaseFileName != ''){
					_databaseFile = File.applicationDirectory.resolvePath(_databaseFileName);
				}
			}
			
			if(_databaseFile != null){
				
				_connection = new SQLConnection();
				_connection.addEventListener(SQLEvent.OPEN, onDatabaseOpen, false, 0, true);
				_connection.addEventListener(SQLEvent.CLOSE, onDatabaseClose, false, 0, true);
				_connection.addEventListener(SQLErrorEvent.ERROR, onDatabaseError, false, 0, true);
				_connection.open(_databaseFile);
			}
		}
		
		public function close():void
		{
			_connection.close();
		}
		
		private function onDatabaseOpen(evt:SQLEvent):void
		{
			dispatchEvent(evt);
		}

		private function onDatabaseClose(evt:SQLEvent):void
		{
			dispatchEvent(evt);
		}
		
		private function onDatabaseError(evt:SQLErrorEvent):void
		{
			dispatchEvent(evt);
		}

	}
}