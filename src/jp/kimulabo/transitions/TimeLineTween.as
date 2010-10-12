﻿package jp.kimulabo.transitions {
	
	
	import flash.events.EventDispatcher;
	
	public class TimeLineTween {
	
		/*--------------------------------------------------
		* プロパティ
		--------------------------------------------------*/
		
		private var _target:*;
		private var _property:String;
		private var _cues:Array;
		private var _delay:Number;
		private var _time:Number;
		private var _duration:Number;
		
		/*--------------------------------------------------
		* Getter
		--------------------------------------------------*/
		
		public function get target():* { return _target; }
		public function get property():String { return _property; }
		public function get delay():Number { return _delay; }
		public function get duration():Number { return _duration; }
		public function get end():Number { return _delay + _duration; }
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function TimeLineTween( i_target:*, i_property:String, i_cues:Array, i_delay:Number = 0, i_duration:Number = NaN ) {
			_target = i_target;
			_property = i_property;
			_cues = i_cues;
			_delay = i_delay;
			_duration = i_duration;
			if ( isNaN( _duration ) ) _calcDuration();
			_cues.sortOn( "time" );
		}
		
		/*--------------------------------------------------
		* 最後のキューポイントを探して長さを求める
		--------------------------------------------------*/
		private function _calcDuration():void {
			
			var c:Cue;
			_duration = 0;
			for each ( c in _cues ) {
				if ( c.time > _duration ) _duration = c.time;
			}
			
		}
		
		/*--------------------------------------------------
		* 更新
		--------------------------------------------------*/
		public function update( i_time:Number ):void {
			if ( !_cues.length ) return;
			
			var time:Number = i_time - _delay;
			
			//変化無しの場合
			if ( !isNaN(_time) && ( ( _time <= 0 && time <= 0 ) || ( _time >= _duration && time >= _duration ) ) ) {
				_time = time;
				return;
			}
			
			
			_time = time;
			if ( _time > _duration ) _time = _duration;
			
			/*
			配列の中身には同じtimeを持つCueが存在しないことが保証されてる必要があると思う
			*/
			
			var l:uint = _cues.length;
			
			//始点より前の場合／キューポイントが１つしかない場合
			if ( _time <= 0 || l == 1 ) {
				_target[_property] = _cues[0].value;
				return;
			}
			
			//最後のキューポイントより後の場合
			if ( _time >= _cues[l-1].time && _duration >= _cues[l-1].time ) {
				_target[_property] = _cues[l-1].value;
				return;
			}
			
			var i:uint;
			var s:Cue;
			var e:Cue;
			var c:Cue;
			var pos:Number;
			
			//始点と終点の検索
			for ( i=0; i<l; i++ ) {
				c = _cues[i];
				if ( c.time == _time ) {
					s = e = c;
					break;
				} if ( c.time > _time ) {
					e = c;
					if ( i > 0 ) s = _cues[i-1];
					else s = e;
					break;
				}
			}


			//始点と終点が同じ場合
			if ( s.value == e.value ) {
				_target[_property] = s.value;
				return;
			}
				
            //数値以外の値の場合
            if ( !(s.value is Number && e.value is Number) ) {
                _target[_property] = s.value;
                return;
            }

			//値を計算
			pos = ( _time - s.time ) / ( e.time - s.time );
			if ( s.easing is Function ) pos = s.easing(pos);
			_target[_property] = s.value + ( e.value - s.value ) * pos;
			
		}
	}
	
}
