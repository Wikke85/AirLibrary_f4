package xt
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.ComboBox;
	import mx.events.FlexEvent;
	
	[Event(name="dataProviderChange", type="flash.events.Event")]

	public class ComboBoxXT extends ComboBox 
	{
		
		public function ComboBoxXT(){
			super();
			prompt = ' ';
			styleName = 'ComboBoxXT';
			labelField = 'omschrijving';
			rowCount = 15;
		}
		
		
		/**
		 * toggles the dropdown 
		 * */
		public function toggle():void {
			downArrowButton_buttonDownHandler(new FlexEvent("buttonDown"));
		}
		
		/**
		 * Set selected item through label. requires 'labelField' to be set
		 */
	    [Inspectable(category="Data")]
	    
		[Bindable("change")]
	    [Bindable("collectionChange")]
	    [Bindable("valueCommit")]
		public function set selectedLabel(value:String):void {
			if(labelField == ''){
				throw new Error("Cannot set "+id+".selectedLabel, because property 'labelField' is not set");
				return;
			}
			for(var i:int=0; i<dataProvider.length; i++){
				if(dataProvider[i].hasOwnProperty(labelField)){
					if(value == dataProvider[i][labelField]){
						selectedIndex = i;
						invalidateDisplayList();
						return;
					}
				}
				else if(value == String(dataProvider[i])){
					selectedIndex = i;
					invalidateDisplayList();
					return;
				}
				else {
					if(value == dataProvider[i]){
						selectedIndex = i;
						invalidateDisplayList();
						return;
					}
				}
			}
			selectedIndex = -1;
			invalidateDisplayList();
		}
		
		
		/**
		 * Set selected item through id value. requires 'idField' to be set
		 */
		public var idField:String = '';
		
	    [Inspectable(category="Data")]
	    
		[Bindable("change")]
	    [Bindable("collectionChange")]
	    [Bindable("valueCommit")]
	    [Bindable]
		public function set selectedId(value:Object):void {
			if(idField == ''){
				throw new Error("Cannot set "+id+".selectedId, because property 'idField' is not set");
				return;
			}
			// callLater's to prevent a dataProvider change to clear the selectedId even when selectedId is a valid item
			callLater(callLater,[setSelectedId,[value]]);
		}
		public function get selectedId():Object {
			return selectedItem==null ? '' : selectedItem[idField];
		}
		
		private function setSelectedId(value:Object):void {
			for(var i:int=0; i<dataProvider.length; i++){
				if(dataProvider[i] != null && dataProvider[i].hasOwnProperty(idField) && value == dataProvider[i][idField]){
					selectedIndex = i;
					invalidateDisplayList();
					validateNow();
					return;
				}
			}
			selectedIndex = -1;
			invalidateDisplayList();
			validateNow();
		}
		
		
		
		[Bindable]
		override public function set dataProvider(value:Object):void {
			var _selectedId:Object = selectedId;
			
			super.dataProvider = value;
			
			doFilter();
			
			invalidateDisplayList();
			validateNow();
			
			if(_selectedId != '' && _selectedId != null) selectedId = _selectedId;
			
			dispatchEvent(new Event('dataProviderChange'));
		}
		
		
		private var _filterFunction:Function;
		
	    [Inspectable(category="Data")]
	    
		public function set filterFunction(value:Function):void {
			_filterFunction = value;
			doFilter();
		}
		
		public function get filterFunction():Function {
			return _filterFunction;
		}
		
		
		private function doFilter():void {
			if(/*_filterFunction != null &&*/ dataProvider != null){
				var arr:ArrayCollection = ArrayCollection(dataProvider);
				arr.filterFunction = _filterFunction;
				arr.refresh();
				dataProvider = arr;
			}
		}
		
		
		
		
	}
}