package xt
{

	import mx.collections.ArrayCollection;
	import mx.controls.Button;
	import mx.controls.TabBar;

	public class TabBarXT extends TabBar {

		public function TabBarXT() {
			super();
		}

		public function get buttons(): ArrayCollection {
			var result:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i < numChildren; i++) {
				var child:Object = getChildAt(i);
				if(child is Button) result.addItem(child);
			}
			return result;
		}

		public function enableButtons(): void {
			toggleButtonsEnabled(true);
		}
		public function disableButtons(): void {
			toggleButtonsEnabled(false);
		}
		private function toggleButtonsEnabled(value:Boolean): void {
			var btns:ArrayCollection = buttons;
			for(var i:int = 0; i < btns.length; i++) {
				//if(includeSelected || (!includeSelected && selectedIndex != i)) {
					Button(btns.getItemAt(i)).enabled = value;
				//}
			}
		}

	}

}