package jp.kimulabo.utils {
	public class AverageFilter {
		
		/*--------------------------------------------------
		* インスタンス変数
		--------------------------------------------------*/
		private var _max:Number;
		private var _min:Number;
		private var _taps:Number;
		private var _values:Vector.<Number>;
		private var _first:Boolean = true;
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		function AverageFilter( taps:Number, min:Number = NaN, max:Number = 0 ) {
			_taps = taps;
			_max = max;
			_min = min;
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
			var acc:Number = 0;
			var i:uint = 0;
			
			
			//初回だけ必要分サンプルを埋める
			if ( _first ) {
				setValue( i_sample );
				_first（ = false;
				return i_sample;
			}
			
			_values[0] = i_sample;
			
			//平均を計算
			for ( i=0; i<_taps; i++ ) acc += _values[i];
			acc = acc/_taps;
			
			//最大／最小値
			if ( acc > _max ) _max = acc;
			if ( isNaN( _min ) || acc < _min ) _min = acc;
			
			//要素をずらす
			for ( i = _taps - 1; i > 0; i-- ) _values[i] = _values[i -1];
			return ( acc - _min ) / ( _max - _min );
		}
	}
}