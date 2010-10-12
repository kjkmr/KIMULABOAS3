package jp.kimulabo.utils {
	
	import flash.events.EventDispatcher;
	import flash.display.Bitmap;
	import flash.events.Event;
    import flash.media.Sound;
    import flash.media.SoundChannel;
	
	public class SoundTimeKeeper extends TimeKeeper {
	
		/*--------------------------------------------------
		* static変数
		--------------------------------------------------*/
		
		private static const _DISPLAY_OBJECT:Bitmap = new Bitmap();
		
		public static function addEnterFrameHandler( i_function:Function ):void {
			_DISPLAY_OBJECT.addEventListener( Event.ENTER_FRAME, i_function );
		}
		
		public static function removeEnterFrameHandler( i_function:Function ):void {
			_DISPLAY_OBJECT.removeEventListener( Event.ENTER_FRAME, i_function );
		}
		
		/*--------------------------------------------------
		* instance変数
		--------------------------------------------------*/
		
        public var bpm:Number;
        public var takt:uint;

        protected var _sound:Sound;
        protected var _channel:SoundChannel;
        protected var _beat:Number;
        protected var _bar:Number;
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function SoundTimeKeeper( i_sound:Sound, i_bpm:Number = 120, i_takt:uint = 4, i_time:Number = 0 ) {
            _sound = i_sound;
            bpm = i_bpm;
            takt = i_takt;
			_time = i_time;
            _beat = bpm / 60;
            _bar = _beat * takt;
		}

		/*--------------------------------------------------
		* getter
		--------------------------------------------------*/
        public function get sound():Sound { return _sound; }
        public function get channel():SoundChannel { return _channel; }

		/*--------------------------------------------------
		* 拍数・小節数から時間に変換
		--------------------------------------------------*/
        public function bar( i_bar:Number, i_beat:Number=0 ):Number {
           return _bar * i_bar + _beat * i_beat;
        }

        public function beat( i_beat:Number ):Number {
            return _beat * i_beat;
        }

		/*--------------------------------------------------
		* 更新
		--------------------------------------------------*/
		public override function update( i_event:Event = null ):void {
			if ( !_playing ) return;
            _time = _channel.position / 1000;
			if ( onUpdate != null ) onUpdate();
		}
		
		/*--------------------------------------------------
		* Getter & Setter for time
		--------------------------------------------------*/
		
		public override function get time():Number { return _time; }
		public override function set time( i_value:Number ):void {
			_time = i_value;
			if ( _playing ) {
                if ( _channel ) _channel.stop();
                _channel = _sound.play( _time );
            }
			if ( onUpdate != null ) onUpdate();
		}
		
    }
}
