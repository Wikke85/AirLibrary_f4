package xt.datagrid
{
	
	import com.events.FilterEvent;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.controls.ComboBox;
	import mx.controls.DataGrid;
	import mx.controls.Spacer;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.DataGridEvent;
	import mx.events.ListEvent;
	import mx.events.ResizeEvent;
	
	[Event(name="filterSelect", type="com.events.FilterEvent")]
	
	public class DataGridFilter extends HBox
	{
		public function DataGridFilter()
		{
			super();
			
			setStyle('horizontalGap', 1);
		}
		
		
		/**
		 * object containing the different columns with their value to filter on
		 * */
		public var allFilterData:Object = {};
		
		
		/**
		 * the datagrid to listen to.
		 * */
		private var _source:DataGrid;
		
		[Bindable]
		public function set source(dataGrid:DataGrid):void {
			_source = dataGrid;
			columns = _source.columns;
			//setColumnsWidth();
			_source.addEventListener(ResizeEvent.RESIZE, source_onResize, false, 0, true);
			_source.addEventListener(DataGridEvent.COLUMN_STRETCH, source_onColumnStretch, false, 0, true);
		}
		public function get source():DataGrid {
			return _source;
		}
		
		
		private function source_onResize(event:ResizeEvent):void {
			setColumnsWidth();
		}
		private function source_onColumnStretch(event:DataGridEvent):void {
			setColumnsWidth();
		}
		
		
		// set all columns the same width as the source's columns width
		public function setColumnsWidth():void {
			var s_cols:Array = _source.columns;
			
			for(var i:int=0; i<s_cols.length; i++){
				if(numChildren > i){
					getChildAt(i).width = s_cols[i].width;
					
					if(getChildAt(i) is ComboBox){
						ComboBox(getChildAt(i)).dropdownWidth = Math.max(ComboBox(getChildAt(i)).width, 150);
					}
					
				}
			}
			
			// extra Column For VerticalScrollBar
			//getChildAt(numChildren-1).width = 15;
			
		}
		
		
		/**
		 * dataProvider from datagrid
		 * the filtering doesnt happen on this object,
		 * instead, listen to FilterEvent.FILTER_SELECT to see which filter was changed
		 * 
		 * dataprovider is only used to populate the comboboxes
		 * */
		public function set dataProvider(value:Object):void {
			
			var data:Object = {};
			allFilterData = {};
			
			// only filter when data is in array (otherwise, it's a bit useless)
			if(value is Array || value is ArrayCollection){
				
				// when columns arent initiated yet, call later
				if(_columns == null || _columns.length == 0){
					callLater(function():void { dataProvider = value; });
				}
				else /*if(value.length > 0)*/ {
					
					// for each column ...
					for(var i:int=0; i<_columns.length; i++){
						
						var col:DataGridColumn = DataGridColumn(_columns[i]);
						
						// if column is set to filter
						if(col is DataGridColumnXT && DataGridColumnXT(col).calc == DataGridColumnXT.CALC_FILTER 
						&& Object(getChildAt(i)).id == 'cbx' + col.dataField 
						){
							
							// reset combobox
							ComboBox(getChildAt(i)).selectedIndex = -1;
							ComboBox(getChildAt(i)).dataProvider = new ArrayCollection([{label: _defaultFilter}]);
							
							// ... and for each record corresponding to the current column
							for(var j:int=0; j<value.length; j++){
								
								// if ignoreFunction is not set, or it is and returns false: continue with adding
								if(DataGridColumnXT(col).ignoreFunction == null || DataGridColumnXT(col).ignoreFunction(value[j], col) == false ){
									
									var alreadyIn:Boolean = false;
									
									// start from 1, because element 0 is the default filter value
									for(var d:int=1; d<ComboBox(getChildAt(i)).dataProvider.length; d++){
										// when the current dataprovider item.element is already in it's corresponding combobox.dataprovider,
										// mark as 'already in dataprovider'
										if( ComboBox(getChildAt(i)).dataProvider[d].label == value[j][col.dataField] ){
											alreadyIn = true;
											ComboBox(getChildAt(i)).dataProvider[d].quantity++;
											break;
										}
									}
									
									// finally, add the item if this isn't already been done
									if(!alreadyIn){
										ArrayCollection(ComboBox(getChildAt(i)).dataProvider).addItem({
											label: 		value[j][col.dataField],
											quantity:	1
										});
									}
									
								}
							}
							
						}
					}
					doDisableUnaffectedFilters();
					
				}
			}
		}
		
		
		private var _columns:Array;
		
		public function get columns():Array {
			return _columns;
		}
		public function set columns(value:Array):void {
			
			removeAllChildren();
			
			_columns = value;
			
			var cbx:ComboBox;
			var s:Spacer;
			
			// add spacers, or comboboxes if column is set to filter
			for(var i:int=0; i<_columns.length; i++){
				
				if(_columns[i] is DataGridColumnXT){
					if(DataGridColumnXT(_columns[i]).calc == DataGridColumnXT.CALC_FILTER){
						cbx = new ComboBox;
						cbx.id = 'cbx' + DataGridColumnXT(_columns[i]).dataField;
						cbx.prompt = _cbxPrompt;
						cbx.labelField = 'label';
						cbx.labelFunction = labelDropDown;
						cbx.selectedIndex = -1;
						cbx.rowCount = _cbxRowCount;
						cbx.dropdownWidth = 150;
						cbx.styleName = _cbxStyleName;
						
						cbx.dataProvider = new ArrayCollection([{label: _defaultFilter}]);
						
						cbx.addEventListener(ListEvent.CHANGE, onCbxChange, false, 0, true);
						
						addChild( cbx );
					}
					else {
						s = new Spacer;
						
						addChild( s );
					}
				}
				
			}
			/*
			s = new Spacer;
			s.id = 'extraColumnForVerticalScrollBar';
			s.width = 15;
			addChild( s );
			*/
		}
		
		
		
		private function labelDropDown(item:Object):String {
			return (
				item.label + (_showQuantities && item.hasOwnProperty('quantity') ? ' (' + item.quantity + ')' : '')
			);
		}
		
		
		
		
		private var _showQuantities:Boolean;
		
		/**
		 * show quantities of filter value after label in combobox
		 * */
		[Bindable]
		public function get showQuantities():Boolean {
			return _showQuantities;
		}
		public function set showQuantities(value:Boolean):void {
			_showQuantities = value;
			
		}
		
		
		
		
		// filter-combobox has changed, pass event to outside world
		private function onCbxChange(event:Event):void {
			
			var f:String = event.target.id.substr(3);	// the datafield of the column
			//var v:String = event.target.selectedLabel;	// the data on which to filter
			var v:String = event.target.selectedItem[event.target.labelField];	// the data on which to filter
			
			allFilterData[f] = v;
			
			dispatchEvent(new FilterEvent(FilterEvent.FILTER_SELECT, f, v));
			
		}
		
		
		/**
		 * clear all or 1 specific combobox selection
		 * when specificFilter = -1: clear all selections
		 * else, if child index on specificFilter is a combobox, clear only that one
		 * */
		public function clearFilters(specificFilter:int = -1):void {
			if(specificFilter == -1){
				for(var i:int=0; i<numChildren; i++){
					if( getChildAt(i) is ComboBox){
						ComboBox(getChildAt(i)).selectedIndex = -1;
						ComboBox(getChildAt(i)).invalidateDisplayList();
					}
				}
			}
			else {
				if(specificFilter > -1 && numChildren > specificFilter){
					if(getChildAt(specificFilter) is ComboBox){
						ComboBox(getChildAt(specificFilter)).selectedIndex = -1;
						ComboBox(getChildAt(specificFilter)).invalidateDisplayList();
					}
				}
			}
		}
		
		
		
		
		
		
		
		// set stylename for comboboxes
		
		private var _cbxStyleName:Object;
		
		[Bindable]
		public function set comboBoxStyleName(value:Object):void {
			_cbxStyleName = value;
			for(var i:int=0; i<numChildren; i++){
				if( getChildAt(i) is ComboBox){
					ComboBox(getChildAt(i)).styleName = _cbxStyleName;
				}
			}
		}
		public function get comboBoxStyleName():Object {
			return _cbxStyleName;
		}
		
		
		
		// set rowcount for comboboxes
		
		private var _cbxRowCount:int = 15;
		
		[Bindable]
		public function set comboBoxRowCount(value:int):void {
			_cbxRowCount = value;
			for(var i:int=0; i<numChildren; i++){
				if( getChildAt(i) is ComboBox){
					ComboBox(getChildAt(i)).rowCount = _cbxRowCount;
				}
			}
		}
		public function get comboBoxRowCount():int {
			return _cbxRowCount;
		}
		
		
		
		// set prompt for comboboxes
		
		private var _cbxPrompt:String = '...';
		
		[Bindable]
		public function set comboBoxPrompt(value:String):void {
			_cbxPrompt = value;
			for(var i:int=0; i<numChildren; i++){
				if( getChildAt(i) is ComboBox){
					ComboBox(getChildAt(i)).prompt = _cbxPrompt;
				}
			}
		}
		public function get comboBoxPrompt():String {
			return _cbxPrompt;
		}
		
		
		
		// set default filter value (for example: "unfiltered")
		
		private var _defaultFilter:String = '<All>';
		
		[Bindable]
		public function set defaultFilter(value:String):void {
			_defaultFilter = value;
			
			for(var i:int=0; i<numChildren; i++){
				if( getChildAt(i) is ComboBox){
					ComboBox(getChildAt(i)).dataProvider[0].label = _defaultFilter;
				}
			}
		}
		public function get defaultFilter():String {
			return _defaultFilter;
		}
		
		
		
		
		// disable comboboxes with only 1 filter value (except default filter) (dataProvider length = 2)
		
		private var _disableUnaffectedFilters:Boolean = false;
		
		[Bindable]
		public function set disableUnaffectedFilters(value:Boolean):void {
			_disableUnaffectedFilters = value;
			
			doDisableUnaffectedFilters();
		}
		public function get disableUnaffectedFilters():Boolean {
			return _disableUnaffectedFilters;
		}
		
		private function doDisableUnaffectedFilters():void {
			for(var i:int=0; i<numChildren; i++){
				if( getChildAt(i) is ComboBox){
					if(ComboBox(getChildAt(i)).dataProvider.length > 2 ) ComboBox(getChildAt(i)).enabled = true;
					else ComboBox(getChildAt(i)).enabled = !_disableUnaffectedFilters;
				}
			}
		}
		
		
	}
}