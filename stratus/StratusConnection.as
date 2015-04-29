package stratus
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.collections.ArrayCollection;
	
	
	[Event(name="hangUp", type="stratus.StratusEvent")]
	[Event(name="connecting", type="stratus.StratusEvent")]
	[Event(name="connected", type="stratus.StratusEvent")]
	[Event(name="message", type="stratus.StratusEvent")]
	[Event(name="connectionFailed", type="stratus.StratusEvent")]
	[Event(name="connectionClosed", type="stratus.StratusEvent")]
	[Event(name="registered", type="stratus.StratusEvent")]
	[Event(name="calling", type="stratus.StratusEvent")]
	[Event(name="callAccepted", type="stratus.StratusEvent")]
	[Event(name="disconnected", type="stratus.StratusEvent")]
	
	
	[Bindable]
	public class StratusConnection extends EventDispatcher
	{
		
		/**
		 * Constructor
		 * key: your developer key
		 * service: your webservice that handles the user IDs
		 * */
		public function StratusConnection(key:String, service:String) {
			super();
			
			this.key = key;
			this.service = service;
			
			_loginState = LOGIN_NOT_CONNECTED;
			dispatchEvent(new Event('loginStateChanged'));
			
			_callState = CALL_NOT_READY;
			dispatchEvent(new Event('callStateChanged'));
			
		}
		
		private var key:String = '';
		private var service:String = '';
		
		// stratus address, hosted by Adobe
		public const connectUrl:String = "rtmfp://stratus.adobe.com";
		
		// this is the connection to stratus
		private var netConnection:NetConnection;
		
		// after connection to stratus, publish listener stream to wait for incoming call
		private var listenerStream:NetStream;
		
		// caller's incoming stream that is connected to callee's listener stream
		private var controlStream:NetStream;
		
		/**
		 * outgoing media stream (audio, video, text and some control messages)
		 * */
		public var outgoingStream:NetStream;
		
		/**
		 * incoming media stream (audio, video, text and some control messages)
		 * */
		public var incomingStream:NetStream;
		
		// ID management serice
		private var idManager:HttpIdManager;
		
		
		
		
		private var _loginState:int = -1;
		
		/**
		 * login/registration state machine
		 * */
		[Bindable('loginStateChanged')]
		public function get loginState():int {
			return _loginState;
		}
		
		/**
		 * loginState: possible values
		 * */
		public static const LOGIN_NOT_CONNECTED:int = 0;
		public static const LOGIN_CONNECTING:int = 1;
		public static const LOGIN_CONNECTED:int = 2;
		public static const LOGIN_DISCONNECTING:int = 3;
		
		
		
		private var _callState:int = -1;
		
		/**
		 * call state machine
		 * */
		[Bindable('callStateChanged')]
		public function get callState():int {
			return _callState;
		}
		
		/**
		 * callState: possible values
		 * */
		public static const CALL_NOT_READY:int = 0;
		public static const CALL_READY:int = 1;
		public static const CALL_CALLING:int = 2;
		public static const CALL_RINGING:int = 3;
		public static const CALL_ESTABLISHED:int = 4;
		public static const CALL_FAILED:int = 5;
		
		
		
		
		
		private var _username:String = '';
		
		
		private var _callee:String = '';
		
		/**
		 * the person that you are trying to call
		 * */
		[Bindable('calleeChanged')]
		public function get callee():String {
			return _callee;
		}
		
		
		
		private var _remoteName:String = "";
		
		/**
		 * the person that you are connected with
		 * */
		[Bindable('remoteNameChanged')]
		public function get remoteName():String {
			return _remoteName;
		}
		
		
		/**
		 * When a remote user connects, automatically accept the call
		 * pay attention when setting to true! Possible security risk!
		 * */
		public var autoAccept:Boolean = false;
		
		
		
		/**
		 * Send audio?
		 * */
		public var sendAudio:Boolean = false;
		
		/**
		 * Send video?
		 * */
		public var sendVideo:Boolean = false;
		
		/**
		 * your camera
		 * */
		public var camera:Camera;
		
		/**
		 * your microphone
		 * */
		public var microphone:Microphone;
		
		/**
		 * The video received from 'remoteName'
		 * */
		public var videoRemote:Video;
		//public var videoLocal:Video;
		
		/**
		 * the volume of the incoming audio stream
		 * */
		public var volumeSpeaker:Number = 1;
		
		
		public function connect(username:String):void {
			this._username = username;
			
			netConnection = new NetConnection();
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, netConnectionHandler);
			netConnection.connect(connectUrl + "/" + key);
			
			_loginState = LOGIN_CONNECTING;
			dispatchEvent(new Event('loginStateChanged'));
			
			dispatchEvent(new StratusEvent(StratusEvent.CONNECTING));
			
			statuses = new ArrayCollection;
			
			setStatus("Connecting to " + connectUrl + "\n");
		}
		
		private function netConnectionHandler(event:NetStatusEvent):void {
			setStatus("NetConnection event: " + event.info.code + "\n");
			
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					connectSuccess();
					break;
					
				case "NetConnection.Connect.Closed":
					_loginState = LOGIN_NOT_CONNECTED;
					dispatchEvent(new Event('loginStateChanged'));
					_callState = CALL_NOT_READY;
					dispatchEvent(new Event('callStateChanged'));
					
					dispatchEvent(new StratusEvent(StratusEvent.CONNECTION_CLOSED));
					break;
					
				case "NetStream.Connect.Success":
					// we get this when other party connects to our control stream our outgoing stream
					setStatus("Connection from: " + event.info.stream.farID + "\n");
					break;
					
				case "NetConnection.Connect.Failed":
					setStatus("Unable to connect to " + connectUrl + "\n");
					_loginState = LOGIN_NOT_CONNECTED;
					dispatchEvent(new Event('loginStateChanged'));
					dispatchEvent(new StratusEvent(StratusEvent.CONNECTION_FAILED));
					break;
					
				case "NetStream.Connect.Closed":
					hangUp();
					break;
		 	}
	 	}
	 	
	 	
	 	
	 	private var statuses:ArrayCollection;
	 	
	 	private function setStatus(message:String):void {
	 		statuses.addItem(message);
	 		dispatchEvent(new StratusEvent(StratusEvent.STATUS, false, false, _remoteName, message));
	 	}
	 	
	 	
		private function listenerHandler(event:NetStatusEvent):void {
			setStatus("Listener event: " + event.info.code + "\n");
		}
		
		private function controlHandler(event:NetStatusEvent):void {
			setStatus("Control event: " + event.info.code + "\n");
		}
		
		private function outgoingStreamHandler(event:NetStatusEvent):void {
			setStatus("Outgoing stream event: " + event.info.code + "\n");
			switch(event.info.code){
				case "NetStream.Play.Start":
					if(_callState == CALL_CALLING){
						outgoingStream.send("onIncomingCall", _username);
					}
					break;
			}
		}
		
		private function incomingStreamHandler(event:NetStatusEvent):void {
			setStatus("Incoming stream event: " + event.info.code + "\n");
			switch(event.info.code){
				case "NetStream.Play.UnpublishNotify":
					hangUp();
					break;
			}
		}
		
	 	// connection to stratus succeeded and we register our fingerprint with a simple web service
		// other clients use the web service to look up our fingerprint
		private function connectSuccess():void {
			setStatus("Connected, my ID: " + netConnection.client.nearID + "\n");
			
			dispatchEvent(new StratusEvent(StratusEvent.CONNECTED));
			
			idManager = new HttpIdManager();
			idManager.addEventListener("registerSuccess", idManagerEvent);
			idManager.addEventListener("registerFailure", idManagerEvent);
			idManager.addEventListener("lookupFailure", idManagerEvent);
			idManager.addEventListener("lookupSuccess", idManagerEvent);
			idManager.addEventListener("idManagerError", idManagerEvent);
			
			idManager.service = service;
			idManager.register(_username, netConnection.client.nearID);
		}
		
		private function completeRegistration():void {
			// start the control stream that will listen to incoming calls
			listenerStream = new NetStream(netConnection);//, NetStream.DIRECT_CONNECTIONS);
			listenerStream.addEventListener(NetStatusEvent.NET_STATUS, listenerHandler);
			listenerStream.publish("control" + _username);
			
			var c:Object = new Object
			c.onPeerConnect = function(caller:NetStream):Boolean
			{
				setStatus("Caller connecting to listener stream: " + caller.client.farID + "\n");
				
				if(_callState == CALL_READY){
					_callState = CALL_RINGING;
					dispatchEvent(new Event('callStateChanged'));
					
					// callee subscribes to media, to be able to get the remote user name
					incomingStream = new NetStream(netConnection);//, caller.client.farID);
					incomingStream.addEventListener(NetStatusEvent.NET_STATUS, incomingStreamHandler);
					incomingStream.play("media-caller");
					
					// set volume for incoming stream
					var st:SoundTransform = new SoundTransform(volumeSpeaker);
					incomingStream.soundTransform = st;
					
					incomingStream.receiveAudio(false);
					incomingStream.receiveVideo(false);
					
					var i:Object = new Object;
					i.onIncomingCall = function(caller:String):void
					{
						if (_callState != CALL_RINGING)
						{
							setStatus("onIncomingCall: Wrong call state: " + _callState + "\n");
							return;
						}
						_remoteName = caller;
						dispatchEvent(new Event('remoteNameChanged'));
						
						setStatus("Incoming call from: " + caller + "\n");
						dispatchEvent(new StratusEvent(StratusEvent.INCOMING_CALL, false, false, _remoteName, caller));
						
						if(autoAccept){
							acceptCall();
						}
					}
					
					i.onIm = function(name:String, text:String):void
					{
						/*textOutput.text += name + ": " + text + "\n";
						textOutput.validateNow();
						textOutput.verticalScrollPosition = textOutput.textHeight;*/
						trace(name + ": " + text);
						dispatchEvent(new StratusEvent(StratusEvent.MESSAGE, false, false, name, text));
						
					}
					incomingStream.client = i;
					
					return true;
				}
				
				setStatus("onPeerConnect: all rejected due to state: " + _callState + "\n");
				
				return false;
			}
			
			listenerStream.client = c;
			
			_callState = CALL_READY;
			dispatchEvent(new Event('callStateChanged'));
			
			dispatchEvent(new StratusEvent(StratusEvent.REGISTERED));
		}
		
		
		private function placeCall(user:String, identity:String):void {
			setStatus("Calling " + user + ", id: " + identity + "\n");
			
			if(identity.length != 64){
				setStatus("Invalid remote ID, call failed\n");
				_callState = CALL_FAILED;
				dispatchEvent(new Event('callStateChanged'));
				return;
			}
			
			// caller subsrcibes to callee's listener stream
			controlStream = new NetStream(netConnection);//, identity);
			controlStream.addEventListener(NetStatusEvent.NET_STATUS, controlHandler);
			controlStream.play("control" + user);
			
			// caller publishes media stream
			outgoingStream = new NetStream(netConnection);//, NetStream.DIRECT_CONNECTIONS);
			outgoingStream.addEventListener(NetStatusEvent.NET_STATUS, outgoingStreamHandler);
			outgoingStream.publish("media-caller");
			
			var o:Object = new Object
			o.onPeerConnect = function(caller:NetStream):Boolean
			{
				setStatus("Callee connecting to media stream: " + caller.client.farID + "\n");
				
				return true;
			}
			outgoingStream.client = o;
			
			startAudio();
			startVideo();
			
			// caller subscribes to callee's media stream
			incomingStream = new NetStream(netConnection);//, identity);
			incomingStream.addEventListener(NetStatusEvent.NET_STATUS, incomingStreamHandler);
			incomingStream.play("media-callee");
			
			// set volume for incoming stream
			var st:SoundTransform = new SoundTransform(volumeSpeaker);
			incomingStream.soundTransform = st;
			
			var i:Object = new Object;
			i.onCallAccepted = function(callee:String):void
			{
				if (_callState != CALL_CALLING)
				{
					setStatus("onCallAccepted: Wrong call state: " + _callState + "\n");
					return;
				}
				
				_callState = CALL_ESTABLISHED;
				dispatchEvent(new Event('callStateChanged'));
				
				setStatus("Call accepted by " + callee + "\n");
			}
			i.onIm = function(name:String, text:String):void
			{
				//textOutput.text += name + ": " + text + "\n";
				trace(name + ": " + text);
				dispatchEvent(new StratusEvent(StratusEvent.MESSAGE, false, false, name, text));
			}
			incomingStream.client = i;
			
			/*remoteVideo = new Video();
			remoteVideo.width = 320;
			remoteVideo.height = 240;
			remoteVideo.attachNetStream(incomingStream);
			remoteVideoDisplay.addChild(remoteVideo);*/
			if(videoRemote != null){
				videoRemote.attachNetStream(incomingStream);
			}
			
			_remoteName = user;
			dispatchEvent(new Event('remoteNameChanged'));
			
			_callState = CALL_CALLING;
			dispatchEvent(new Event('callStateChanged'));
			
			dispatchEvent(new StratusEvent(StratusEvent.CALLING));
		}
		
		
		// process successful response from web service
		private function idManagerEvent(e:Event):void {
			setStatus("ID event: " + e.type + "\n");
			dispatchEvent(e);
			
			if(e.type == "registerSuccess"){
				switch (_loginState)
				{
					case LOGIN_CONNECTING:
						_loginState = LOGIN_CONNECTED;
						dispatchEvent(new Event('loginStateChanged'));
						break;
					case LOGIN_DISCONNECTING:
					case LOGIN_NOT_CONNECTED:
						_loginState = LOGIN_NOT_CONNECTED;
						dispatchEvent(new Event('loginStateChanged'));
						return;
					case LOGIN_CONNECTED:
						return;
				}
				
				completeRegistration();
			}
			else if(e.type == "lookupSuccess"){
				// party query response
				var i:IdManagerEvent = e as IdManagerEvent;
				
				placeCall(i.user, i.id);
			}
			else {
				// all error messages ar IdManagerError type
				var error:IdManagerError = e as IdManagerError;
				setStatus("Error description: " + error.description + "\n");
				
				onDisconnect();
			}
		}
		
		
		// user clicked accept button
		public function acceptCall():void {
			incomingStream.receiveAudio(true);
			incomingStream.receiveVideo(true);
			
			/*remoteVideo = new Video();
			remoteVideo.width = 320;
			remoteVideo.height = 240;
			remoteVideo.attachNetStream(incomingStream);
			remoteVideoDisplay.addChild(remoteVideo);*/
			if(videoRemote != null){
				videoRemote.attachNetStream(incomingStream);
			}
			
			// callee publishes media
			outgoingStream = new NetStream(netConnection);//, NetStream.DIRECT_CONNECTIONS);
			outgoingStream.addEventListener(NetStatusEvent.NET_STATUS, outgoingStreamHandler);
			outgoingStream.publish("media-callee");
			
			var o:Object = new Object
			o.onPeerConnect = function(caller:NetStream):Boolean
			{
				setStatus("Caller connecting to media stream: " + caller.client.farID + "\n");
				
				return true;
			}
			outgoingStream.client = o;
			
			outgoingStream.send("onCallAccepted", _username);
			
			startVideo();
			startAudio();
			
			_callState = CALL_ESTABLISHED;
			dispatchEvent(new Event('callStateChanged'));
			
			dispatchEvent(new StratusEvent(StratusEvent.CALL_ACCEPTED));
		}
		
		
		public function cancelCall():void {
			hangUp();
		}
		
		public function rejectCall():void {
			hangUp();
		}
		
		
		public function onDisconnect():void {
			setStatus("Disconnecting.\n");
			
			hangUp();
			
			_callState = CALL_NOT_READY;
			dispatchEvent(new Event('callStateChanged'));
			
			if(idManager){
				idManager.unregister();
				idManager = null;
			}
			
			_loginState = LOGIN_NOT_CONNECTED;
			dispatchEvent(new Event('loginStateChanged'));
			
			netConnection.close();
			netConnection = null;
			
			dispatchEvent(new StratusEvent(StratusEvent.DISCONNECTED));
		}
		
		// placing a call
		public function call(callee:String):void {
			this._callee = callee;
			dispatchEvent(new Event('calleeChanged'));
			
			if (netConnection && netConnection.connected){
				if(callee.length == 0){
					setStatus("Please enter name to call\n");
					return;
				}
				
				// first, we need to lookup callee's fingerprint using the web service
				if(idManager){
					idManager.lookup(callee);
				}
				else {
					setStatus("Not registered.\n");
					return;
				}
			}
			else {
				setStatus("Not connected.\n");
			}
		}
		
		public function startAudio():void {
			if(sendAudio){
				if (microphone && outgoingStream)
				{
					outgoingStream.attachAudio(microphone);
				}
			}
			else {
				if(outgoingStream != null){
					outgoingStream.attachAudio(null);
				}
			}
		}
		
		public function startVideo():void {
			if(sendVideo){
				if (camera)
				{
					//localVideoDisplay.attachCamera(camera);
					if (outgoingStream)
					{
						outgoingStream.attachCamera(camera);
					}
				}
			}
			else {
				//localVideoDisplay.attachCamera(null);
				if (outgoingStream){
					outgoingStream.attachCamera(null);
				}
			}
		}
		
		
		public function hangUp():void {
			setStatus("Hanging up call\n");
			
			_callee = "";
			_callState = CALL_READY;
			dispatchEvent(new Event('callStateChanged'));
			
			if (incomingStream != null){
				incomingStream.close();
				incomingStream.removeEventListener(NetStatusEvent.NET_STATUS, incomingStreamHandler);
			}
			
			if (outgoingStream != null){
				outgoingStream.close();
				outgoingStream.removeEventListener(NetStatusEvent.NET_STATUS, outgoingStreamHandler);
			}
			
			if (controlStream != null){
				controlStream.close();
				controlStream.removeEventListener(NetStatusEvent.NET_STATUS, controlHandler);
			}
			
			incomingStream = null;
			outgoingStream = null;
			controlStream = null;
			
			_remoteName = "";
			dispatchEvent(new Event('remoteNameChanged'));
			
			dispatchEvent(new StratusEvent(StratusEvent.HANG_UP));
			
			//receiveAudioCheckbox.selected = true;
			//receiveVideoCheckbox.selected = true;
			
			//callTimer = 0;
		}
		
		// sending text message
		public function send(/*functionToCall:String,*/ textMessage:String):void {
			if (textMessage.length != 0 && outgoingStream){
				outgoingStream.send('onIm', _username, textMessage);
			}
		}
		
		
		
	}
	
}
