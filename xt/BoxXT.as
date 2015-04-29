package xt
{

	import mx.containers.Box;
	import flash.display.Graphics;
	import flash.display.GradientType;
	import mx.styles.StyleManager;
	import mx.styles.CSSStyleDeclaration;
	import flash.geom.Matrix;
	import mx.core.FlexSprite;

	[Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no")]
	[Style(name="fillAlphas",type="Array",arrayType="Number",inherit="no")]
	[Style(name="fillDirection",type="String",inherit="no")]
	[Style(name="fillRotation",type="int",inherit="no")]

	public class BoxXT extends Box {

		// Constructor:
		public function BoxXT() {
			super();
		}

		// Initialize Styles:
		// ==================
		private static var classConstructed:Boolean = classConstruct();
		private static function classConstruct(): Boolean {
			if(!StyleManager.getStyleDeclaration("BoxXT")) {
				var newStyleDeclaration:CSSStyleDeclaration = new CSSStyleDeclaration();
				newStyleDeclaration.setStyle("fillColors",[0xE7E7E7,0xD9D9D9]);
				newStyleDeclaration.setStyle("fillAlphas",[0.85,0.85]);
				newStyleDeclaration.setStyle("fillDirection","vertical");
				StyleManager.setStyleDeclaration("BoxXT",newStyleDeclaration,true);
			}
			return true;
		}

		// Fields:
		// =======
		private var bg:FlexSprite;
		private var fillColorsChanged:Boolean = true;
		private var fillAlphasChanged:Boolean = true;
		private var fillDirectionChanged:Boolean = true;
		private var _gradientBackground:Boolean = false;
		private var _gradientBackgroundChanged:Boolean = false;

		// Properties:
		// ===========
		[Bindable("gradientBackgroundChanged")]
		[Inspectable(category="General", enumeration="true,false", defaultValue="false")]
		public function get gradientBackground(): Boolean { return _gradientBackground; }
		public function set gradientBackground(value:Boolean): void {
			_gradientBackground = value;
			_gradientBackgroundChanged = true;
			invalidateProperties();
		}

		// Overriden Methods:
		// ==================
		override public function styleChanged(styleProp:String):void {
			super.styleChanged(styleProp);
			if(styleProp == "fillColors") {
				fillColorsChanged = true; 
				invalidateDisplayList();
			}
			if(styleProp == "fillAlphas") {
				fillAlphasChanged = true; 
				invalidateDisplayList();
			}
			if(styleProp == "fillDirection") {
				fillDirectionChanged = true; 
				invalidateDisplayList();
			}
		}
		override protected function createChildren(): void {
			super.createChildren();
			if(!bg) {
				bg = new FlexSprite();
				bg.name = "bg";
				bg.visible = false;
				bg.tabEnabled = false;
				rawChildren.addChildAt(bg,0);
			}
		}
		override protected function commitProperties(): void {
			super.commitProperties();
			if(_gradientBackgroundChanged) {
				if(bg) bg.visible = _gradientBackground;
				if(initialized) layoutChrome(unscaledWidth,unscaledHeight);
			}
		}
		override protected function layoutChrome(unscaledWidth:Number,unscaledHeight:Number): void {
			super.layoutChrome(unscaledWidth,unscaledHeight);
			var sizeChanged:Boolean = (bg.width != unscaledWidth || bg.height != unscaledHeight);
			if(sizeChanged || fillColorsChanged || fillAlphasChanged) {
				bg.width = unscaledWidth;
				bg.height = unscaledHeight;
				drawBackGround(0,0,unscaledWidth,unscaledHeight);
				fillColorsChanged = false;
				fillAlphasChanged = false;
				fillDirectionChanged = false;
			}
		}
		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number): void {
			rawChildren.setChildIndex(bg,0);
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
		
		// Protected Methods:
		// ==================
		protected function drawBackGround(x:Number,y:Number,width:Number,height:Number): void {
			var fillColors:Array = getStyle("fillColors");
			var fillAlphas:Array = getStyle("fillAlphas");
			var fillDirection:String = getStyle("fillDirection");
			var fillRotation:int = getStyle("fillRotation");
			var ratios:Array = [0x00,0xFF];
			var matrix:Matrix;
			var radius:Number = getStyle("cornerRadius");
			switch(fillDirection) {
				case "vertical":   matrix = verticalGradientMatrix(x,y,width,height);	bg.rotation = 0;	break;
				case "horizontal": matrix = horizontalGradientMatrix(x,y,width,height);	bg.rotation = 0;	break;
				default:
					matrix = verticalGradientMatrix(x,y,width,height);
					bg.rotation = fillRotation;
			}
			var g:Graphics = bg.graphics;
			g.beginGradientFill(GradientType.LINEAR,fillColors,fillAlphas,ratios,matrix);
			g.drawRoundRect(x,y,width,height,radius+4,radius+4);
			g.endFill();
			
		}
		
		
		
	}
	
	
	
}

