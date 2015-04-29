package com.rdr
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.CheckBox;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;

	public class CheckboxRenderer extends CheckBox implements IDropInListItemRenderer
	{
		
		override public function set listData(value:BaseListData):void
		{
			super.listData = value;
			setCheckvalue();
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			setCheckvalue();
		}
		
		public function CheckboxRenderer()
		{
			super();
			addEventListener(MouseEvent.CLICK, onClick, false, 0 , true);
		}
		
		private function onClick(event:Event):void {
			data[listData['dataField']] = this.selected;
		}
		
		/*[Bindable("dataChange")]
		[Bindable("change")]
		[Bindable("render")]*/
		private function setCheckvalue():void {
			if(data != null){
				
				var field:Object = null;
				
				if( listData.hasOwnProperty('dataField') && data.hasOwnProperty(listData['dataField']) )
				{
					field = data[listData['dataField']];
				}
				if( field == null )
				{
					field = 'null';
				}
				
				switch( field.toString().toLowerCase() )
				{
					case 'true':
					case '1':
						selected = true;
						break;
					
					default:
						selected = false;
				}
				
			}
		}
		
		   
	}
	
}
