package xt.datagrid
{
	
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.events.DataGridEvent;
	import mx.events.ResizeEvent;

	public class DataGridTotals extends DataGrid
	{
		public function DataGridTotals()
		{
			super();
			
			showHeaders = false;
			selectable = false;
			
			
			rowCount = 1;
			height = rowCount * rowHeight;
			
		}
		
		
		private var calculating:Boolean = false;
		
		
		public var addSpacingForScrollbar:Boolean = true;
		
		
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
		// and if the extra column (for the vScrollbar) exists, remove it, as the setter for columns adds this one again
		public function setColumnsWidth():void {
			var s_cols:Array = _source.columns;
			var cols:Array = columns;
			
			for(var i:int=0; i<s_cols.length; i++){
				cols[i].width = s_cols[i].width;
				
			}
			
			if(cols[cols.length-1].dataField == 'extraColumnForVerticalScrollBar'){
				cols.pop();
			}
			columns = cols;
			invalidateDisplayList();
		}
		
		
		override public function set dataProvider(value:Object):void {
			
			var data:Object = {};
			
			// only perform calculations when data is in array
			if(value is Array || value is ArrayCollection){
				
				calculating = true;
				
				// when columns arent initiated yet, call later
				if(columns == null /*|| columns.length == 0*/){
					callLater(function():void { dataProvider = value; });
				}
				else if(value.length > 0) {
					
					// for each column ...
					for(var i:int=0; i<columns.length; i++){
						
						var col:DataGridColumn = DataGridColumn(columns[i]);
							
						var avgSumTotal:Number = 0;
						
						// ... and for each record corresponding to the current column
						for(var j:int=0; j<value.length; j++){
							
							//if( value[j][col.dataField] is Number || value[j][col.dataField] is int ){
								
								// previous value entered, perform calculation with it
								if(data.hasOwnProperty( col.dataField )){
									
									if(col is DataGridColumnXT){
										
										// if ignoreFunction is not set, or it is and returns false: continue with adding
										if(DataGridColumnXT(col).ignoreFunction == null || DataGridColumnXT(col).ignoreFunction(value[j], col) == false ){
											
											switch( DataGridColumnXT(col).calc ){
												case DataGridColumnXT.CALC_SUM:
													data[ col.dataField ] += value[j][col.dataField];
													//DataGridColumnXT(col).isCalculated = true;
													break;
												
												case DataGridColumnXT.CALC_MAX:
													data[ col.dataField ] = Math.max(value[j][col.dataField], data[ col.dataField ]);
													//DataGridColumnXT(col).isCalculated = true;
													break;
												
												case DataGridColumnXT.CALC_MIN:
													data[ col.dataField ] = Math.min(value[j][col.dataField], data[ col.dataField ]);
													//DataGridColumnXT(col).isCalculated = true;
													break;
												
												case DataGridColumnXT.CALC_COUNT:
													if( value[j][col.dataField] != null && value[j][col.dataField] != '' && value[j][col.dataField] > 0 ){
														data[ col.dataField ]++;
														//DataGridColumnXT(col).isCalculated = true;
													}
													break;
												
												case DataGridColumnXT.CALC_CLEAR:
													data[ col.dataField ] = ' ';
													break;
												
												case DataGridColumnXT.CALC_TEXT:
													data[ col.dataField ] = DataGridColumnXT(col).defaultText;
													break;
												
												case DataGridColumnXT.CALC_NONE:
												default:
													//DataGridColumnXT(col).isCalculated = false;
													/*DataGridColumnXT(col).itemRenderer = null;
													DataGridColumnXT(col).labelFunction = null;*/
											}
											
										}
									}
									else {
										data[ col.dataField ] += value[j][col.dataField];
									}
									
								}
								// no previous value, initialize it
								else {
									if(col is DataGridColumnXT){
										switch( DataGridColumnXT(col).calc ){
											case DataGridColumnXT.CALC_SUM:
											case DataGridColumnXT.CALC_MAX:
											case DataGridColumnXT.CALC_MIN:
												data[ col.dataField ] = value[j][col.dataField];
												//DataGridColumnXT(col).isCalculated = true;
												break;
												
											case DataGridColumnXT.CALC_COUNT:
												if( value[j][col.dataField] != null && value[j][col.dataField] != '' && value[j][col.dataField] > 0 ){
													data[ col.dataField ] = 1;
													//DataGridColumnXT(col).isCalculated = true;
												}
												break;
											
											case DataGridColumnXT.CALC_AVG:
												avgSumTotal += value[j][col.dataField];
												//DataGridColumnXT(col).isCalculated = false;
												break;
											
											case DataGridColumnXT.CALC_CLEAR:
												data[ col.dataField ] = ' ';
												break;
											
											case DataGridColumnXT.CALC_TEXT:
												data[ col.dataField ] = DataGridColumnXT(col).defaultText;
												break;
											
											case DataGridColumnXT.CALC_NONE:
											default:
												/*col.dataField = 'uncalculated'+i;
												data[ col.dataField ] = ' ';*/
												//DataGridColumnXT(col).isCalculated = false;
												/*DataGridColumnXT(col).itemRenderer = null;
												DataGridColumnXT(col).labelFunction = null;*/
										}
									}
									else {
										data[ col.dataField ] = value[j][col.dataField];
									}
								}
							
						}
						
						if(col is DataGridColumnXT && DataGridColumnXT(col).calc == DataGridColumnXT.CALC_AVG ){
							data[ col.dataField ] = avgSumTotal / value.length;
						}
						
					}
					
					data.extraColumnForVerticalScrollBar = ' ';
					
					super.dataProvider = data;
				}
				else {
					super.dataProvider = [];
				}
				calculating = false;
			}
			// no calculations are being performed on an object
			else {
				super.dataProvider = value;
			}
		}
		
		override public function set columns(value:Array):void {
			
			// add dummy column with the size of vertical scrollbar
			if(addSpacingForScrollbar){
				var col:DataGridColumn = new DataGridColumn;
				col.width = 15;
				col.headerText = ' ';
				col.dataField = 'extraColumnForVerticalScrollBar';
				value[value.length] = col;
			}
			
			
			/*for(var i:int=0; i<value.length; i++){
				if( value[i] is DataGridColumnXT && DataGridColumnXT(value[i]).calc == DataGridColumnXT.CALC_CLEAR ){
					DataGridColumnXT(value[i]).dataField = 'clearedField';
					DataGridColumnXT(value[i]).itemRenderer = new ClassFactory(Label);
				}
			}*/
			
			super.columns = value;
		}
		
		
		
		public function getValue(columnDataField:String):Object {
			var retval:Object;
			retval = dataProvider[0][columnDataField];
			
			return retval;
		}
		
		
		
	}
}