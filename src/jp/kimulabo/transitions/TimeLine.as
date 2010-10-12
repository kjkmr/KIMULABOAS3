package jp.kimulabo.transitions {
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import jp.kimulabo.utils.TimeKeeper;
	
	
	public class TimeLine extends EventDispatcher {
	
		/*--------------------------------------------------
		* プロパティ
		--------------------------------------------------*/
		public var loop:Boolean = false;
		public var scale:Number = 1;
		
		private var _timeKeeper:TimeKeeper;
		private var _time:Number = 0;
		private var _lastUpdateTime:Number = NaN;
		private var _duration:Number = NaN;
		private var _calcuratedDuration:Number = 0;
		
		//
		private var _slave:Boolean = false;
		private var _slaveIn:Number = 0;
		private var _slaveOut:Number;
		
		
		//
		private var _tweens:Dictionary = new Dictionary( true );
		private var _slaves:Dictionary = new Dictionary( true );
		private var _functions:Array = [];

        public function get slaveIn():Number {
            return isNaN(_slaveIn) ? 0 : _slaveIn;
        }
        public function set slaveIn( i_value:Number ):void {
            _slaveIn = i_value;
        }

        public function get slaveOut():Number {
            return isNaN(_slaveOut) ? _slaveIn + duration : _slaveOut;
        }
        public function set slaveOut( i_value:Number ):void {
            _slaveOut = i_value;
        }
       
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function TimeLine( i_timeKeeper:TimeKeeper = null ) {
			_timeKeeper = i_timeKeeper;
		}
		
		
		/*--------------------------------------------------
		* Getter & Setter for duration
		--------------------------------------------------*/
		
		public function get duration():Number {
			return isNaN( _duration ) ? _calcuratedDuration : _duration;
		}
		
		public function set duration( i_value:Number ):void {
			_duration = i_value;
		}
		
		/*--------------------------------------------------
		* Getter & Setter for time
		--------------------------------------------------*/
		public function get time():Number { return _time; }
		public function set time( i_value:Number ):void {
			/*
			var d:Number = duration;
			if ( i_value > d ) i_value = d;
			*/
			_time = i_value;
			if ( _timeKeeper ) _timeKeeper.time = i_value;
			_update();
		}
		
		/*--------------------------------------------------
		* Getter & Setter for slave
		--------------------------------------------------*/
		public function get slave():Boolean { return _slave; }
		public function set slave( i_value:Boolean ):void {
			_slave = i_value;
			if ( ! _slave && _timeKeeper ) _timeKeeper.stop();
		}
		
		/*--------------------------------------------------
		* 再生／停止
		--------------------------------------------------*/
		public function start( i_time:Number = NaN, i_scale:Number = NaN ):void {
			if ( _slave ) return;
			if ( !duration ) return;
			if ( !_timeKeeper ) {
                _timeKeeper = new TimeKeeper();
                _timeKeeper.time = _time;
            }
            _timeKeeper.onUpdate = _update;
			if ( !isNaN(i_time) ) time = i_time;
			if ( !isNaN(i_scale) ) scale = i_scale;
			_timeKeeper.start();
			dispatchEvent( new TimeLineEvent( TimeLineEvent.START ) );
		}
		
		public function stop():void {
			if ( _slave ) return;
			if ( _timeKeeper ) _timeKeeper.stop();
			dispatchEvent( new TimeLineEvent( TimeLineEvent.STOP ) );
		}
		
		/*--------------------------------------------------
		* 更新
		--------------------------------------------------*/
		private function _update( i_event:Event = null ):void {
			if ( _timeKeeper ) _time = _timeKeeper.time;
			
			var properties:Object;
			var tween:TimeLineTween;
			
			var d:Number = duration;
			var time:Number = _time * scale;
			
			if ( _slave ) {
				if ( !isNaN(slaveOut) && slaveOut > slaveIn && time > slaveOut ) time = slaveOut - slaveIn;
				else time -= slaveIn;
				if ( slaveIn && time < 0 ) time = 0;
			}
			
			if ( loop ) {
				while ( time > d ) time -= d;
				while ( time < 0 ) time += d;
			}
			
			//各Tweenの更新
			for each ( properties in _tweens ) {
				for each ( tween in properties ) tween.update(time);
			}
			
			//SlaveのTimeLineの更新
			var child:TimeLine;
			for each ( child in _slaves ) {
                if ( ( isNaN(_lastUpdateTime) || _lastUpdateTime < child.slaveIn ) && time >= child.slaveIn ) {
                    child.dispatchEvent( new TimeLineEvent( TimeLineEvent.START) );
                } else if ( !isNaN(_lastUpdateTime) && _lastUpdateTime < child.slaveOut && time >= child.slaveOut ) {
                    child.dispatchEvent( new TimeLineEvent( TimeLineEvent.COMPLETE ) );
                }
                child.time = time;
            }
			
			//functionの実行
			var c:Cue;
			var b:Number = _time > _lastUpdateTime ? _lastUpdateTime : _time;
			var e:Number = _time > _lastUpdateTime ? _time : _lastUpdateTime;
			for each ( c in _functions ) {
				if ( ( c.time > b && c.time < e ) || _time == c.time ) ( c.value as Function )();
			}
			
			
			_lastUpdateTime = _time;
			
			//slaveの場合はここまで
			if ( _slave ) return;
			
			//
			if ( _time >= d ) {
				if ( loop && _timeKeeper && _timeKeeper.playing ) {
					dispatchEvent( new TimeLineEvent( TimeLineEvent.LOOP ) );
					while ( _time >= d ) _time -= d;
					time = _time;
				} else {
					dispatchEvent( new TimeLineEvent( TimeLineEvent.COMPLETE ) );
					stop();
				}
			}
		}
		
		/*--------------------------------------------------
		* TimeLineの追加
		--------------------------------------------------*/
		public function addSlave( i_timeLine:TimeLine ):void {
			i_timeLine.stop();
			i_timeLine.slave = true;
			i_timeLine.time = time;
			_slaves[i_timeLine] = i_timeLine;
			_calcurateDuration();
		}
		
		public function removeSlave( i_timeLine:TimeLine ):void {
			if ( _slaves[i_timeLine] ) delete _slaves[i_timeLine];
			i_timeLine.slave = false;
			_calcurateDuration();
		}
		
		
		/*--------------------------------------------------
		* Tweenの追加
		--------------------------------------------------*/
		public function addTween( i_obj:*, i_properties:*, i_cues:Array, i_delay:Number = 0, i_duration:Number = NaN ):void {
			var t:TimeLineTween;
            if ( i_obj is Array ); else i_obj = [i_obj];
			if ( i_properties is String ) i_properties = [i_properties];
			if ( i_properties is Array ) {
				var prop:String;
                var obj:*;
                for each ( obj in i_obj ) {
			        if ( !_tweens[obj] ) _tweens[obj] = {};
                    for each ( prop in i_properties ) {
                        t = new TimeLineTween( obj, prop, i_cues, i_delay, i_duration );
                        t.update( _time );
                        _tweens[obj][prop] = t;
                    }
                }
			}
			_calcurateDuration();
		}
		
		/*--------------------------------------------------
		* Tweenの削除
		--------------------------------------------------*/
		public function removeTween( i_obj:* = null, i_property:String = "" ):void {
			if ( !i_obj ) {
				_tweens = new Dictionary( true );
				_calcurateDuration();
				return;
			}
			if ( _tweens[i_obj] ) {
				if ( i_property ) {
					if ( _tweens[i_obj].hasOwnProperty(i_property) ) delete _tweens[i_obj][i_property];
				} else {
					delete _tweens[i_obj];
				}
			}
			_calcurateDuration();
		}
		
		/*--------------------------------------------------
		* Functionの追加
		--------------------------------------------------*/
		public function addFunction( i_time:Number, i_function:Function ):void {
			_functions.push( new Cue( i_time, i_function ) );
			_functions.sortOn( "time", Array.NUMERIC );
			_calcurateDuration();
		}
		
		public function addFunctions( i_cues:Array, i_delay:Number = 0 ):void {
			var c:Cue;
			for each ( c in i_cues ) {
				if ( c.value is Function ) {
					c.time += i_delay;
					_functions.push(c);
				} else {
					throw( "TimeLine.addTween : the value of the cue must be a function." );
				}
			}
			_functions.sortOn( "time", Array.NUMERIC );
			_calcurateDuration();
		}
		
		public function removeFunction( i_function:Function ):void {
			var c:Cue;
			var i:uint;
			var l:uint = _functions.length;
			for ( i=0; i<l; i++ ) {
				c = _functions[i];
				if ( c.value != i_function ) continue;
				_functions.splice( i, 1 );
				i--;
			}
		}
		
		
		/*--------------------------------------------------
		* durationの計算
		--------------------------------------------------*/
		private function _calcurateDuration():void {
			_calcuratedDuration = 0;
			
			var properties:Object;
			var tween:TimeLineTween;
			
			//各Tween
			for each ( properties in _tweens ) {
				for each ( tween in properties ) {
					if ( _calcuratedDuration < tween.end ) _calcuratedDuration = tween.end;
				}
			}
			
			//子TimeLine
			var child:TimeLine;
			var cd:Number;
			for each ( child in _slaves ) {
				cd = child.slaveOut ? child.slaveOut : child.duration + ( isNaN(child.slaveIn) ? 0 : child.slaveIn );
				if ( _calcuratedDuration < cd ) _calcuratedDuration = cd;
			}
			
			//function
			var c:Cue;
			for each ( c in _functions ) {
				if ( _calcuratedDuration < c.time ) _calcuratedDuration = c.time;
			}
			
		}
		
		/*--------------------------------------------------
		* clone
		--------------------------------------------------*/
		
	}
	
}
