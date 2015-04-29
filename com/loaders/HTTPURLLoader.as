package com.loaders
{
	
	import flash.errors.EOFError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.system.Security;
	
	import mx.utils.StringUtil;
	
	[Event(name="close", type="flash.events.Event.CLOSE")]
	[Event(name="complete", type="flash.events.Event.COMPLETE")]
	[Event(name="open", type="flash.events.Event.CONNECT")]
	[Event(name="ioError", type="flash.events.IOErrorEvent.IO_ERROR")]
	[Event(name="securityError", type="flash.events.SecurityErrorEvent.SECURITY_ERROR")]
	[Event(name="progress", type="flash.events.ProgressEvent.PROGRESS")]
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent.HTTP_STATUS")]
	[Event(name="dataLoaded", type="flash.events.Event")]
	
	public class HTTPURLLoader extends EventDispatcher
	{
		
		
		private var _httpPort:uint = 80;
		private var _httpSocket:Socket;
		private var _request:URLRequest;
		public var httpRequest:String;
		public var httpServer:String;
		private var _headersServed:Boolean = false;
		private var _responseHeaders:Object;
		private var _data:String = "";
		private var _bytesLoaded:int = 0;
		private var _bytesTotal:int = 0;
		private var _tmpStr:String = "";
		
		public function get data():String
		{
			return _data;
		}
		
		public function get responseHeaders():Object
		{
			return _responseHeaders;
		}
		
		public function get bytesLoaded():int
		{
			return _bytesLoaded;
		}
		
		public function HTTPURLLoader()
		{
			super();
			
			// create http-socket
			_httpSocket = new Socket();
			
			//subscribe to events
			_httpSocket.addEventListener( "connect" , onConnectEvent , false , 0 );
			_httpSocket.addEventListener( "close" , onCloseEvent , false, 0 );
			_httpSocket.addEventListener( "ioError" , onIOErrorEvent , false, 0 );
			_httpSocket.addEventListener( "securityError" , onSecurityErrorEvent , false, 0 );
			_httpSocket.addEventListener( "socketData" , onSocketDataEvent , false , 0 );
		}
		
		//## event handlers ##
		
		private function onConnectEvent(event:Event):void
		{
			sendHeaders();
			dispatchEvent(new Event(Event.CONNECT));
			
		}
		
		private function onCloseEvent(event:Event):void
		{
			dispatchEvent(new Event(flash.events.Event.COMPLETE));
		}
		
		private function onIOErrorEvent(event:IOErrorEvent):void
		{
			dispatchEvent(event);
		}
		
		private function onSecurityErrorEvent(event:SecurityErrorEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		private function onSocketDataEvent(event:ProgressEvent):void
		{
			_bytesLoaded+= _httpSocket.bytesAvailable;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _bytesLoaded, _bytesTotal));
			trace("HTTPURLLoader::onSocketDataEvent() -> " + _bytesLoaded);
			
			//temporary string variable
			var str:String = ""
			
			// loop while there are bytes available
			while (_httpSocket.bytesAvailable)
			{
				
				//attempt to read from the socket receive buffer
				try
				{
					str = _httpSocket.readUTFBytes(_httpSocket.bytesAvailable);
					
				}
				//watch for EndOfFile Errors!!!
				catch(e:EOFError) 
				{
					break;
				} 
				 
			}
			
			if(!_headersServed)
			{
				_tmpStr+= str;
				
				
				//check if headers are over; 
				if(str.indexOf("\r\n\r\n")!=-1)
				{
					_headersServed = true;
					
					//parse header
					var t1:Array = _tmpStr.split("\r\n\r\n");
					var t2:Array;
					var t3:Array;
					_data+= t1[1];
					
					t2 = t1[0].split("\r\n");
					
					_responseHeaders = {};
					for each(var header:String in t2)
					{
						if(header.indexOf("HTTP/1.")==-1)
						{
							t3 = header.split(":");
							_responseHeaders[t3[0]] = StringUtil.trim(t3[1]); 
						}
					}
					
					
					if(_responseHeaders["Content-Length"])
					{
						//total bytes = content-length + header size (number of characters in header)
						//not working, need to work on right logic..
						_bytesTotal = int(_responseHeaders["Content-Length"]) +_tmpStr.length;
					}
					
				}
				
				var isHTTPStatus:Boolean = false;
				
				if(_tmpStr.indexOf("HTTP/1.1 200")!=-1 || _tmpStr.indexOf("HTTP/1.0 200")!=-1)
				{
					dispatchEvent(new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS, false, false, 200));
				}
				else if(_tmpStr.indexOf("HTTP/1.1 304")!=-1 || _tmpStr.indexOf("HTTP/1.0 304")!=-1)
				{
					dispatchEvent(new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS, false, false, 304));
				}
				else if(_tmpStr.indexOf("HTTP/1.1 400")!=-1 || _tmpStr.indexOf("HTTP/1.0 400")!=-1)
				{
					dispatchEvent(new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS, false, false, 400));
					_httpSocket.close();
					return; 
				}
				else if(_tmpStr.indexOf("HTTP/1.1 401")!=-1 || _tmpStr.indexOf("HTTP/1.0 401")!=-1)
				{
					dispatchEvent(new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS, false, false, 401));
					_httpSocket.close(); 
					return;
				}
				else if(_tmpStr.indexOf("HTTP/1.1 403")!=-1 || _tmpStr.indexOf("HTTP/1.0 403")!=-1)
				{
					dispatchEvent(new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS, false, false, 403));
					_httpSocket.close();
					return; 
				}
				else if(_tmpStr.indexOf("HTTP/1.1 404")!=-1 || _tmpStr.indexOf("HTTP/1.0 404")!=-1)
				{
					dispatchEvent(new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS, false, false, 404));
					_httpSocket.close();
					return; 
				}
				else if(_tmpStr.indexOf("HTTP/1.1 410")!=-1 || _tmpStr.indexOf("HTTP/1.0 410")!=-1)
				{
					dispatchEvent(new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS, false, false, 410));
				}
				else if(_tmpStr.indexOf("HTTP/1.1 500")!=-1 || _tmpStr.indexOf("HTTP/1.0 500")!=-1)
				{
					dispatchEvent(new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS, false, false, 500));
					_httpSocket.close();
					return; 
				}
				else if(_tmpStr.indexOf("HTTP/1.1 501")!=-1 || _tmpStr.indexOf("HTTP/1.0 501")!=-1)
				{
					dispatchEvent(new HTTPStatusEvent (HTTPStatusEvent.HTTP_STATUS, false, false, 501));
					_httpSocket.close();
					return; 
				}
				
			}
			else { 
				_data+= str;
				
				dispatchEvent(new Event('dataLoaded'));
			}
		} 
		
		private function sendHeaders():void
		{
			var requestHeaders:Array = _request.requestHeaders;
			
			var h:String = "";
			
			_responseHeaders = null;
			_bytesLoaded = 0;
			_bytesTotal = 0;
			_data = "";
			_headersServed = false;
			_tmpStr = "";
			
			//create an HTTP 1.0 Header Request
			h+= "GET " + httpRequest + " HTTP/1.0\r\n";
			h+= "Host:" + httpServer + "\r\n";
			
			if(requestHeaders.length > 0)
			{
				for each(var rh:URLRequestHeader in requestHeaders)
				{
					h+= rh.name + ":" + rh.value + "\r\n";
				}
			}
			
			
			//set HTTP headers to socket buffer
			_httpSocket.writeUTFBytes(h + "\r\n\r\n")
			
			//push the data to server
			_httpSocket.flush() 
		}
		
		private function parseURL():Boolean
		{
			
			//parse URL into sockServer and sockRequest
			
			var d:Array = _request.url.split('http://')[1].split('/');
			if(d.length > 0)
			{
				httpServer = d.shift();
				
				//load crossdomain, if its on server.
				Security.loadPolicyFile("http://"+httpServer+"/crossdomain.xml");
				httpRequest = '/' + d.join('/');
				return true;
			}
			return false;
		}
		
		
		public function load(request:URLRequest):void
		{
			_request = request;
			if(parseURL())
			{
				_httpSocket.connect(httpServer, _httpPort);
				
			}
			else
			{
				throw new Error("Invalid URL");
			} 
			
		}
		
		public function close():void
		{
			if(_httpSocket.connected)
			{
				_httpSocket.close();
				dispatchEvent(new Event(Event.CLOSE));
			}
		}
		
	}

}