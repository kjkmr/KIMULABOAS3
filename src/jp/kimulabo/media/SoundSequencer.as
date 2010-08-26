package jp.kimulabo.media {
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import jp.kimulabo.utils.Ticker;
	import jp.kimulabo.utils.TickerEvent;
	
	/*--------------------------------------------------
	* シーケンスされたタイミングでサウンドを再生する
	--------------------------------------------------*/
	public class SoundSequencer {
		
		/*--------------------------------------------------
		* プロパティ
		--------------------------------------------------*/
		
		public var sequence:Array;
		public var enabled:Boolean = true;
		
		private var _sound:Sound;
		private var _ticker:Ticker;
		private var _soundChannel:SoundChannel;
		private var _volume:Number = 1;
		
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function SoundSequencer( i_sound:Sound, i_ticker:Ticker, i_sequence:Array = null ) {
			_sound = i_sound;
			_ticker = i_ticker;
			sequence = i_sequence ? i_sequence : [];
			_ticker.addEventListener( TickerEvent.TICK, _onTick );
		}
		
		/*--------------------------------------------------
		* volume
		--------------------------------------------------*/
		public function get volume():Number { return _volume; }
		public function set volume( i_value:Number ):void {
			_volume = i_value;
			if ( !_soundChannel ) return;
			var s:SoundTransform = _soundChannel.soundTransform;
			s.volume = _volume;
			_soundChannel.soundTransform = s;
		}
		
		/*--------------------------------------------------
		* 
		--------------------------------------------------*/
		private function _onTick( i_event:TickerEvent ):void {
			if ( !sequence.length || !enabled ) return;
			var p:Number = _ticker.tick % sequence.length;
			if ( sequence[p] ) {
				_soundChannel = _sound.play();
				volume = _volume;
			}
		}
		
	}
}