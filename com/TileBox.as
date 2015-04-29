package com {

	import com.rdr.TileBoxItemBase;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.BoxDirection;
	import mx.containers.utilityClasses.CanvasLayout;
	import mx.containers.utilityClasses.IConstraintLayout;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.Container;
	import mx.core.IFactory;
	import mx.core.IUIComponent;
	import mx.core.ScrollPolicy;
	import mx.core.mx_internal;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.ItemClickEvent;
	import mx.utils.UIDUtil;

	use namespace mx_internal;

	// Styles:
	[Style(name="horizontalAlign", type="String", enumeration="left,center,right", inherit="no")]
	[Style(name="verticalAlign", type="String", enumeration="bottom,middle,top", inherit="no")]
	[Style(name="horizontalGap", type="Number", format="Length", inherit="no")]
	[Style(name="verticalGap", type="Number", format="Length", inherit="no")]
	[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]
	[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

	// Excluded APIs:
	[Exclude(name="focusIn", kind="event")]
	[Exclude(name="focusOut", kind="event")]
	[Exclude(name="focusBlendMode", kind="style")]
	[Exclude(name="focusSkin", kind="style")]
	[Exclude(name="focusThickness", kind="style")]
	[Exclude(name="focusInEffect", kind="effect")]
	[Exclude(name="focusOutEffect", kind="effect")]

	// Events:
	[Event("pageChange")]
	[Event(name="itemClick",type="mx.events.ItemClickEvent")]

	// Defaults:
	[DefaultBindingProperty(source="selectedItem", destination="dataProvider")]
	[DefaultProperty("dataProvider")]
	[DefaultTriggerEvent("change")]

	public class TileBox extends Container implements IConstraintLayout {

		public static const PAGE_CHANGE:String = "pageChange";
		public static const ITEM_CLICK:String = "itemClick";

		// Constructor:
		public function TileBox() {
			super();
			layoutObject.target = this;
			tabEnabled = true;
			//itemRenderer = new ClassFactory(TileBoxItemRenderer);
			// Set default sizes.
			setRowHeight(50);
			setColumnWidth(50);
		}

		// Fields:
		// =======
		mx_internal var layoutObject:CanvasLayout = new CanvasLayout();
		protected var contentList:ArrayCollection = new ArrayCollection();
		protected var defaultColumnCount:int = 4;
		protected var defaultRowCount:int = 4;
		protected var explicitColumnCount:int = -1;
		protected var explicitColumnWidth:Number;
		protected var explicitRowCount:int = -1;
		protected var explicitRowHeight:Number;
		protected var itemsSizeChanged:Boolean;
		mx_internal var bSelectionChanged:Boolean;
		mx_internal var bSelectedIndexChanged:Boolean;
		private var bSelectedItemChanged:Boolean;
		private var _invalidateSize:Boolean;
		private var _invalidateDisplayList:Boolean;
		private var _suspendLayout:Boolean;

		// Properties:
		// ===========
		
		private var _direction:String = BoxDirection.VERTICAL;
		
	    [Bindable("directionChanged")]
	    [Inspectable(category="General", enumeration="vertical,horizontal", defaultValue="vertical")]
		public function get direction(): String { return _direction; }
		public function set direction(value:String): void {
			_direction = value;
			//_invalidateSize = true;
			//_invalidateDisplayList = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("directionChanged"));
		}
		
		
		
		private var _itemRenderer:IFactory;
		
		[Inspectable(category="Data")]
		public function get itemRenderer(): IFactory { return _itemRenderer; }
		public function set itemRenderer(value:IFactory): void {
			/*if(value) _itemRenderer = value;
			else _itemRenderer = itemRenderer = new ClassFactory(TileBoxItemRenderer);*/
			_itemRenderer = value;
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
			event.kind = CollectionEventKind.RESET;
			collectionChangeHandler(event);
			//_invalidateSize = true;
			//_invalidateDisplayList = true;
			//invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("itemRendererChanged"));
		}
		
		
		
		public var _dataProvider:ArrayCollection = new ArrayCollection();
		
		[Bindable("collectionChange")]
		[Inspectable(category="Data", defaultValue="undefined")]
		public function get dataProvider(): Object { return _dataProvider; }
		public function set dataProvider(value:Object): void {
			if(_dataProvider && _dataProvider is ArrayCollection) {
				_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false);
			}
			if(value is ArrayCollection) {
				_dataProvider = ArrayCollection(value);
			} else if(value is Array) {
				_dataProvider = new ArrayCollection(value as Array);
			} else {
				var tmp:Array = [];
				if(value != null) tmp[tmp.length] = value;
				_dataProvider = new ArrayCollection(tmp);
			}
			_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,0,true);
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
			event.kind = CollectionEventKind.RESET;
			collectionChangeHandler(event);
			//_invalidateSize = true;
			//_invalidateDisplayList = true;
			//invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(event);
		}
		
		
		
		private var _labelField:String = "label";
		
		[Bindable("labelFieldChanged")]
		[Inspectable(category="Data", defaultValue="label")]
		public function get labelField(): String { return _labelField; }
		public function set labelField(value:String): void {
			_labelField = value;
			//_invalidateSize = true;
			//_invalidateDisplayList = true;
			//invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("labelFieldChanged"));
		}
		
		
		
		private var _selectedItem:Object;
		
		[Bindable]
		public function get selectedItem():Object {
			return _selectedItem;
		}
		public function set selectedItem(value:Object):void {
			_selectedItem = value;
		}
		
		
		private var _selectedIndex:int = -1;
		
		[Bindable]
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void {
			_selectedIndex = value;
		}
		
		
/*		private var _data:Object;
		[Bindable("dataChange")]
		[Inspectable(environment="none")]
		override public function get data(): Object { return _data; }
		override public function set data(value:Object): void {
			_data = value;
			if(_listData && _listData is DataGridListData) {
				selectedItem = _data[DataGridListData(_listData).dataField];
			} else if(_listData is ListData && ListData(_listData).labelField in _data) {
				selectedItem = _data[ListData(_listData).labelField];
			} else {
				selectedItem = _data;
			}
			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}*/
		
		
		
		private var _listData:BaseListData;
		
		[Bindable("dataChange")]
		[Inspectable(environment="none")]
		public function get listData(): BaseListData { return _listData; }
		public function set listData(value:BaseListData): void {
			_listData = value;
		}
		
		
		
		private var _rowCount:int = -1;
		private var rowCountChanged:Boolean = true;
		
		[Bindable("rowCountChanged")]
		public function get rowCount(): int { return _rowCount; }
		public function set rowCount(value:int): void {
			explicitRowCount = value;
			if(_rowCount != value) {
				setRowCount(value);
				//_invalidateSize = true;
				//_invalidateDisplayList = true;
				//invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
				dispatchEvent(new Event("rowCountChanged"));
			}
		}
		
		
		
		private var _columnCount:int = -1;
		private var columnCountChanged:Boolean = true;
		
		[Bindable("columnCountChanged")]
		public function get columnCount(): int { return _columnCount; }
		public function set columnCount(value:int): void {
			explicitColumnCount = value;
			if(_columnCount != value) {
				setColumnCount(value);
				//_invalidateSize = true;
				//_invalidateDisplayList = true;
				//invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
				dispatchEvent(new Event("columnCountChanged"));
			}
		}
		
		
		
		private var _columnWidth:Number;
		private var columnWidthChanged:Boolean = false;
		
		[Bindable("columnWidthChanged")]
		public function get columnWidth(): Number { return _columnWidth; }
		public function set columnWidth(value:Number): void {
			explicitColumnWidth = value;
			if(_columnWidth != value) {
				setColumnWidth(value);
				//_invalidateSize = true;
				//_invalidateDisplayList = true;
				//invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
				dispatchEvent(new Event("columnWidthChanged"));
			}
		}
		
		
		
		private var _rowHeight:Number;
		private var rowHeightChanged:Boolean = false;
		
		[Bindable("rowHeightChanged")]
		[Inspectable(category="General")]
		public function get rowHeight(): Number { return _rowHeight; }
		public function set rowHeight(value:Number): void {
			explicitRowHeight = value;
			if(_rowHeight != value) {
				setRowHeight(value);
				//_invalidateSize = true;
				//_invalidateDisplayList = true;
				//invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
				dispatchEvent(new Event("rowHeightChanged"));
			}
		}
		
		
		
		private var _selectable:Boolean = true;
		
		[Bindable]
		[Inspectable(defaultValue="true")]
		public function get selectable(): Boolean { return _selectable; }
		public function set selectable(value:Boolean): void {
			_selectable = value;
		}
		
		
		
/*		mx_internal var _selectedIndex:int = -1;
		[Bindable("change")]
		[Bindable("valueCommit")]
		[Inspectable(category="General", defaultValue="-1")]
		public function get selectedIndex(): int { return _selectedIndex; }
		public function set selectedIndex(value:int): void {
			if(!_dataProvider || _dataProvider.length == 0) {
				_selectedIndex = value;
				bSelectionChanged = true;
				bSelectedIndexChanged = true;
				invalidateDisplayList();
				return;
			}
			commitSelectedIndex(value);
		}*/
/*		private var _selectedItem:Object;
		[Bindable("change")]
		[Bindable("valueCommit")]
		[Inspectable(environment="none")]
		public function get selectedItem(): Object { return _selectedItem; }
		public function set selectedItem(data:Object): void {
			if(!_dataProvider || _dataProvider.length == 0) {
				_selectedItem = data;
				bSelectedItemChanged = true;
				bSelectionChanged = true;
				invalidateDisplayList();
				return;
			}
			commitSelectedItem(data);
		}*/

		// Paging:
		// =======
		
		private var _paging:Boolean = true;
		
		[Bindable("pagingChange")]
		[Inspectable(defaultValue="true")]
		public function get paging(): Boolean { return _paging; }
		public function set paging(value:Boolean): void {
			_paging = value;
			//_invalidateSize = true;
			//_invalidateDisplayList = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("pagingChange"));
		}
		
		
		private var _currentPage:int = 0;
		private var _pageChanged:Boolean;
		
		[Bindable("pageChange")]
		public function get currentPage(): int { return _currentPage; }
		public function set currentPage(value:int): void {
			_currentPage = (value > 0) ? value : 0;
			_pageChanged = true;
			//_invalidateDisplayList = true;
			//invalidateProperties();
			invalidateDisplayList();
		}
		
		
		private var _pageCount:int = 1;
		
		[Bindable("pageCountChange")]
		public function get pageCount(): int { return _pageCount; }
		private function setPageCount(value:int): void {
			_pageCount = (value > 0) ? value : 1;
			dispatchEvent(new Event("pageCountChange"));
		}
		
		
		private var _maxItemCount:int = 1;
		
		[Bindable("maxItemCountChange")]
		public function get maxItemCount(): int { return _maxItemCount; }
		private function setMaxItemCount(value:int): void {
			if(_maxItemCount == value) return;
			_maxItemCount = value;
			dispatchEvent(new Event("maxItemCountChange"));
		}
		
		
		private var _itemCount:int = 0;
		
		[Bindable("itemCountChange")]
		public function get itemCount(): int { return _itemCount; }
		private function setItemCount(value:int): void {
			_itemCount = value;
			dispatchEvent(new Event("itemCountChange"));
		}
		
		
		[Bindable("scrollingChanged")]
		public function get isScrolling(): Boolean {
			return (_isScrollingVertical || _isScrollingHorizontal);
		}
		
		
		
		
		private var _isScrollingVertical:Boolean;
		
		[Bindable("scrollingChanged")]
		public function get isScrollingVertical(): Boolean { return _isScrollingVertical; }
		private function setIsScrollingVertical(value:Boolean): void {
			if(_isScrollingVertical == value) return
			_isScrollingVertical = value;
			dispatchEvent(new Event("scrollingChanged"));
		}
		
		
		
		private var _isScrollingHorizontal:Boolean;
		
		[Bindable("scrollingChanged")]
		public function get isScrollingHorizontal(): Boolean { return _isScrollingHorizontal; }
		private function setIsScrollingHorizontal(value:Boolean): void {
			if(_isScrollingHorizontal == value) return
			_isScrollingHorizontal = value;
			dispatchEvent(new Event("scrollingChanged"));
		}
		
		
		
		private var _caching:Boolean = false;
		
		[Bindable("cachingChange")]
		[Inspectable(defaultValue="false")]
		public function get caching(): Boolean { return _caching; }
		public function set caching(value:Boolean): void {
			_caching = value;
			//_invalidateDisplayList = true;
			invalidateProperties();
			invalidateDisplayList();
			dispatchEvent(new Event("cachingChange"));
		}
		
		public function get constraintColumns(): Array { return []; }
		public function set constraintColumns(value:Array): void {}
		
		public function get constraintRows(): Array { return []; }
		public function set constraintRows(value:Array): void {}
		
		
		// Properties Helper Methods:
		// ==========================
		
		private function setRowCount(value:int): void { _rowCount = value; }
		private function setRowHeight(value:Number): void { _rowHeight = value; }
		private function setColumnCount(value:int): void { _columnCount = value; }
		private function setColumnWidth(value:Number): void { _columnWidth = value; }
		
		
/*		mx_internal function commitSelectedIndex(value:int): void {
		}*/
/*		private function commitSelectedItem(data:Object,clearFirst:Boolean=true): void {
		}*/
		
		public function get startIndex():int {
			if(currentPage == 0)
				return 1;
			else
				return (currentPage * maxItemCount) + 1;
		}
		
		public function get endIndex():int {
			/*if(currentPage == 0)
				return 0;
			else*/
				return int((currentPage * maxItemCount) + numChildren);
		}
		
		public function get total():int {
			return int(dataProvider.length);
		}
		
		
		public function firstPage(): void {
			currentPage = 0;
		}
		public function lastPage(): void {
			currentPage = 999;
		}
		public function nextPage(): void {
			currentPage++;
		}
		public function previousPage(): void {
			if(currentPage > 0) currentPage--;
		}
		public function setPage(page:int): void {
			currentPage = (page >= 0) ? page : 0;
		}

		// Overriden Methods:
		// ==================
		override protected function createChildren(): void {
			super.createChildren();
			contentList = new ArrayCollection();
		}
		override protected function commitProperties(): void {
			super.commitProperties();
			/*if(_invalidateSize) {
				invalidateSize();
				_invalidateSize = false;
			}
			if(_invalidateDisplayList) {
				invalidateDisplayList();
				_invalidateDisplayList = false;
			}*/
			if(_paging) {
				horizontalScrollPolicy = ScrollPolicy.OFF;
				verticalScrollPolicy = ScrollPolicy.OFF;
			} else {
				switch(_direction) {
					case BoxDirection.HORIZONTAL: horizontalScrollPolicy = ScrollPolicy.AUTO;
												  verticalScrollPolicy = ScrollPolicy.OFF; break;
					case BoxDirection.VERTICAL: horizontalScrollPolicy = ScrollPolicy.OFF;
												verticalScrollPolicy = ScrollPolicy.AUTO; break;
				}
			}
		}
		override public function styleChanged(styleProp:String): void {
			super.styleChanged(styleProp);
			switch(styleProp) {
				case "paddingLeft":
				case "paddingRight":
				case "paddingTop":
				case "paddingBottom":
				case "horizontalGap":
				case "verticalGap":
					invalidateSize();
					invalidateDisplayList();
			}
		}
		override protected function measure(): void {
			super.measure();
			layoutObject.measure();
			if(numChildren == 0 && _dataProvider.length > 0) {
				invalidateSize();
			} else {
				var pLeft:Number = getStyle('paddingLeft');
				var pRight:Number = getStyle('paddingRight');
				var pTop:Number = getStyle('paddingTop');
				var pBottom:Number = getStyle('paddingBottom');
				var gHorizontal:Number = getStyle('horizontalGap');
				var gVertical:Number = getStyle('verticalGap');
				var i:int, item:IListItemRenderer;
				var _w:Number, _h:Number;
				calculateColumnWidth(unscaledWidth);
				calculateRowHeight(unscaledHeight);
				if(direction == BoxDirection.VERTICAL) {
					if(!isNaN(explicitWidth)) {
						measuredMinWidth = explicitWidth;
					} else if(!isNaN(percentWidth) && parent) {
						//var parentPaddingLeft:Number = Number(UIComponent(parent).getStyle('paddingLeft'));
						//var parentPaddingRight:Number = Number(UIComponent(parent).getStyle('paddingRight'));
						//measuredMinWidth = parent.width - parentPaddingLeft - parentPaddingRight - x;
						return;
					} else if(explicitColumnCount > 0) {
						measuredMinWidth = pLeft + pRight + (_columnWidth * _columnCount) + (gHorizontal * (_columnCount - 1));
					} else {
						measuredMinWidth = measuredWidth;
					}
				} else if(direction == BoxDirection.HORIZONTAL) {
					if(!isNaN(explicitHeight)) {
						measuredMinHeight = explicitHeight;
					} else if(!isNaN(percentWidth) && parent) {
						//var parentPaddingTop:Number = Number(UIComponent(parent).getStyle('paddingTop'));
						//var parentPaddingBottom:Number = Number(UIComponent(parent).getStyle('paddingBottom'));
						//measuredMinHeight = parent.height - parentPaddingTop - parentPaddingBottom - y;
						return;
					} else if(explicitRowCount > 0) {
						measuredMinHeight = pTop + pBottom + (_rowHeight * _rowCount) + (gVertical * (_rowCount - 1));
					} else {
						measuredMinHeight = measuredHeight;
					}
				}
				if(!isNaN(explicitMinWidth)) measuredMinWidth = Math.max(measuredMinWidth,explicitMinWidth);
				if(!isNaN(explicitMaxWidth)) measuredMinWidth = Math.min(measuredMinWidth,explicitMaxWidth);
				if(!isNaN(explicitMinHeight)) measuredMinHeight = Math.max(measuredMinHeight,explicitMinWidth);
				if(!isNaN(explicitMaxHeight)) measuredMinHeight = Math.min(measuredMinHeight,explicitMaxHeight);
				measuredWidth = measuredMinWidth;
				measuredHeight = measuredMinHeight;
			}
		}
		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number): void {
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			layoutObject.updateDisplayList(unscaledWidth,unscaledHeight);
			if(_suspendLayout) return;
			var pLeft:Number = getStyle('paddingLeft');
			var pRight:Number = getStyle('paddingRight');
			var pTop:Number = getStyle('paddingTop');
			var pBottom:Number = getStyle('paddingBottom');
			var gHorizontal:Number = getStyle('horizontalGap');
			var gVertical:Number = getStyle('verticalGap');
			var i:int, index:int, item:IListItemRenderer, itemData:Object;
			var items:ArrayCollection = new ArrayCollection();
			var itemsData:ArrayCollection = new ArrayCollection();
			var _c:int, _r:int;
			if(paging) {
				// Calculate page data:
				setMaxItemCount(getMaxPageItems());
				if(maxItemCount <= 0) return;
				// Adjust currentPage before pageCount (to prevent that currentPage can be larger than pageCount on pageCountChange Event).
				var pCount:int = Math.ceil(_dataProvider.length / maxItemCount);
				if(pCount <= 0) pCount = 1;
				if(_currentPage > pCount - 1) {
					_pageChanged = true;
					_currentPage = pCount - 1;
				}
				setPageCount(pCount);
				var firstPageIndex:int = _currentPage * maxItemCount;
				var lastPageIndex:int = firstPageIndex + maxItemCount - 1;
				if(lastPageIndex > _dataProvider.length - 1) lastPageIndex = _dataProvider.length - 1;
				// Manage items when not caching:
				if(!caching) {
					index = 0;
					// Add new and re-arrage existing items to display:
					for(i = firstPageIndex; i <= lastPageIndex; i++) {
						itemData = _dataProvider.getItemAt(i);
						item = getItemByData(itemData);
						if(item) {
							var j:int = contentList.getItemIndex(item);
							if(j != index) {
								contentList.removeItemAt(j);
								contentList.addItemAt(item,index);
							} else {
								item.data = null;
								item.data = itemData;
							}
						} else {
							item = itemRenderer.newInstance();
							item.addEventListener("click",onItemClick);
							item.data = itemData;
							if(item is TileBoxItemBase){
								(item as TileBoxItemBase).parentList = this;
							}
							contentList.addItemAt(item,index);
						}
						index++;
					}
					// Remove items not to display:
					for(i = contentList.length - 1; i > index - 1; i--) {
						item = IListItemRenderer(contentList.getItemAt(i));
						disposeItem(item);
						contentList.removeItemAt(i);
					}
				
				// Set items size, position and data on current page:
					for(i = 0; i < contentList.length; i++) {
						item = IListItemRenderer(contentList.getItemAt(i));
						if(direction == BoxDirection.VERTICAL) {
							_c = (i >= _columnCount) ? (i % _columnCount) : i;
							_r = Math.floor(i / _columnCount);
						} else if(direction == BoxDirection.HORIZONTAL) {
							_c = Math.floor(i / _rowCount);
							_r = (i >= _rowCount) ? (i % _rowCount) : i;
						}
						item.move(pLeft + (_c * (_columnWidth + gHorizontal)),pTop + (_r * (_rowHeight + gVertical)));
						item.setActualSize(_columnWidth,_rowHeight);
						items.addItem(item);
						itemsData.addItem( { index:i, item:item, column:_c, row:_r } );
					}
				} 
				else {
					// Set items size, position and data on current page:
					for(i = firstPageIndex; i <= lastPageIndex; i++) {
						item = IListItemRenderer(contentList.getItemAt(i));
						if(direction == BoxDirection.VERTICAL) {
							_c = (i >= _columnCount) ? (i % _columnCount) : i;
							_r = Math.floor(i / _columnCount) - (_currentPage * (maxItemCount / _columnCount));
						} else if(direction == BoxDirection.HORIZONTAL) {
							_c = Math.floor(i / _rowCount) - (_currentPage * (maxItemCount / _rowCount));
							_r = (i >= _rowCount) ? (i % _rowCount) : i;
						}
						item.move(pLeft + (_c * (_columnWidth + gHorizontal)),pTop + (_r * (_rowHeight + gVertical)));
						item.setActualSize(_columnWidth,_rowHeight);
						items.addItem(item);
						itemsData.addItem( { index:i, item:item, column:_c, row:_r } );
					}
				}
			} else {
				setMaxItemCount(contentList.length);
				setPageCount(1);
				if(checkScrolling()) {
					if(verticalScrollBar) calculateColumnWidth(unscaledWidth - verticalScrollBar.width);
					else calculateColumnWidth(unscaledWidth - 16);
					if(horizontalScrollBar) calculateRowHeight(unscaledWidth - horizontalScrollBar.height);
					else calculateRowHeight(unscaledWidth - 16);
				}
				for(i = 0; i < contentList.length; i++) {
					item = IListItemRenderer(contentList.getItemAt(i));
					if(direction == BoxDirection.VERTICAL) {
						_c = (i >= _columnCount) ? (i % _columnCount) : i;
						_r = Math.floor(i / _columnCount) - (_currentPage * (maxItemCount / _columnCount));
					} else if(direction == BoxDirection.HORIZONTAL) {
						_c = Math.floor(i / _rowCount) - (_currentPage * (maxItemCount / _rowCount));
						_r = (i >= _rowCount) ? (i % _rowCount) : i;
					}
					item.move(pLeft + (_c * (_columnWidth + gHorizontal)),pTop + (_r * (_rowHeight + gVertical)));
					item.setActualSize(_columnWidth,_rowHeight);
					items.addItem(item);
					itemsData.addItem( { index:i, item:item, column:_c, row:_r } );
				}
			}
			// Add items as childs to page:
			for(i = numChildren - 1; i >= 0 ; i--) {
				item = IListItemRenderer(getChildAt(i));
				if(!items.contains(item)) removeChild(DisplayObject(item));
			}
			for(i = 0; i < items.length; i++) {
				item = IListItemRenderer(items.getItemAt(i));
				if(!contains(DisplayObject(item))) addChild(DisplayObject(item));
				itemData = itemsData.getItemAt(i);
				setItemData(itemData.index,itemData.item,itemData.column,itemData.row);
			}
			// Count items on page changed ?
			if(itemCount != numChildren) setItemCount(numChildren);
			// Page has changed ?
			if(_pageChanged) dispatchEvent(new Event("pageChange"));
		}

		// Event Handler Methods:
		// ======================
		protected function collectionChangeHandler(event:CollectionEvent): void {
			if(caching || !paging) {
				var i:int, item:IListItemRenderer, itemData:Object;
				if(event.kind == CollectionEventKind.ADD) {
					for(i = 0; i < _dataProvider.length; i++) {
						itemData = _dataProvider.getItemAt(i);
						item = getItemByData(itemData);
						if(!item) {
							item = itemRenderer.newInstance();
							item.addEventListener("click",onItemClick);
							item.data = itemData;
							contentList.addItemAt(item,i);
						}
					}
				} else if(event.kind == CollectionEventKind.REPLACE) {
					for(i = 0; i < _dataProvider.length; i++) {
						itemData = _dataProvider.getItemAt(i);
						item = getItemByData(itemData);
						if(!item) {
							disposeItem(contentList.getItemAt(i));
							item = itemRenderer.newInstance();
							item.addEventListener("click",onItemClick);
							item.data = itemData;
							contentList.setItemAt(item,i);
						}
					}
				} else if(event.kind == CollectionEventKind.REMOVE) {
					for(i = 0; i < contentList.length; i++) {
						item = IListItemRenderer(contentList.getItemAt(i));
						if(!_dataProvider.contains(item.data)) {
							disposeItem(item);
							contentList.removeItemAt(i);
						}
					}
				} else if(event.kind == CollectionEventKind.MOVE) {
					// Item in an ArrayCollection cannot be moved ???
				} else if(event.kind == CollectionEventKind.REFRESH) {
					for(i = 0; i < _dataProvider.length; i++) {
						itemData = _dataProvider.getItemAt(i);
						item = getItemByData(itemData);
						if(item) {
							var index:int = contentList.getItemIndex(item);
							if(index != i) {
								contentList.removeItemAt(index);
								contentList.addItemAt(item,i);
							} else {
								item.data = null;
								item.data = itemData;
							}
						} else {
							item = itemRenderer.newInstance();
							item.addEventListener("click",onItemClick);
							item.data = itemData;
							contentList.addItemAt(item,i);
						}
					}
					for(var j:int = contentList.length - 1; j >= i; j--) {
						disposeItem(contentList.getItemAt(j));
						contentList.removeItemAt(j);
					}
				} else if(event.kind == CollectionEventKind.RESET) {
					for(i = 0; i < contentList.length; i++) {
						disposeItem(contentList.getItemAt(i));
					}
					contentList.removeAll();
					removeAllChildren();
					for(i = 0; i < _dataProvider.length; i++) {
						item = itemRenderer.newInstance();
						item.data = _dataProvider.getItemAt(i);
						item.addEventListener("click",onItemClick);
						contentList.addItem(item);
					}
				}
			}
			invalidateDisplayList();
		}
		private function onItemClick(event:MouseEvent): void {
			var item:IListItemRenderer = IListItemRenderer(event.currentTarget);
			var label:String = isNaN(Number(item.data)) && item.data.hasOwnProperty(labelField) ? item.data[labelField] : String(item.data);
			var index:int = getChildIndex(DisplayObject(item));
			var relatedObject:InteractiveObject = InteractiveObject(item);
			var itemObj:Object = item.data;
			_selectedItem = item.data;
			_selectedIndex = index;
			var e:ItemClickEvent = new ItemClickEvent("itemClick",true,false,label,index,relatedObject,itemObj);
			dispatchEvent(e);
		}

		// Private Methods:
		// ================
		private function getItemByData(itemData:Object): IListItemRenderer {
			for(var i:int = 0; i < contentList.length; i++) {
				var item:IListItemRenderer = IListItemRenderer(contentList.getItemAt(i));
				if(item.data == itemData) return item;
			}
			return null;
		}
		private function disposeItem(obj:Object): void {
			var item:IListItemRenderer = IListItemRenderer(obj);
			item.removeEventListener("click",onItemClick);
			item.data = null;
			if(item is IDropInListItemRenderer) IDropInListItemRenderer(item).listData = null;
		}
		private function getMaxPageItems(): int {
			var pLeft:Number = getStyle('paddingLeft');
			var pRight:Number = getStyle('paddingRight');
			var pTop:Number = getStyle('paddingTop');
			var pBottom:Number = getStyle('paddingBottom');
			var gHorizontal:Number = getStyle('horizontalGap');
			var gVertical:Number = getStyle('verticalGap');
			var xW:int, yH:int;
			if(direction == BoxDirection.VERTICAL) {
				if(_columnCount > -1) xW = _columnCount;
				else xW = defaultColumnCount;
				yH = Math.floor((unscaledHeight - pTop - pBottom + gVertical) / (_rowHeight + gVertical));
			} else if(direction == BoxDirection.HORIZONTAL) {
				xW = Math.floor((unscaledWidth - pLeft - pRight + gHorizontal) / (_columnWidth + gHorizontal));
				if(_rowCount > -1) yH = _rowCount;
				else yH = defaultRowCount;
			}
			return (xW * yH);
		}
		private function setItemData(index:int,item:IListItemRenderer,columnIndex:int,rowIndex:int): void {
			if(caching) item.data = _dataProvider.getItemAt(index);
			else { var tmp:Object = item.data; item.data = null; item.data = tmp; }
			if(item is IDropInListItemRenderer) {
				var label:String = String(item.data[labelField]);
				var uid:String = UIDUtil.getUID(item);
				IDropInListItemRenderer(item).listData = new BaseListData(label,uid,this,rowIndex,columnIndex);
			}
		}
		private function calculateColumnWidth(unscaledWidth:Number): void {
			var pLeft:Number = getStyle('paddingLeft');
			var pRight:Number = getStyle('paddingRight');
			var pTop:Number = getStyle('paddingTop');
			var pBottom:Number = getStyle('paddingBottom');
			var gHorizontal:Number = getStyle('horizontalGap');
			var i:int, item:IListItemRenderer, _w:Number;
			if(!isNaN(explicitColumnWidth)) {
				setColumnWidth(explicitColumnWidth);
			} else if(!isNaN(percentWidth) || !isNaN(explicitWidth)) {
				_w = (unscaledWidth - pLeft - pRight - (gHorizontal * (columnCount - 1))) / columnCount;
				setColumnWidth(_w);
			} else {
				var wMax:Number = 0;
				for(i = 0; i < numChildren; i++) {
					item = IListItemRenderer(getChildAt(i));
					var wItem:Number = item.getExplicitOrMeasuredWidth();
					if(wItem > wMax) wMax = wItem;
				}
				setColumnWidth(wMax);
			}
		}
		private function calculateRowHeight(unscaledHeight:Number): void {
			var pLeft:Number = getStyle('paddingLeft');
			var pRight:Number = getStyle('paddingRight');
			var pTop:Number = getStyle('paddingTop');
			var pBottom:Number = getStyle('paddingBottom');
			var gVertical:Number = getStyle('verticalGap');
			var i:int, item:IListItemRenderer, _h:Number;
			if(!isNaN(explicitRowHeight)) {
				setRowHeight(explicitRowHeight);
			} else if(!isNaN(percentHeight) || !isNaN(explicitHeight)) {
				_h = (unscaledHeight - pTop - pBottom - (gVertical * (rowCount - 1))) / rowCount;
				setRowHeight(_h);
			} else {
				var hMax:Number = 0;
				for(i = 0; i < numChildren; i++) {
					item = IListItemRenderer(getChildAt(i));
					var hItem:Number = item.getExplicitOrMeasuredHeight();
					if(hItem > hMax) hMax = hItem;
				}
				setRowHeight(hMax);
			}
		}

		// Public Methods:
		// ===============
		private function checkScrolling(): Boolean {
			var pLeft:Number = getStyle('paddingLeft');
			var pRight:Number = getStyle('paddingRight');
			var pTop:Number = getStyle('paddingTop');
			var pBottom:Number = getStyle('paddingBottom');
			var gHorizontal:Number = getStyle('horizontalGap');
			var gVertical:Number = getStyle('verticalGap');
			var xW:int, yH:int;
			if(direction == BoxDirection.VERTICAL) {
				if((_rowHeight + gVertical) * contentList.length > (unscaledHeight - pTop - pBottom + gVertical)) {
					setIsScrollingVertical(true);
					return true;
				} else {
					setIsScrollingVertical(false);
				}
			} else if(direction == BoxDirection.HORIZONTAL) {
				if((_columnWidth + gHorizontal) * contentList.length > (unscaledWidth - pLeft - pRight + gHorizontal)) {
					setIsScrollingHorizontal(true);
					return true;
				} else {
					setIsScrollingHorizontal(false);
				}
			}
			return false;
		}
		public function suspendLayout(): void {
			_suspendLayout = true;
		}
		public function resumeLayout(redraw:Boolean=false): void {
			_suspendLayout = false;
			if(redraw) invalidateDisplayList();
		}

		// Highlighting and selection Methods:
		// ===================================
		public function isItemHighlighted(data:Object): Boolean {
			if(!data) return false;
			// When something is selected, the selection indicator overlays the highlighted indicator so we want
			// to draw as selected and not highlighted.
//			var isSelected:Boolean = highlightIndicator && (selectionLayer.getChildIndex(highlightIndicator) != selectionLayer.numChildren - 1)
//			if(data is String) return (data == highlightUID && !isSelected);
//			return itemToUID(data) == highlightUID && !isSelected;
			return false;
		}
		public function isItemSelected(data:Object): Boolean {
//			if(!data) return false;
//			if(data is String) return (selectedData[data] != undefined)
//			return selectedData[itemToUID(data)] != undefined;
			return false;
		}

		// Container to Box:
		// =================
		mx_internal function isVertical(): Boolean {
			return direction != BoxDirection.HORIZONTAL;
		}
		public function pixelsToPercent(pxl:Number): Number {
			var vertical:Boolean = isVertical();
			// Compute our total percent and total # pixels for that percent.
			var totalPerc:Number = 0;
			var totalSize:Number = 0;
			var n:int = numChildren;
			for(var i:int = 0; i < n ; i++) {
				var child:IUIComponent = IUIComponent(getChildAt(i));
				var size:Number = vertical ? child.height : child.width;
				var perc:Number = vertical ? child.percentHeight : child.percentWidth;
				if(!isNaN(perc)) {
					totalPerc += perc;
					totalSize += size;
				}
			}
			// Now if we found one let's compute the percent amount that we'd require for a given number of pixels.
			var p:Number = 100;
			if(totalSize != pxl) {
				// Now we want the ratio of pixels per percent to remain constant as we assume the a component
				// will consume them. So,
				//   (totalSize - pxl) / totalPerc = totalSize / (totalPerc + p)
				// where we solve for p.
				p = ((totalSize * totalPerc) / (totalSize - pxl)) - totalPerc;
			}
			return p;
		}

	}

}