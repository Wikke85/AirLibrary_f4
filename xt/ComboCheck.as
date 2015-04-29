/*
 * ComboCheck
 * v1.1
 * Arcadio Carballares Martín, 2009
 * http://www.carballares.es/arcadio
 */
package xt {
	
	import xt.combo.ComboCheckDropDownFactory;
	import xt.combo.ComboCheckEvent;
	import xt.combo.ComboCheckItemRenderer;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.ComboBox;
	import mx.core.ClassFactory;
	import mx.events.FlexEvent;
	
	[Event(name="addItem", type="flash.events.Event")]
	
    public class ComboCheck extends ComboBox {
    	
    	private var _selectedItems:ArrayCollection;
    	private var _dataSelectedField:String = 'selected';
    	private var _multiLabelField:String;
    	private var _multiLabelSeparator:String = ', ';
    	
    	[Bindable("change")]
    	[Bindable("valueCommit")]
    	[Bindable("collectionChange")]
    	public function set selectedItems(value:ArrayCollection):void {
    		_selectedItems=value;
			callLater(invalidateLabel);
    	}
    	public function get selectedItems():ArrayCollection {
    		return _selectedItems;
    	}
    	
    	
		override public function set dataProvider(value:Object):void {
			super.dataProvider = value;
			callLater(invalidateLabel);
		}
		
    	/**
    	 * field to specify which field gets updated as selected
    	 * */
    	[Bindable]
    	public function set dataSelectedField(value:String):void {
    		_dataSelectedField = value;
    		ComboCheckItemRenderer.dataSelectedField = _dataSelectedField;
    	}
    	public function get dataSelectedField():String {
    		return _dataSelectedField;
    	}
    	
    	
    	/**
    	 * property to combine the combobox text when multiple items are selected
    	 * */
    	[Bindable]
    	public function set multiLabelField(value:String):void {
    		_multiLabelField = value;
    		invalidateLabel();
    	}
    	public function get multiLabelField():String {
    		return _multiLabelField;
    	}
    	
    	
    	/**
    	 * property to separate the multiple selected items that are displayed in the combobox
    	 * */
    	[Bindable]
    	public function set multiLabelSeparator(value:String):void {
    		_multiLabelSeparator = value;
    		invalidateLabel();
    	}
    	public function get multiLabelSeparator():String {
    		return _multiLabelSeparator;
    	}
    	
    	
        public function ComboCheck() {
            super();
            addEventListener("comboChecked", onComboChecked);
            addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            var render:ClassFactory = new ClassFactory(ComboCheckItemRenderer);
		    itemRenderer=render;
		    var myDropDownFactory:ClassFactory = new ClassFactory(ComboCheckDropDownFactory);
        	super.dropdownFactory = myDropDownFactory;
        	_selectedItems = new ArrayCollection();
        }
        
        private function onCreationComplete(event:Event):void {
        	dropdown.addEventListener(FlexEvent.CREATION_COMPLETE, onDropDownComplete);
        }
        
        private function onDropDownComplete(event:Event):void {
        	//trace ("dropdown complete!");
        }
        
        private function onComboChecked(event:ComboCheckEvent):void {
        	var obj:Object=event.obj;
        	var index:int=_selectedItems.getItemIndex(obj);
        	if (index == -1) {
        		_selectedItems.addItem(obj);
        	} else {
        		_selectedItems.removeItemAt(index);
        	}
        	
    		invalidateLabel();
    		
        	dispatchEvent(new Event("valueCommit"));
        	dispatchEvent(new Event("addItem"));
        }
        
        public function invalidateLabel():void {
        	if (_selectedItems.length > 1) {
        		if(_multiLabelField == '' || _multiLabelField == null){
        			text = 'multiple';
        		}
        		else {
        			text = '';
        			for(var i:int=0; i<_selectedItems.length; i++){
        				if(_selectedItems[i].hasOwnProperty(_multiLabelField)){
        					if(text != ''){
        						text += _multiLabelSeparator;
        					}
        					text += '' + _selectedItems[i][_multiLabelField];
        				}
        			}
        		}
        	}
        	if (_selectedItems.length == 1) {
        		text = _selectedItems.getItemAt(0)[labelField];
        	}
        	if (_selectedItems.length < 1) {
        		text = '';
        	}
        	
        }
        
    }
}