package xt.combo {
	
	import xt.ComboCheck;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.CheckBox;
	import mx.controls.listClasses.BaseListData;
	import mx.events.FlexEvent;
	
	[Event(name="comboChecked", type="com.xt.combo.ComboCheckEvent")]
	
	public class ComboCheckItemRenderer extends CheckBox {
		
		public static var dataSelectedField:String = 'selected';
		
		public function ComboCheckItemRenderer() {
			super();
			//addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(MouseEvent.CLICK,onClick);
		}

		/*private function onCreationComplete(event:Event):void {
			if (data.assigned==true) {
				selected=true;
				var cck:ComboCheck=ComboCheck(ComboCheckDropDownFactory(owner).owner);
				var index:int=cck.selectedItems.getItemIndex(data);
        		if (index==-1) {
					cck.selectedItems.addItem(data);
        		}
			}
			//trace ("ItemRenderer created!");
		}*/

        private function onClick(event:Event):void {
	        super.data[ComboCheckItemRenderer.dataSelectedField] = selected;
	        var myComboCheckEvent:ComboCheckEvent=new ComboCheckEvent(ComboCheckEvent.COMBO_CHECKED);
	        myComboCheckEvent.obj=data;
	        owner.dispatchEvent(myComboCheckEvent);
        }
        
        override public function set data(item:Object):void {
        	super.data = item;
        	selected = data != null && data.hasOwnProperty(ComboCheckItemRenderer.dataSelectedField) ? data[ComboCheckItemRenderer.dataSelectedField] : false;
        	
        	/*if (data.assigned==true) {
				//selected=true;
				var cck:ComboCheck=ComboCheck(ComboCheckDropDownFactory(owner).owner);
				var index:int=cck.selectedItems.getItemIndex(data);
        		if (index==-1) {
					cck.selectedItems.addItem(data);
        		}
			}*/
        }
        
        
        override public function set listData(value:BaseListData):void {
        	super.listData = value;
        }
        
	}
}