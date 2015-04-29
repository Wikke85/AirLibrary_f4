package xt.datagrid
{
	import mx.controls.dataGridClasses.DataGridColumn;

	public class DataGridColumnXT extends DataGridColumn
	{
		public function DataGridColumnXT(columnName:String=null)
		{
			super(columnName);
		}
		
		
		public static const CALC_DUMMY:String = 'dummy';	// empty column which takes up space, but is unsortable
		public static const CALC_SUM:String = 'sum';		// total sum of all items in column
		public static const CALC_AVG:String = 'avg';		// average for all items in column
		public static const CALC_MAX:String = 'max';		// highest value in column
		public static const CALC_MIN:String = 'min';		// lowest value
		public static const CALC_COUNT:String = 'count';	// items in column which are not empty (e.g. null, '', 0)
		public static const CALC_NONE:String = 'none';		// no calculation - this field remains empty - Default value
		public static const CALC_FILTER:String = 'filter';	// put all items distinct in a combobox above the column for filtering
		public static const CALC_CLEAR:String = 'clear';	// explicitly clear the field
		public static const CALC_TEXT:String = 'text';		// put a string (in var 'defaultText') in the column; for labelling the field next to it, for example
		
		private var _calc:String = 'none';
		
		
		//[ArrayElementType("mx.containers.utilityClasses.ConstraintColumn")]
		//[Inspectable(arrayType="mx.containers.utilityClasses.ConstraintColumn")]
		
		[Bindable]
		[Inspectable(category="General", enumeration="dummy,sum,avg,max,min,count,none,filter,clear,text", defaultValue="none")]
		public function set calc(value:String):void {
			_calc = value;
			if(_calc == CALC_DUMMY){
				headerText = ' ';
				dataField = 'DataGridColumnXT_dummy';
				sortable = false;
			}
		}
		public function get calc():String {
			return _calc;
		}
		
		//[Bindable] public var isCalculated:Boolean = false;
		
		[Bindable] public var defaultText:String = '';
		
		
		/**
		 * function to calculate whether the item should be included in the calculation or not
		 * this function takes, like the labelFunction, 2 arguments:
		 * 	item:	Object	-> the data object
		 * 	col:	DataGridColumn	-> the current datagrid column
		 * 
		 * returns Boolean:
		 * 	true:	the item is ignored in the calculations
		 * 	false:	the item is considered in the calculations
		 * */
		public var ignoreFunction:Function;
		
	}
}