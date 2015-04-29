package xt
{
	
	import mx.controls.Button;
	import mx.controls.NumericStepper;

	public class NumericStepperXT extends NumericStepper
	{
		
		/**
		 * property used in repeaters to know which data is passed to the control
		 * in mxml: <xt:NumericStepperXT value="{repeaterComponent.currentItem.datafield}"
		 * 				passedData="{repeaterComponent.currentItem}"/>
		*/
		[Bindable] public var passedData:Object;
		
		public function NumericStepperXT()
		{
			super();
		}
		
		// arrow buttons 
		public var buttonUp:Button;
		public var buttonDown:Button;
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			// get arrow buttons
			buttonUp	= Button(super.getChildAt(1));
			buttonDown	= Button(super.getChildAt(2));
		}
		
		// set/get enabled statuses of up/down arrows
		[Bindable]
		public function set enableUp(value:Boolean):void {
			buttonUp.enabled = value;
		}
		public function get enableUp():Boolean {
			return buttonUp.enabled;
		}
		
		[Bindable]
		public function set enableDown(value:Boolean):void {
			buttonDown.enabled = value;
		}
		public function get enableDown():Boolean {
			return buttonDown.enabled;
		}
		
		
	}
}