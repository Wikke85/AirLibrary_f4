package utils
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	
	import mx.core.UITextField;
	import mx.graphics.ImageSnapshot;
	
	public class GraphicsUtils
	{
		public function GraphicsUtils()
		{
		}
		
		/*
		As You can see we added UITextField() instance, taked it's snapshot via mx.graphics.ImageSnapshot() class method captureBitmapData(). 
		Than we measured it's actually dimmentions and re-captured text snapshot with proper sizes. 
		Than we set line style to (0,0,0) to hide rectangle border we don't need. 
		We are going to place out text-image in our g at coordinates (fromX+toX)/2, (fromY+toY)/2). 
		So, next important thing is to create replacement Matrix() we will use to fill rectangle. 
		Without this matrix rectangle filling would be started in g coordinates (0,0) 
		
		So, we added Matrix() with tx and ty coeficients set to point we are going to add rectangle. 
		Last step is to add a rectangle and fill it with «text-image» BitmapData using replacement matrix. 
		When user would move mesh nodes, edge would be redrawed, sm.tx and sm.ty would be recounted and rectangle would be filled proper.
		
		*/
		public static function addText(g:Graphics, text:String, 
			fromX:int, fromY:int, toX:int, toY:int, 
			lineThickness:Number, lineColour:uint):void {
			
			g.lineStyle(lineThickness, lineColour);
			g.moveTo(fromX, fromY);
			g.lineTo(toX, toY);
			
			var uit:UITextField = new UITextField;
			uit.text = text;
			uit.autoSize = TextFieldAutoSize.LEFT;
			var textBitmapData:BitmapData = ImageSnapshot.captureBitmapData(uit);
			var sizeMatrix:Matrix = new Matrix();
			
			var coef:Number = Math.min(uit.measuredWidth/textBitmapData.width, uit.measuredHeight/textBitmapData.height);
			
			sizeMatrix.a = coef;
			sizeMatrix.d = coef;
			
			textBitmapData = ImageSnapshot.captureBitmapData(uit, sizeMatrix);
			
			g.lineStyle(0,0,0);
			var sm:Matrix = new Matrix();
			sm.tx = (fromX + toX)/2;
			sm.ty = (fromY + toY)/2;
			g.beginBitmapFill(textBitmapData, sm, false);
			g.drawRect((fromX+toX)/2, (fromY+toY)/2, uit.measuredWidth, uit.measuredHeight);
			g.endFill();
			
		}
		
		
	}
	
}
