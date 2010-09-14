package jp.kimulabo.data.chart {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/*--------------------------------------------------
	* グラフを構成するパーツの基本クラス
	--------------------------------------------------*/
	public class ChartPart extends Sprite {
		
		/*--------------------------------------------------
		* インスタンス変数
		--------------------------------------------------*/
		
		protected var _data:XML;
		protected var _color:uint;
		protected var _unit:String;
		protected var _value:Number;
		protected var _tooltip:String;
		protected var _tip:ChartTooltip;
		
		public function get data():XML { return _data; }
		public function get color():uint { return _color; }
		public function get unit():String { return _unit; }
		public function get value():Number { return _value; }
		public function get tooltip():String { return _tooltip; }
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function ChartPart( i_data:XML, i_color:uint, i_unit:String = "" ) {
			
			//プロパティ
			_data = i_data;
			_color = i_color;
			_unit = i_unit;
			_value = parseFloat( _data.children().toString() );
			_tooltip = _data.@tooltip.toString();
			if ( !_tooltip ) _tooltip = _value + _unit;
			
			_tip = new ChartTooltip();
			
			//マウスイベント
			addEventListener( MouseEvent.ROLL_OVER, _onRollOver );
			addEventListener( MouseEvent.ROLL_OUT, _onRollOut );
			buttonMode = true;
		}
		
		/*--------------------------------------------------
		* マウスイベント
		--------------------------------------------------*/
		protected function _onRollOver( i_event:MouseEvent ):void {
			alpha = 0.75;
			parent.addChild( _tip );
		}
		
		protected function _onRollOut( i_event:MouseEvent ):void {
			alpha = 1;
			if ( parent.contains( _tip ) ) parent.removeChild( _tip );
		}
		
		/*--------------------------------------------------
		* Tooltip
		--------------------------------------------------*/
		public function get label():String { return _tip.label; }
		public function set label( i_value:String ):void {
			_tip.label = i_value;
		}
		
		public function get spec():String { return _tip.spec; }
		public function set spec( i_value:String ):void {
			_tip.spec = i_value;
		}
		
		/*--------------------------------------------------
		* クリア
		--------------------------------------------------*/
		public function clear():void {
			graphics.clear();
		}
		
		/*--------------------------------------------------
		* 削除
		--------------------------------------------------*/
		public function remove():void {
			if ( parent ) parent.removeChild( this );
		}
	}
}