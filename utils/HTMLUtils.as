package utils
{
	
	/**
	 * Various functions to manipulate HTML text
	 * */
	public class HTMLUtils
	{
		
		/**
		 * replace SIZE="" tags with POINTSIZE="" in the FONT tag
		 * 
		 * this prevents the html text to show up gigantically in html mails
		 * */
		public static function sizeToPointsize(value:String):String
		{
			return value.replace(/ size=\"/gi, ' pointsize="');
		}
		
		/**
		 * replace POINTSIZE="" tags with SIZE="" in the FONT tag
		 * 
		 * */
		public static function pointsizeToSize(value:String):String
		{
			return value.replace(/ pointsize=\"/gi, ' size="');
		}
		
		
		
		/**
		 * remove each html tag.
		 * if breaksToNewlines = true,
		 * all line breaks are converted to newlines first
		 * */
		public static function removeHtml(text:String, breaksToNewlines:Boolean=true):String {
			if(breaksToNewlines){
				text = breakToNewline(text);
			}
			
			// remove everything between <>'s
			text = text.replace(/<[^>]*>/g, '');
			
			return text;
		}
		
		
		/**
		 * remove all html comments.
		 * */
		public static function removeHtmlComments(text:String):String {
			text = text.replace(/<!--[^>]*-->/g, '');
			return text;
		}
		
		
		/**
		 * remove all html tags (empty removes all html).
		 * multiple tags possible (separate by , or ;)
		 * */
		public static function removeHtmlTags(text:String, tag:String=''):String {
			tag = tag.replace(/ /g, '');
			if(tag.indexOf(',') > -1 || tag.indexOf(';') > -1){
				tag = '[' + tag.replace(/[,|;]/g, '|') + ']';
			}
			var repl1:RegExp = new RegExp('<'+tag+'[^>]*>', 'gi');	// open tag
			var repl2:RegExp = new RegExp('</'+tag+'*>', 'gi');		// close tag
			text = text.replace(repl1, '').replace(repl2, '');
			return text;
		}
		
		
		
		
		/**
		 * replace breaks with newline characters
		 * @see also newlineToBreak
		 * */
		public static function breakToNewline(text:String):String {
			text = text.replace(/<br[^>]*>/gi, '\n');
			
			return text;
		}
		
		/**
		 * replace newline characters with breaks
		 * @see also breakToNewline
		 * */
		public static function newlineToBreak(text:String):String {
			text = text.replace(/\n/g, "<br>");
			return text;
		}
		
		
		
		/**
		 * remove target="_blank" attributes from javascript links (leave other links intact)
		 * or remove all target attributes
		 * 
		 * for use with mx.controls.RichTextEditor
		 * */
		public static function removeLinkTargets(value:String, removeAll:Boolean = false):String {
			var textparts:Array = value.split(/\<a /gi);	// split on every link, so each array element contains 1 href element
			if(textparts.length > 1){
				for(var p:int=0; p<textparts.length; p++){
					var line:String = textparts[p];
					if((removeAll || line.toLowerCase().indexOf('javascript:') > -1) && line.toLowerCase().indexOf('target="_blank"') != -1){	// when javascript url:
						line = line.replace(/target=\"_blank\"/i, '');	// remove the target attribute
						textparts[p] = line;
					}
				}
				value = textparts.join('<A ');
			}
			return value;
		}
		
		
		
		
	}
}