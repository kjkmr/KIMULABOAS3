package jp.kimulabo.transitions {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
	import jp.starryworks.transitions.patterns.IPattern;
	import jp.starryworks.transitions.patterns.*;
	import caurina.transitions.Tweener;
	
	
	public class PatternTransition {
		
		/*----------------------------------------------------------------------------------------------------
		* static
		----------------------------------------------------------------------------------------------------*/
		
		/*--------------------------------------------------
		* 定数
		--------------------------------------------------*/
		
		public static const PATTERN_WIDTH:uint = 60;
		public static const INTERVAL:uint = 1;
		
		
		/*----------------------------------------------------------------------------------------------------
		* instance
		----------------------------------------------------------------------------------------------------*/
		
		/*--------------------------------------------------
		* インスタンス変数
		--------------------------------------------------*/
		
		private var _target:DisplayObject;					//ターゲット
		private var _patterns:Array;						//パターンのビットマップ
		private var _mask:Shape = new Shape();				//マスク
		private var _position:Number;						//position ( -1 <= _position <= 1 )
		private var _reverseOnHide:Boolean = false;			//非表示にするときに表示の逆再生にする
		private var _reverseOnInterrupt:Boolean = true;		//表示途中に割り込みで非表示にするときに逆再生にする
		private var _isShown:Boolean = false;				//表示フラグ
		private var _matrix:Matrix = new Matrix();
		private var _width:Number;
		private var _height:Number;
		private var _x:Number;
		private var _y:Number;
		
		/*--------------------------------------------------
		* コンストラクタ
		* i_patternsの要素数は3以上の奇数でないといけない
		--------------------------------------------------*/
		public function PatternTransition( i_target:DisplayObject, i_pattern:IPattern, i_reverseOnHide:Boolean = false, i_reverseOnInterrupt:Boolean = true ):void {
			_target = i_target;
			_patterns = i_pattern.bitmaps;
			_reverseOnHide = i_reverseOnHide;
			_reverseOnInterrupt = i_reverseOnInterrupt;
			if ( _patterns.length < 3 || _patterns.length % 2 == 0 ) {
				throw( "length of the pattern array must be 3 or upper and also odd number." );
			}
			_position = -1;
			if ( _target.parent ) _onAdded();
			else _onRemoved();
			
			//_mask.alpha = 0.2;
		}
		
		/*--------------------------------------------------
		* ステージ配置
		--------------------------------------------------*/
		private function _onAdded( i_event:Event = null ):void {
			if ( i_event ) i_event.target.removeEventListener( i_event.type, arguments.callee );
			enable();
			_target.addEventListener( Event.REMOVED_FROM_STAGE, _onRemoved );
		}
		
		private function _onRemoved( i_event:Event = null ):void {
			if ( i_event ) i_event.target.removeEventListener( i_event.type, arguments.callee );
			disable();
			_target.addEventListener( Event.ADDED_TO_STAGE, _onAdded );
		}
		
		/*--------------------------------------------------
		* width / height
		--------------------------------------------------*/
		public function get width():Number { return _width; }
		public function set width( i_value:Number ):void {
			_width = i_value;
			redraw();
		}
		
		public function get height():Number { return _height; }
		public function set height( i_value:Number ):void {
			_height = i_value;
			redraw();
		}
		
		/*--------------------------------------------------
		* x / y
		--------------------------------------------------*/
		public function get x():Number { return _x; }
		public function set x( i_value:Number ):void {
			_x = i_value;
			redraw();
		}
		
		public function get y():Number { return _y; }
		public function set y( i_value:Number ):void {
			_y = i_value;
			redraw();
		}
		
		/*--------------------------------------------------
		* offset
		--------------------------------------------------*/
		public function get offsetX():Number { return _matrix.tx; }
		public function set offsetX( i_value:Number ):void { _matrix.tx = i_value; }
		
		public function get offsetY():Number { return _matrix.ty; }
		public function set offsetY( i_value:Number ):void { _matrix.ty = i_value; }
		
		/*--------------------------------------------------
		* position
		--------------------------------------------------*/
		public function get position():Number { return _position }
		public function set position( i_value:Number ):void {
			if ( _position == i_value ) return;
			_position = i_value;
			if ( _position > 1 ) _position = 1;
			else if ( _position < -1 ) _position = -1;
			redraw();
		}
		
		/*--------------------------------------------------
		* 再描画
		--------------------------------------------------*/
		public function redraw():void {
			//
			var r:Rectangle = _target.getBounds( _target.parent );
			var i:uint = ( _position * 0.5 + 0.5 ) * ( _patterns.length - 1 ) >> 0;
			//
			if ( _width ) r.width = _width;
			if ( _height ) r.height = _height;
			if ( !isNaN(_x) ) r.x = _x;
			if ( !isNaN(_y) ) r.y = _y;
			
			
			//マスクを再描画
			_mask.graphics.clear();
			_mask.graphics.beginBitmapFill( _patterns[i], _matrix );
			_mask.graphics.drawRect( r.x, r.y, r.width, r.height );
			_mask.graphics.endFill();
			_mask.cacheAsBitmap = true;
			_target.cacheAsBitmap = true;
			//_target.mask = _mask;
			
		}
		
		/*--------------------------------------------------
		* 有効／無効
		--------------------------------------------------*/
		public function enable():void {
			if ( _mask.parent ) _mask.parent.removeChild( _mask );
			_target.parent.addChild( _mask );
			_target.mask = _mask;
			redraw();
		}
		
		public function disable():void {
			if ( _mask.parent ) _mask.parent.removeChild( _mask );
			if ( _target.mask == _mask ) _target.mask = null;
		}
		
		/*--------------------------------------------------
		* 表示
		--------------------------------------------------*/
		
		//表示
		public function show( i_time:Number = 0, i_transition:String = "linear", i_delay:Number = 0, i_onComplete:Function = null ):void {
			if ( _isShown ) return;
			_isShown = true;
			if ( position == 1 ) position = -1;
			//Tweener.removeTweens( this, "position" );
			Tweener.addTween( this, { position:0, time:i_time, delay:i_delay, transition:i_transition, onComplete:i_onComplete } );
		}
		
		//非表示
		public function hide( i_time:Number = 0, i_transition:String = "linear", i_delay:Number = 0, i_onComplete:Function = null ):void {
			if ( !_isShown ) return;
			_isShown = false;
			var p:int = ( ( position < 0 && _reverseOnInterrupt ) || _reverseOnHide ) ? -1 : 1;
			Tweener.removeTweens( this, "position" );
			Tweener.addTween( this, { position:p, time:i_time, delay:i_delay, transition:i_transition, onComplete:i_onComplete } );
		}
		
		//toggle
		public function toggle( i_time:Number = 0, i_transition:String = "linear", i_delay:Number = 0, i_onComplete:Function = null ):void {
			var f:Function;
			if ( _isShown ) f = hide;
			else f = show;
			f( i_time, i_transition, i_delay, i_onComplete );
		}
		
		/*--------------------------------------------------
		* 破棄
		--------------------------------------------------*/
		public function dispose():void {
			_target.mask = null;
			if ( _mask.parent ) _mask.parent.removeChild( _mask );
			_target.removeEventListener( Event.REMOVED_FROM_STAGE, _onRemoved );
			_target.removeEventListener( Event.ADDED_TO_STAGE, _onAdded );
		}
	}
}