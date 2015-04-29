package utils {

	import mx.utils.StringUtil;

	public class StringUtils extends StringUtil {

		public function StringUtils() {
			super();
		}
		
		/*public static function trim(str:String,chars:String=" "): String {
			if(chars != " ") return StringUtils.trimChars(str,chars);
			return StringUtil.trim(str);
		}
		
		public static function trimArrayElements(value:String,delimiter:String): String {
			return StringUtil.trimArrayElements(value,delimiter);
		}
		
		public static function isWhitespace(character:String): Boolean {
			return StringUtil.isWhitespace(character);
		}*/
		
		/* *
		 * "qsdsdt{1}df {0}s qsdfq" => {0} = Array[0].toString(), ...
		 * * /
		public static function substitute(str:String, ... rest): String {
			// Replace all of the parameters in the msg string.
			var len:uint = rest.length;
			var args:Array;
			if(len == 1 && rest[0] is Array) {
				args = rest[0] as Array;
				len = args.length;
			} else {
				args = rest;
			}
			for(var i:int = 0; i < len; i++) {
				str = str.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
			}
			return str;
			
		}*/
		
		public static function trimStart(str:String,chars:String=" "): String {
			var startIndex:int = 0;
			var endIndex:int = str.length - 1;
			if(chars == " ") {
				while(isWhitespace(str.charAt(startIndex))){
					startIndex++;
				}
			} else {
				while(str.substr(startIndex,chars.length) == chars){
					startIndex += chars.length;
				}
			}
			if(endIndex >= startIndex) return str.slice(startIndex, endIndex + 1); else return "";
		}
		
		public static function trimEnd(str:String,chars:String=" "): String {
			var startIndex:int = 0;
			var endIndex:int = str.length - 1;
			if(chars == " ") {
				while(isWhitespace(str.charAt(endIndex))){
					endIndex--;
				}
			} else {
				while(str.substr(endIndex,chars.length) == chars){
					endIndex -= chars.length;
				}
			}
			if(endIndex >= startIndex) return str.slice(startIndex, endIndex + 1); else return "";
		}
		
		public static function trimChars(str:String,chars:String=" "): String {
			var startIndex:int = 0;
			var endIndex:int = str.length - 1;
			while(str.substr(startIndex,chars.length) == chars){
				startIndex += chars.length;
			}
			while(str.substr(endIndex,chars.length) == chars){
				endIndex -= chars.length;
			}
			if(endIndex >= startIndex) return str.slice(startIndex, endIndex + 1); else return "";
		}
		
		/*public static const CR:String = String.fromCharCode(13);
		public static const LF:String = String.fromCharCode(10);
		public static const CRLF:String = String.fromCharCode(13) + String.fromCharCode(10);
		public static const TAB:String = String.fromCharCode(9);
		public static const VT:String = String.fromCharCode(11);
		public static const BS:String = String.fromCharCode(8);*/

		public static function isLowerCase(str:String): Boolean {
			if(!str || str == "") return false;
			
			//return str.replace(/^[A-Z]/g, '') != '';
			
			var result:Boolean = true;
			var i:int = 0; var cc:int;
			while((i < str.length) && result) {
				cc = str.charCodeAt(i);
				result = result && (cc > 96 && cc < 123);
				i++;
			}
			return result;
		}
		
		public static function isUpperCase(str:String): Boolean {
			if(!str || str == "") return false;
			var result:Boolean = true;
			var i:int = 0; var cc:int;
			while((i < str.length) && result) {
				cc = str.charCodeAt(i);
				result = result && (cc > 96 && cc < 123);
				i++;
			}
			return result;
		}
		
		public static function isAlpha(str:String): Boolean {
			if(!str || str == "") return false;
			var result:Boolean = true;
			var i:int = 0; var cc:int;
			while((i < str.length) && result) {
				cc = str.charCodeAt(i);
				result = result && ((cc > 64 && cc < 91) || (cc > 96 && cc < 123));
				i++;
			}
			return result;
		}
		
		public static function isNumeric(str:String): Boolean {
			if(!str || str == "") return false;
			var result:Boolean = true;
			var i:int = 0; var cc:int;
			while((i < str.length) && result) {
				cc = str.charCodeAt(i);
				result = result && (cc > 47 && cc < 58);
				i++;
			}
			return result;
		}
		
		public static function isAlphaNumeric(str:String): Boolean {
			if(!str || str == "") return false;
			var result:Boolean = true;
			var i:int = 0; var cc:int;
			while((i < str.length) && result) {
				cc = str.charCodeAt(i);
				result = result && ((cc > 64 && cc < 91) || (cc > 96 && cc < 123) || (cc > 47 && cc < 58));
				i++;
			}
			return result;
		}

		public static function insertAt(str:String,value:String,index:int): String {
			var part1:String = str.substring(0,index);
			var part2:String = str.substr(index);
			return (part1 + value + part2);
		}
		
		/*public static function replace(str:String,find:String,replace:String): String {
			if(str == null) return null;
			return str.split(find).join(replace);
		}*/
		
		public static function replaceAt(str:String,index:int,length:int,replace:String): String {
			var part1:String = str.substring(0,index);
			var part2:String = str.substr(index + length);
			return (part1 + replace + part2);
		}
		
		/*public static function replaceAny(str:String,find:Array,replace:String): String {
			if(str == null) return null;
			for(var i:int = 0; i < find.length; i++) {
				str = str.split(find[i]).join(replace);
			}
			return str;
		}*/
		
		/*public static function remove(str:String,find:String): String {
			if(str == null) return null;
			return str.split(find).join("");
		}*/
		
		/*public static function removeAny(str:String,find:Array): String {
			if(str == null) return null;
			for(var i:int = 0; i < find.length; i++) {
				str = str.split(find[i]).join("");
			}
			return str;
		}*/
		
		/**
		 * replace special chars (with quote, circle above, trema, ...) with notrmal letter
		 * */
		public static function simplify(str:String): String {
			
			str = str.replace(/À|Á|Â|Ã|Ä|Å/g, 'A');
			str = str.replace(/à|á|â|ã|ä|å/g, 'a');
			
			str = str.replace(/Ç/g, 'C');
			str = str.replace(/ç/g, 'c');
			
			str = str.replace(/Ð/g, 'D');
			str = str.replace(/ð/g, 'd');
			
			str = str.replace(/È|É|Ê|Ë/g, 'E');
			str = str.replace(/è|é|ê|ë/g, 'e');
			
			str = str.replace(/Ƒ/g, 'F');
			str = str.replace(/ƒ/g, 'f');
			
			str = str.replace(/Ì|Í|Î|Ï/g, 'I');
			str = str.replace(/ì|í|î|ï/g, 'i');
			
			str = str.replace(/Ñ/g, 'N');
			str = str.replace(/ñ/g, 'n');
			
			str = str.replace(/Ò|Ó|Ô|Õ|Ö/g, 'O');
			str = str.replace(/ò|ó|ô|õ|ö/g, 'o');
			
			str = str.replace(/Š/g, 'S');
			str = str.replace(/š/g, 's');
			
			str = str.replace(/Ù|Ú|Û|Ü/g, 'U');
			str = str.replace(/ù|ú|û|ü/g, 'u');
			
			str = str.replace(/Ý|Ÿ/g, 'Y');
			str = str.replace(/ý|ÿ/g, 'y');
			
			return str
		}
		
		
		/**
		 * Removes all double white space characters with a single space
		 * */
		public static function clearWhiteSpace(text:String):String {
			text = text.replace(/\n\r\t\0/g, ' ');
			while(text.indexOf('  ') > -1){
				text = text.replace(/  /g, ' ');
			}
			return text;
		}
		
		
		
		/**
		 * Change text so that a human can still read it, but a computer can't;
		 * Leaving the first and last letter in place,
		 * e.g.
		 * "The house on the prairie is brown."
		 * becomes
		 * "The hsuoe on the pareire is bwron."
		 * */
		public static function mindFuck(value:String):String {
			/*var tmp:Array = value.split(' ');
			for(var i:int=0; i<tmp.length; i++){
				var w:String = tmp[i];
				// short words don't mix up: in, or, and, why, ...
				if(w.length > 3){
					var w2:String = w.charAt(0);
					w = w.substring(1);
					for(var j:int=0; j<w.length-1; j++){
						var n:int = Math.random() * j;
						w2 += w.charAt(n);
						w = w.substring(0, n) + w.substring(n+1);
					}
					w2 += w.charAt(w.length-1);
					tmp[i] = w2;
				}
			}
			value = tmp.join(' ');*/
			
			
				var value:String = 'The house on the prairie is brown.';
				var tmp:Array = value.split(/\W/);
				for(var i:int=0; i<tmp.length; i++){
					var w:String = tmp[i];
					// short words don't mix up: in, or, and, why, ...
					if(w.length > 3){
						var w2:String = w.charAt(0);
						w = w.substring(1);
						for(var j:int=0; j<w.length; j++){
							var n:int = Math.random() * (w.length-1);
							w2 += w.charAt(n);
							w = w.substring(0, n) + w.substring(n+1);
						}
						w2 += w.charAt(w.length-1);
						
						// if the same, do again
						if(w2 == tmp[i]){
							w = tmp[i];
							
							w2 = w.charAt(0);
							w = w.substring(1);
							for(j=0; j<w.length; j++){
								n = Math.random() * (w.length-1);
								w2 += w.charAt(n);
								w = w.substring(0, n) + w.substring(n+1);
							}
							w2 += w.charAt(w.length-1);
						}
						
						tmp[i] = value.replace(tmp[i], w2);
					}
				}
				//value = tmp.join(' ');
				
				
			return value;
		}
		
		
	}

}
