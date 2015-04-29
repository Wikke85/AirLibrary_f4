package xt
{
	import mx.core.UITextField;
	
	/**
	 * Used in ButtonXT to make the label multi-line-enabled
	 * */
	internal class UITextFieldXT extends UITextField
	{
	
		public function UITextFieldXT()
		{
			super();
		}
	
	    override public function truncateToFit(s:String = null):Boolean
		{
			return false;
		}
	}
	
}
