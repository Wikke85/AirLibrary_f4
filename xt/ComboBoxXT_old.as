package xt
{

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.core.EdgeMetrics;
	import mx.core.IFlexDisplayObject;
	import mx.core.UITextField;
	import mx.events.ListEvent;
	import mx.events.ResizeEvent;
	import mx.skins.RectangularBorder;
	import mx.skins.halo.HaloBorder;

	// Styles:
	[Style(name="disabledFillColors",type="Array",arrayType="uint",format="Color",inherit="yes")]
	[Style(name="backgroundImageXt", type="Object", format="File", inherit="no")]

	public class ComboBoxXT_old extends ComboBox {
		
		// Fields:
		// =======
		private var _fillColors:Object;
		private var _disabledFillColors:Object;
		private var _offsetTop:Number = 0;
		private var _offsetLeft:Number = 0;
		private var _offsetBottom:Number = -2;
		private var _offsetRight:Number = 0;
		private var backgroundImageXtClass:Object;
		// protected:
		protected var backgroundImageXt:DisplayObject;
		
		// Constructor:
		// ============
		public function ComboBoxXT() {
			super();
			labelField = "description";
			addEventListener("change",onChange,false,0,true);
			addEventListener("resize",onResize,false,0,true);
		}

		// Properties:
		// ===========
		override public function set enabled(value:Boolean): void {
			if(super.enabled != value) {
				_disabledFillColors = getStyle("disabledFillColors");
				if(!value) {
					_fillColors = getStyle("fillColors");
					if(_disabledFillColors != null) setStyle("fillColors",_disabledFillColors);
				} else {
					if(_disabledFillColors != null) setStyle("fillColors",_fillColors);
				}
			}
			super.enabled = value;
		}
		// idField:
		private var _idField:Object = "id";
		private var idFieldChanged:Boolean;
		[Bindable("idFieldChanged")]
		[Inspectable(category="Data",defaultValue="id")]
		public function get idField(): Object {
			return _idField;
		}
		public function set idField(value:Object): void {
			_idField = value;
			idFieldChanged = true;
			invalidateDisplayList();
			dispatchEvent(new Event("idFieldChanged"));
		}
		// selectedId:
		private var _selectedId:Object;
		[Bindable("selectedIdChanged")]
		[Bindable("change")]
		[Bindable("collectionChange")]
		[Bindable("valueCommit")]
		[Inspectable(category="Data",defaultValue=null)]
		public function get selectedId(): Object { return _selectedId; }
		public function set selectedId(value:Object): void {
			_selectedId = value;
			selectItemById(value);
			invalidateDisplayList();
			dispatchEvent(new Event("selectedIdChanged"));
		}
		// dataProvider:
		[Bindable]
		override public function set dataProvider(value:Object):void {
			super.dataProvider = value;
			if(selectedId && selectedId != "") {
				selectItemById(selectedId);
				invalidateDisplayList();
			}
		}
		// helper Methods:
		private function selectItemById(id:Object): void {
			var newIndex:int = -1;
			for(var i:int=0; i < dataProvider.length; i++) {
				var item:Object = dataProvider[i];
				if(item && item.hasOwnProperty(idField) && (id == item[idField])) newIndex = i;
			}
			selectedIndex = newIndex;
		}

		// Overriden Methods:
		// ==================
		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number): void {
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			var bm:EdgeMetrics = EdgeMetrics.EMPTY;
			var border:IFlexDisplayObject = IFlexDisplayObject(getChildAt(0));
			var bgImageIndex:int = 0;
			if(border) {
	        	if(border is RectangularBorder) {
	        		bm = RectangularBorder(border).borderMetrics;
		        	bgImageIndex = getChildIndex(DisplayObject(border)) + 1;
	        	}
	        }
	        var backgroundImageStyle:Object = getStyle("backgroundImageXt");
	        if(backgroundImageStyle && backgroundImageStyle is Class) {
	        	var bgCls:Class = Class(backgroundImageStyle);
	        	if(backgroundImageXt && (bgCls != backgroundImageXtClass)) {
	        		removeChild(backgroundImageXt);
	        		backgroundImageXt = null;
	        	}
	        	if(!backgroundImageXt) {
		        	var bgImg:DisplayObject = new bgCls();
        			bgImg.x = (bm.left - 1 < 0) ? 0 : bm.left - 1;
		       		bgImg.y = (bm.top - 1 < 0) ? 0 : bm.top - 1;
	        		addChildAt(bgImg,bgImageIndex + 1);
	        		backgroundImageXtClass = bgCls;
	        		backgroundImageXt = bgImg;
	        	}
	        }
	        textInput.x = bm.left + _offsetLeft;
	        textInput.y = bm.top + _offsetTop;
	        textInput.width = Math.max(0, unscaledWidth -
	        	((bm.left + _offsetLeft) + (bm.right + _offsetRight) + 21));
	        textInput.height = Math.max(0, unscaledHeight -
	        	((bm.top + _offsetTop) + (bm.bottom + _offsetBottom) - 1));
		}
		
		// Event Handler Methods:
		// ======================
		private function onChange(event:Event): void {
			if(selectedItem && selectedItem.hasOwnProperty(idField)) _selectedId = selectedItem[idField];
		}
		private function onResize(event:ResizeEvent): void {
			if(height < 15) {
				_offsetTop = -5;
				_offsetLeft = -5;
			}
			if(height >= 15) {
				var t:Number = Math.floor((height - 24) / 2);
				_offsetTop = t;
				_offsetLeft = t;
			}
		}

		// SelectItem:
		// ===========
		// 	   Return Value: "-1" if failed to select the item; else the "selectedIndex" of the item.
		// ========================================================================================
		public function selectItem(displayValue:String): int {
			return selectItemByDataField(displayValue,this.labelField);
		}
		public function selectItemByDataField(value:Object,dataField:String="id"): int {
			var result:int = -1;
			var items:Array;
			if(this.dataProvider == null) throw new Error("ComboBox \" + this.name + \" has an empty dataProvider.");
			if(this.dataProvider is Array) items = this.dataProvider as Array; else
			if(this.dataProvider.source is Array) items = this.dataProvider.source as Array;
			for(var i:int = 0; i<items.length; i++) {
				try {
					if(items[i][dataField] == value) {
						result = i;
						break;
					}
				} catch(e:Error) {
				}
			}
			this.selectedIndex = result;
			dispatchEvent(new ListEvent("change"));
			return result;
		}
		// ========================================================================================

	}
}