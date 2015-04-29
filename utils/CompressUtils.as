package utils
{
	public class CompressUtils
	{
		public function CompressUtils()
		{
		}
		
		public static var legalEntities:Array = [
			'copyright',	'copy right',	'(c)',	'©',
			'registered',	'(r)',	'®',
			'trademark',	'trade mark',	'(tm)',	'™',
			'all rights reserved',
			'gpl', 'gnu public license'
		];
		
		public static function compressCss(value:String, preserveLegal:Boolean):String {
			var s:String = value;
			//var preserveLegal:Boolean = cbxKeepDisclaimers.selected;
			
			var separator:String = "\n";
			// convert win delimiters to \n
			if(s.indexOf("\r\n") > -1){
				separator = "\r\n";
				s = s.replace(/\r\n/g, '\n');
			}
			// convert mac delimiters to \n
			if(s.indexOf("\r") > -1 && s.indexOf("\n") == -1){
				separator = "\r";
				s = s.replace(/\r/g, '\n');
			}
			
			
			
			var start:Number = s.indexOf('/*START DEBUG*/');
			var end:Number = s.indexOf('/*END DEBUG*/', start);
			
			// remove debug/test blocks and everything between: /*START DEBUG*/ ... /*END DEBUG*/
			while(start > -1 && end > -1){
				var ds:String = s.substring(start, end+13);
				s = s.substring(0, start) + s.substring(end + 13);
				
				start = s.indexOf('/*START DEBUG*/', start + 1);
				end = s.indexOf('/*END DEBUG*/', start + 2);
				
			}
			
			
			
			start = s.indexOf('/*');
			end = s.indexOf('*/', start);
			
			// remove comments: /* ... */
			while(start > -1 && end > -1){
				//s = s.replace(/\/\**\*\//, '');
				
				var cs:String = s.substring(start, end+2);
				
				if((preserveLegal && !hasDisclaimer(cs))
					||
					!preserveLegal
				){
					s = s.substring(0, start) + s.substring(end + 2);
				}
				
				start = s.indexOf('/*', start + 1);
				end = s.indexOf('*/', start + 2);
				
			}
			
			
			
			// remove all double spacing (tabs to spaces, double spaces to single, ...)
			s = removeWhiteSpace(s);
			
			// remove spaces before and after brackets {}
			s = s.replace(/\{ /g, '{');
			s = s.replace(/ \{/g, '{');
			s = s.replace(/\} /g, '}');
			s = s.replace(/ \}/g, '}');
			
			// replace enters before brackets
			s = s.replace(/\n{/g, '{');
			
			// set first declaration after bracket behind the bracket
			s = s.replace(/\{\n/g, '{');
			
			// set other declarations after first declaration
			s = s.replace(/;\n/g, ';');
			
			// replaces spaces before/after a comma
			s = s.replace(/, /g, ',');
			s = s.replace(/ ,/g, ',');
			
			// replaces enters after a comma
			s = s.replace(/,\n/g, ',');
			
			// replaces spaces before/after a double point
			s = s.replace(/: /g, ':');
			s = s.replace(/ :/g, ':');
			
			// replaces spaces before/after a point-comma
			s = s.replace(/; /g, ';');
			s = s.replace(/ ;/g, ';');
			
			// @charset '...';#declaration{...} => line break
			s = s.replace(/;#/g, ';\n#');
			
			// '0px' => '0'
			s = s.replace(/:0px/g, ':0');
			s = s.replace(/ 0px/g, ' 0');
			
			
			var a:Array = s.split('\n');
			for(var i:Number=0; i<a.length; i++){
				
				/*
					write colours as smaller :
					#FF1122 becomes #F12
					but #F1268D or #EEE remains the same
				*/
				var hashIndex:Number = String(a[i]).indexOf('#');
				
				while(hashIndex > -1){
					var color:String = String(a[i]).substr(hashIndex, 7);	// get color: #FF1122, #F1268D, #EEE;nex-decl...
					
					if(color.replace(/#|[0-9]|[a-f]/gi, '') == ''){// valid colour: #FF1122, #F1268D
						if(color.charAt(0) == '#' && color.charAt(1) == color.charAt(2) && color.charAt(3) == color.charAt(4) && color.charAt(5) == color.charAt(6)){	// check if format = #FF1122
							a[i] = String(a[i]).replace(color, color.charAt(0) + color.charAt(1).toUpperCase() + color.charAt(3).toUpperCase() + color.charAt(5).toUpperCase());	// replace #FF1122 with #F12
						}
					}
					
					// find next colour on line
					hashIndex = String(a[i]).indexOf('#', hashIndex + 3);
				}
				
				
				/*
					TODO:
						
						combine:
							border-top-style:dotted; border-right-style:solid; border-bottom-style:dotted; border-left-style:solid; => border-style:dotted solid;
							border-top-color:#color1; border-right-color:#color2; border-bottom-color:#color1; border-left-color:#color2; => border-color:#color1 #color2;
							border-top-width:width1; border-right-width:width2; border-bottom-width:width1; border-left-width:width2; => border-width:width1 width2;
						
				*/
				
				
				/*
					fix padding-xxxs:
						padding-xxx:10px; ... => padding:10px ...;
				*/
				var paddingIndexTop:Number		= String(a[i]).indexOf('padding-top:');
				var paddingIndexRight:Number	= String(a[i]).indexOf('padding-right:');
				var paddingIndexBottom:Number	= String(a[i]).indexOf('padding-bottom:');
				var paddingIndexLeft:Number	= String(a[i]).indexOf('padding-left:');
				
				if(true // all 4 and only those 4
					&& paddingIndexTop		> -1 && String(a[i]).indexOf('padding-top:',	paddingIndexTop		+ 1) == -1
					&& paddingIndexRight	> -1 && String(a[i]).indexOf('padding-right:',	paddingIndexRight	+ 1) == -1
					&& paddingIndexBottom	> -1 && String(a[i]).indexOf('padding-bottom:',	paddingIndexBottom	+ 1) == -1
					&& paddingIndexLeft		> -1 && String(a[i]).indexOf('padding-left:',	paddingIndexLeft	+ 1) == -1
				){
					
					// get paddings
					var paddingTop:String		= String(a[i]).substring(paddingIndexTop,		a[i].indexOf(';', paddingIndexTop		+ 1	) + 1);
					var paddingRight:String		= String(a[i]).substring(paddingIndexRight,		a[i].indexOf(';', paddingIndexRight		+ 1	) + 1);
					var paddingBottom:String	= String(a[i]).substring(paddingIndexBottom,	a[i].indexOf(';', paddingIndexBottom	+ 1	) + 1);
					var paddingLeft:String		= String(a[i]).substring(paddingIndexLeft,		a[i].indexOf(';', paddingIndexLeft		+ 1	) + 1);
					
					// remove old paddings
					a[i] = a[i].replace(paddingTop, '').replace(paddingRight, '').replace(paddingBottom, '').replace(paddingLeft, '');
					
					// set new padding
					a[i] = String(a[i]).substring(0, a[i].length - 1);
					a[i] += 'padding:' + 
						paddingTop		.replace('padding-top:',	'').replace(';', '') + ' ' + 
						paddingRight	.replace('padding-right:',	'').replace(';', '') + ' ' + 
						paddingBottom	.replace('padding-bottom:',	'').replace(';', '') + ' ' + 
						paddingLeft		.replace('padding-left:',	'').replace(';', '') + ';';
					
					a[i] += '}';
				}
				
				
				/*
					fix paddings:
						padding:10px 10px 10px 10px; => padding:10px;
						padding:10px 5px 10px 5px; => padding:10px 5px;
				*/
				var paddingIndex:Number = String(a[i]).indexOf('padding:');
				if(paddingIndex > -1){
					var padding:String = String(a[i]).substring(paddingIndex, String(a[i]).indexOf(';', paddingIndex));	// get padding: 0; 15px; 12px 14px; 10px 8px 5px 2px; ...
					padding = padding.replace(':', ': ');
					var paddings:Array = padding.split(' ');
					var padding2:String = '';
					
					if(paddings.length == 5 && paddings[0] == 'padding:' && paddings[1] == paddings[3] && paddings[2] == paddings[4]){
						// padding: 10px 10px 10px 10px; => padding: 10px;
						if(paddings[2] == paddings[3]){
							padding2 = paddings[0] + paddings[1];
						}
						// padding: 10px 5px 10px 5px; => padding: 10px 5px;
						else {
							padding2 = paddings[0] + paddings[1] + ' ' + paddings[2];
						}
						a[i] = a[i].replace(padding.replace(': ', ':'), padding2);
					}
				}
				
				
				
				/*
					fix margin-xxxs:
						margin-xxx:10px; ... => margin:10px ...;
				*/
				var marginIndexTop:Number		= String(a[i]).indexOf('margin-top:');
				var marginIndexRight:Number	= String(a[i]).indexOf('margin-right:');
				var marginIndexBottom:Number	= String(a[i]).indexOf('margin-bottom:');
				var marginIndexLeft:Number		= String(a[i]).indexOf('margin-left:');
				
				if(true // all 4 and only those 4
					&& marginIndexTop		> -1 && String(a[i]).indexOf('margin-top:',		marginIndexTop		+ 1) == -1
					&& marginIndexRight		> -1 && String(a[i]).indexOf('margin-right:',	marginIndexRight	+ 1) == -1
					&& marginIndexBottom	> -1 && String(a[i]).indexOf('margin-bottom:',	marginIndexBottom	+ 1) == -1
					&& marginIndexLeft		> -1 && String(a[i]).indexOf('margin-left:',	marginIndexLeft		+ 1) == -1
				){
					
					// get margins
					var marginTop:String	= String(a[i]).substring(marginIndexTop,		a[i].indexOf(';', marginIndexTop		+ 1	) + 1);
					var marginRight:String	= String(a[i]).substring(marginIndexRight,		a[i].indexOf(';', marginIndexRight		+ 1	) + 1);
					var marginBottom:String	= String(a[i]).substring(marginIndexBottom,		a[i].indexOf(';', marginIndexBottom		+ 1	) + 1);
					var marginLeft:String	= String(a[i]).substring(marginIndexLeft,		a[i].indexOf(';', marginIndexLeft		+ 1	) + 1);
					
					// remove old margins
					a[i] = a[i].replace(marginTop, '').replace(marginRight, '').replace(marginBottom, '').replace(marginLeft, '');
					
					// set new margin
					a[i] = String(a[i]).substring(0, a[i].length - 1);
					a[i] += 'margin:' + 
						marginTop		.replace('margin-top:',		'').replace(';', '') + ' ' + 
						marginRight		.replace('margin-right:',	'').replace(';', '') + ' ' + 
						marginBottom	.replace('margin-bottom:',	'').replace(';', '') + ' ' + 
						marginLeft		.replace('margin-left:',	'').replace(';', '') + ';';
					
					a[i] += '}';
				}
				
				
				/*
					fix margins:
						margin:10px 10px 10px 10px; => margin:10px;
						margin:10px 5px 10px 5px; => margin:10px 5px;
				*/
				var marginIndex:Number = String(a[i]).indexOf('margin:');
				if(marginIndex > -1){
					var margin:String = String(a[i]).substring(marginIndex, String(a[i]).indexOf(';', marginIndex));	// get margin: 0; 15px; 12px 14px; 10px 8px 5px 2px; ...
					margin = margin.replace(':', ': ');
					var margins:Array = margin.split(' ');
					var margin2:String = '';
					
					if(margins.length == 5 && margins[0] == 'margin:' && margins[1] == margins[3] && margins[2] == margins[4]){
						// margin: 10px 10px 10px 10px; => margin: 10px;
						if(margins[2] == margins[3]){
							margin2 = margins[0] + margins[1];
						}
						// margin: 10px 5px 10px 5px; => margin: 10px 5px;
						else {
							margin2 = margins[0] + margins[1] + ' ' + margins[2];
						}
						a[i] = a[i].replace(margin.replace(': ', ':'), margin2);
					}
				}
				
				
				// remove left-over empty lines
				if(a[i] == ' ' || a[i] == ''){
					a.splice(i, 1);
					i--;
				}
				// empty declaration => remove line
				else if(a[i].indexOf('{}') > -1 || a[i].indexOf('{ }') > -1){
					a.splice(i, 1);
					i--;
				}
				
			}
			
			
			s = a.join(separator);
			
			return s;
			
		}
		public static function compressCssLines(value:String):String {
			var s:String = value;
			//var preserveLegal:Boolean = cbxKeepDisclaimers.selected;
			
			var separator:String = "\n";
			// convert win delimiters to \n
			if(s.indexOf("\r\n") > -1){
				separator = "\r\n";
				s = s.replace(/\r\n/g, '\n');
			}
			// convert mac delimiters to \n
			if(s.indexOf("\r") > -1 && s.indexOf("\n") == -1){
				separator = "\r";
				s = s.replace(/\r/g, '\n');
			}
			
			var a:Array = s.split('\n');
			
			s = '';
			for(var j:Number=0; j<a.length; j++){
				if(a[j].indexOf('/*') == 0 || a[j].indexOf('//') == 0){
					s += a[j] + separator;
				}
				else {
					s += a[j];
				}
			}
			
			return s;
			
		}
		
		
		
		public static function deCompressCss(value:String):String {
			var s:String = value;
			
			var separator:String = "\n";
			// convert win delimiters to \n
			if(s.indexOf("\r\n") > -1){
				separator = "\r\n";
				s = s.replace(/\r\n/g, '\n');
			}
			// convert mac delimiters to \n
			if(s.indexOf("\r") > -1 && s.indexOf("\n") == -1){
				separator = "\r";
				s = s.replace(/\r/g, '\n');
			}
			
			// remove spaces before and after brackets {}
			s = s.replace(/\{ /g, '{');
			s = s.replace(/ \{/g, '{');
			s = s.replace(/\} /g, '}');
			s = s.replace(/ \}/g, '}');
			
			// place enters before brackets
			s = s.replace(/{/g, '\n{');
			
			// set first declaration after bracket on next line
			s = s.replace(/\{/g, '{\n\t');
			
			// set other declarations after first declaration
			s = s.replace(/;/g, ';\n\t');
			
			// replaces spaces before/after a comma
			s = s.replace(/,/g, ', ');
			
			
			// replaces spaces before/after a double point
			s = s.replace(/:/g, ': ');
			
			// @charset '...';#declaration{...} => line break
			s = s.replace(/;#/g, ';\n#');
			
			
			// final bracket, remove tab
			s = s.replace(/\t}/g, '}');
			
			return s;
			
		}
		
		
		
		
		public static function compressJs(value:String, preserveLegal:Boolean, removeNewLines:Boolean):String {
			var s:String = value;
			//var preserveLegal:Boolean = cbxKeepDisclaimers.selected;
			
			var valid:Boolean = true;
			
			var stringModeSingle:Boolean = false;
			var stringModeDouble:Boolean = false;
			var regexMode:Boolean = false;
			
			var cChar:String = ''; // current char
			var pChar:String = ''; // previous char
			var ppChar:String = ''; // previous previous char
			var pppChar:String = ''; // previous previous previous char
			var nChar:String = ''; // next char
			var nWord:String = ''; // next word
			
			var i:Number = 0;
			
			var separator:String = "\n";
			if(s.indexOf("\r\n") > -1){
				separator = "\r\n";
			}
			else if(s.indexOf("\r") > -1){
				separator = "\r";
			}
			
			
			/*
				- check validity
					- comments?
					- each line must either end with (white space ignored):
						- {
						- }
						- ) (find previous '(', no ; may be in between)
						- ; (end)
						- nothing (whitespace)
			*/
			
			
			var start:Number = s.indexOf('/*START DEBUG*/');
			var end:Number = s.indexOf('/*END DEBUG*/', start);
			
			// remove debug/test blocks: /*START DEBUG*/ ... /*END DEBUG*/
			while(start > -1 && end > -1){
				var ds:String = s.substring(start, end+13);
				s = s.substring(0, start) + s.substring(end + 13);
				
				start = s.indexOf('/*START DEBUG*/', start + 1);
				end = s.indexOf('/*END DEBUG*/', start + 2);
				
			}
			
			var regexStartIndex:Number = -1;
			
			// loop over each char
			while(i < s.length){
				cChar = s.charAt(i);
				if(i > 0){
					//preserve previous char
					pChar = s.charAt(i-1);
				}
				if(i > 1){
					//preserve previous char
					ppChar = s.charAt(i-2);
				}
				if(i > 2){
					//preserve previous char
					pppChar = s.charAt(i-3);
				}
				if(i < s.length-2){
					//read next char
					nChar = s.charAt(i+1);
					var nwi:Number = s.length;
					
					var chars:Array = [' ','\n','\r','\t','(',')','{','}','[',']',':',',',';','.','-','+','*','/','\\','=','<','>','!'];
					for(var ci:Number=0; ci<chars.length; ci++){
						nwi = Math.min(nwi, s.indexOf(chars[ci], i + 2) == -1 ? nwi : s.indexOf(chars[ci], i + 2));
					}
					/*nwi = Math.min(nwi, s.indexOf(' ', i + 1) == -1 ? nwi : s.indexOf(' ', i + 1));
					nwi = Math.min(nwi, s.indexOf('\n', i + 1) == -1 ? nwi : s.indexOf('\n', i + 1));
					nwi = Math.min(nwi, s.indexOf('\r', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf('\t', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf('(', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf(')', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf('{', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf('}', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf('[', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf(']', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf(':', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf(',', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf(';', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf('.', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf('-', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf('+', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf('*', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf('/', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf('\\', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf('=', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf('<', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf('>', i + 1) == -1 ? nwi : );
					nwi = Math.min(nwi, s.indexOf('!', i + 1) == -1 ? nwi : );*/
					
					if(nwi > 0){
						nWord = s.substring(i + 1, nwi);
					}
					else {
						nWord = '';
					}
				}
				else {
					nChar = '';
					nWord = '';
				}
				
				
				// check if currently in regular expression
				if(regexMode){
					// check for division ( / ) => no regex
					if(cChar == '\n' || cChar == '\r' && regexStartIndex > -1){
						regexMode = false;
						i = regexStartIndex;
						regexStartIndex = -1;
					}
					else if(!stringModeDouble && !stringModeSingle && cChar == '/' && (pChar != '\\' /*|| (pChar == '\\' && ppChar == '\\')*/ || (pChar == '\\' && ppChar == '\\' && pppChar != '\\')) ){
						regexMode = false;
						regexStartIndex = -1;
					}
					
					/*
					/ /
					/ \/ /
					/\//
					
					/ \\\/ /
					/\\\//
					
					
					if
						cchar = / & pchar != \
						or
						cchar = / & pchar = \ & ppchar = \ & pppchar != \
					
					
					var checkRegex:String = s.substring(i, Math.max(s.indexOf('\n', i+1), s.indexOf('\r', i+1)) );	// without initial /
					var regexEndIndex:Number = checkRegex.indexOf('/', i);
					
					// 1 slash on this line, probably a 'divide'
					if(regexEndIndex == -1){
						regexMode = false;
					}
					else {
						
						
						
					}
					
					// find end slash of regex
					else if(checkRegex.length > 1 && checkRegex[regexEndIndex - 1] != '\\'){
						regexMode = false;
					}
					else if(checkRegex[regexEndIndex - 1] != '\\' || (checkRegex[regexEndIndex - 1] == '\\' && checkRegex[regexEndIndex - 2] == '\\')){
						regexMode = false;
					}
					
					*/
					
				}
				else if(!regexMode){
					//if(!stringModeDouble && !stringModeSingle && cChar == '/' && nChar != '/' && pChar != '/' && pChar != '*' && (pChar != '\\' /*|| (pChar == '\\' && ppChar == '\\')*/ || (pChar == '\\' && ppChar == '\\' && pppChar != '\\'))  && nChar != '*'){
					if(!stringModeDouble && !stringModeSingle && cChar == '/' && (pChar == '(' || pChar == '=' || pChar == ':') && (pChar != '*' || (pChar == '\\' && ppChar == '\\' && pppChar != '\\'))  && nChar != '*'){
						regexMode = true;
						regexStartIndex = i;
					}
				}
				
				// check if currently in double quoted string
				if(cChar == '"' && !stringModeSingle && !regexMode){
					if(pChar != '' && (pChar != '\\' /*|| (pChar == '\\' && ppChar == '\\')*/ || (pChar == '\\' && ppChar == '\\' && pppChar != '\\')) ){
						stringModeDouble = !stringModeDouble;
					}
				}
				
				// check if currently in single quoted string
				if(cChar == "'" && !stringModeDouble && !regexMode){
					if(pChar != '' && (pChar != '\\' /*|| (pChar == '\\' && ppChar == '\\')*/ || (pChar == '\\' && ppChar == '\\' && pppChar != '\\')) ){
						stringModeSingle = !stringModeSingle;
					}
				}
				
				// remove singleline comment
				if(!stringModeDouble && !stringModeSingle && !regexMode && cChar == '/' && nChar == '/'){
					var cs1:String = s.substring(i, s.indexOf(separator, i+2)+separator.length);
					
					if(
						(preserveLegal && !hasDisclaimer(cs1))
						||
						!preserveLegal
					){
						s = s.slice(0, i) + s.slice(s.indexOf(separator, i+2)+separator.length);
						i--;
					}
					else {
						i = s.indexOf(separator, i+2)+separator.length;
					}
					
				}
				
				// remove multiline comment
				// if preserveLegal = true, a comment block with a copyright, disclaimer or trademark is kept
				// if the string "start 
				else if(!stringModeDouble && !stringModeSingle && !regexMode && cChar == '/' && nChar == '*'){
					var cs2:String = s.substring(i, s.indexOf('*/', i+2) + 2);
					
					
					/*if(cs2.indexOf('') > -1){
						
					}
					else */ {
						
						if(
							(preserveLegal && !hasDisclaimer(cs2))
							||
							!preserveLegal
						){
							s = s.slice(0, i) + s.slice(s.indexOf('*/', i+2)+2);
							i--;
						}
						else {
							i = s.indexOf('*/', i+2);
						}
						
					}
				}
				
				// remove double whitespaces
				else if(!stringModeDouble && !stringModeSingle && !regexMode && (cChar == ' ' || cChar == '\t') && (pChar == '' || pChar == ' ' || pChar == '\t')){
					s = s.slice(0, i) + s.slice(i+1);
					i--;
				}
				
				// remove whitespace if applicable (only if whitespace is between 2 non alfanumerical chars (excluded: underscore (_), jQuery ($))
				// e.g.
				// var temp = 'some  value' ;
				// becomes
				// var temp='some  value';
				else if(
					!stringModeDouble && !stringModeSingle && !regexMode && (cChar == ' ' || cChar == '\t' || (removeNewLines && (cChar == '\n' || cChar == '\r') && nWord != 'function' && nWord != '$'))
					&&
					((pChar == '' || pChar.replace(/\_|\$|[a-z]|[0-9]/gi, '') != '') || (nChar == '' || nChar.replace(/\_|\$|[a-z]|[0-9]/gi, '') != ''))
				){
					s = s.slice(0, i) + s.slice(i+1);
					i--;
				}
				
				// remove '1 opening bracket on line'
				else if(i > 0 && !stringModeDouble && !stringModeSingle && !regexMode && (cChar == '{' || cChar == '[') && (pChar == '\n' || pChar == '\r')){
					s = s.slice(0, i-1) + s.slice(i);
					i--;
				}
				
				// remove '1 closing bracket on line'
				/*if(i < s.length-1 && !stringModeDouble && !stringModeSingle && !regexMode && (cChar == '}' || cChar == ']') && (nChar == '\n' || nChar == '\r')){
					s = s.slice(0, i+1) + s.slice(i+2);
					i--;
				}*/
				
				i++;	// Next char
				
			}
			
			
			/*
				TODO: 
					- varname smallifier: scopes? only in function?
					- function names smaller: which? no private property, functions in other function?
					- functions on 1 line: how to determine?
					
			*/
			
			
			while(s.indexOf(separator+separator) > -1){
				s = s.split(separator+separator).join(separator);
			}
			
			var a:Array = s.split('\nfunction ');
			for(var j:Number=0; j<a.length; j++){
				//...
			}
			
			
			// remove first line if empty
			if(s.charAt(0) == '\n'){
				s = s.substr(1);
			}
			// remove last line if empty
			if(s.charAt(s.length-1) == '\n'){
				s = s.substr(0, s.length-1);
			}
			
			return s;
			
		}
		
		
		private static function hasDisclaimer(value:String):Boolean {
			value = value.toLowerCase();
			var retval:Boolean = false
			if(value != ''){
				for(var i:Number=0; i<legalEntities.length; i++){
					if(value.indexOf(String(legalEntities[i]).toLowerCase()) > -1){
						retval = true;
						break;
					}
				}
			}
			
			return retval;
		}
		
		
		/*public static function removeWhiteSpace(value:String):String {
			
			if(value.indexOf("\r\n") > -1){
				value = value.replace(/\r\n/g, '\n');
			}
			
			// convert mac delimiters to \n
			if(value.indexOf("\r") > -1 && value.indexOf("\n") == -1){
				value = value.replace(/\r/g, '\n');
			}
			
			// replace tabs with spaces
			value = value.replace(/\t/g, ' ');
			
			// remove double spaces
			while(value.indexOf('  ') > -1){
				value = value.replace(/  /g, ' ');
			}
			
			// replace newline+space with newline 
			// remove spaces from beginning of line
			value = value.replace(/\n /g, '\n');
			// remove spaces from end of line
			value = value.replace(/ \n/g, '\n');
			
			
			// remove empty lines
			while(value.indexOf('\n\n') > -1){
				value = value.replace(/\n\n/g, '\n');
			}
			
			return value;
		}*/
		
		public static function removeWhiteSpace(value:String):String {
			
			var separator:String = "\n";
			if(value.indexOf("\r\n") > -1){
				separator = "\r\n";
			}
			else if(value.indexOf("\r") > -1){
				separator = "\r";
			}
			
			if(value.indexOf("\r\n") > -1){
				value = value.replace(/\r\n/g, '\n');
			}
			
			// convert mac delimiters to \n
			if(value.indexOf("\r") > -1 && value.indexOf("\n") == -1){
				value = value.replace(/\r/g, '\n');
			}
			
			// replace tabs with spaces
			value = value.replace(/\t/g, ' ');
			
			// remove double spaces
			while(value.indexOf('  ') > -1){
				value = value.replace(/  /g, ' ');
			}
			
			// replace newline+space with newline 
			// remove spaces from beginning of line
			value = value.replace(/\n /g, '\n');
			// remove spaces from end of line
			value = value.replace(/ \n/g, '\n');
			
			
			// remove empty lines
			while(value.indexOf('\n\n') > -1){
				value = value.replace(/\n\n/g, '\n');
			}
			
			// remove first line if empty
			if(value.charAt(0) == '\n'){
				value = value.substr(1);
			}
			// remove last line if empty
			if(value.charAt(value.length-1) == '\n'){
				value = value.substr(0, value.length-1);
			}
			
			value = value.replace(/\n/g, separator);
			
			return value;
		}
		
		
	}
}