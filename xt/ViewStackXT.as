package xt
{
	import mx.containers.ViewStack;
	import mx.events.IndexChangedEvent;

	public class ViewStackXT extends ViewStack
	{
		
		private var previousIndex:int = -1;
		
		public function ViewStackXT()
		{
			super();
			addEventListener('change', onIndexChange, false, 0.0, true);
		}
		
		/**
		 * Go to previous selected Index
		 */
		public function previous():void {
			selectedIndex = previousIndex;
			
		}
		
		private function onIndexChange(event:IndexChangedEvent):void{
			previousIndex = event.oldIndex;
		}
		
	}
}