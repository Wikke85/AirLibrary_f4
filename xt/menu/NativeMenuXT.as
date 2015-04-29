package xt.menu
{
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	
	/**
	
	Menu bar defined by xml file/xml data
	
	Menu structure for NativeMenuXT.
	Make sure each item has a unique id, or else no correct working can be guaranteed!
	
	example of a menu item:
	<item id="unique_id1" label="label for the menu" 
		tooltip="the tooltip text" 
		icon="document_preferences"
		action="actioncode"
		enabled="true"
		icon="some_icon"
		separator="false"/>
	
	all properties are, strictly seen, optional; but for a correct working, you must enter as much as possible,
	at least label and action are necessary! () in case separator = false
	
	Changing label and/or toolTip changes the appearance without major impact.
	
	An item only needs the label property
	
	label: string; a label for the menu item, if not set, the item wont show
	tooltip: string; the tooltip text which appears on the menu item if it's an icon
		if no tooltip is set, the label will be used as tooltip
	icon: string; the image class name as defined in com.prosteps.Factory.Images
	action: string; internal command identifier - predefined in Capsugel_5p.mxml, function 'onMenuSelect'
	enabled: true or false; set menu item as enabled
	separator: true or false; if true, every other property is ignored and the menu item appears as a small line (aka separator)
	
	*/
	
	public class NativeMenuXT extends NativeMenu
	{
		
		public var childrenList:ArrayCollection = new ArrayCollection;
		public var menuList:ArrayCollection = new ArrayCollection;
		
		/**
		 * Constructor
		 * 
		 * XMLMenuDefinition: the XML representing the menu data
		 * */
		public function NativeMenuXT(XMLMenuDefinition:XML)
		{
			super();
			childrenList = new ArrayCollection;
			addChildrenToMenu(this, XMLMenuDefinition.children());
		}
		
		/**
		 * adds menu items to the current menu
		 * 
		 * XMLMenuDefinition: the XML representing the menu data
		 * */
		public function addChildren(XMLMenuDefinition:XML):void 
		{
			addChildrenToMenu(this, XMLMenuDefinition.children());
		}
		
		private function addChildrenToMenu(menu:NativeMenu, children:XMLList):NativeMenuItem
		{
			var menuItem:NativeMenuItem;
			var submenu:NativeMenu;
			
			for each (var child:XML in children)
			{
				var isSeparator:Boolean = false;
				var separatorTest:String = '';
				
				if(child.hasOwnProperty('@separator')){
					separatorTest = String(child.@separator);
				}
				if(child.hasOwnProperty('@isSeparator')){
					separatorTest = String(child.@isSeparator);
				}
				
				if(String(child.name()).toLowerCase() == 'separator'){
					isSeparator = true;
				}
				if(separatorTest.toLowerCase() == 'true' || separatorTest == '1'){
					isSeparator = true;
				}
				
				if (String(child.@label).length > 0)
				{
					menuItem = new NativeMenuItem(
						child.@label, 
						isSeparator
					);
				}
				else
				{
					menuItem = new NativeMenuItem(
						child.name(), 
						isSeparator
					);
					
				}
				
				menuItem.name = child.@id;
				
				/*if( child.hasOwnProperty('@enabled') ){
					switch(String(child.@enabled).toLowerCase()){
						case 'false':
							menuItem.enabled = false;
							break;
						
						case 'true':
							menuItem.enabled = true;
							break;
						
						default:
							
					}
				}*/
				menuItem.enabled = (child.hasOwnProperty('@enabled') && child.@enabled == true) || !child.hasOwnProperty('@enabled');
				
				/*menuItem.keyEquivalentModifiers = [Keyboard.CONTROL, Keyboard.SHIFT];
				menuItem.keyEquivalent = String( (child.hasOwnProperty('@key') && child.@key != '') ? child.@key : '' );
				menuItem.mnemonicIndex = int( (child.hasOwnProperty('@index') && child.@index != '') ? child.@index : -1 );*/
				
				if (child.children().length() > 0)
				{
					menuItem.submenu = new NativeMenu();
					addChildrenToMenu(menuItem.submenu,child.children());
					
					menuList.addItem(menuItem);
				}
				else {//if item is menu, don't add to array
					menuItem.data = {};
					menuItem.data.action	= child.hasOwnProperty('@action')	? String(child.@action)		: null;
					menuItem.data.icon		= child.hasOwnProperty('@icon')		? String(child.@icon)		: null;
					menuItem.data.tooltip	= child.hasOwnProperty('@tooltip')	? String(child.@tooltip)	: null;
					menuItem.data.id		= child.hasOwnProperty('@id')		? String(child.@id)			: '';
					
					childrenList.addItem(menuItem);
				}
				
				menu.addItem(menuItem);
			}
			return menuItem;
        }
        
        /***/
		public function enableMenuById(idMenuItem:String, value:Boolean):void {
			for(var i:int=0; i<childrenList.length; i++){
				if(childrenList[i].name == idMenuItem){
					childrenList[i].enabled = value;
				}
			}
		}
        
        /***/
		public function getMenuItemById(idMenuItem:String):NativeMenuItem {
			var m:NativeMenuItem;
			for(var i:int=0; i<childrenList.length; i++){
				if(childrenList[i].data.id == idMenuItem){
					m = childrenList[i];
					break;
				}
			}
			return m;
		}
		
        /***/
		public function getMenuById(idMenuItem:String):NativeMenuItem {
			var m:NativeMenuItem;
			for(var i:int=0; i<menuList.length; i++){
				if(menuList[i].id == idMenuItem){
					m = menuList[i];
					break;
				}
			}
			return m;
		}
		
		
	}
	
}
