package utils
{
	import mx.containers.Form;
	import mx.containers.FormItem;
	import mx.controls.ComboBox;
	import mx.controls.DateChooser;
	import mx.controls.DateField;
	import mx.controls.Text;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	import mx.events.ValidationResultEvent;
	import mx.validators.EmailValidator;
	
	
	/**
	 * Validation Utilities for various components
	 * 
	 * Usage:
	 * 
	 * a variabele to see if the validation succeeded for all components
	 * <code>var valid:Boolean = true;</code>
	 * 
	 * calls to the validation utilities, followed by the 'valid' variabele.
	 * place the 'valid' var at the end of each validation like this:
	 * 
	 * <code>
	 * 	valid = ValidationUtils.text(component1, 'error string for component 1') && valid;
	 * 	valid = ValidationUtils.text(component2, 'error string for component 2') && valid;
	 * </code>
	 * 
	 * or else the errorstrings will not be set to each component if one validation fails,
	 * because an &&-expression does not continue when a sub-expression equals false
	 * 
	 * at the end, you can do something like this:
	 * <code>
	 * 	if(valid){
	 * 		doFunctionForValidData();
	 * 	}
	 * </code>
	 * 
	 * */
	public class ValidationUtils
	{
		
		/**
		 * For label 'required', like FormItem required=true
		 * */
		public static const REQUIRED_INDICATOR:String = '<font color="#CC0000">*</font>';
		
		
		/**
		 * check if textfield contains text (spaces are ignored)
		 * */
		public static function text(component:UIComponent, errorString:String=''):Boolean {
			var valid:Boolean = false;
			
			if(component is TextInput || component is TextArea){
				valid = Object(component).text.split(' ').join('') != '';
			}
			
			component.errorString = valid ? '' : errorString;
			
			return valid;
		}
		
		
		
		/**
		 * check if one of the given textfields has a value entered
		 * */
		public static function texts(errorString:String='', ...textFields):Boolean {
			var valid:Boolean = false;
			var i:int=0;
			
			for(i=0; i<textFields.length; i++){
				if(textFields[i] is TextInput || textFields[i] is TextArea){
					if(textFields[i].text.split(' ').join('') != ''){
						valid = true;
						break;
					}
				}
			}
			
			for(i=0; i<textFields.length; i++){
				if(textFields[i] is TextInput || textFields[i] is TextArea){
					if(valid){
						textFields[i].errorString = '';
					}
					else {
						textFields[i].errorString = errorString;
					}
				}
			}
			
			return valid;
		}
		
		
		
		
		private static var valEmail:EmailValidator;
		
		/**
		 * check if email address is valid
		 * */
		public static function email(component:TextInput, errorString:String=''):Boolean {
			if(valEmail == null){
				valEmail = new EmailValidator;
			}
			
			var valid:Boolean = valEmail.validate(component.text).type == ValidationResultEvent.VALID;
			component.errorString = valid ? '' : errorString;
			
			return valid;
		}
		
		
		
		
		
		
		
		
		
		/**
		 * check if combobox has a value selected
		 * */
		public static function comboBox(component:ComboBox, errorString:String=''):Boolean {
			var valid:Boolean = component.selectedItem != null;
			component.errorString = valid ? '' : errorString;
			
			return valid;
		}
		
		
		
		
		/**
		 * check if one of the given comboBoxes has a value selected
		 * */
		public static function comboBoxes(errorString:String='', ...comboBoxes):Boolean {
			var valid:Boolean = false;
			var i:int=0;
			
			for(i=0; i<comboBoxes.length; i++){
				if(comboBoxes[i] is ComboBox){
					if((comboBoxes[i] as ComboBox).selectedItem != null){
						valid = true;
						break;
					}
				}
			}
			
			for(i=0; i<comboBoxes.length; i++){
				if(comboBoxes[i] is ComboBox){
					if(valid){
						(comboBoxes[i] as ComboBox).errorString = '';
					}
					else {
						(comboBoxes[i] as ComboBox).errorString = errorString;
					}
				}
			}
			
			return valid;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * check if datefield/datechooser has a value selected
		 * id component is not of type datefield/datechooser, return false
		 * */
		public static function dateField(component:UIComponent, errorString:String=''):Boolean {
			var valid:Boolean = true;
			if(component is DateField || component is DateChooser){
				valid = Object(component).selectedDate != null;
			}
			else {
				valid = false;
			}
			component.errorString = valid ? '' : errorString;
			
			return valid;
		}
		
		
		/**
		 * check if one of the given dateFields has a value entered
		 * */
		public static function dateFields(errorString:String='', ...dateFields):Boolean {
			var valid:Boolean = false;
			var i:int=0;
			
			for(i=0; i<dateFields.length; i++){
				if(dateFields[i] is DateField || dateFields[i] is DateChooser){
					if(dateFields[i].text.split(' ').join('') != ''){
						valid = true;
						break;
					}
				}
			}
			
			for(i=0; i<dateFields.length; i++){
				if(dateFields[i] is DateField || dateFields[i] is DateChooser){
					if(valid){
						dateFields[i].errorString = '';
					}
					else {
						dateFields[i].errorString = errorString;
					}
				}
			}
			
			return valid;
		}
		
		
		
		/**
		 * check if textinput contains a valid date string
		 * */
		public static function dateString(component:TextInput, errorString:String=''):Boolean {
			var valid:Boolean = true;
			
			// TODO
			
			component.errorString = valid ? '' : errorString;
			
			return valid;
		}
		
		
		
		
		/**
		 * check if textinput contains a valid hour string
		 * */
		public static function hourString(component:TextInput, errorString:String='', errorStringHours:String='', errorStringMinutes:String=''):Boolean {
			var valid:Boolean = false;
			
			errorStringHours = errorStringHours == '' ? errorString : errorStringHours;
			errorStringMinutes = errorStringMinutes == '' ? errorString : errorStringMinutes;
			
			/*var re:RegExp = \\d\d:\d\d\;
			
			if(re.test(component.text)){
				var hours:int	= int(component.text.split(':')[0]);
				var minutes:int	= int(component.text.split(':')[1]);
				
				if(hours < 24 && minutes < 60){
					valid = true;
					component.errorString = '';
				}
				else if(hours > 23) component.errorString = errorStringHours;
				else if(minutes > 59) component.errorString = errorStringMinutes;
				else component.errorString = errorString;
			}*/
			
			if(component.text.length == 5){
				
				if(
					component.text.charAt(0) != ':' && 
					component.text.charAt(1) != ':' && 
					component.text.charAt(2) == ':' && 
					component.text.charAt(3) != ':' && 
					component.text.charAt(4) != ':'
				){
					var hours:int	= int(component.text.split(':')[0]);
					var minutes:int	= int(component.text.split(':')[1]);
					
					if(hours < 24 && minutes < 60){
						valid = true;
						component.errorString = '';
					}
					else if(hours > 23) component.errorString = errorStringHours;
					else if(minutes > 59) component.errorString = errorStringMinutes;
					else component.errorString = errorString;
				}
				else component.errorString = errorString;
			}
			else component.errorString = errorString;
			
			return valid;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		/** 
		 * Controle BTW nummer (enkel BE en NL btw nummers)
		 * BE: BE0123456749
		 * NL: NL811641387
		 * */
		public static function btwNummer(component:TextInput, errorString:String=''):Boolean {
			var valid:Boolean = false;
  			
  			var btwNr:String = component.text.toUpperCase()
  				.split(' ').join('')
  				.split('-').join('')
  				.split('.').join('')
  				.split('_').join('')
  				.split(',').join('')
  			;
  			
			if(btwNr.indexOf('BE') == 0){
				//Eerst opmaak wegdoen indien nodig
				if(btwNr.substr(0,3) == 'BE0')		btwNr = btwNr.substring(3);
				else if(btwNr.substring(0,2) == 'BE')	btwNr = btwNr.substring(2);
				
				if(btwNr.length > 9){
					//aBTWnummer := copy(aBTWnummer,1,3)+ copy(aBTWnummer,5,3)+ copy(aBTWnummer,9,3);
					//??
				}
				
				//Als lengte klopt, check doen
				if(btwNr.length == 9){
					var tmp_btw:int = int(btwNr.substr(0,7));
					if(tmp_btw > 0)
					valid = !( (97 - (tmp_btw % 97)) != int(btwNr.substr(7)));
				}
			}
			
			//Opmaak corrigeren
			else if(btwNr.substr(0,2) == 'NL') {
				btwNr = btwNr.substr(2);
				
				// Laatste 3 chars hebben we niet nodig ?? waarom niet?
				//btwNr = btwNr.substring(0,btwNr.length-3);
				
				if(btwNr.length > 9){
					// aBTWnummer := copy(aBTWnummer,1,3)+ copy(aBTWnummer,5,3)+ copy(aBTWnummer,9,3);
					// ??
				}
				
				//Nu check doen als lengte klopt
				if(btwNr.length == 9){
					var produktsom:int = 0;
					
					for(var i:int=7; i>=0; i--){
						produktsom += (int(btwNr.charAt(i)) * (10-(i+1)));
					}
					valid = (produktsom % 11) == int(btwNr.charAt(8));
				}
			}
			else {
				//valid = true;
			}
			
			component.errorString = valid ? '' : errorString;
			
			return valid;
		}
		
		
		
		
		
		
		
		
		
		/** 
		 * Controle van een telefoonnr. (BE)
		 * 
		 *	+32 14 551202		= true
		 *	+32 14 55120
		 *	003  14 551202
		 *	0032 14 551202		= true
		 *	+32 472 45 36 78	= true
		 *	+32 47  45 36 78	= true
		 *	0032 472 45 36 78	= true
		 *	032  472 45 36 78
		 *	072 45 36 78		= true
		 *	0472 45 36 78		= true
		 *	014/58 69 5
		 *	014/58 69 45		= true
		 *	03/58  56 23
		 *	03/584 56 23		= true
		 * 
		 * */
		public static function phoneNr(component:TextInput=null, errorString:String=''):Boolean {
			var valid:Boolean = false;
			
			var pn:String = component.text
				.split(' ').join('')
				.split('/').join('')
				.split('.').join('')
				.split('-').join('')
				.split('_').join('')
				.split(',').join('')
				.split(';').join('')
			;
			
			if(pn != ''){
				// +3214551202 -> 014551202
				if(pn.indexOf('+32') == 0){
					pn = '0' + pn.substr(3);
					/*if(/ *pn.charAt(0) == '1' &&* / pn.length == 8) valid = true;
					else if(/ *pn.charAt(0) != '1'* / && pn.length == 9) valid = true;*/
				}
				// 003214551202 -> 014551202
				else if(pn.indexOf('0032') == 0){
					pn = '0' + pn.substr(4);
					/*if(pn.charAt(0) == '1' && pn.length == 8) valid = true;
					else if(pn.charAt(0) != '1' && pn.length == 9) valid = true;*/
				}
				
				// 014551202 = 9,	0472453678 = 10
				if(pn.length == 9 || pn.length == 10){
					valid = true;
				}
			}
			
			component.errorString = valid ? '' : errorString;
			
			return valid;
		}
		
		
		
		
		/**
		 * For form() function: errorString for textfield
		 * */
		public static var formTextfieldRequiredError:String = '';
		
		/**
		 * For form() function: errorString for combobox
		 * */
		public static var formComboboxRequiredError:String = '';
		
		/**
		 * For form() function: errorString for datefield
		 * */
		public static var formDateRequiredError:String = '';
		
		
		/**
		 * Validate complete form
		 * All FormItems which are required and contain a child which is a
		 * 	- TextInput
		 * 	- TextArea
		 * 	- ComboBox
		 * 	- DateField
		 * 	- DateChooser
		 * */
		public static function form(form:Form):Boolean {
			var valid:Boolean = true;
			
			for(var i:int=0; i<form.numChildren; i++){
				if(form.getChildAt(i) is FormItem && (form.getChildAt(i) as FormItem).required){
					var fi:FormItem = form.getChildAt(i) as FormItem;
					var c:Object = fi.numChildren == 1 ? fi.getChildAt(0) : null;
					
					if(c != null){
						
						if(c is TextInput || c is TextArea){
							valid = text(c as UIComponent, formTextfieldRequiredError) && valid;
						}
						
						if(c is ComboBox){
							valid = comboBox(c as ComboBox, formComboboxRequiredError) && valid;
						}
						
						if(c is DateField || c is DateChooser){
							valid = dateField(c as UIComponent, formTextfieldRequiredError) && valid;
						}
						
					}
					
				}
			}
			
			return valid;
		}
		
		
		
		
		
		
		
	}
	
}