package core
{
	
	public class ApplicationSettings
	{
		public function ApplicationSettings()
		{
			super();
		}
		
		public var application:_Application	= new _Application;
		public var webservices:_WebServices	= new _WebServices;
		public var updater:_Updater			= new _Updater;
		
		public var additional:Object;
		
	}
	
}


class _Application {
	public function _Application(){}
	
	public var url:String;
	public var sessionProperties:Array;
	public var info:String = '';
	
	public var useStratus:Boolean = false;
	public var stratusKey:String = '';
	public var stratusUrl:String = '';
	
}

class _WebServices {
	public function _WebServices(){}
	
	public var destination:String;
	public var endpoint:String;
	public var source:String;
	
}

class _Updater {
	public function _Updater(){}
	
	public var url:String;
	public var logger:String;
	
}
