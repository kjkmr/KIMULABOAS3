﻿package jp.kimulabo.transitions {
	
	import flash.events.EventDispatcher;
	
	public class Cue {
	
		/*--------------------------------------------------
		* プロパティ
		--------------------------------------------------*/
		
		public var time:Number;
		public var value:*;
		public var easing:Function;
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function Cue( i_time:Number, i_value:*, i_easing:Function = null ) {
			time = i_time;
			value = i_value;
			easing = i_easing;
		}
		
	}
	
}
