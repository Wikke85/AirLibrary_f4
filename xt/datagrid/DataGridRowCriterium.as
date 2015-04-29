package xt.datagrid
{
	
	import com.Condition;
	import com.Criterium;

	public class DataGridRowCriterium extends Criterium {
		
	    // Public Style Fields:
	    //public var color: Object;
	    public var backgroundColor: Object;
	    
	    [Inspectable(enumeration="normal,italic")]
	    public var fontStyle: Object;
	    
	    [Inspectable(enumeration="normal,bold")]
	    public var fontWeight: Object;
		
		// Constructor:
		public function DataGridRowCriterium(dataField:String, condition:Condition, value:Object=null, backgroundColor:Object=null) {
			super(dataField, condition, value);
			this.backgroundColor = backgroundColor;
	//		_owner = owner
			/*var _color:Object = _owner.getStyle("color");
			var _backgroundColor:Object = _owner.getStyle("backgroundColor");
			var _fontStyle:Object = _owner.getStyle("fontStyle");
			var _fontWeight:Object = _owner.getStyle("fontWeight");
			if(_color != null) color = uint(_color);
			if(_backgroundColor != null) backgroundColor = uint(_backgroundColor);
			if(_fontStyle != null) fontStyle = String(_fontStyle);
			if(_fontWeight != null) fontWeight = String(_fontWeight);*/
		}

	}

}