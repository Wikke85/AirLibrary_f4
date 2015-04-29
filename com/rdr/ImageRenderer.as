package com.rdr
{
	import mx.controls.Image;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	public class ImageRenderer extends UIComponent implements IListItemRenderer, IDropInListItemRenderer
	{
		public function ImageRenderer()
		{
			super();
		}
		
		private var _listData:BaseListData, _data:Object;
		
		[Bindable] private var isChecked:Boolean = false;
		
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
			img.maintainAspectRatio = true;
			img.scaleContent = true;
			img.setStyle('horizontalAlign', 'center');
			img.setStyle('verticalAlign', 'top');
			addChild(img);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			img.move(0,0);   
			img.setActualSize(unscaledWidth,unscaledHeight);   
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			
			if(listData != null && listData.hasOwnProperty('dataField') && data != null && data.hasOwnProperty(listData['dataField']) )
			//&& data[listData['dataField']] != null && data[listData['dataField']] != '')
			{
				img.source = data[listData['dataField']];
			}
		}
		
		
		
	}
	
}
