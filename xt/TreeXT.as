package xt
{
	import flash.events.Event;
	
	import mx.collections.XMLListCollection;
	import mx.controls.Tree;
	import mx.events.ListEvent;
	
	[Event(name="itemSelect", type="mx.events.ListEvent")]
	[Event(name="treeSelect", type="mx.events.ListEvent")]
	[Event(name="allExpanded", type="flash.events.Event")]
	
	
	/**
	 * This Tree class is an extention of the mx Tree class
	 * with added functionality for handling opening/closing folders.
	 * 
	 * @author				wifle
	 * @datecreated			-
	 * @modified by			-
	 * @datemodified		-
	 */
	public class TreeXT extends mx.controls.Tree
	{
		public function TreeXT()
		{
			super();
			addEventListener(ListEvent.ITEM_CLICK, onItemClick, false, 0, true);
		}
		
		/**
		 * when set to true, the tree handles opening and closing of tree branches on it's own.
		 * that is, if you have set the idField and folderIndicator properties to respectively
		 * indicate which elements in the tree items represent a unique id per item and if the item is a folder
		 * */
		[Bindable] public var handleOpening:Boolean = false;
		
		/**
		 * 	Required when handleOpening = true
		 *  Storage for idField property.
		 * 	represents a unique id for an item in the dataprovider
		 */
		[Bindable] public var idField:String = '';
		
		/**
		 *  Storage for folder indicator property.
		 * 	indicates if a xml item is represented as a tree.
		 * 	example of a folder item with indicator folderIndicator="folder":
		 * 	<Item label="Some tree folder" folder="" />
		 * 
		 *	the folder indicator doesn't need data, it just needs to be set.
		 * 
		 * 	if handleOpening is set to true,
		 * 	items with this property set will not trigger an 'itemSelect' event when clicked,
		 * 	but the corresponding folder will open/close depending if it's already open or not
		 * 
		 * instead they will trigger a 'treeSelect' event
		 */
		[Bindable] public var folderIndicator:String = '';
		
		
		/**
		 * when set to true, the first level is automatically expanded after setting dataProvider
		 * */
		[Bindable] public var autoOpenFirst:Boolean = false;
		
		/**
		 * when set to true, the first level is automatically expanded after setting dataProvider
		 * */
		[Bindable] public var autoOpenAll:Boolean = false;
		
		
		/**
		 * set dataprovider to accept XML data and parse it correctly
		 * */
		override public function set dataProvider(value:Object):void {
			/*super.dataProvider = XML(value);
			
			// Eerste level open vouwen => Error!!!
			var nodeChildren:XMLListCollection = XMLListCollection(super.dataProvider);
			
			for(var i:int = 0; i<nodeChildren.length; i++) {
				try{ expandItem(nodeChildren.getItemAt(i),true); } catch(e:Error) {}
			}
			
			invalidateList();
			validateNow();
			
			callLater(callLater,[expandFirstLevel]);
			*/
			
			super.dataProvider = value;
			
			if(autoOpenAll){
				callLater(expandAll,[true]);
			}
			else if(autoOpenFirst){
				callLater(expandFirstLevel,[true]);
			}
				
		}
		
		
		
		private function onItemClick(event:ListEvent):void {
			if(handleOpening){
				event.stopImmediatePropagation();
				event.preventDefault();
				
				if(idField == ''){
					throw new Error('Could not handle itemClick on com.prosteps.components.Tree automatically, because the property idField is not set');
					return;
				}
				if(folderIndicator == ''){
					throw new Error('Could not handle itemClick on com.prosteps.components.Tree automatically, because the property folderIndicator is not set');
					return;
				}
				
				if(!hasOwnProperty('selectedItem') || selectedItem == null) return;
				
				//tree item click action
				if ( !selectedItem.hasOwnProperty( folderIndicator ) ) {
					
					dispatchEvent(new ListEvent('itemSelect'));
					
				}
				else {// expand tree folder
					var isOpen:Boolean = ( openItems.length==0 );
					
					for(var o:int=0; o<openItems.length; o++){
						if(openItems[o][ idField ] == selectedItem[ idField ] ){
							isOpen = false;
							break;
						}
						else isOpen = true;
					}
					
					expandItem(selectedItem, isOpen, true, false);
					
					dispatchEvent(new ListEvent('treeSelect'));
					
				}
			}
		}
		
		
		
		
		public function expandFirstLevel(open:Boolean = true):void {
			//var children:XMLList = XMLList(dataProvider).children();
			var children:Object = dataProvider;
			for(var i:int=children.length-1; i>=0; i--){
				selectedIndex = i;
				invalidateList();
				expandItem(selectedItem, open, false);
			}
			
		}
		
		public function expandAll(open:Boolean = true):void {
			expandFirstLevel(false);
			
			//var children:XMLList = XMLList(dataProvider).children();
			var children:Object = dataProvider;
			
			for(var i:int=children.length-1; i>=0; i--){
				selectedIndex = i;
				invalidateList();
				expandChildrenOf( selectedItem, open );
			}
			dispatchEvent(new Event('allExpanded'));
		}
		
		
		
		
	}
	
}
