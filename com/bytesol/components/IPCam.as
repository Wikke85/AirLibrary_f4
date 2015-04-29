package com.bytesol.components
{
  import flash.events.ErrorEvent;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import flash.events.SecurityErrorEvent;
  import flash.net.Socket;
  import flash.utils.ByteArray;
  
  import mx.collections.ArrayCollection;
  import mx.controls.Alert;
  import mx.utils.Base64Encoder;
  import mx.utils.URLUtil;
  
  [Event(name="image", type="flash.events.Event")]
  [Event(name="connect", type="flash.events.Event")]
  [Event(name="error", type="flash.events.Event")]

  public class IPCam extends EventDispatcher
  {
    private var socket:Socket = null;
    private var buffer:ByteArray = null;
    private var url:String = "";
    private var user:String = "";
    private var pass:String = "";
    private var start:int = 0;
    private var parseHeaders:Boolean = true;
    private var headers:ArrayCollection = new ArrayCollection();
    
    public var image:ByteArray = null;
    
    public function IPCam()
    {
      buffer = new ByteArray();
      socket = new Socket();
      //socket.timeout = 5000;
      socket.addEventListener(Event.CONNECT, onSockConn);
      socket.addEventListener(ProgressEvent.SOCKET_DATA, onSockData);
      socket.addEventListener(IOErrorEvent.IO_ERROR, onError);
      socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
    }
    
    private function onError(e:ErrorEvent):void
    {
      sendError(e.text);
    }
    
    private function sendError(msg:String):void
    {
      disconnect(); 
      dispatchEvent(new Event("error"));    
      Alert.show(msg, "Error");
    }
    
    public function disconnect():void
    {
      if(socket.connected)
        socket.close();
      start = 0;
      image = null;
      buffer = null;
    }
    
    public function connect(url:String, user:String="", pass:String=""):void
    {
      disconnect();
              
      if(!URLUtil.isHttpURL(url))
      {
        sendError("Invalid Url");
        return;
      }
       
      var port:uint = URLUtil.getPort(url);
      var server:String = URLUtil.getServerName(url);
      this.url = url;
      this.user = user;
      this.pass = pass;
      socket.connect(server, port);       
    }

    private function getLiveUrl():String
    {
      var str:String = URLUtil.getServerNameWithPort(url);
      return url.substr(url.indexOf(str) + str.length + 1);
    }

    private function onSockConn(event:Event):void
    {
      buffer = new ByteArray();
      
      var auth:Base64Encoder = new Base64Encoder();
      var request:String = "";
    
      auth.encode(user + ":" + pass);
      
      request += "GET /" + getLiveUrl() + " HTTP/1.0\r\n";
      if(user.length > 0 && pass.length > 0)        
        request += "Authorization: Basic " + auth.toString() + "\r\n"
      request += "Connection: Keep-Alive\r\n\r\n";
      trace(request);
      parseHeaders = true;
      socket.writeMultiByte(request, "us-ascii");       
    }

    private function readline():String
    {
      var s:String = "";
      
      while(buffer.bytesAvailable > 0)
      {
        var t:String = buffer.readMultiByte(1, "us-ascii");
        if(t == "\r") continue;
        if(t == "\n") 
          break;
        s += t;
      } 
      return s;
    }
    
    private function getContentType():String
    {
      var content:String = "Content-Type: ";
      for each(var str:String in headers)
      {
        if(str.indexOf(content) >= 0)
        {
          return str.substr(str.indexOf(content) + content.length);
        }
      }
      return "";  
    }
    
    private function onParseHeaders():Boolean
    {
      parseHeaders = false;
      headers.removeAll();
      while(1)
      {
        var line:String = readline();
        if(line.length == 0) break;
        
        headers.addItem(line);
        trace(line);
      }
      try
      {
        var arr:Array = headers[0].split(" ");
        if(arr[1] == "200")
        {
          var content:String = getContentType();
          if(content.indexOf("multipart/x-mixed-replace") >= 0)
          { 
            dispatchEvent(new Event("connect"));
            return true;
          }
          throw (new Error("error"));
        }
        else if(arr[1] == "401")
          sendError("User name or password is incorrect.");
        else
          sendError("Server retured error code " + arr[1] + ".");
      }
      catch(e:Error)
      {
        sendError("Invalid response received.");
      }
      return false;
    }
    
    private function onSockData(event:ProgressEvent):void
    {
      socket.readBytes(buffer, buffer.length);    
      if(parseHeaders)
      {
        if(!onParseHeaders()) return;
      }
      findImage();       
    }

    private function findImage():Boolean
    {
      var marker:ByteArray = null;
      var end:int = 0;        
      var offset:int = 0;       
  
      offset = start;
      marker = new ByteArray();
      
      // If there are bytes and the offset is at the start
      // Look for a JPEG image
      if( buffer.length > 1 ) 
      {
        if( start == 0 )
        {
          // Look for the start of the JPEG
          for( offset; offset < buffer.length - 1; offset++ ) 
          {
            buffer.position = offset;
            buffer.readBytes( marker, 0, 2 );
            
            if( marker[0] == 255 && marker[1] == 216 ) 
            {
              start = offset;
              break;          
            }
          }
        }
        
        // Look for the end of the JPEG
        for( offset; offset < buffer.length - 1; offset++ ) 
        {
          buffer.position = offset;
          buffer.readBytes( marker, 0, 2 );
          
          if( marker[0] == 255 && marker[1] == 217 ) 
          {
            end = offset;
            
            // Grab image if an end is found
            image = new ByteArray();
  
            buffer.position = start;
            buffer.readBytes( image, 0, end - start );
            
            dispatchEvent(new Event("image"));
            
            // Remove image from incoming buffer
            var copy:ByteArray = new ByteArray();                    
            buffer.position = end;
            buffer.readBytes(copy, 0);
            buffer = copy;
            
            // Reset values
            start = 0;
            offset = 0;
            return true;
          }
        }
      }
      return false;       
    }
  }
}