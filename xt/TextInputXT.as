package xt
{
	import flash.events.Event;
	
	import mx.controls.TextInput;
	
	
	[Style(name="promptColor", type="uint", format="Color", inherit="yes")]
	
	
	public class TextInputXT extends TextInput
	{
		
		// temp var to store the current colour in when setting the prompt color
		private var color:uint = 0x0;
		
		public function TextInputXT()
		{
			super();
			addEventListener('focusIn', onFocusIn, false, 0, true);
			addEventListener('focusOut', onFocusOut, false, 0, true);
			
		}
		
		
		/*
		 * remove the prompt text and set the color back to normal
		 */
		private function onFocusIn(event:Event):void {
			if(text == _prompt){
				super.text = '';
				
				color = getStyle('color');
				setStyle('color', getStyle('promptColor'));
			}
		}
		
		/*
		 * show the prompt text when no other text is entered and set the prompt color
		 */
		private function onFocusOut(event:Event):void {
			if(text == ''){
				text = _prompt;
				
				setStyle('color', color);
			}
		}
		
		
		
		
		private var _prompt:String = '';
		
		/**
		 * Value to show when textfield is empty.
		 * */
		[Bindable]
		public function set prompt(value:String):void {
			if(_prompt != value){
				_prompt = value;
				if(text == ''){
					text = _prompt;
					
					color = getStyle('color');
					setStyle('color', getStyle('promptColor'));
				}
			}
		}
		public function get prompt():String {
			return _prompt;
		}
		
		
		
		[Bindable]
		override public function set text(value:String):void {
			super.text = value;
			if(super.text == ''){
				super.text = _prompt;
				color = getStyle('color');
				setStyle('color', getStyle('promptColor'));
			}
		}
		override public function get text():String {
			return super.text == _prompt ? '' : super.text;
		}
		
		
		/**
		 * Highlights all text (ctrl-A)
		 * */
		public function selectAll(): void {
			selectionBeginIndex = 0;
			selectionEndIndex = text.length;
			
		}
		
		/**
		 * Deselects highlighted text
		 * */
		public function selectNone(): void {
			selectionBeginIndex = 0;
			selectionEndIndex = 0;
			
		}
		
		
		/**
		 * get the currently selected text
		 * */
		public function get selectedText(): String {
			return text.substring(selectionBeginIndex, selectionEndIndex);
		}
		
		
	}
}