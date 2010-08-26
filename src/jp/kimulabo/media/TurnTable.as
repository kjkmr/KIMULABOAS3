package jp.kimulabo.media {
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	
	import caurina.transitions.Tweener;

	public class TurnTable {
		/*--------------------------------------------------
		* 定数
		--------------------------------------------------*/
		private static const BLOCK_SIZE: int = 2048;
		
		/*--------------------------------------------------
		* スタティック変数
		--------------------------------------------------*/
		
		private var _source:Sound;
		private var _output:Sound;
		private var _channel:SoundChannel;
		private var _volume:Number = 1;
		private var _bpm:uint;
		
		//ピッチシフト用
		private var _pitch:Number = 1;
		private var _pitchBeforePause:Number;
		private var _numSamples:Number = 0;
		private var _wave:ByteArray;
		private var _position:Number;
		
		//
		private var _isScratching:Boolean = false;
		private var _isPlaying:Boolean = false;
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function TurnTable( i_source:Sound, i_bpm:uint = 0 ) {
			_source = i_source;
			_bpm = i_bpm;
			_init();
		}
		
		/*--------------------------------------------------
		* 初期化
		--------------------------------------------------*/
		private function _init() {
			
			
			_position = 0;
			_wave = new ByteArray();
			_output = new Sound();
			_output.addEventListener( SampleDataEvent.SAMPLE_DATA, _onSampleData );
			
			//サンプル数取得
			_numSamples = 0;
			var dummy:ByteArray = new ByteArray();
			var l:Number = _source.bytesTotal * 0.1 >> 0;
			if ( l > BLOCK_SIZE * 1000 ) l = BLOCK_SIZE * 1000;
			var n:Number = 0;
			while ( n < l ) {
				n = _source.extract( dummy, l );
				_numSamples += n;
			}
			
		}
		
		/*--------------------------------------------------
		* 再生
		--------------------------------------------------*/
		public function play():SoundChannel {
			if ( _isPlaying ) return _channel;
			_isPlaying = true;
			_channel = _output.play();
			volume = _volume;
			return _channel;
		}
		
		public function stop():void {
			if ( !_isPlaying ) return;
			_isPlaying = false;
			if ( _channel ) {
				_channel.stop();
				_channel = null;
			}
		}
		
		
		/*--------------------------------------------------
		* スクラッチ
		--------------------------------------------------*/
		public function startScratch():void {
			if ( _isScratching ) return;
			_isScratching = true;
			Tweener.removeTweens( this, "pitch" );
		}
		
		public function endScratch():void {
			if ( !_isScratching || !_isPlaying ) return;
			_isScratching = false;
			Tweener.addTween( this, { pitch:1, time:1, transition:"easeInOutCubic" } );
		}
		
		/*--------------------------------------------------
		* pause / resume
		--------------------------------------------------*/
		public function pause( i_time:Number = 3 ):void {
			_pitchBeforePause = _pitch;
			Tweener.addTween( this, { volume:0, pitch:0, time:i_time, transition:"easeOutCubic" } );
		}
		
		public function resume( i_time:Number = 1 ):void {
			if ( _isPlaying && !_channel ) {
				_channel = _output.play();
				volume = _volume;
			}
			Tweener.addTween( this, { volume:1, volume:1, pitch:_pitchBeforePause, time:i_time, transition:"easeOutCubic" } );
		}
		
		
		/*--------------------------------------------------
		* Getter & Setter for volume
		--------------------------------------------------*/
		public function get volume():Number {
			return _volume;
		}
		
		public function set volume( i_value:Number ):void {
			if ( !_channel ) return;
			_volume = i_value;
			var s:SoundTransform = _channel.soundTransform;
			s.volume = _volume;
			_channel.soundTransform = s;
		}
		
		
		/*--------------------------------------------------
		* Getter for position
		--------------------------------------------------*/
		public function get position():Number { return _position; }
		
		public function get beat():Number {
			var time:Number = _position / 44100;
			return time / ( 60 / _bpm );
		}
		
		/*--------------------------------------------------
		* サンプル生成
		--------------------------------------------------*/
		private function _onSampleData( i_event:SampleDataEvent ):void {
			
			var i:uint, l:uint;
			var data:ByteArray = i_event.data;
			
			//_pitchが0のときの処理
			if ( _pitch == 0 ) {
				//サンプルデータ生成
				l = BLOCK_SIZE;
				for ( i=0; i<l; i++ ) {
					data.writeFloat( 0 );
					data.writeFloat( 0 );
				}
				return;
			}
			
			//ByteArrayを上書きして再利用する
			_wave = new ByteArray();
			
			//ピッチシフトするために必要なソース音源のサイズ
			var sourceBlockSize: Number = BLOCK_SIZE * _pitch;
			sourceBlockSize = sourceBlockSize < 0 ? -sourceBlockSize : sourceBlockSize;
			
			//必要なソース音源のサンプル数
			var numSamplesNeeded:int = Math.ceil( sourceBlockSize ) + 2;
			if ( numSamplesNeeded < 1 ) numSamplesNeeded = 1;
			
			//ソース音源からサンプルを読み込み
			var numSampesRead:int;
			if ( _pitch > 0 ) {
				//
				//正再生
				//
				numSampesRead = _source.extract( _wave, numSamplesNeeded, _position >> 0 );
				//ファイルの終点に達したときはループ
				if ( numSampesRead < numSamplesNeeded ) {
					_position = 0;
					numSamplesNeeded -= numSampesRead;
					numSampesRead += _source.extract( _wave, numSamplesNeeded, _position );
					_position += numSamplesNeeded;
				} else {
					//_positionを進める
					_position += BLOCK_SIZE * _pitch;
				}
			} else {
				//
				//逆再生
				//
				//ファイルの先頭に達する場合はループ
				if ( _position < numSamplesNeeded ) {
					var shortage:Number = numSamplesNeeded - _position;
					_position = _numSamples - shortage;
					numSampesRead = _source.extract( _wave, numSamplesNeeded, _position >> 0 );
					numSamplesNeeded -= numSampesRead;
					numSampesRead = _source.extract( _wave, numSamplesNeeded, 0 >> 0 );
				} else {
					numSampesRead = _source.extract( _wave, numSamplesNeeded, _position - numSamplesNeeded >> 0 );
					_position += BLOCK_SIZE * _pitch;
				}
			}
			
			
			
			//サンプルデータ生成
			l = BLOCK_SIZE;
			var wavePosition:Number = _pitch >= 0 ? 0 : BLOCK_SIZE * -_pitch;
			
			for ( i=0; i<l; i++ ) {
				_wave.position = wavePosition << 3;
				data.writeFloat( _wave.readFloat() );
				data.writeFloat( _wave.readFloat() );
				wavePosition += _pitch;
			}
			
		}
		
		
		/*--------------------------------------------------
		* Getter & Setter for pitch
		--------------------------------------------------*/
		public function get pitch():Number { return _pitch; }
		public function set pitch( i_value:Number ):void {
			if ( isNaN( i_value ) ) i_value = 0;
			else if ( i_value < -5 ) i_value = -5;
			else if ( i_value > 5 ) i_value = 5;
			_pitch = i_value;
		}

	}
}
