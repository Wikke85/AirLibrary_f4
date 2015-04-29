package utils {

	import mx.core.UIComponent;
	import mx.controls.TextInput;
	import mx.controls.TextArea;
	
	public class TextUtils extends Object {
		
		public function TextUtils() {
			super();
		}

		public static function selectAll(control:UIComponent): void {
			if(control is TextInput) {
				var ti:TextInput = TextInput(control);
				ti.selectionBeginIndex = 0;
				ti.selectionEndIndex = ti.text.length;
			}
			if(control is TextArea) {
				var ta:TextArea = TextArea(control);
				ta.selectionBeginIndex = 0;
				ta.selectionEndIndex = ta.text.length;
			}
		}
		public static function selectNone(control:UIComponent): void {
			if(control is TextInput) {
				var ti:TextInput = TextInput(control);
				ti.selectionBeginIndex = 0;
				ti.selectionEndIndex = 0;
			}
			if(control is TextArea) {
				var ta:TextArea = TextArea(control);
				ta.selectionBeginIndex = 0;
				ta.selectionEndIndex = 0;
			}
		}
		
	}

}