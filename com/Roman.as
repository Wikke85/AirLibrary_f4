package com
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Convert integers to Roman format and back
	 * Roman ciphers:
	 * 	I:	1
	 * 	V:	5
	 * 	X:	10
	 * 	L:	50
	 * 	C:	100
	 * 	D:	500
	 * 	M:	1000
	 * 
	 * for numbers higher than or equal to 5000 things change a bit:
	 * 5000 is represented as 5 x 1000 (V . M) or 'V.M '
	 * */
	public class Roman extends EventDispatcher
	{
		
		public function Roman()
		{
			super();
		}
		
		// different symbols possible
		// arranged by weight (from left)
		private const codes:Array = [
			['', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX'],	// 0 - 9
			['', 'X', 'XX', 'XXX', 'XL', 'L', 'LX', 'LXX', 'LXXX', 'XC'],	// 10 - 90
			['', 'C', 'CC', 'CCC', 'DC', 'D', 'DC', 'DCC', 'DCCC', 'CM']	// 100 - 900
			//['', 'M', 'MM', 'MMM', 'MMMM', 'V.M ', 'VI.M ', 'VII.M ', 'VIII.M ', 'IX.M '],	// 1000 - 9000
		];
		
		
		// placeholder for the values represented by its letter
		private const values:Object = {
			I:	1,
			V:	5,
			X:	10,
			L:	50,
			C:	100,
			D:	500,
			M:	1000
		}
		
		
		
		private var _numeric:int = 0;
		
		/**
		 * the numerical value
		 * */
		[Bindable]
		public function get numeric():int {
			return _numeric;
		}
		public function set numeric(value:int):void {
			_numeric = value;
			_string = '';
			
			calculate();
		}
		
		
		
		
		private var _string:String;
		
		/**
		 * the romanic representation
		 * */
		[Bindable('valueChanged')]
		public function get string():String {
			return _string;
		}
		/*public function set string(value:String):void {
			_string = value;
			_numeric = 0;
			
			var weight:int = 1;
			var char:String = '';
			var curVal:int = 0;
			
			for(var i:int=_string.length-1; i>=0; i--){
				char = _string.charAt(i).toUpperCase();
				
				// if the char is before a higher valued char (I in IV)
				/*if(weight < values[char]){
					_numeric -= values[char];
				}
				else {
					_numeric += values[char];
				}
				
				if(weight < values[char]){
					weight = values[char]
				}* /
				
				
				
				
				
			}
			
			
		}*/
		
		
		
		
		
		private var _jupiterMode:Boolean = false;
		
		/**
		 * Jupiter mode: represent 4 as IIII instead of IV
		 * historical implementation:
		 * 	IV could be mixed up for the first letters of the god Jupiter: IVPITER, so sometimes Romans wrote 4 as IIII sometimes
		 * 	also used in watches and clocks: 4 I's were cheaper to produce than IV, because it didn't need to be joined (the 'V')
		 * */
		[Bindable]
		public function get jupiterMode():Boolean {
			return _jupiterMode;
		}
		public function set jupiterMode(value:Boolean):void {
			_jupiterMode = value;
			calculate();
		}
		
		
		
		
		
		private function calculate():void {
			if(_numeric > 0){
				var s:String = _numeric.toString();
				var tmpCode:String = '';
				
				for(var i:int=0; i<codes.length; i++){
					tmpCode = codes[i][int(s.charAt(s.length - 1))];
					
					if(jupiterMode && tmpCode == 'IV'){
						tmpCode = 'IIII';
					}
					
					_string = tmpCode + _string;
					
					s = s.substr(0, s.length-1);
					
				}
				
				/*for(var ki:int=0; ki<int(s); ki++){
					_string = 'M' + _string;
				}*/
				
				var m:String = '';
				for(var j:int=0; j<codes.length; j++){
					tmpCode = codes[i][int(s.charAt(s.length - 1))];
					
					if(jupiterMode && tmpCode == 'IV'){
						tmpCode = 'IIII';
					}
					
					m = tmpCode + m;
					
					s = s.substr(0, s.length-1);
					
				}
				
				_string = m + '.M ' + _string;
				
				
			}
			
			dispatchEvent(new Event('valueChanged'));
		}
		
		
		
		
		
	}
	
}
