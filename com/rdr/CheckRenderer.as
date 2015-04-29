package com.rdr
{
	import mx.controls.Image;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	public class CheckRenderer extends UIComponent implements IListItemRenderer
	{
		public function CheckRenderer()
		{
			super();
		}
		
		/**
		 * Set the tooltip for either a checked or an unchecked datagrid cell
		 * Use like this:
		 * <mx:DataGridColumn headerText="Column Tooltip" dataField="has_tooltip">
		 * 	<mx:itemRenderer>
		 * 		<mx:Component>
		 * 			<com:CheckRenderer tooltipChecked="<tooltip for checked>" tooltipUnchecked="<tooltip for unchecked>" />
		 * 		</mx:Component>
		 * 	</mx:itemRenderer>
		 * </mx:DataGridColumn>
		 * */
		[Bindable] public var tooltipChecked:String	= '';
		[Bindable] public var tooltipUnchecked:String	= '';
		
		/**
		 * Indicates that the check is visible
		 * (no setter)
		 * */
		[Bindable] public var isChecked:Boolean = false;
		
		
		private var _listData:BaseListData, _data:Object;
		
		private var img:Image;
		
		[Bindable("dataChange")]
		public function get listData():BaseListData
		{
			return _listData;
		}
		public function set listData(value:BaseListData):void
		{
			_listData = value;
			invalidateProperties();
	        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}
		
		
		[Bindable("dataChange")]
	    public function get data():Object {
	        return _data;
	    }
	    public function set data(value:Object):void {
	        _data = value;
	        invalidateProperties();
	        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
	    }
		
		
		override protected function createChildren():void {                
			super.createChildren();
			img = new Image;
			img.visible = false;
			img.source = 'images/16x16/ok.png';
			img.maintainAspectRatio = true;
			img.scaleContent = false;
			img.setStyle('horizontalAlign', 'center');
			img.setStyle('verticalAlign', 'middle');
			addChild(img);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			img.move(0,0);   
			img.setActualSize(unscaledWidth,unscaledHeight);   
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			
			var field:String;
			
			if( listData.hasOwnProperty('dataField') && data.hasOwnProperty(listData['dataField']) )
			{
				field = (''+data[listData['dataField']]).toLowerCase();
			}
			
			if(field == 'true' || field == '1'){
				img.visible = true;
			
				toolTip = tooltipChecked;
				img.toolTip = tooltipChecked;
				
			}
			else {
				img.visible = false;
				
				toolTip = tooltipUnchecked;
				img.toolTip = tooltipUnchecked;
				
			}
			isChecked = img.visible;
			
		}
		
		
		
	}
	
}
