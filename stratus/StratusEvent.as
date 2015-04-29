package stratus
{
	import flash.events.Event;
	
	public class StratusEvent extends Event
	{
		
		public static const HANG_UP:String = 'hangUp';
		public static const CONNECTING:String = 'connecting';
		public static const CONNECTED:String = 'connected';
		public static const MESSAGE:String = 'message';
		public static const CONNECTION_FAILED:String = 'connectionFailed';
		public static const CONNECTION_CLOSED:String = 'connectionClosed';
		public static const REGISTERED:String = 'registered';
		public static const CALLING:String = 'calling';
		public static const INCOMING_CALL:String = 'incomingCall';
		public static const CALL_ACCEPTED:String = 'callAccepted';
		public static const DISCONNECTED:String = 'disconnected';
		public static const ERROR:String = 'error';
		public static const STATUS:String = 'status';
		
		public var remoteName:String = '';
		public var message:String = '';
		
		public function StratusEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, remoteName:String='', message:String='')
		{
			super(type, bubbles, cancelable);
			this.remoteName = remoteName;
			this.message = message;
		}
		
	}
}