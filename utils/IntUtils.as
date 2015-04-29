package utils
{
    
    import flash.utils.Endian;
    
    /**
     * Contains reusable methods for operations pertaining 
     * to int values.
     * 
     * @private
     */
    public class IntUtils {
        
        /**
         * Rotates x left n bits
         *
         * @langversion ActionScript 3.0
         * @playerversion Flash 9.0
         * @tiptext
         */
        public static function rol ( x:int, n:int ):int {
            return ( x << n ) | ( x >>> ( 32 - n ) );
        }
        
        /**
         * Rotates x right n bits
         *
         * @langversion ActionScript 3.0
         * @playerversion Flash 9.0
         * @tiptext
         */
        public static function ror ( x:int, n:int ):uint {
            var nn:int = 32 - n;
            return ( x << nn ) | ( x >>> ( 32 - nn ) );
        }
        
        /** String for quick lookup of a hex character based on index */
        private static var hexChars:String = "0123456789abcdef";
        
        /**
         * Outputs the hex value of a int, allowing the developer to specify
         * the endianess in the process.  Hex output is lowercase.
         *
         * @param n The int value to output as hex
         * @param bigEndian Flag to output the int as big or little endian
         * @return A string of length 8 corresponding to the 
         *        hex representation of n ( minus the leading "0x" )
         * @langversion ActionScript 3.0
         * @playerversion Flash 9.0
         * @tiptext
         */
        public static function toHex( n:int, bigEndian:Boolean = false ):String {
            var s:String = "";
            
            if ( bigEndian ) {
                for ( var i:int = 0; i < 4; i++ ) {
                    s += hexChars.charAt( ( n >> ( ( 3 - i ) * 8 + 4 ) ) & 0xF ) 
                        + hexChars.charAt( ( n >> ( ( 3 - i ) * 8 ) ) & 0xF );
                }
            } else {
                for ( var x:int = 0; x < 4; x++ ) {
                    s += hexChars.charAt( ( n >> ( x * 8 + 4 ) ) & 0xF )
                        + hexChars.charAt( ( n >> ( x * 8 ) ) & 0xF );
                }
            }
            
            return s;
        }
        
        /**
         * Outputs the int value of a hex, allowing the developer to specify
         * the endianess in the process. 
         *
         */
        public static function toInt( hex:String, bigEndian:Boolean = false ):int {
            var n:int = 0;
            
            hex = hex.toLowerCase();
            if(hex.indexOf('0x') == 0){
            	hex = hex.substr(2);
            }
            
            if ( bigEndian ) {
                for ( var i:int = 0; i < 4; i++ ) {
                   
                }
            } else {
                for ( var x:int = hex.length; x >= 0; x-- ) {
                   n += hexChars.indexOf(hex[x]);
                }
            }
            
            return n;
        }
        
    }
        
}