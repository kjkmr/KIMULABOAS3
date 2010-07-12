package jp.kimulabo.utils {
	
	import flash.display.DisplayObject;
	
	public class ResizeManagedObject {
		
		/*--------------------------------------------------
		* instance変数
		--------------------------------------------------*/
		private var _enabled:Boolean = true;		
		private var _x:Number;						//ステージの幅に対するX座標（0 <= x <= 1）
		private var _y:Number;						//ステージの高さに対するY座標（0 <= y <= 1）
		private var _width:Number;					//ステージの幅に対するオブジェクトの幅（0 <= width <= 1）
		private var _height:Number;					//ステージの高さに対するオブジェクトの高さ（0 <= height <= 1）
		private var _offsetX:Number = 0;
		private var _offsetY:Number = 0;
		private var _offsetWidth:Number = 0;
		private var _offsetHeight:Number = 0;
		private var _considerWidth:Boolean = false;
		private var _considerHeight:Boolean = false;
		private var _round:Boolean = false;
		private var _keepRatio:Boolean = false;
		private var _fill:Boolean = true;
		private var _target:DisplayObject;
		private var _delayed:Boolean;
		
		public function get enabled():Boolean { return _enabled; }
		public function get x():Number { return _x; }
		public function get y():Number { return _y; }
		public function get width():Number { return _width; }
		public function get height():Number { return _height; }
		public function get offsetX():Number { return _offsetX; }
		public function get offsetY():Number { return _offsetY; }
		public function get offsetWidth():Number { return _offsetWidth; }
		public function get offsetHeight():Number { return _offsetHeight; }
		public function get considerWidth():Boolean { return _considerWidth; }
		public function get considerHeight():Boolean { return _considerHeight; }
		public function get round():Boolean { return _round; }
		public function get keepRatio():Boolean { return _keepRatio; }
		public function get fill():Boolean { return _fill; }
		public function get target():DisplayObject { return _target; }
		public function get delayed():Boolean { return _delayed; }
		
		public function set enabled( i_value:Boolean ):void { _enabled = i_value; fit(); }
		public function set x( i_value:Number ):void { _x = i_value; fit(); }
		public function set y( i_value:Number ):void { _y = i_value; fit(); }
		public function set width( i_value:Number ):void { _width = i_value; fit(); }
		public function set height( i_value:Number ):void { _height = i_value; fit(); }
		public function set offsetX( i_value:Number ):void { _offsetX = i_value; fit(); }
		public function set offsetY( i_value:Number ):void { _offsetY = i_value; fit(); }
		public function set offsetWidth( i_value:Number ):void { _offsetWidth = i_value; fit(); }
		public function set offsetHeight( i_value:Number ):void { _offsetHeight = i_value; fit(); }
		public function set considerWidth( i_value:Boolean ):void { _considerWidth = i_value; fit(); }
		public function set considerHeight( i_value:Boolean ):void { _considerHeight = i_value; fit(); }
		public function set round( i_value:Boolean ):void { _round = i_value; fit(); }
		public function set keepRatio( i_value:Boolean ):void { _keepRatio = i_value; fit(); }
		public function set fill( i_value:Boolean ):void { _fill = i_value; fit(); }
		public function set target( i_value:DisplayObject ):void { _target = i_value; fit(); }
		public function set delayed( i_value:Boolean ):void { _delayed = i_value; fit(); }
		
		
		/*--------------------------------------------------
		* Constructor
		--------------------------------------------------*/
		public function ResizeManagedObject( i_target:DisplayObject, i_settings:Object, i_delayed:Boolean = false ):void {
			_target = i_target;
			_delayed = i_delayed;
			settings( i_settings );
		}
		
		/*--------------------------------------------------
		* fit
		--------------------------------------------------*/
		public function fit():void {
			ResizeManager.fit( this );
		}
		
		/*--------------------------------------------------
		* settings
		--------------------------------------------------*/
		public function settings( i_settings:Object ):void {
			var p:String;
			for ( p in i_settings ) {
				if ( this.hasOwnProperty(p) ) this["_"+p] = i_settings[p];
				else throw( "Invalid property : "+p);
			}
		}
		
	}
}