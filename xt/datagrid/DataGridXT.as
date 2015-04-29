package xt.datagrid
{
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.listClasses.ListBase;
	import mx.core.FlexShape;
	import mx.core.FlexSprite;
	import mx.events.ListEvent;
	import mx.styles.StyleManager;
	
	[Event(name="dataProviderChange", type="flash.events.Event")]
	
	
	
	public class DataGridXT extends DataGrid {

		// Fields:
		//private var _emptyTextBox: HBox;
		//private var _emptyText: String = "";
		//private var rollOverRowData:Object = null;
		
		// Constructor:
		public function DataGridXT() {
			super();
			/*addEventListener("resize", onResize, false, 0.0, true);
			addEventListener("itemRollOver",onItemRollOver, false, 0.0, true);
			addEventListener("itemRollOut",onItemRollOut, false, 0.0, true);
			addEventListener("itemClick",onItemClick, false, 0.0, true);
			addEventListener("scroll", onScroll, false, 0.0, true);*/
		}

		// Properties:
		[arrayType("com.xt.DataGridRowCriterium")]
		private var _rowCriteria:Array = [];
        
        [Bindable]
        public function get rowCriteria(): Array {
        	return _rowCriteria;
        }
        public function set rowCriteria(value:Array): void {
        	_rowCriteria = value;
        }
        
        
        // store dataprovider in separate var for paging.
        
        private var _dataProvider:ArrayCollection;
        private var dataProviderChanged:Boolean = false;
        
		[Bindable]
		override public function set dataProvider(value:Object): void {
			var _selectedId:Object = selectedId;
			
			//super.dataProvider = value;
			
			if(value is ArrayCollection) {
				_dataProvider = value as ArrayCollection;
			}
			else if (value is Array) {
				_dataProvider = new ArrayCollection(value as Array);
			}
			else {
				_dataProvider = new ArrayCollection([value]);
			}
			
			/*if(collection == null) return;
			if(collection.length == 0 && _emptyText != "") addEmptyText(); else removeEmptyText();*/
			
			invalidateDisplayList();
			validateNow();
			
			if(_selectedId != '' && _selectedId != null) selectedId = _selectedId;
			
			dataProviderChanged = true;
			dispatchEvent(new Event('dataProviderChange'));
			invalidatePaging();
		}
		
		
		
		private var _pageLength:int = 0;
		private var pageLengthChanged:Boolean = false;
		
		/**
		 * items per page. if smaller than 0: default to 0
		 * to disable paging: set to 0
		 * */
		[Bindable]
		public function set pageLength(value:int):void {
			if(_pageLength != value){
				_pageLength = value;
				pageLengthChanged = true;
				invalidatePaging();
			}
		}
		public function get pageLength():int {
			return _pageLength;
		}
		
		
		
		private var _currentPage:int = 1;
		private var currentPageChanged:Boolean = false;
		
		/**
		 * current page, starting from 1
		 * */
		[Bindable]
		public function set currentPage(value:int):void {
			if(_currentPage != value){
				_currentPage = value;
				currentPageChanged = true;
				invalidatePaging();
			}
		}
		public function get currentPage():int {
			return _currentPage;
		}
		
		
		private var _pages:int = 1;
		
		/**
		 * total pages
		 * */
		[Bindable('pagesChanged')]
		public function get pages():int {
			return _pages;
		}
		
		
		
		protected function invalidatePaging():void {
			if(_dataProvider != null){
				if(dataProviderChanged || currentPageChanged || pageLengthChanged){
					
					// pagelength must be greather than 0 to page, else 1 page
					if(_pageLength > 0){
						
						// get number of pages
						_pages = int(Math.ceil(_dataProvider.source.length / _pageLength));
						
						// if currentpage is valid (datalength / pagelength)
						if(_currentPage <= _pages){
							
							_dataProvider.filterFunction = 
							function(item:Object):Boolean {
								// row visible if index between currentpage and currentpage x pagelength
								return (
									_dataProvider.getItemIndex(item) >= ((_currentPage - 1) * _pageLength)
									&&
									_dataProvider.getItemIndex(item) < (_currentPage * _pageLength)
								);
							}
							
						}
						else {
							_currentPage = 1;
						}
						
						_hasPreviousPage = _currentPage > 1;
						_hasNextPage = _currentPage < _pages;
						
					}
					else {
						_pageLength = 0;
						_pages = 1;
						_currentPage = 1;
						
						_hasPreviousPage = false;
						_hasNextPage = false;
						
						_dataProvider.filterFunction = null;
					}
					_dataProvider.refresh();
					
					dataProviderChanged = false;
					currentPageChanged = false;
					pageLengthChanged = false;
				}
				super.dataProvider = _dataProvider;
				dispatchEvent(new Event('pagesChanged'));
			}
		}
		
		/**
		 * select previous page (from current) if available
		 * */
		public function previousPage():void {
			if(_currentPage > 1){
				currentPage--;
			}
		}
		
		
		private var _hasPreviousPage:Boolean = false;
		
		/**
		 * indicates if there is a page available before the current page
		 * */
		[Bindable('pagesChanged')]
		public function get hasPreviousPage():Boolean {
			return _hasPreviousPage;
		}
		
		
		/**
		 * select next page (from current) if available
		 * */
		public function nextPage():void {
			if(_currentPage < _pages){
				currentPage++;
			}
		}
		
		private var _hasNextPage:Boolean = false;
		
		/**
		 * indicates if there is a page available after the current page
		 * */
		[Bindable('pagesChanged')]
		public function get hasNextPage():Boolean {
			return _hasNextPage;
		}
		
		
		
		/*public function get emptyText(): String { return _emptyText}
		public function set emptyText(value:String): void {
			_emptyText = value;
			if(collection == null) return;
			if(collection.length == 0 && value != "") addEmptyText(); else removeEmptyText();
		}
		
		
		public function get isScrollingHorizontal(): Boolean {
			var result:Boolean;
			var widthColSpace:int = width - 2;
			var widthCols:int;
			for(var i:int = 0; i<columns.length; i++) widthCols += columns[i].width;
			return (widthCols > widthColSpace);
		}
		
		public function get isScrollingVertical(): Boolean {
			var result:Boolean;
			var heightRowSpace:int = height - headerHeight - 2;
			var heightRows:int = dataProvider.length * rowHeight;
			return (heightRows > heightRowSpace);
		}
		
		// Event Handler Methods:
		private function onResize(event:Event = null): void {
			if(_emptyTextBox != null) _emptyTextBox.width = width - 8;
		}
		
		// Private Methods:
		private function addEmptyText(): void {
			if(_emptyTextBox == null) createEmptyText();
			updateEmptyText();
			_emptyTextBox.visible = true;
			if(contains(_emptyTextBox)) removeChild(_emptyTextBox);
			 addChild(_emptyTextBox);
		}
		
		private function removeEmptyText(): void {
			if(_emptyTextBox == null) return;
			_emptyTextBox.visible = false;
			if(contains(_emptyTextBox)) removeChild(_emptyTextBox);
		}
		
		private function createEmptyText(): void {
			_emptyTextBox = new HBox();
			_emptyTextBox.setStyle("verticalAlign","middle");
			var lbl:Label = new Label();
			//lbl.setStyle("fontWeight","bold");
			lbl.setStyle("fontStyle","italic");
			lbl.setStyle("fontSize",getStyle("fontSize"));
			_emptyTextBox.addChild(lbl)
		}
		
		private function updateEmptyText(): void {
			Label(_emptyTextBox.getChildAt(0)).text = _emptyText;
			_emptyTextBox.setStyle("backgroundColor",getStyle("alternatingItemColors")[0]);
			_emptyTextBox.x = 6;
			_emptyTextBox.y = headerHeight + 1;
			_emptyTextBox.width = width - 8;
			_emptyTextBox.height = rowHeight;
		}
		
		
		// Public Methods:
		public function showEmptyText(): void {
			if(collection.length == 0 && _emptyText != "") addEmptyText();
		}
		
		public function hideEmptyText(): void {
			if(_emptyTextBox != null) removeEmptyText();
		}
		
		
		// Overriden Methods:
        override protected function drawRowBackgrounds(): void {                    
            var rowBGs:Sprite = Sprite(listContent.getChildByName("rowBGs"));
            if(!rowBGs) {
                rowBGs = new FlexSprite();
                rowBGs.mouseEnabled = false;
                rowBGs.name = "rowBGs";
                listContent.addChildAt(rowBGs, 0);
            }
            var colors:Array = getStyle("alternatingItemColors");
            if(!colors || colors.length == 0) return;
            StyleManager.getColorNames(colors);
            var curRow: int = 0;
            //if(showHeaders) curRow++;
            var rowBackgroundColor: Object;
            var rowColor: Object;
            var rowFontStyle: Object;
            var rowFontWeight: Object;
            var rowCriterium: DataGridRowCriterium;
            var rowData:Object;
            var actualRow: int = verticalScrollPosition;
            var cellValue: Object = new Object;
            var i: int = 0;
            // loop through rows        
            while(curRow < listItems.length) {  
                rowBackgroundColor = colors[actualRow % colors.length];
				if(_rowCriteria.length != 0 && columnCount != 0 && actualRow < dataProvider.length) {          
                   	rowData = dataProvider.getItemAt(actualRow);
                    // loop backwards through rowCriteria for priority order
                    for(var rc:int = _rowCriteria.length - 1; rc>=0; rc--) {
                        rowCriterium = _rowCriteria[rc];
                         // match condition && value for custom row colors
                        if(rowCriterium.compare(rowData)) {
                       		if(rowCriterium.backgroundColor != null) rowBackgroundColor = rowCriterium.backgroundColor;
                       	/*	if(rowCriterium.color != null) rowColor = rowCriterium.color;
                       		if(rowCriterium.fontStyle != null) rowFontStyle = rowCriterium.fontStyle;
                       		if(rowCriterium.fontWeight != null) rowFontWeight = rowCriterium.fontWeight;* /
                        }
                    }
                }
                drawRowBackground(rowBGs, i++, rowInfo[curRow].y, rowInfo[curRow].height, uint(rowBackgroundColor), actualRow);
                curRow++;
                actualRow++;
            }
            while(rowBGs.numChildren > i){
            	rowBGs.removeChildAt(rowBGs.numChildren - 1);
            }
           
        	super.invalidateDisplayList();
        }    
		
		
		// ============================================================
		// BUG: text-rollover-color & text-selected-color  DON'T  WORK.
		// ============================================================
		private function onItemRollOver(event:ListEvent): void {
			var color:Object = getStyle("textRollOverColor");
			if(color) setRowTextColor(event.itemRenderer,color);
		}
		
		private function onItemRollOut(event:ListEvent): void {
			var color:Object = getStyle("color");
			if(color) setRowTextColor(event.itemRenderer,color);
		}
		
		private function onItemClick(event:ListEvent): void {
			var color:Object = getStyle("textSelectedColor");
			if(color) {
				var c:Object = getStyle("color");
				if(c && color != c) {
					setStyle("color",null);
					setStyle("color",c);
					//setAllRowsTextColor(c);
				}
				setRowTextColor(event.itemRenderer,color);
			}
		}
		
		private function onScroll(event:Event = null): void {
			var color:Object = getStyle("color");
			if(color) {
				setStyle("color",null);
				setStyle("color",color);
				//setAllRowsTextColor(color);
			}
		}
		
		private function setRowTextColor(currentItem:IListItemRenderer,color:Object): void {
			for(var i:int = 0; i < listItems.length; i++) {
				var ac:ArrayCollection = new ArrayCollection(listItems[i]);
				if(ac.contains(currentItem)) {
					for(var j:int = 0; j < ac.length; j++) {
						Object(ac.getItemAt(j)).setStyle("color",color);
					}
					break;
				}
			}
		}
		
		private function setAllRowsTextColor(color:Object): void {
			for(var i:int = 0; i < listItems.length; i++) {
				for(var j:int = 0; j < listItems[i].length; j++) {
					var rdr:Object = Object(listItems[i][j]);
					rdr.setStyle("color",null);
					rdr.setStyle("color",color);
				}
			}
		}*/
		
		/**
		 * set to true and the 'color'field (as uint) in the dataprovider's object will be set as background colour for that row
		 * */
		[Bindable] public var useCustomBackgrounds:Boolean = false;
		
		/**
		 * function to calculate the row backgroundcolor.
		 * declare as function(rowData:Object, defaultColor:uint, rowIndex:int):uint
		 * */
		public var rowColourFunction:Function;
		
		override protected function drawRowBackground(s:Sprite, rowIndex:int, y:Number, height:Number, color:uint, dataIndex:int):void {
			if(useCustomBackgrounds || rowColourFunction != null){
				var contentHolder:Object = /*ListBaseContentHolder*/(s.parent);
				var background:Shape;
				
				if(rowIndex < s.numChildren) {
					background = Shape(s.getChildAt(rowIndex));
				}
				else {
					background = new FlexShape();
					background.name = "background";
					s.addChild(background);
				}
				
				background.y = y;
				
				// Height is usually as tall is the items in the row, but not if
				// it would extend below the bottom of listContent
				var height:Number = Math.min(height, contentHolder.height - y);
				
				var g:Graphics = background.graphics;
				g.clear();
				
				var color2:uint;
				var color2Set:Boolean = false;
				
				if(dataProvider != null && dataIndex < dataProvider.length){
					if(rowColourFunction != null){
						color2 = rowColourFunction(dataProvider.getItemAt(dataIndex), color, dataIndex);
						color2Set = true;
					}
					else if(_rowCriteria != null){
						for(var i:int=0; i<_rowCriteria.length; i++){
							if((_rowCriteria[i] as DataGridRowCriterium).compare( dataProvider.getItemAt(dataIndex) )){
								color2 = uint((_rowCriteria[i] as DataGridRowCriterium).backgroundColor);
								color2Set = true;
								break;
							}
						}
					}
					
					if(!color2Set){
						if(dataProvider.getItemAt(dataIndex).hasOwnProperty('color') && dataProvider.getItemAt(dataIndex).color is uint)
						{
							color2 = dataProvider.getItemAt(dataIndex).color;
						}
						else {
							color2 = color;
						}
					}
				}
				else {
					color2 = color;
				}
				
				g.beginFill(color2, getStyle("backgroundAlpha"));
				g.drawRect(0, 0, contentHolder.width, height);
				g.endFill();
			}
			else {
				super.drawRowBackground(s, rowIndex, y, height, color, dataIndex);
			}
		}
		
		// ============================================================
		// ============================================================
		
		
		
		/**
		 * toggle: 
		 * if true: change selectedItems with single click on a row, acts like if you would hold down control
		 * 			shift key is being ignored
		 * toggleOnDataField:	if you click a column with 'dataField' the same as 
		 * 						toggleOnDataField, this reacts like when toggle is set to true.
		 */
		[Bindable] public var toggle:Boolean = false;
		[Bindable] public var toggleOnDataField:String = '';
		
		override protected function selectItem(item:IListItemRenderer, shiftKey:Boolean, ctrlKey:Boolean, transition:Boolean=true):Boolean
		{
			var columnToggle:Boolean = false;	//	toggle row based on dataField of the current column
			
			if(
				Object(item).hasOwnProperty('listData')
				&& Object(item)['listData'].hasOwnProperty('dataField')
				&& Object(item)['listData']['dataField'] == toggleOnDataField
			){
				columnToggle = true;
			}
			
			/*if(Object(item).hasOwnProperty('className') && item['className'] == toggleOnClassName){
				columnToggle = true;
			}*/
			
			if(toggle || columnToggle){
				// when toggled: shift-key = false and ctrl-key = true
				// shift: because else the grid selects a range between 2 rows: undesired
				// ctrl:  functionality of the grid to (de)select multiple items, now happens automatically
				return super.selectItem(item, false, true, transition);
			}
			else {
				// default behaviour
				return super.selectItem(item, shiftKey, ctrlKey, transition);
			}
		}
		
		
		
		/**
		 * Force grid to scroll to index, even if the row is visible.
		 * default, the grid only scrolls when the row to scroll to is invisible
		 */
		public function scrollToIndexForced(index:int):void
	    {
	    	if(index >= 0)
	    	{
				var newVPos:int;
				
				newVPos = Math.min(index, maxVerticalScrollPosition);
				verticalScrollPosition = newVPos;
	    	}
	    	
	    }
		
		
		
		/**
		 * Set selected item through id value. requires 'idField' to be set
		 */
		public var idField:String = '';
		
		[Bindable("change")]
	    [Bindable("collectionChange")]
	    [Bindable("valueCommit")]
	    [Bindable]
		public function set selectedId(value:Object):void {
			if(idField == ''){
				throw new Error("Cannot set "+id+".selectedId, because property 'idField' is not set");
				return;
			}
			// callLater's to prevent a dataProvider change to clear the selectedId even when selectedId is a valid item
			callLater(callLater,[setSelectedId,[value]]);
		}
		public function get selectedId():Object {
			return selectedItem==null ? '' : selectedItem[idField];
		}
		
		protected function setSelectedId(value:Object):void {
			for(var i:int=0; i<dataProvider.length; i++){
				if(dataProvider[i] != null && dataProvider[i].hasOwnProperty(idField) && value == dataProvider[i][idField]){
					selectedIndex = i;
					invalidateDisplayList();
					validateNow();
					return;
				}
			}
			selectedIndex = -1;
			invalidateDisplayList();
			validateNow();
		}
		
		
		
	}
	
}