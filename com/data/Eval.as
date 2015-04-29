package com.data
{
	public class Eval
	{
		public function Eval()
		{
		}
		
		/**
		 * Parse given string as calculation
		 * (, ), +, -, *, /, .
		 * 
		 * */
		public static function parseNumeric(value:String):Number {
			var ret:Number;
			var data:Array;
			
			var b:int=0;	// brackets '('
			var t:int=0;	// multiplification (x times) '*'
			var d:int=0;	// division '/'
			var p:int=0;	// plus '+'
			var m:int=0;	// minus '-'
			
			// first, set all commas to points 
			value = value.replace(/,/g, '.');
			
			// make sure all operators are surrounded by spaces (for splitting)
			value = value.replace(/\(/g, ' ( ');
			value = value.replace(/\)/g, ' ) ');
			value = value.replace(/\*/g, ' * ');
			value = value.replace(/\//g, ' / ');
			value = value.replace(/\+/g, ' + ');
			value = value.replace(/\-/g, ' - ');
			
			while (value.indexOf('  ') > -1){
				value = value.replace(/  /g, ' ');
			}
			
			data = value.split(' ');
			
			value = calcBrackets(value);
			
			/*
			for(b=0; b<data.length; b++){
				data[b] = data[b].split('*');
				
				for(t=0; t<data[b].length; t++){
					data[b][t] = data[b][t].split('/');
					
					for(d=0; d<data[b][t].length; d++){
						data[b][t][d] = data[b][t][d].split('+');
						
						for(m=0; m<data[b][t][d].length; m++){
							data[b][t][d][m] = data[b][t][d][m].split('-');
						}
					}
				}
			}
			
			for(b=0; b<data.length; b++){
				
				for(t=0; t<data[b].length; t++){
					
					for(d=0; d<data[b][t].length; d++){
						
						for(m=0; m<data[b][t][d].length; m++){
							
							
						}
					}
				}
			}*/
			
			return ret;
		}
		
		
		private static function calcBrackets(value:String):String {
			var deepestOpen:int = -1;
			var deepestClose:int = -1;
			
			var currentOpen:int = -1;
			var currentClose:int = -1;
			
			
			currentClose = value.indexOf(')');
			currentOpen = value.substring(0, currentClose).lastIndexOf('(');
			
			while(currentOpen < currentClose || (currentOpen == -1 && currentClose == -1) ){
				deepestOpen = currentOpen;
				deepestClose = currentClose;
				
				var r:String = value.substring(currentOpen, currentClose+1);
				value = value.replace(r, calcValue(r));
				
				currentClose = value.indexOf(')');
				currentOpen = value.substring(0, currentClose).lastIndexOf('(');
				
				//currentOpen = value.indexOf('(', currentOpen);
				//currentClose = value.indexOf(')', currentOpen);
			}
			
			return value;
		}
		
		
		private static function calcValue(value:String):String {
			// replace brackets, we're in the currently deepest brackets, so they are not needed anymore
			value = value.replace(/[\(|\)]/i, '');
			var retval:String = '';
			
			var i:int=0;
			
			for(i=0; i<value.length; i++){
				
			}
			
			return retval;
		}
		
	}
	
}