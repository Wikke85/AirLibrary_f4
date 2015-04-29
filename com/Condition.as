package com {
	
	[Bindable] public class Condition extends Object {

		public var ID:int = 0;
		public static const Equal:Condition = new Condition(0);
		public static const NotEqual:Condition = new Condition(1);
		public static const LighterThan:Condition = new Condition(2);
		public static const LighterThanOrEqual:Condition = new Condition(3);
		public static const GreaterThan:Condition = new Condition(4);
		public static const GreaterThanOrEqual:Condition = new Condition(5);
		public static const InList:Condition = new Condition(6);
		public static const NotInList:Condition = new Condition(7);

		private var _condition:int;

		public function Condition(condition:int): void {
			_condition = condition;
		}
		
		public function toString(): String {
			var result:String;
			switch(_condition) {
				case Condition.Equal.toInteger():				result = "Equal"; break;
				case Condition.NotEqual.toInteger():			result = "NotEqual"; break;
				case Condition.LighterThan.toInteger():			result = "LighterThan"; break;
				case Condition.LighterThanOrEqual.toInteger():	result = "LighterThanOrEqual"; break;
				case Condition.GreaterThan.toInteger():			result = "GreaterThan"; break;
				case Condition.GreaterThanOrEqual.toInteger():	result = "GreaterThanOrEqual"; break;
				case Condition.InList.toInteger():				result = "InList"; break;
				case Condition.NotInList.toInteger():			result = "NotInList"; break;
			}
			return result;
		}
		public function toInteger(): int {
			return _condition;
		}
		
		public static function parse(value:String): Condition {
			if(value == null) return null;
			var result:Condition;
			switch(value.toLowerCase()) {
				case "eq":	case "equal":		case "=": case "==":						result = Condition.Equal; break;
				case "ne":	case "notequal":	case "n": case "!=": case "<>":				result = Condition.NotEqual; break;
				case "lt":	case "lighterthan":	case "<":									result = Condition.LighterThan; break;
				case "le":	case "lighterthanorequal":	case "lte": case "<=":				result = Condition.LighterThanOrEqual; break;
				case "gt":	case "greaterthan":			case ">":							result = Condition.GreaterThan; break;
				case "ge":	case "greaterthanorequal":	case "gte": case ">=":				result = Condition.GreaterThanOrEqual; break;
				case "in":	case "inlist":	case "il":	case "inl":							result = Condition.InList; break;
				case "ni":	case "notinlist":	case "nil":	case "ninl":	case "notinl":	result = Condition.NotInList; break;
			}
			return result;
		}
		
	}
}
