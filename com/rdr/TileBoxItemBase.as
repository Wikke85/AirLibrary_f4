package com.rdr
{
	import com.TileBox;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	
	[Style(name="hoverColor", type="uint", format="Color", inherit="yes")]
	[Style(name="selectedColor", type="uint", format="Color", inherit="yes")]
	
	public class TileBoxItemBase extends Canvas
	{
		
		
		[Bindable] public var showHover:Boolean = true;
		
		[Bindable] public var isHovering:Boolean = true;
		
		public var created:Boolean;
		
		public var parentList:TileBox;
		
		private var bgColor:uint;
		
		public function TileBoxItemBase()
		{
			super();
			
			bgColor = uint(getStyle('backgroundColor'));
			
			horizontalScrollPolicy	= 'off';
			verticalScrollPolicy	= 'off';
			
			addEventListener(MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
			
			addEventListener('creationComplete', onComplete, false, 0, true);
			addEventListener('render', onRender, false, 0, true);
		}
		
		private function onComplete(event:Event):void {
			created = true;
			if(data != null){
				setData();
			}
		}
		
		private function onRender(event:Event):void {
			setStyle('backgroundColor', isHovering ? getStyle('hoverColor') : (parentList.selectedItem == data ? getStyle('hoverColor') : bgColor));
		}
		
		
		override public function set data(value:Object): void {
			super.data = value;
			if(created){
				setData();
			}
		}
		
		private function onRollOver(event:MouseEvent):void {
			if(showHover){
				//bgColor = uint(getStyle('backgroundColor'));
				//setStyle("backgroundColor", getStyle('hoverColor'));
				isHovering = true;
			}
		}
		private function onRollOut(event:MouseEvent):void {
			if(showHover){
				//setStyle("backgroundColor", bgColor);
				isHovering = false;
			}
		}
		
		// override to set data
		protected function setData(): void {
			
		}
		
	}
}