package xt
{
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.printing.PrintJob;
	import flash.printing.PrintJobOptions;
	import flash.printing.PrintJobOrientation;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.core.UIComponentGlobals;
	import mx.core.mx_internal;
	import mx.printing.FlexPrintJobScaleType;
	
	use namespace mx_internal;
	
	public class PrintJobXT extends EventDispatcher {
		
		public function PrintJobXT() {
			super();
		}
		
		private var printJob:PrintJob = new PrintJob();
		private var pages:ArrayCollection = new ArrayCollection();
		
		
		
		private var _pageWidth:Number = 0;
		
		public function get pageWidth(): Number {
			return _pageWidth;
		}
		
		
		private var _pageHeight:Number = 0;
		
		public function get pageHeight(): Number {
			return _pageHeight;
		}
		
		
		
		private var _printAsBitmap:Boolean = true;
		
		public function get printAsBitmap(): Boolean {
			return _printAsBitmap;
		}
		public function set printAsBitmap(value:Boolean): void {
			_printAsBitmap = value;
		}
		
		
		
		public function get orientation(): String {
			return printJob.orientation;
		}
		public function set orientation(value:String): void {
			var i:int; var page:Object;
			if(printJob.orientation == PrintJobOrientation.PORTRAIT) {
				if(value == PrintJobOrientation.LANDSCAPE) {
					for(i = 0; i < pages.length; i++) {
						page = pages.getItemAt(i);
						Sprite(page.obj).rotation = -90;
						//Rectangle(page.rec). ...
					}
				}
			}
			else if(printJob.orientation == PrintJobOrientation.LANDSCAPE) {
				if(value == PrintJobOrientation.PORTRAIT) {
					for(i = 0; i < pages.length; i++) {
						page = pages.getItemAt(i);
						Sprite(page.obj).rotation = 90;
						//Rectangle(page.rec). ...
					}
				}
			}
		}
		
		public function start(): Boolean {
			var ok:Boolean = printJob.start();
			if(ok) {
				_pageWidth = printJob.pageWidth;
				_pageHeight = printJob.pageHeight;
			}
			return ok;
		}
		
		public function addObject(obj:IUIComponent,scaleType:String = "matchWidth"): void {
			var objWidth:Number;
			var objHeight:Number;
			var objPercWidth:Number;
			var objPercHeight:Number;
			var n:int;
			var i:int;
			var j:int;
			var child:IFlexDisplayObject;
			var childPercentSizes:Object = {};
			if(obj is Application) {
				// The following loop is required only for scenario where 
				// application may have a few children with percent
				// width or height.
				n = Application(obj).numChildren
				for(i = 0; i < n; i++) {
					child = IFlexDisplayObject(Application(obj).getChildAt(i));
					if(child is UIComponent && (!isNaN(UIComponent(child).percentWidth) || !isNaN(UIComponent(child).percentHeight))) {
						childPercentSizes[child.name] = {};
						if(!isNaN(UIComponent(child).percentWidth) && isNaN(UIComponent(child).explicitWidth)) {
							childPercentSizes[child.name].percentWidth = UIComponent(child).percentWidth;
							UIComponent(child).percentWidth = NaN;
							UIComponent(child).explicitWidth = UIComponent(child).width;
						}
						if(!isNaN(UIComponent(child).percentHeight) && isNaN(UIComponent(child).explicitHeight)) {
							childPercentSizes[child.name].percentHeight = UIComponent(child).percentHeight;
							UIComponent(child).percentHeight = NaN;
							UIComponent(child).explicitHeight = UIComponent(child).height;
						}
					}
				}
				UIComponent(obj).validateSize();
				objWidth = obj.measuredWidth;
				objHeight = obj.measuredHeight;
			}
			else {
				// Lock if the content is percent width or height.
				if(!isNaN(obj.percentWidth) && isNaN(obj.explicitWidth)) {
					objPercWidth = obj.percentWidth;
					obj.percentWidth = NaN;
					obj.explicitWidth = obj.width;
				}
				if(!isNaN(obj.percentHeight) && isNaN(obj.explicitHeight)) {
					objPercHeight = obj.percentHeight;
					obj.percentHeight = NaN;
					obj.explicitHeight = obj.height;
				}
				objWidth = obj.getExplicitOrMeasuredWidth();
				objHeight = obj.getExplicitOrMeasuredHeight();
			}
			var widthRatio:Number = _pageWidth/objWidth;
			var heightRatio:Number = _pageHeight/objHeight;
			var ratio:Number = 1;
			if(scaleType == FlexPrintJobScaleType.SHOW_ALL) {
				// Smaller of the two ratios for showAll.
				ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio;
			}
			else if(scaleType == FlexPrintJobScaleType.FILL_PAGE) {
				// Bigger of the two ratios for fillPage.
				ratio = (widthRatio > heightRatio) ? widthRatio : heightRatio;
			}
			else if(scaleType == FlexPrintJobScaleType.NONE) {
				
			}
			else if(scaleType == FlexPrintJobScaleType.MATCH_HEIGHT) {
				ratio = heightRatio;
			}
			else {
				ratio = widthRatio;
			}
			// Scale it to the required value.
			obj.scaleX *= ratio;
			obj.scaleY *= ratio;
			UIComponentGlobals.layoutManager.usePhasedInstantiation = false;
			UIComponentGlobals.layoutManager.validateNow();
			var arrPrintData:Array = prepareToPrintObject(obj);
			if(obj is Application) {
				objWidth *= ratio;
				objHeight *= ratio;
			}
			else {
				objWidth = obj.getExplicitOrMeasuredWidth();
				objHeight = obj.getExplicitOrMeasuredHeight();
			}
			// Find the number of pages required in vertical and horizontal.
			var hPages:int = Math.ceil(objWidth / _pageWidth);
			var vPages:int = Math.ceil(objHeight / _pageHeight);
			// when sent to addPage, scaling is to be ignored.
			var incrX:Number = _pageWidth / ratio;
			var incrY:Number = _pageHeight / ratio;
			var lastPageWidth:Number = (objWidth % _pageWidth) / ratio;
			var lastPageHeight:Number = (objHeight % _pageHeight) / ratio;
			for(j = 0; j < vPages; j++) {
				for(i = 0; i < hPages; i++) {
					var r:Rectangle = new Rectangle(i * incrX, j * incrY, incrX, incrY);
					// For last pages send only the remaining amount
					// so that rest of the paper is printed white
					// else it prints that in gray.
					if(i == hPages - 1 && lastPageWidth != 0){
						r.width = lastPageWidth;
					}
					if(j == vPages - 1 && lastPageHeight != 0){
						r.height = lastPageHeight;
					}
					// The final edge may have got fractioned as
					// contents may not be complete multiple of pageWidth/Height.
					// This may result in a blank area at the end of page.
					// Tthis rounding off ensures no small blank area in the end 
					// but results in some part of next page getting reprinted
					// this page but it does not result in loss of any information.
					r.width = Math.ceil(r.width);
					r.height = Math.ceil(r.height);
					var printJobOptions:PrintJobOptions = new PrintJobOptions();
					printJobOptions.printAsBitmap = _printAsBitmap;
					printJob.addPage(Sprite(obj), r, printJobOptions);
					pages.addItem({obj:obj,rec:r});
				}
			}
			finishPrintObject(obj, arrPrintData);
			// Scale it back.
			obj.scaleX /= ratio;
			obj.scaleY /= ratio;
			if(obj is Application) {
				// The following loop is required only for scenario
				// where application may have a few children
				// with percent width or height.
				n = Application(obj).numChildren
				for(i = 0; i < n; i++) {
					child = IFlexDisplayObject(Application(obj).getChildAt(i));
					if(child is UIComponent && childPercentSizes[child.name]) {
						var childPercentSize:Object = childPercentSizes[child.name];
						if(childPercentSize && !isNaN(childPercentSize.percentWidth)) {
							UIComponent(child).percentWidth = childPercentSize.percentWidth;
							UIComponent(child).explicitWidth = NaN;
						}
						if(childPercentSize && !isNaN(childPercentSize.percentHeight)) {
							UIComponent(child).percentHeight = childPercentSize.percentHeight;
							UIComponent(child).explicitHeight = NaN;
						}
					}
				}
				UIComponent(obj).validateSize();
			}
			else {
				// Unlock if the content was percent width or height.
				if(!isNaN(objPercWidth)) {
					obj.percentWidth = objPercWidth;
					obj.explicitWidth = NaN;
				}
				if(!isNaN(objPercHeight)) {
					obj.percentHeight = objPercHeight;
					obj.explicitHeight = NaN;
				}
			}
			UIComponentGlobals.layoutManager.usePhasedInstantiation = false;
			UIComponentGlobals.layoutManager.validateNow();	
		}
		
		public function send(): void {
			printJob.send();
			pages.removeAll();
		}
		
		
		
		private function prepareToPrintObject(target:IUIComponent): Array {
			var arrPrintData:Array = [];
			var obj:DisplayObject = (target is DisplayObject) ? DisplayObject(target) : null;
			var index:Number = 0;
			while(obj) {
				if(obj is UIComponent){
					arrPrintData[index++] = UIComponent(obj).prepareToPrint(UIComponent(target));
				}
				else if(obj is DisplayObject && !(obj is Stage)) {
					arrPrintData[index++] = DisplayObject(obj).mask;
					DisplayObject(obj).mask = null;
				}
				obj = (obj.parent is DisplayObject) ? DisplayObject(obj.parent) : null;
			}
			return arrPrintData;
		}
		
		
		
		private function finishPrintObject(target:IUIComponent,arrPrintData:Array): void {
			var obj:DisplayObject = (target is DisplayObject) ? DisplayObject(target) : null;
			var index:Number = 0;
			while(obj) {
				if(obj is UIComponent){
					UIComponent(obj).finishPrint(arrPrintData[index++],UIComponent(target));
				}
				else if(obj is DisplayObject && !(obj is Stage)) {
					DisplayObject(obj).mask = arrPrintData[index++];
				}
				obj = (obj.parent is DisplayObject) ? DisplayObject(obj.parent) : null;
			}
		}

	}
	
}

