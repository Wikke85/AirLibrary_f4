package com.data
{
	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	
	/**
	 * Wrapper for EncryptedLocalStore.
	 * 
	 * assign a name to it and call the functions read(), write() and clear()
	 * 
	 * This is much more convenient than calling EncryptedLocalStore.getItem('something'), checking for nulls, setting item, ...
	 * */
	public class SecuredCookie
	{
		private var ba:ByteArray;
		
		public var data:Object;
		
		private var _name:String = '';
		
		public function SecuredCookie(name:String)
		{
			_name = name;
			ba = EncryptedLocalStore.getItem(name);
			read();
		}
		
		public function read():void {
			if(ba != null){
				data = ba.readObject();
			}
		}
		
		public function save():void	{
			if(ba != null){
				ba.writeObject(data);
				EncryptedLocalStore.setItem(_name, ba);
			}
		}
		
		public function clear():void {
			EncryptedLocalStore.removeItem(_name);
			ba = null;
			data = null;
		}

	}
}