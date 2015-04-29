package com {

	import com.Condition;
	import mx.collections.ArrayCollection;

	public class Criterium extends Object {

	    // Public Fields:
	    public var dataField: String = "";
	    public var condition: Condition = Condition.Equal;
	    public var value: Object = "";
	    public var caseSensitive:Boolean = false;
	    public var compareFunction:Function = null;
	    /**
	    * Compare function defenition:
	    * ============================
	    * function compareFunction(c:Criterium,data:Object): Boolean
	    */

		// Constructor:
		public function Criterium(dataField:String,condition:Condition,value:Object=null): void {
			this.dataField = dataField;
			this.condition = condition;
			this.value = value;
		}

		// Public Methods:
		public function compare(data:Object): Boolean {
			var result:Boolean;
			if(compareFunction != null) {
				try {
					result = compareFunction(this,data);
				} catch(e:Error) {
					var msg:String = "Criterium: Incorrect function definition. Compare function example: ";
					msg += "function compareFunction(c:Criterium,data:Object): Boolean";
					throw new Error(msg);
				}
			}
			else result = Criterium.compare(data[dataField],value,condition,caseSensitive);
			return result;
		}
		public static function compare(ref:Object,val:Object,condition:Condition=null,caseSensitive:Boolean=false): Boolean {
			var result:Boolean = false;
			var _value:Object = val;
			var _ref:Object = ref;
			if(!condition) condition = Condition.Equal;
			if((_value is String) && (ref is String)) {
				if(!caseSensitive) {
					_value = String(_value).toLowerCase();
					_ref = String(ref).toLowerCase();
				}
			}
			switch(condition) {
			    case Condition.Equal :				if(_ref == _value) result = true; break;
			    case Condition.NotEqual :			if(_ref != _value) result = true; break;
			    case Condition.LighterThan :		if(_ref < _value)  result = true; break; 
			    case Condition.GreaterThan :		if(_ref > _value)  result = true; break;
			    case Condition.LighterThanOrEqual :	if(_ref <= _value) result = true; break;
			    case Condition.GreaterThanOrEqual :	if(_ref >= _value) result = true; break;
			    case Condition.InList :				if(getAC(_value).contains(_ref)) result = true; break;
			    case Condition.NotInList :			if(!getAC(_value).contains(_ref)) result = true; break;
			}
			return result;
		}

		// Private Methods:
		private static function getAC(value:Object): ArrayCollection {
			var a:ArrayCollection = new ArrayCollection([]);
	    	if(value is Array || value is ArrayCollection) {
	    		if(value is ArrayCollection) a = ArrayCollection(value);
	    		if(value is Array) 			 a = new ArrayCollection(value as Array);
	    	} else {
	    		//throw new Error("When using Condition.InList, Criterium.value must be an Array or ArrayCollection.");
	    		a.addItem(value);
	    	}
	    	return a;
		}

	}

}