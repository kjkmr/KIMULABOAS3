﻿package jp.kimulabo.transitions {
	
	
	public final class Easing {
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function Easing() {
			trace ("This is a static class and should not be instantiated.")
		}
		
		/*----------------------------------------------------------------------------------------------------
		* スタティックメソッド
		----------------------------------------------------------------------------------------------------*/
		
		/*--------------------------------------------------
		* トランジション
		--------------------------------------------------*/
		
		//イージングなし
		public static function none( i_position:Number ):Number {
			return i_position;
		}
		
		//サインカーブ
		public static function sineOut( i_position:Number ):Number {
			return Math.sin( i_position * Math.PI * 0.5 );
		}
		
		public static function sineIn( i_position:Number ):Number {
			return 1 + Math.sin( ( i_position * 0.5 + 1.5 ) * Math.PI );
			//return 1 + Math.sin( i_position * Math.PI * 0.5 + Math.PI * 1.5 );
		}
		
		public static function sineInOut( i_position:Number ):Number {
			return ( 1 + Math.sin( i_position * Math.PI + Math.PI * 1.5 ) ) * 0.5;
		}
		
		//Quadカーブ
		public static function quadOut( i_position:Number ):Number {
			return 1 - Math.pow( 1 - i_position, 2 );
		}
		
		public static function quadIn( i_position:Number ):Number {
			return Math.pow( i_position, 2 );
		}
		
		public static function quadInOut( i_position:Number ):Number {
			if ( i_position < 0.5 ) return Math.pow( i_position * 2, 2 ) * 0.5;
			return ( 1 - Math.pow( 1 - ( i_position - 0.5 ) * 2, 2 ) ) * 0.5 + 0.5;
		}
		
		//Cubicカーブ
		public static function cubicOut( i_position:Number ):Number {
			return 1 - Math.pow( 1 - i_position, 3 );
		}
		
		public static function cubicIn( i_position:Number ):Number {
			return Math.pow( i_position, 3 );
		}
		
		public static function cubicInOut( i_position:Number ):Number {
			if ( i_position < 0.5 ) return Math.pow( i_position * 2, 3 ) * 0.5;
			return ( 1 - Math.pow( 1 - ( i_position - 0.5 ) * 2, 3 ) ) * 0.5 + 0.5;
		}
		
		//Quartカーブ
		public static function quartOut( i_position:Number ):Number {
			return 1 - Math.pow( 1 - i_position, 4 );
		}
		
		public static function quartIn( i_position:Number ):Number {
			return Math.pow( i_position, 4 );
		}
		
		public static function quartInOut( i_position:Number ):Number {
			if ( i_position < 0.5 ) return Math.pow( i_position * 2, 4 ) * 0.5;
			return ( 1 - Math.pow( 1 - ( i_position - 0.5 ) * 2, 4 ) ) * 0.5 + 0.5;
		}
		
		//Quintカーブ
		public static function quintOut( i_position:Number ):Number {
			return 1 - Math.pow( 1 - i_position, 5 );
		}
		
		public static function quintIn( i_position:Number ):Number {
			return Math.pow( i_position, 5 );
		}
		
		public static function quintInOut( i_position:Number ):Number {
			if ( i_position < 0.5 ) return Math.pow( i_position * 2, 5 ) * 0.5;
			return ( 1 - Math.pow( 1 - ( i_position - 0.5 ) * 2, 5 ) ) * 0.5 + 0.5;
		}
		
	}
}