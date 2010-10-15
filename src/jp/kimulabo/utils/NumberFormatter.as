package jp.kimulabo.utils {
	/*--------------------------------------------------
	* 数値に３桁おきにカンマを挿入するためのクラス
	--------------------------------------------------*/
	public final class NumberFormatter {
		
		/*--------------------------------------------------
		* static定数
		--------------------------------------------------*/
		public static const REG:RegExp = /^-?(\d+)(\d{3})/;
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		function NumberFormatter() {
			throw("Can't create instance of this class.");
		}
		
		/*--------------------------------------------------
		* フォーマット
		--------------------------------------------------*/
		public static function format( i_num:* ):String {
			var n:Number = i_num is Number ? i_num : parseFloat(i_num.toString());
			var i:int = n >> 0;
			var d:String = Number( n - i ).toString();
			if ( d == "0" ) d = "";
			else d = d.substr(1);
			var s:String = i.toString();
			while ( REG.test(s) ) s = s.replace( REG, "$1,$2" );
			return s + d;
		}
	}
}
