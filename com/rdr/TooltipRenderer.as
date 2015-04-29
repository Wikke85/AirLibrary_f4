package com.rdr
{
	
	import mx.controls.Label;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;

	public class TooltipRenderer extends Label implements IDropInListItemRenderer
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
		
		public function TooltipRenderer()
		{
			super();
		}
		
		private function setCheckvalue():void {
			if(data != null){
				
				var tooltip:String = '';
				
				if( listData.hasOwnProperty('dataField') && data.hasOwnProperty(listData['dataField']) )
				{
					tooltip = data[listData['dataField']];
				}
				if( tooltip == null )
				{
					tooltip = '';
				}
				
				toolTip = tooltip;
				
			}
		}
		
		   
	}
	
}
