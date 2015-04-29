package xt
{
	import flash.display.DisplayObject;
	import flash.text.TextLineMetrics;
	
	import mx.controls.Button;
	import mx.core.IFlexDisplayObject;
	
	import mx.core.mx_internal;
	use namespace mx_internal;
	
	/**
	 * ButtonXT's label can be HTML text, and multiline enabled
	 * */
	public class ButtonXT extends Button
	{
	
		public function ButtonXT()
		{
			super();
		}
	
		override protected function createChildren():void
		{
			if (!textField)
			{
				textField = new UITextFieldXT();
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
	}
	
}
