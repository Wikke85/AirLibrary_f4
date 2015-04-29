package com.data
{
	import flash.net.SharedObject;
	
	/**
	 * Wrapper for SharedObject.
	 * 
	 * assign a name to it and call the functions read(), write() and clear()
	 * 
	 * This is much more convenient than calling SharedObject.getLocal('something'), checking for nulls, flush()ing, ...
	 * */
	public class Cookie
	{
		private var so:SharedObject;
		
		public var data:Object;
		
		public function Cookie(name:String)
		{
			so = SharedObject.getLocal(name);
			read();
		}
		
		public function read():void {
			if(so != null){
				data = so.data;
			}
		}
		
		public function save():void	{
			if(so != null){
				/*for(var s1:String in so.data){
					delete so.data[s1];
				}*/
				//so.data = new Object;
				for(var s2:String in data){
					so.data[s2] = data[s2];
				}
				so.flush();
			}
		}
		
		public function clear():void {
			if(so != null){
				so.clear();
			}
		}

	}
}