package com.sqlite
{
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Functions to execute a single query or multiple sql queries.
	 * 
	 * */
	public class SQLHelper
	{
		
		
		public function SQLHelper(){}
		
		
		/**
		 * Set this var to a SqLite Query object after opening a database
		 * */
		public static var query:Query;
		
		/**
		 * Var indicating that the queue is executing
		 * */
		[Bindable] public static var isQueueing:Boolean = false;
		
		/**
		 * Set this to run after an error appeared.
		 * and when 'alwaysRunGlobalFunctions' is 'true'
		 * */
		public static var globalErrorFunction:Function;
		
		/**
		 * when set to false, the 'globalErrorFunction' only runs when the 'errorFunction' is null
		 * */
		public static var alwaysRunGlobalFunctions:Boolean = true;
		
		
		
		private static var _resultFunction:Function;
		private static var _errorFunction:Function;
		
		private static var queryHasEventListeners:Boolean = false;
		
		private static var sqlQueue:ArrayCollection = new ArrayCollection;
		
		
		
		
		/**
		 * add a query to the queue
		 * queries will be run in the order they are entered 
		 * */
		public static function addQueue(queryString:String):void {
			sqlQueue.addItem({
				sql:	queryString
			});
		}
		
		/**
		 * start executing the queue.
		 * all the queue items are being run one by the time, in order of entrance.
		 * when done, the 'resultFunction' gets called with an Array parameter containing the result if any
		 * on an error, the 'errorFunction' gets called with an SQLErrorEvent parameter
		 * */
		public static function startQueue(resultFunction:Function=null, errorFunction:Function=null):void {
			_resultFunction	= resultFunction;
			_errorFunction	= errorFunction;
			isQueueing = true;
			nextQueue();
		}
		
		
		private static function nextQueue():void {
			if(sqlQueue.length > 0){
				executeSQL(sqlQueue[0].sql);
			}
		}
		
		
		
		
		/**
		 * execute a single query.
		 * when done, the 'resultFunction' gets called with an Array parameter containing the result if any
		 * on an error, the 'errorFunction' gets called with an SQLErrorEvent parameter
		 * */
		public static function executeSQL(queryString:String, resultFunction:Function=null, errorFunction:Function=null):void
		{
			
			// when queueing, there are no resultfunctions or errorfunctions when this method is being called,
			// the 'if' prevents them from being set to 'null'
			if(!isQueueing){
				_resultFunction = resultFunction;
				_errorFunction = errorFunction;
			}
			
			query.sql = queryString;
			
			if(!queryHasEventListeners){
				//query.connection = db.connection;
				
				query.addEventListener(SQLEvent.RESULT, onQueryResult);
				query.addEventListener(SQLErrorEvent.ERROR, function(event:SQLErrorEvent):void {
					//log(event.error.toString());
					//log('\tQuery: '+event.target.sql);
					
					// if errorfunction is defined: run
					if(_errorFunction != null){
						_errorFunction(event);
					}
					// run global errorfunction when errorfunction is not defined or when set to 'always run'
					if(_errorFunction == null || alwaysRunGlobalFunctions) {
						globalErrorFunction(event);
					}
					
					if(isQueueing){
						if(sqlQueue.length > 0) sqlQueue.removeItemAt(0);
					}
				});
				queryHasEventListeners = true;
			}
			
			query.execute();
		}
		
		private static function onQueryResult(event:SQLEvent):void {
			if(isQueueing){
				sqlQueue.removeItemAt(0);
				if(sqlQueue.length == 0){
					isQueueing = false;
					if(_resultFunction != null){
						_resultFunction(query.data);
					}
				}
				else {
					//startQueue(resultFunction, errorFunction);
					nextQueue();
				}
				
			}
			else {
				//assignData(query.data);
				if(_resultFunction != null){
					_resultFunction(query.data);
				}
				//resultFunction = null;
			}
		}
		
		
	}
}