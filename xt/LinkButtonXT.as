package xt
{
	import flash.display.DisplayObject;
	import flash.text.TextLineMetrics;
	
	import mx.controls.LinkButton;
	import mx.core.IFlexDisplayObject;
	import mx.core.mx_internal;
	use namespace mx_internal;
	
	/**
	 * LinkButtonXT's label can be HTML text, and multiline enabled
	 * */
	public class LinkButtonXT extends LinkButton
	{
	
		public function LinkButtonXT()
		{
			super();
		}
	
		override protected function createChildren():void
		{
			if (!textField)
			{
				textField = new UITextFieldXT();
				textField.percentWidth	= 100;
				textField.percentHeight	= 100;
				textField.styleName = this;
				addChild(DisplayObject(textField));
			}
	
			super.createChildren();
	
			textField.multiline = true;
			textField.wordWrap = true;
		}
	
		override protected function measure():void
		{
			if (!isNaN(explicitWidth))
			{
				var tempIcon:IFlexDisplayObject = getCurrentIcon();
				var w:Number = explicitWidth;
				if (tempIcon)
					w -= tempIcon.width + int(getStyle("horizontalGap")) + int(getStyle("paddingLeft")) + int(getStyle("paddingRight"));
				textField.width = w;
			}
			super.measure();
			
		}
	
	    override public function measureText(s:String):TextLineMetrics
		{
			textField.htmlText = s;
			var lineMetrics:TextLineMetrics = textField.getLineMetrics(0);
			lineMetrics.width = textField.textWidth + 4;
			lineMetrics.height = textField.textHeight + 4;
			return lineMetrics;
		}
		
		
		[Bindable]
		override public function set enabled(value:Boolean):void {
			super.enabled;
			invalidateAdvanced();
		}
		
		
		private var _advancedButton:Boolean = true;
		[Bindable]
		public function set advancedButton(value:Boolean):void {
			_advancedButton = value;
			invalidateAdvanced();
		}
		public function get advancedButton():Boolean {
			return _advancedButton;
		}
		
		
		private function invalidateAdvanced():void {
			if(_advancedButton){
				alpha = enabled ? 1 : 0.6;
				buttonMode = enabled;
			}
		}
		
		
	}
	
}
