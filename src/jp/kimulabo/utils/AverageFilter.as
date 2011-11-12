package jp.kimulabo.utils {
	public class AverageFilter {
		
		/*--------------------------------------------------
		* インスタンス変数
		--------------------------------------------------*/
		private var _taps:Number;
		private var _values:Vector.<Number>;
		private var _first:Boolean = true;
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		function AverageFilter( taps:Number ) {
			_taps = taps;
			_values = new Vector.<Number>(_taps);
		}
		
		/*--------------------------------------------------
		* set value
		--------------------------------------------------*/
		public function setValue( i_value:Number ):void {
			var i:uint = 0;
			for ( i=0; i<_taps; i++ ) _values[i] = i_value;
		}
		
		/*--------------------------------------------------
		* process
		--------------------------------------------------*/
		public function process( i_sample:Number ):Number {
			var avg:Number = 0;
			var i:uint = 0;
			
			
			//初回だけ必要分サンプルを埋める
			if ( _first ) {
				setValue( i_sample );
				_first = false;
				return i_sample;
			}
			
			//要素をずらす
			for ( i = _taps - 1; i > 0; i-- ) _values[i] = _values[i -1];
			
			_values[0] = i_sample;
			
			//平均を計算
			for ( i=0; i<_taps; i++ ) avg += _values[i];
			avg = avg/_taps;
			
			return avg;
		}
	}
}