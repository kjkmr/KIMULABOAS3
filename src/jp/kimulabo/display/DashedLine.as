package jp.kimulabo.display {
	
	import flash.display.Shape;
	import flash.display.BitmapData;
	
	/*--------------------------------------------------
	* シンプルな破線を描画するクラス（直線のみ）
	--------------------------------------------------*/
	public class DashedLine extends Shape {
		/*--------------------------------------------------
		* プロパティ
		--------------------------------------------------*/
		private var _length:Number;
		private var _weight:Number;
		private var _color:uint;
		private var _dash:uint;
		private var _gap:uint;
		
		private var _bitmapData:BitmapData;
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function DashedLine( i_length:Number, i_weight:Number = 0, i_color:uint = 0, i_dash:uint = 1, i_gap:uint = 1 ) {
			
			_length = i_length;
			_weight = i_weight;
			_color = i_color;
			_dash = i_dash;
			_gap = i_gap;
			
			makePattern();
		}
		
		/*--------------------------------------------------
		* パターンビットマップ生成
		--------------------------------------------------*/
		public function makePattern():void {
			_bitmapData = new BitmapData( _dash + _gap, 1, true, 0 );
			_bitmapData.lock();
			var i:uint = 0;
			for ( i=0; i<_dash; i++ ) _bitmapData.setPixel32( i, 0 , 0xff000000 | _color );
			draw();
		}
		
		/*--------------------------------------------------
		* 描画
		--------------------------------------------------*/
		public function draw():void {
			graphics.clear();
			graphics.lineStyle( _weight, 0, 1, true, "normal", "none" );
			graphics.lineBitmapStyle( _bitmapData, null, true, true );
			graphics.moveTo( 0, 0 );
			graphics.lineTo( _length, 0 );
		}
		
		/*--------------------------------------------------
		* lengthプロパティ
		--------------------------------------------------*/
		public function get length():uint { return _length; }
		public function set length( i_value:uint ):void {
			_length = i_value;
			draw();
		}
		
		/*--------------------------------------------------
		* weightプロパティ
		--------------------------------------------------*/
		public function get weight():uint { return _weight; }
		public function set weight( i_value:uint ):void {
			_weight = i_value;
			draw();
		}
		
		/*--------------------------------------------------
		* colorプロパティ
		--------------------------------------------------*/
		public function get color():uint { return _color; }
		public function set color( i_value:uint ):void {
			_color = i_value;
			makePattern();
		}
		
		/*--------------------------------------------------
		* dashプロパティ
		--------------------------------------------------*/
		public function get dash():uint { return _dash; }
		public function set dash( i_value:uint ):void {
			_dash = i_value;
			makePattern();
		}
		
		/*--------------------------------------------------
		* gapプロパティ
		--------------------------------------------------*/
		public function get gap():uint { return _gap; }
		public function set gap( i_value:uint ):void {
			_gap = i_value;
			makePattern();
		}
		
		
	}
}