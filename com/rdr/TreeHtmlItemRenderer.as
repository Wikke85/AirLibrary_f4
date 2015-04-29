package com.rdr
{
	import mx.controls.treeClasses.TreeItemRenderer;
	
	/**
	 * This TreeHtmlItemRenderer class is an extention of the mx TreeItemRenderer class.
	 * Set the itemRenderer property of a tree to this class to be able to use html as label.
	 * Also works if the labelFunction returns html.
	 * 
	 * @author				wifle
	 * @datecreated			-
	 * @modified by			-
	 * @datemodified		-
	 */
	public class TreeHtmlItemRenderer extends TreeItemRenderer
	{
		public function TreeHtmlItemRenderer()
		{
			super();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (label != null)
			{
				// the magic:
				label.htmlText = label.text;
			}
		}
	}
	
}
