package com.mijntuin
{
	import com.events.MijnTuinEvent;
	import com.oauth.OAuthConsumer;
	import com.oauth.OAuthRequest;
	import com.oauth.OAuthSignatureMethod_HMAC_SHA1;
	import com.oauth.OAuthToken;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class ApiWrapper extends EventDispatcher
	{
		public function ApiWrapper()
		{
			super();
		}
		
		
		
		protected var consumerKey:String = 'YOUR CONSUMER KEY';
		protected var consumerSecret:String = 'YOUR CONSUMER SECRET';
		
		protected var baseUrl:String = "http://api.mijntuin.org";
		protected var requestTokenUrl:String = baseUrl+"oauth/request_token";
		protected var authorizeUrl:String = "http://www.mijntuin.org/oauth/authorize";
		protected var accessTokenUrl:String = baseUrl+"oauth/access_token";
		
		protected var token:OAuthToken = new OAuthToken();
		protected var verifier:String;
		protected var consumer:OAuthConsumer = new OAuthConsumer(consumerKey, consumerSecret);
		protected var signatureMethod:OAuthSignatureMethod_HMAC_SHA1 = new OAuthSignatureMethod_HMAC_SHA1();
		
		
		public function getRequestToken():void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, requestTokenHandler);
			var request:OAuthRequest = new OAuthRequest(OAuthRequest.HTTP_METHOD_GET, requestTokenUrl, null, consumer, null);
			loader.load(new URLRequest(request.buildRequest(signatureMethod)));
		}
		
		protected function requestTokenHandler(event:Event):void 
		{
			dispatchEvent(new MijnTuinEvent(MijnTuinEvent.GOT_REQUEST_TOKEN));
			parseToken(event.currentTarget.data);
		}
		
		public function authorizeToken():void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, authorizeTokenHandler);
			var request:OAuthRequest = new OAuthRequest(OAuthRequest.HTTP_METHOD_POST, authorizeUrl, null, consumer, token);
			
			loader.load(new URLRequest(request.buildRequest(signatureMethod)));
		}
		
		protected function authorizeTokenHandler(event:Event):void
		{
			dispatchEvent(new MijnTuinEvent(MijnTuinEvent.AUTHORIZED_TOKEN));
			parseToken(event.currentTarget.data);
			getAccessToken();
		}
		
		protected function getAccessToken():void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, accessTokenHandler);
			var request:OAuthRequest = new OAuthRequest(OAuthRequest.HTTP_METHOD_GET, accessTokenUrl, {oauth_verifier: verifier}, consumer, token);
			loader.load(new URLRequest(request.buildRequest(signatureMethod)));
		}
		
		protected function accessTokenHandler(event:Event):void 
		{
			dispatchEvent(new MijnTuinEvent(MijnTuinEvent.GOT_ACCESS_TOKEN));
			parseToken(event.currentTarget.data);
		}
		
		protected function parseToken(response:String):void 
		{
			var params:Array = response.split("&");
			for (var i:int = 0; i < params.length; i++) 
			{
				var param:String = params[i];
				var nameValue:Array = param.split("=");
				if (nameValue.length == 2) 
				{
					switch (nameValue[0]) 
					{
						case "oauth_token":
							token.key = nameValue[1];
							break;
						case "oauth_token_secret":
							token.secret = nameValue[1];
							break;
						case "oauth_verifier":
							verifier = nameValue[1];
							break;
					}
				}
			}
		}
		
		public function sendRequest(url:String, parameters:Object = null):void 
		{
			parameters = (parameters)? parameters : new Object;
			parameters.oauth_verifier = verifier
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, resultHandler);
			var request:OAuthRequest = new OAuthRequest(OAuthRequest.HTTP_METHOD_GET, baseUrl+url+'.xml', parameters, consumer, token);
			loader.load(new URLRequest(request.buildRequest(signatureMethod)));
		}
		
		protected function resultHandler(event:Event):void 
		{
			dispatchEvent(new MijnTuinEvent(MijnTuinEvent.DATA_RECEIVED, event.currentTarget.data));
		}     
		            
		

	}
}