package xt
{
	import flash.display.DisplayObject;
	
	import mx.containers.Panel;
	import mx.controls.LinkButton;
	
	[Event(name="button1Click", type="flash.events.Event")]
	[Event(name="button2Click", type="flash.events.Event")]
	[Event(name="button3Click", type="flash.events.Event")]

	public class PanelXT extends Panel
	{
		
		
		[Bindable] public var headerChildren:Array;
		
		[Bindable] public var icon1:Class;
		[Bindable] public var icon2:Class;
		[Bindable] public var icon3:Class;
		
		[Bindable] public var toolTip1:String;
		[Bindable] public var toolTip2:String;
		[Bindable] public var toolTip3:String;
		
		[Bindable] private var _visible1:Boolean = true;
		[Bindable] private var _visible2:Boolean = true;
		[Bindable] private var _visible3:Boolean = true;
		
		[Bindable] private var _enabled1:Boolean = true;
		[Bindable] private var _enabled2:Boolean = true;
		[Bindable] private var _enabled3:Boolean = true;
		
		/* visibles */
		[Bindable]
		public function set visible1(value:Boolean):void {
			_visible1 = value;
			layoutButtons();
		}
		public function get visible1():Boolean {
			return _visible1;
		}
		
		[Bindable]
		public function set visible2(value:Boolean):void {
			_visible2 = value;
			layoutButtons();
		}
		public function get visible2():Boolean {
			return _visible2;
		}
		
		[Bindable]
		public function set visible3(value:Boolean):void {
			_visible3 = value;
			layoutButtons();
		}
		public function get visible3():Boolean {
			return _visible2;
		}
		/* visibles */
		
		
		/* enableds */
		[Bindable]
		public function set enabled1(value:Boolean):void {
			_enabled1 = value;
			layoutButtons();
		}
		public function get enabled1():Boolean {
			return _enabled1;
		}
		
		[Bindable]
		public function set enabled2(value:Boolean):void {
			_enabled2 = value;
			layoutButtons();
		}
		public function get enabled2():Boolean {
			return _enabled2;
		}
		
		[Bindable]
		public function set enabled3(value:Boolean):void {
			_enabled3 = value;
			layoutButtons();
		}
		public function get enabled3():Boolean {
			return _enabled2;
		}
		/* enableds */
		
		
		[Bindable] public var buttonWidth:Number = 20;
		[Bindable] public var buttonHeight:Number = 18;
		
		private var button1:LinkButton;
		private var button2:LinkButton;
		private var button3:LinkButton;
		
		
		public function PanelXT()
		{
			super();
		}
		
		override protected function createChildren(): void {
			super.createChildren();
			button1 = new LinkButton();
			button1.label = '';
			button1.addEventListener("click", on1Click, false, 0.0, true);
			titleBar.addChild(button1);
			
			button2 = new LinkButton();
			button2.label = '';
			button2.addEventListener("click", on2Click, false, 0.0, true);
			titleBar.addChild(button2);
			
			button3 = new LinkButton();
			button3.label = '';
			button3.addEventListener("click", on3Click, false, 0.0, true);
			titleBar.addChild(button3);
			
			if(headerChildren != null){
				for(var i:int=0; i<headerChildren.length; i++){
					if(headerChildren[i] is DisplayObject){
						titleBar.addChild(headerChildren[i] as DisplayObject);
					}
				}
			}
		}
		
		override protected function layoutChrome(unscaledWidth:Number,unscaledHeight:Number): void {
			super.layoutChrome(unscaledWidth,unscaledHeight);
			layoutButtons();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number): void {
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			layoutButtons();
		}
		
		
		private function layoutButtons():void {
			if(titleBar == null){
				callLater(layoutButtons);
			}
			else {
				var _x:int = titleBar.width;
				
				button1.width = buttonWidth;
				button1.height = buttonHeight;
				button1.toolTip = toolTip1;
				button1.setStyle('icon', icon1);
				button1.enabled = _enabled1;
				if(icon1){
					_x = _x - button1.width - button1.y;
					button1.y = (titleBar.height - button1.height) / 2;
					button1.x = _x.valueOf();
					button1.visible = visible1;
				}
				else {
					button1.visible = false;
					button1.x = 0 - button1.width - 5;
				}
				
				button2.width = buttonWidth;
				button2.height = buttonHeight;
				button2.toolTip = toolTip2;
				button2.setStyle('icon', icon2);
				button2.enabled = _enabled2;
				if(icon2){
					_x = _x - button2.width - button2.y;
					button2.y = (titleBar.height - button2.height) / 2;
					button2.x = _x.valueOf();
					button2.visible = visible2;
				}
				else {
					button2.visible = false;
					button2.x = 0 - button2.width - 5;
				}
				
				button3.width = buttonWidth;
				button3.height = buttonHeight;
				button3.toolTip = toolTip3;
				button3.setStyle('icon', icon3);
				button3.enabled = _enabled3;
				if(icon3){
					_x = _x - button3.width - button3.y;
					button3.y = (titleBar.height - button3.height) / 2;
					button3.x = _x.valueOf();
					button3.visible = visible3;
				}
				else {
					button3.visible = false;
					button3.x = 0 - button3.width - 5;
				}
			}
		}
		
		private function on1Click(event:Event): void {
			dispatchEvent(new Event('button1Click'));
		}
		
		private function on2Click(event:Event): void {
			dispatchEvent(new Event('button2Click'));
		}
		
		private function on3Click(event:Event): void {
			dispatchEvent(new Event('button3Click'));
		}
		
		
	}
}