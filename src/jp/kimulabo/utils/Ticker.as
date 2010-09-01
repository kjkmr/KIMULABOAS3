package jp.kimulabo.utils {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	/*--------------------------------------------------
	* リズムに合わせてイベントを発行するクラス
	--------------------------------------------------*/
	public class Ticker extends EventDispatcher {
		
		private static var _instances:Array = [];
		
		/*--------------------------------------------------
		* 更新
		--------------------------------------------------*/
		public static function update( i_time:Number = NaN ):void {
			if ( isNaN( i_time ) ) i_time = getTimer();
			var i:uint;
			var l:uint = _instances.length;
			for ( i=0; i<l; i++ ) _instances[i].update( i_time );
		}
		
		
		/*--------------------------------------------------
		* 開始
		--------------------------------------------------*/
		public static function start( i_time:Number = NaN ):void {
			if ( isNaN( i_time ) ) i_time = getTimer();
			var i:uint;
			var l:uint = _instances.length;
			for ( i=0; i<l; i++ ) _instances[i].start( i_time );
		}
		
		/*----------------------------------------------------------------------------------------------------
		* インスタンス
		----------------------------------------------------------------------------------------------------*/
		public var timeOffset:Number = 0;
		public var beatOffset:Number = 0;
		public var tickOffset:Number = 0;
		
		private var _lastTime:Number;
		private var _resolution:uint;		//1拍の分解数（16分なら4）
		private var _bpm:uint;				//BPM
		private var _shuffle:Number = 0.1;
		private var _tickTime:Number;		//1コマの時間（ミリ秒）
		private var _shuffleTime:Number;	//シャッフルのずれ時間（ミリ秒）
		private var _beatTime:Number;		//1拍の時間（ミリ秒）
		
		private var _bar:uint = 0;
		private var _beat:uint = 0;
		private var _tick:uint = 0;
		private var __tick:uint = 0;
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function Ticker( i_bpm:uint = 120, i_resolution:uint = 4, i_shuffle:Number = 0.1 ) {
			_bpm = i_bpm;
			_resolution = i_resolution;
			_shuffle = i_shuffle;
			_instances.push( this );
			reset();
		}
		
		/*--------------------------------------------------
		* start
		--------------------------------------------------*/
		public function start( i_time:Number ):void {
			_lastTime = i_time;
		}
		
		/*--------------------------------------------------
		* reset
		--------------------------------------------------*/
		public function reset():void {
			_beatTime = 60 / ( _bpm ) * 1000 >> 0;
			_tickTime = _beatTime / _resolution;
			_shuffleTime = _tickTime * _shuffle;
		}
		
		/*--------------------------------------------------
		* getter
		--------------------------------------------------*/
		public function get tick():uint { return _tick; }
		public function get beat():uint { return _beat; }
		public function get bar():uint { return _bar; }
		public function get bpm():uint { return _bpm; }
		
		
		/*--------------------------------------------------
		* 更新
		--------------------------------------------------*/
		public function update( i_time:Number ):void {
			if ( !_lastTime ) return;
			i_time += timeOffset;
			var offset:Number = i_time - _lastTime;
			__tick = offset / _tickTime >> 0;
			var t:Number = __tick + beatOffset * _resolution + tickOffset >> 0;
			if ( t <= _tick ) return;
			_tick = t;
			var beat:uint = t / _resolution >> 0;
			var bar:uint = beat / 4 >> 0;
			beat = beat % 4;
			dispatchEvent( new TickerEvent( TickerEvent.TICK ) );
			if ( _beat != beat ) dispatchEvent( new TickerEvent( TickerEvent.BEAT ) );
			if ( _bar != bar ) dispatchEvent( new TickerEvent( TickerEvent.BAR ) );
			_beat = beat;
			_bar = bar;
			
		}
		
	}
}