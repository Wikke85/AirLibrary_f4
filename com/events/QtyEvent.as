package com.events
{
	import flash.events.Event;

	public class QtyEvent extends Event
	{
		
		public static const TOTALS_SET:String	= 'totalsSet';
		public static const QTY_SAVING:String	= 'qtySaving';
		public static const QTY_SAVED:String	= 'qtySaved';
		
		
		private var _id_artikel_maat:int = -1;
		private var _qty:int = -1;
		private var _qty_valid:Boolean = false;
		private var _maat:String = '';
		
		public function QtyEvent(type:String, id_artikel_maat:int, qty:int, qty_valid:Boolean, maat:String='', bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_id_artikel_maat	= id_artikel_maat;
			_qty				= qty;
			_qty_valid			= qty_valid;
			_maat				= maat;
		}
		
		public function get id_artikel_maat():int	{ return _id_artikel_maat; }
		public function get qty():int			{ return _qty; }
		public function get qty_valid():Boolean	{ return _qty_valid; }
		public function get maat():String		{ return _maat; }
		
	}
}