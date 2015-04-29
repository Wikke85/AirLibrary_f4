package xt
{
	import mx.containers.Form;
	import mx.containers.FormItem;
	import mx.controls.ComboBox;
	import mx.controls.DateChooser;
	import mx.controls.DateField;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	
	import utils.ValidationUtils;
	
	
	public class FormXT extends Form
	{
		
		public function FormXT()
		{
			super();
		}
		
		
		
		/**
		 * For validate() function: errorString for textfield
		 * 
		 * @default "This field is required";
		 * */
		[Bindable] public var formTextfieldRequiredError:String = 'This field is required';
		
		/**
		 * For validate() function: errorString for combobox
		 * 
		 * @default "This field is required";
		 * */
		[Bindable] public var formComboboxRequiredError:String = 'This field is required';
		
		/**
		 * For validate() function: errorString for datefield
		 * 
		 * @default "This field is required";
		 * */
		[Bindable] public var formDateRequiredError:String = 'This field is required';
		
		
		
		/**
		 * Validate complete form
		 * All FormItems which are required and contain a child which is a
		 * 	- TextInput
		 * 	- TextArea
		 * 	- ComboBox
		 * 	- DateField
		 * 	- DateChooser
		 * */
		public function validate():Boolean {
			var valid:Boolean = true;
			
			for(var i:int=0; i<numChildren; i++){
				if(getChildAt(i) is FormItem && (getChildAt(i) as FormItem).required){
					var fi:FormItem = getChildAt(i) as FormItem;
					var c:Object = fi.numChildren == 1 ? fi.getChildAt(0) : null;
					
					if(c != null){
						
						if(c is TextInput || c is TextArea){
							valid = ValidationUtils.text(c as UIComponent, formTextfieldRequiredError) && valid;
						}
						
						if(c is ComboBox){
							valid = ValidationUtils.comboBox(c as ComboBox, formComboboxRequiredError) && valid;
						}
						
						if(c is DateField || c is DateChooser){
							valid = ValidationUtils.dateField(c as UIComponent, formTextfieldRequiredError) && valid;
						}
						
					}
					
				}
			}
			
			return valid;
		}
		
		
	}
	
}
