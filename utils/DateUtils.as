package utils
{
    
    
    /**
     * Contains reusable methods for operations pertaining to Date objects / dates
     * 
     * @private
     */
    public class DateUtils {
        
        /**
         * convert a christian year to a satanic year
         */
        public static function christianYearToSatanicYear( year:int ):int {
            return year - 1966;
        }
        
        /**
         * convert a satanic year to a christian year
         */
        public static function satanicYearToChristianYear( year:int ):int {
            return year + 1966;
        }
        
		
		/**
		 * convert a satanic year to a christian year
		 */
		public static function mysqlStringToDate( value:String ):Date {
			var d:Date;
			var sp:Array, sp1:Array, sp2:Array; // splitted date - 2013-01-01 12:34:56
			if(value != null){
				sp = value.split(' ');
				sp1 = sp[0].split('-');
				sp2 = sp[1].split(':');
				
				if(sp1.length == 3 && sp2.length == 3){
					try {
						d = new Date(sp1[0], sp1[1]-1, sp1[2], sp2[0], sp2[1], sp2[2]);
					}
					catch(e:Error){
						
					}
				}
			}
			return d;
		}
		
		
    }
        
}