package com
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	[Event(name="dataChanging", type="flash.events.Event")]
	[Event(name="dataChange", type="flash.events.Event")]
	//[Event(name="dataError", type="flash.events.ErrorEvent")]
	
	[Event(name="dataClear", type="flash.events.Event")]
	
	
	public class ViewObject extends EventDispatcher
	{
		
		public static const EVENT_DATA_CHANGING:String = 'dataChanging';
		public static const EVENT_DATA_CHANGE:String = 'dataChange';
		public static const EVENT_DATA_CLEAR:String = 'dataClear';
		
		private var fields:Array;
		public var _source:Object;
		
		public function ViewObject(data:Object = null, nameField:String='', dataField:String='')
		{
			_source = data;
			if(data != null) assign(data, nameField, dataField);
		}
		
		public function assign(data:Object, nameField:String='', dataField:String=''):void
		{
			dispatchEvent(new Event(ViewObject.EVENT_DATA_CHANGING,true,true));
			
			fields = [];
			
			if(data is Array || data is ArrayCollection){
				for(var i:int=0; i<data.length; i++){
					try {
						if(this.hasOwnProperty(data[i][nameField].toLowerCase())){
							
							fields[fields.length] = data[i][nameField].toLowerCase();
							
							if( this[data[i][nameField].toLowerCase()] is Number ){
								 this[data[i][nameField].toLowerCase()] = Number(data[i][dataField]);
							}
							
							else if( this[data[i][nameField].toLowerCase()] is Boolean ){
								this[data[i][nameField].toLowerCase()] = (
										String(data[i][dataField]) == '1'
										||
										String(data[i][dataField]).toLowerCase() == 'true'
									);
								
							}
							
							else if( this[data[i][nameField].toLowerCase()] is Date ){
								this[data[i][nameField].toLowerCase()] = data[i][dataField] == '' ? null : data[i][dataField] as Date;
							}
							
							else if( this[data[i][nameField].toLowerCase()] is Array ){
								this[data[i][nameField].toLowerCase()] = data[i][dataField] as Array;
							}
							
							else if( this[data[i][nameField].toLowerCase()] is ArrayCollection ){
								this[data[i][nameField].toLowerCase()] = new ArrayCollection( data[i][dataField].source as Array );
							}
							
							else if( this[data[i][nameField].toLowerCase()] is ViewObject ){
								if( this[data[i][nameField].toLowerCase()] == null) this[o.toLowerCase()] = new ViewObject;
								ViewObject(this[data[i][nameField].toLowerCase()]).clear();
								ViewObject(this[data[i][nameField].toLowerCase()]).assign( data[i][dataField] );
							}
							
							else {
								/*if( this[o.toLowerCase()] == null ){
									this[o.toLowerCase()] = new ;
								}*/
								this[data[i][nameField].toLowerCase()] = data[i][dataField];
							}
							
						}
					}
					catch(te:TypeError){
						trace("TypeError in "+toString()+" while assigning data to '"+o+"': "+te.message);// +"\n"+ te.getStackTrace());
					}
					catch(e:Error){
						trace("Error in "+toString()+" while assigning data to '"+o+"': "+e.message);// +"\n"+ e.getStackTrace());
						//dispatchEvent(new ErrorEvent('dataError',false, false, 'Error while assigning data to "'+o+'": '+e.message +"\n"+ e.getStackTrace()));
					}
					/*finally {
						continue;
					}*/
				}
			}
			else {
				for(var o:String in data){
					try {
						if(this.hasOwnProperty(o.toLowerCase())){
							
							fields[fields.length] = o.toLowerCase();
							
							if( this[o.toLowerCase()] is Number ){
								 this[o.toLowerCase()] = Number(data[o]);
							}
							
							else if( this[o.toLowerCase()] is Boolean ){
								if(data[o] is Number || data[o] is int){
									this[o.toLowerCase()] = data[o] == 1;
								}
								else {
									this[o.toLowerCase()] = String(data[o]).toLowerCase() == 'true' || String(data[o]) == '1';
								}
							}
							
							else if( this[o.toLowerCase()] is Date ){
								this[o.toLowerCase()] = data[o] == '' ? null : data[o] as Date;
							}
							
							else if( this[o.toLowerCase()] is Array ){
								this[o.toLowerCase()] = data[o] as Array;
							}
							
							else if( this[o.toLowerCase()] is ArrayCollection ){
								this[o.toLowerCase()] = new ArrayCollection( data[o].source as Array );
							}
							
							else if( this[o.toLowerCase()] is ViewObject ){
								if( this[o.toLowerCase()] == null) this[o.toLowerCase()] = new ViewObject;
								ViewObject(this[o.toLowerCase()]).clear();
								ViewObject(this[o.toLowerCase()]).assign( data[o] );
							}
							
							else {
								/*if( this[o.toLowerCase()] == null ){
									this[o.toLowerCase()] = new ;
								}*/
								this[o.toLowerCase()] = data[o];
							}
							
						}
					}
					catch(te:TypeError){
						trace("TypeError in "+toString()+" while assigning data to '"+o+"': "+te.message);// +"\n"+ te.getStackTrace());
					}
					catch(e:Error){
						trace("Error in "+toString()+" while assigning data to '"+o+"': "+e.message);// +"\n"+ e.getStackTrace());
						//dispatchEvent(new ErrorEvent('dataError',false, false, 'Error while assigning data to "'+o+'": '+e.message +"\n"+ e.getStackTrace()));
					}
					/*finally {
						continue;
					}*/
				}
			}
			
			dispatchEvent(new Event(ViewObject.EVENT_DATA_CHANGE,true,true));
			
		}
		
		
		
		public function clear():void
		{
			
			for(var o:String in this){
				try {
					
					if( this[o] is Number ){
						 this[o] = -1;
					}
					
					else if( this[o] is Boolean ){
						this[o] = false;
					}
					
					else if( this[o] is Date ){
						this[o] = null;
					}
					
					else if( this[o] is Array ){
						this[o] = [];
					}
					
					else if( this[o] is ArrayCollection ){
						this[o] = new ArrayCollection;
					}
					
					else if( this[o] is ViewObject ){
						this[o] = new ViewObject;
					}
					
					else {
						/*if( this[o] == null ){
							this[o] = new ;
						}*/
						this[o] = '';
					}
					
				}
				catch(e:Error){
					trace('Error in '+toString()+' while clearing "'+o+'": '+e.message);// +"\n"+ e.getStackTrace());
					//dispatchEvent(new ErrorEvent('dataError',false, false, 'Error while assigning data to "'+o+'": '+e.message +"\n"+ e.getStackTrace()));
				}
				/*finally {
					continue;
				}*/
			}
			
			dispatchEvent(new Event(ViewObject.EVENT_DATA_CLEAR,true,true));
			
		}
		
		
		public function toObject():Object {
			var ret:Object = new Object;
			for(var o:String in fields){
				ret[fields[o]] = this[fields[o]];
			}
			return ret;
		}
		
	}
	
}

