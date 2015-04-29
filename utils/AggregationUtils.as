package utils
{
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	/**
	 * SQL grouping/aggregating functions
	 * - distinct
	 * - row_number
	 * - max
	 * - min
	 * - avg
	 * - sum
	 * - isnull
	 * 
	 * Warning:
	 * Performance may suck monkeyballs, but that's not the point
	 * */
	public class AggregationUtils
	{
		
		
		public function AggregationUtils()
		{
		}
		
		/*
		/**
		 * SELECT DISTINCT [fields] FROM [source]
		 * */
		public static function groupBy(source:ArrayCollection, fields:Array):ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			
			if(source != null && source.length > 0 && fields != null && fields.length > 0){
				var alreadyIn:int = 0;
				
				for(var s:int=0; s<source.length; s++){
					alreadyIn = 0;
					
					for(var r:int=0; r<result.length; r++){
						for(var f:int=0; f<fields.length; f++){
							if(result[r][ fields[f] ] == source[s][ fields[f] ]){
								alreadyIn++;
							}
						}
					}
					
					if(alreadyIn < fields.length){
						result.source.push({});
						
						for(var f2:int=0; f2<fields.length; f2++){
							result.source[result.source.length-1][fields[f2]] = source[s][ fields[f2] ];
						}
					}
					
				}
				
			}
			
			return result;
		}
		
		/**
		 * SELECT [source].*, row_number() over(partition by [partitionBy] order by [orderBy]) as [resultField] FROM [source]
		 * */
		/*public static function rowNumber(source:ArrayCollection, partitionBy:Array, orderBy:Array, resultField:String):ArrayCollection {
			//TODO: implement rowNumber
			var result:ArrayCollection = new ArrayCollection;
			var oldSort:ISort;
			var sf:SortField;
			var f:Array;
			var isNumeric:Boolean = false;
			if(source != null && source.length > 0 && resultField != null && resultField != ''){
				oldSort = source.sort;
				
				if(orderBy != null && orderBy.length > 0){
					source.sort = new Sort;
					source.sort.fields = [];
					
					for(var oi:int=0; oi<orderBy.length; oi++){
						f = orderBy[oi].split(' ');
						isNumeric = source[0][f[0]];
						sf = new SortField(f[0], true, f.length > 1 && String(f[1]).toLowerCase() == 'desc', isNumeric);
						source.sort.fields.push(sf);
					}
					source.refresh();
				}
				
				for(var s:int=0; s<source.length; s++){
					
				}
				
				source.sort = oldSort;
				source.refresh();
			}
			return result;
		}*/
		
		/**
		 * SELECT max([field]) FROM [source]
		 * */
		public static function max(source:ArrayCollection, field:String):Number {
			var result:Number = NaN;
			
			if(source != null && source.length > 0 && field != null && field != ''){
				result = 0;
				for(var s:int=0; s<source.length; s++){
					result = Math.max(result, source[s][field]);
				}
			}
			
			return result;
		}
		
		/**
		 * SELECT min([field]) FROM [source]
		 * */
		public static function min(source:ArrayCollection, field:String):Number {
			var result:Number = NaN;
			
			if(source != null && source.length > 0 && field != null && field != ''){
				result = source[0][field];
				for(var s:int=0; s<source.length; s++){
					result = Math.min(result, source[s][field]);
				}
			}
			
			return result;
		}
		
		/**
		 * SELECT avg([field]) FROM [source]
		 * */
		public static function avg(source:ArrayCollection, field:String):Number {
			var result:Number = NaN;
			
			if(source != null && source.length > 0 && field != null && field != ''){
				result = 0;
				for(var s:int=0; s<source.length; s++){
					result += source[s][field];
				}
				result = result / source.length;
			}
			
			return result;
		}
		
		/**
		 * SELECT sum([field]) FROM [source]
		 * */
		public static function sum(source:ArrayCollection, field:String):Number {
			var result:Number = NaN;
			
			if(source != null && source.length > 0 && field != null && field != ''){
				result = 0;
				for(var s:int=0; s<source.length; s++){
					result += source[s][field];
				}
			}
			
			return result;
		}
		
			
		
		//// Helper functions
		
		private static function isNull(value:Object, nullValue:Object):Object {
			return value == null ? nullValue : value;
		}
		
		
	}
	
}
