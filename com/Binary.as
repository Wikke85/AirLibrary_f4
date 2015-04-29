package com
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class Binary extends EventDispatcher
	{
		public function Binary()
		{
		}
		
		private var _bits:ArrayCollection = new ArrayCollection([0]);
		
		public var bitCount:int = 8;
		
		[Bindable]
		public function set valueString(value:String):void {
			var values:Array = value.split('');
			
			_bits = new ArrayCollection;
			
			for(var i:int=values.length-1; i>=0; i--){
				_bits.addItem(int(values[i]));
			}
			dispatchEvent(new Event('bitsChanged'));
		}
		public function get valueString():String {
			var retval:String = '';
			for(var i:int=_bits.length-1; i>=0; i--){
				retval += _bits[i];
			}
			if(bitCount > 0){
				while(retval.length < bitCount) {
					retval = "0" + retval;
				}
			}
			return retval;
		}
		
		
		
		[Bindable]
		public function set valueInt(value:int):void {
			_bits = new ArrayCollection;
			
			while(value > 0) {
				_bits.addItem( value % 2 );
				value = Math.floor(value / 2);
			}
			
			dispatchEvent(new Event('bitsChanged'));
		}
		public function get valueInt():int {
			var retval:int = 0;
			for(var i:int=0; i<_bits.length; i++){
				if(_bits[i] == 1){
					retval += Math.pow(2, i);
				}
			}
			return retval;
		}
		
		
		
		[Bindable('bitsChanged')]
		public function getBit(index:int):Boolean {
			return _bits.length > index ? _bits.getItemAt(index) == 1 : false;
		}
		[Bindable('bitsChanged')]
		public function setBit(index:int, value:Boolean):void {
			_bits.setItemAt(value, index) == 1;
		}
		
		
	}
}