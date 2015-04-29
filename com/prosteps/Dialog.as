package com.prosteps
{
	import dialogs.ChoiceDialog2;
	import dialogs.ConfirmDialog2;
	import dialogs.InputDialog2;
	import dialogs.ListDialog2;
	import dialogs.MessageDialog2;
	import dialogs.ProgressDialog;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * dispatched when a dialog is shown (multiple messages only fire this event once)
	 * */
	[Event(name="showDialog", type="flash.events.Event")]
	
	/**
	 * dispatched when a dialog closes
	 * */
	[Event(name="hideDialog", type="flash.events.Event")]
	
	
	/**
	 * Dialog functions:
	 * 	- message
	 * 	- error
	 * 	- confirm
	 * 	- choice
	 * 	- input
	 * 	- select
	 * 	- showLoader
	 * 	- hideLoader
	 * */
	public class Dialog extends EventDispatcher
	{
		
		public static const TYPE_WARNING:	String = 'warning';
		public static const TYPE_ERROR:		String = 'error';
		public static const TYPE_HELP:		String = 'help';
		public static const TYPE_INFO:		String = 'info';
		public static const TYPE_ABOUT:		String = 'about';
		public static const TYPE_UNKNOWN:	String = 'unknown';
		
		//public static const MODE_NATIVE:	String = 'native';
		//public static const MODE_FLASH:		String = 'flash';
		
		
		
		public function Dialog()
		{
			super();
		}
		
		
		private static var _instance:Dialog;
		
		/**
		 * Singleton implementation
		 * */
		public static function get instance():Dialog {
			if(_instance == null){
				_instance = new Dialog;
			}
			return _instance;
		}
		
		
		/* *
		 * Whether the dialogs are native Windows (native) or Panels (flash)
		 * * /
		[Inspectable(category="General", enumeration="native,flash", defaultValue="native")]
		public var mode:String = MODE_NATIVE;*/
		
		
		/**
		 * Show a message with icon and OK-button
		 * if multiple messages are shown after each other, 
		 * then they will be showed in a queue
		 * */
		public function message(message:String, title:String = 'Message', type:String = TYPE_INFO): void {
			
			_messages.addItem({message: message, title: title, type: type});
			
			if(_dlgMessage == null){
				_dlgMessage = new MessageDialog2;
				_dlgMessage.addEventListener('confirmation', onMsgConfirm, false, 0, true);
			}
			
			showMsg();
			dispatchEvent(new Event('showDialog'));
		}
		
		
		/**
		 * Show an error message
		 * 'error' icon and OK-button
		 * if multiple errors are shown after each other, 
		 * then they will be showed in a queue
		 * */
		public function error(errorMessage:String, title:String = 'Error'): void {
			message(errorMessage, title, TYPE_ERROR);
		}
		
		
		
		/**
		 * Show a dialog with 2 buttons: OK and Cancel
		 * */
		public function confirm(message:String, title:String, okHandler:Function, cancelHandler:Function = null): void {
			
			_okHandlerFunction = okHandler;
			_cancelHandlerFunction = cancelHandler;
			
			if(_dlgConfirm == null){
				_dlgConfirm = new ConfirmDialog2;
			}
			
			_dlgConfirm.open();
			_dlgConfirm.reset();
			_dlgConfirm.centerWindow();
			
			_dlgConfirm.title = title;
			_dlgConfirm.message = message;
			_dlgConfirm.messageType = TYPE_HELP;
			
			_dlgConfirm.addEventListener('okEvent', okHandlerInternal, false, 0.0, true);
			_dlgConfirm.addEventListener('cancelEvent', cancelHandlerInternal, false, 0.0, true);
			
			dispatchEvent(new Event('showDialog'));
		}
		
		
		
		/**
		 * Show a dialog with 3 buttons: Choise 1, Choise 2 and Cancel
		 * */
		public function choice(message:String, title:String, 
			choise1Prompt:String, choise1Handler:Function, 
			choise2Prompt:String, choise2Handler:Function, 
			cancelHandler:Function = null
		):void {
			_Choise1Function = choise1Handler;
			_Choise2Function = choise2Handler;
			_cancelChoiseFunction = cancelHandler;
			
			if(_dlgChoice == null){
				_dlgChoice = new ChoiceDialog2;
				
			}
			
			_dlgChoice.open();
			_dlgChoice.reset();
			
			_dlgChoice.centerWindow();
			
			_dlgChoice.title = title;
			_dlgChoice.message = message;
			
			_dlgChoice.choise1 = choise1Prompt != null && choise1Prompt != '' ? choise1Prompt : 'Yes';
			_dlgChoice.choise2 = choise2Prompt != null && choise2Prompt != '' ? choise2Prompt : 'No';
			
			_dlgChoice.messageType = TYPE_HELP;
			
			_dlgChoice.addEventListener('choice1Event', internal_choise1Handler, false, 0.0, true);
			_dlgChoice.addEventListener('choice2Event', internal_choise2Handler, false, 0.0, true);
			_dlgChoice.addEventListener('cancelEvent', internal_cancelHandler, false, 0.0, true);
			
			dispatchEvent(new Event('showDialog'));
		}
		
		
		/**
		 * Display a popup with a TextInput field
		 * parameters:
		 * 	title:		a title for the popup
		 * 	message:	text that comes with the inputfield, containing user instructions on what to enter
		 * 	inputHandler:	function that gets called when user clicks 'Ok', takes a string as parameter containing the entered value
		 * 	previousValue:	initial TextInput value (for when some data is being replaced/updated)
		 * 	validate:		type of user input which is enabled,
		 * 					types are:
		 * 						float		 : enter a numeric value containing , and . (positive or negative)
		 * 						int			 : enter a numeric value (positive or negative)
		 * 						textonly	 : only text can be entered (a-z, A-Z, spaces)
		 * 						alphanumeric : only alphanumerical characters are allowed (a-z, A-Z, 0-9, spaces)
		 * 						hex			 : to enable hexadecimal values only (0-9, a-f, spaces)
		 * 						text		 : all characters are enabled, DEFAULT
		 * 						largetext	 : large textinput is shown, no validation
		 * 						textrequired : all characters are enabled, text must be entered
		 * minimum, maximum:	when validate = 'float' or 'int', the entered value must be between these values
		 * */
		public function input(title:String, message:String, inputHandler:Function, previousValue:String='', validate:String='text', minimum:Number=0, maximum:Number=0): void {
			_inputHandlerFunction = inputHandler;
			
			if(_dlgInput == null){
				_dlgInput = new InputDialog2;
			}
			
			_dlgInput.open();
			_dlgInput.reset();
			
			_dlgInput.centerWindow();
			
			_dlgInput.title = title;
			_dlgInput.message = message;
			_dlgInput.minimum = minimum;
			_dlgInput.maximum = maximum;
			_dlgInput.validate = validate;
			_dlgInput.edt.text = previousValue;
			_dlgInput.edt2.text = previousValue;
			
			_dlgInput.messageType = TYPE_HELP;
			
			
			_dlgInput.addEventListener('okEvent', inputOkHandlerInternal, false, 0.0, true);
			_dlgInput.addEventListener('cancelEvent', inputCancelHandlerInternal, false, 0.0, true);
			
			dispatchEvent(new Event('showDialog'));
		}
		
		
		/**
		 * Indicates if a loader dialog is shown
		 * */
		[Bindable] public var loaderIsShown:Boolean = false;
		
		
		/**
		 * show a small dialog with 'loading...' and percentage
		 * */
		public function showLoader(title:String, text:String, value:Number, total:Number=100, disableApp:Boolean = true, indeterminate:Boolean=false):void {
			if(_progressDialog == null){
				_progressDialog = new ProgressDialog;
			}
			if(!loaderIsShown){
				loaderIsShown = true;
				_progressDialog.open();
				_progressDialog.reset();
				
				_progressDialog.centerWindow();
			}
			_progressDialog.message = text;
			_progressDialog.title = title;
			
			if(indeterminate){
				_progressDialog.pb.enabled = true;
				_progressDialog.pb.indeterminate = true;
			}
			else {
				_progressDialog.pb.indeterminate = false;
				_progressDialog.pb.enabled = false;
				_progressDialog.pb.setProgress(value, total);
			}
		}
		
		
		/**
		 * hide the loader dialog
		 * */
		public function hideLoader():void {
			_progressDialog.close();
			loaderIsShown = false;
		}
		
		
		
		
		/**
		 * Function to select an item from a given list (lookups, custom data, ...).
		 * The result function must take an Object as parameter. This object will be the selected item
		 * skipIfOne: if true, don't show the dialog, but instantly call the result function
		 * */
		public function select(data:ArrayCollection, labelField:String, title:String, info:String, resultFunction:Function, skipIfOne:Boolean = true):void {
			dlgSelectFromList_resultFunction = resultFunction;
			
			if(skipIfOne && data.length == 1){
				if(resultFunction != null){
					resultFunction(data[0]);
				}
			}
			else {
				if(dlgSelectFromList == null){
					dlgSelectFromList = new ListDialog2;
					dlgSelectFromList.addEventListener('confirmation', onDlgSelectFromListDone, false, 0, true);
				}
				dlgSelectFromList.open();
				dlgSelectFromList.reset();
				
				dlgSelectFromList.centerWindow();
				
				dlgSelectFromList.title = title;
				dlgSelectFromList.info = info;
				dlgSelectFromList.lst.labelField = labelField;
				dlgSelectFromList.lst.dataProvider = data;
				
			}
			
		}
		
		
		
		
		//////////////////////////////////////////
		
		
		// message
		private var _dlgMessage:MessageDialog2;
		
		// ok-cancel
		private var _dlgConfirm:ConfirmDialog2;
		private var _okHandlerFunction:Function;
		private var _cancelHandlerFunction:Function;
		
		// choise
		private var _dlgChoice:ChoiceDialog2;
		private var _Choise1Function:Function;
		private var _Choise2Function:Function;
		private var _cancelChoiseFunction:Function;
		
		// input
		private var _dlgInput:InputDialog2;
		private var _inputHandlerFunction:Function;
		
		// loader
		private var _progressDialog:ProgressDialog;
		
		// select from list
		private var dlgSelectFromList:ListDialog2;
		private var dlgSelectFromList_resultFunction:Function;
		
		
		private var _messages:ArrayCollection = new ArrayCollection;
		
		
		private function showMsg():void {
			
			_dlgMessage.open();
			_dlgMessage.reset();
			
			_dlgMessage.centerWindow();
			
			_dlgMessage.title = _messages[0].title;
			_dlgMessage.message = _messages[0].message;
			_dlgMessage.messageType = _messages[0].type;
			
		}
		
		private function onMsgConfirm(event:Event):void {
			_messages.removeItemAt(0);
			if(_messages.length > 0){
				showMsg();
			}
			else {
				dispatchEvent(new Event('hideDialog'));
			}
		}
		
		
		
		
		private function okHandlerInternal(event:Event):void {
			dispatchEvent(new Event('hideDialog'));
			_dlgConfirm.removeEventListener('okEvent', okHandlerInternal);
			_dlgConfirm.removeEventListener('cancelEvent', cancelHandlerInternal);
			_okHandlerFunction();
		}
		
		private function cancelHandlerInternal(event:Event):void {
			dispatchEvent(new Event('hideDialog'));
			_dlgConfirm.removeEventListener('okEvent', okHandlerInternal);
			_dlgConfirm.removeEventListener('cancelEvent', cancelHandlerInternal);
			if(_cancelHandlerFunction != null) _cancelHandlerFunction();
		}
		
		
		
		
		
		private function internal_choise1Handler(event:Event):void {
			dispatchEvent(new Event('hideDialog'));
			_dlgChoice.removeEventListener('choice1Event', internal_choise1Handler);
			_dlgChoice.removeEventListener('choice2Event', internal_choise2Handler);
			_dlgChoice.removeEventListener('cancelEvent', internal_cancelHandler);
			if(_Choise1Function != null)	_Choise1Function();
		}
		
		private function internal_choise2Handler(event:Event):void {
			dispatchEvent(new Event('hideDialog'));
			_dlgChoice.removeEventListener('choice1Event', internal_cancelHandler);
			_dlgChoice.removeEventListener('choice2Event', internal_choise2Handler);
			_dlgChoice.removeEventListener('cancelEvent', internal_cancelHandler);
			if(_Choise2Function != null)	_Choise2Function();
		}
		
		private function internal_cancelHandler(event:Event):void {
			dispatchEvent(new Event('hideDialog'));
			_dlgChoice.removeEventListener('choice1Event', internal_cancelHandler);
			_dlgChoice.removeEventListener('choice2Event', internal_choise2Handler);
			_dlgChoice.removeEventListener('cancelEvent', internal_cancelHandler);
			if(_cancelChoiseFunction != null)	_cancelChoiseFunction();
		}
		
		
		
		
		private function inputOkHandlerInternal(event:Event):void {
			dispatchEvent(new Event('hideDialog'));
			_dlgInput.removeEventListener('okEvent', inputOkHandlerInternal);
			_dlgInput.removeEventListener('cancelEvent', inputCancelHandlerInternal);
			_inputHandlerFunction(_dlgInput.edt.text);
		}
		
		private function inputCancelHandlerInternal(event:Event):void {
			dispatchEvent(new Event('hideDialog'));
			_dlgInput.removeEventListener('okEvent', inputOkHandlerInternal);
			_dlgInput.removeEventListener('cancelEvent', inputCancelHandlerInternal);
			//_inputHandlerFunction(event);
		}
		
		
		
		private function inputHandlerInternal(event:Event):void {
			_dlgInput.removeEventListener('okEvent', inputHandlerInternal);
			_inputHandlerFunction(_dlgInput.aText);
		}
		
		
		
		private function onDlgSelectFromListDone(event:Event):void {
			if(dlgSelectFromList_resultFunction != null){
				dlgSelectFromList_resultFunction(dlgSelectFromList.selectedItem);
			}
			dlgSelectFromList_resultFunction = null;
		}
	
		
		
		
	}
	
}
