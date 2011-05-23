package jp.kimulabo.utils {
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/*--------------------------------------------------
	* EnterFrameManagerイベントを一元管理するクラス
	--------------------------------------------------*/
	
	public class EnterFrameManager {
		/*--------------------------------------------------
		* static変数
		--------------------------------------------------*/
		private static var _functions:Vector.<Function> = new Vector.<Function>();
		private static var _dispatcher:Sprite = new Sprite();
		private static var _enabled:Boolean = false;
		private static var __init:Boolean = false;
		
		/*--------------------------------------------------
		* Constructor
		--------------------------------------------------*/
		public function EnterFrameManager():void {
			throw("Can't create instance of this class.");
		}
		
		/*--------------------------------------------------
		* 初期化
		--------------------------------------------------*/
		private static function _init():void {
			if ( __init ) return;
			enabled = true;
			__init = true;
		}
		
		/*--------------------------------------------------
		* 追加／削除
		--------------------------------------------------*/
		public static function add( i_function:Function ):void {
			var i:uint;
			var l:uint = _functions.length;
			for ( i=0; i<l; i++ ) if ( _functions[i] == i_function ) return;
			_functions.push( i_function );
			_init();
		}
		
		public static function remove( i_function:Function ):void {
			var i:uint;
			var l:uint = _functions.length;
			for ( i=0; i<l; i++ ) {
				if ( _functions[i] == i_function ) {
					_functions.splice(i,1);
					i--;
					l--;
				}
			}
		}
		
		/*--------------------------------------------------
		* enabled
		--------------------------------------------------*/
		public static function get enabled():Boolean { return _enabled; }
		public static function set enabled( i_value:Boolean ):void {
			_enabled = i_value;
			if ( _enabled ) _dispatcher.addEventListener( Event.ENTER_FRAME, _enterFrame );
			else _dispatcher.removeEventListener( Event.ENTER_FRAME, _enterFrame );
			
		}
		
		
		/*--------------------------------------------------
		* EnterFrame
		--------------------------------------------------*/
		private static function _enterFrame( i_event:Event ):void {
			enterFrame();
		}
		
		public static function enterFrame():void {
			var i:uint;
			var l:uint = _functions.length;
			for ( i=0; i<l; i++ ) _functions[i]();
		}

		
	}
}
