﻿package jp.kimulabo.utils {
	
	import flash.events.EventDispatcher;
	import flash.display.Bitmap;
	import flash.utils.getTimer;
	import flash.events.Event;
	
	public class TimeKeeper extends EventDispatcher {
	
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
		
		public var onUpdate:Function;
		
		protected var _time:Number = 0;
		protected var _started:Number;
		protected var _playing:Boolean = false;
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function TimeKeeper( i_time:Number = 0 ) {
			_time = i_time;
		}
		
		/*--------------------------------------------------
		* 更新
		--------------------------------------------------*/
		public function update( i_event:Event = null ):void {
			if ( !_playing ) return;
			_time = isNaN(_started) ? 0 : ( getTimer() - _started ) / 1000;
			if ( onUpdate != null ) onUpdate();
		}
		
		/*--------------------------------------------------
		* Getter & Setter for time
		--------------------------------------------------*/
		
		public function get time():Number { return _time; }
		public function set time( i_value:Number ):void {
			_time = i_value;
			if ( _playing ) _started = getTimer() - _time * 1000;
			if ( onUpdate != null ) onUpdate();
		}
		
		public function get playing():Boolean { return _playing; }
		
		/*--------------------------------------------------
		* 開始・停止
		--------------------------------------------------*/
        public function start( i_time:Number = NaN ):void {
			_playing = true;
            time = isNaN(i_time) ? _time : i_time;
			TimeKeeper.addEnterFrameHandler( update );
		}
		
		public function stop():void {
			TimeKeeper.removeEnterFrameHandler( update );
			_playing = false;
			_time = 0;
		}
		
	}
	
}
