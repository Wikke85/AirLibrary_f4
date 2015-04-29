package com.module
{
	import mx.events.FlexEvent;
	import mx.modules.Module;

	public class ModuleComponent extends Module implements IModuleComponent
	{
		
		[Bindable] public var complete:Boolean = false;
		
		public var selectedView:String;
		public var viewsCurrentState:String;
		
		
		public function ModuleComponent()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true);
		}
		
		private function onCreationComplete(event:FlexEvent):void {
			complete = true;
		}
		
		public function load( view:String, viewState:String='' ):void {
			selectedView = view;
			viewsCurrentState = viewState;
			
			if(!complete){
				callLater(load,[view, viewState]);
			}
			else {
				selectView( view, viewState );
			}
		}
		
		
		
		/**
		 * Override this function in a custom component to load data/perform updating/...
		 * */
		public function selectView( view:String, viewState:String='' ):void {
			
		}
		
		
		
	}
}