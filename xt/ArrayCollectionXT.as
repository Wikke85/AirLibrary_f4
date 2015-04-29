package xt
{
	import flash.utils.IExternalizable;
	
	import mx.collections.ArrayCollection;
	
	public class ArrayCollectionXT extends ArrayCollection implements IExternalizable
	{
		
		/**
		 * Extended ArrayCollection
		 * uses idField
		 * added some valuable functions missing in ArrayCollection
		 * */
		public function ArrayCollectionXT(source:Array = null, idField:String = '')
		{
			super(source);
			_idField = idField;
		}
		
		
		
		
		private var _idField:String;
		
		/**
		 * idField
		 * */
		public function get idField():String {
			return _idField;
		}
		public function set idField(value:String):void {
			_idField = value;
		}
		
		
		/**
		 * get the corresponding item where [idField] is id
		 * */
		public function getItemAtId(id:Object):Object {
			if(String(_idField) != 'null' && String(_idField).replace(/ /g, '') != ''){
				for(var i:int=0; i<source.length; i++){
					if(source[i][_idField] == id){
						return source[i];
					}
				}
			}
			return null;
		}
		
		/**
		 * check if collection contains an object where [idField] equals id
		 * */
		public function containsID(id:Object): Boolean {
			if(String(_idField) != 'null' && String(_idField).replace(/ /g, '') != ''){
				for(var i:int = 0; i < source.length; i++) {
					if(source[i][_idField] == id) return true;
				}
			}
			return false;
		}
		
		/**
		 * remove the object where [idField] equals id
		 * */
		public function removeItemAtId(id:Object):Object {
			if(String(_idField) != 'null' && String(_idField).replace(/ /g, '') != ''){
				for(var i:int = 0; i < source.length; i++) {
					if(source[i][_idField] == id) return removeItemAt(i);
				}
			}
			return null;
		}
		
		/**
		 * remove an Object from the collection
		 * */
		public function removeItem(value:Object):Object {
			for(var i:int = 0; i < source.length; i++) {
				if(source[i] == value) return removeItemAt(i);
			}
			return null;
		}
		
	}
}