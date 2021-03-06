﻿package jp.kimulabo.data.chart {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.Event;
	
	
	/*--------------------------------------------------
	* グラフのツールチップ表示用クラス
	--------------------------------------------------*/
	public class ChartTooltip extends Sprite {
		
		/*--------------------------------------------------
		* スタティック変数
		--------------------------------------------------*/
		
		public static const LABEL_FONT:String = "_sans";
		public static const LABEL_FORMAT:TextFormat = new TextFormat( LABEL_FONT, 11, 0x333333, true );
		
		public static const SPEC_FONT:String = "_sans";
		public static const SPEC_FORMAT:TextFormat = new TextFormat( SPEC_FONT, 10.5, 0x333333 );
		
		/*--------------------------------------------------
		* インスタンス変数
		--------------------------------------------------*/
		
		protected var _label:TextField = new TextField();
		protected var _spec:TextField = new TextField();
		
		protected var _width:Number;
		protected var _embedFonts:Boolean = false;
		protected var _labelFont:String;
		protected var _labelTextFormat:TextFormat = LABEL_FORMAT;
		protected var _specFont:String;
		protected var _specTextFormat:TextFormat = SPEC_FORMAT;
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function ChartTooltip( i_label:String = "", i_spec:String = "" ) {
			
			//
			_label.selectable = _spec.selectable = false;
			_label.embedFonts = _spec.embedFonts = _embedFonts;
			_label.autoSize = _spec.autoSize = TextFieldAutoSize.LEFT;
			_label.defaultTextFormat = _labelTextFormat;
			_spec.defaultTextFormat = _specTextFormat;
			
			mouseEnabled = false;
			mouseChildren = false;
			
			addChild( _label );
			addChild( _spec );
			
			label = i_label;
			spec = i_spec;
			
			cacheAsBitmap = true;
			
			addEventListener( Event.ADDED_TO_STAGE, _added );
		}
		
		/*--------------------------------------------------
		* 配置イベント
		--------------------------------------------------*/
		private function _added( i_event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, _added );
			addEventListener( Event.ENTER_FRAME, _enterFrame );
			addEventListener( Event.REMOVED_FROM_STAGE, _removed );
			x = parent.mouseX;
			y = parent.mouseY;
		}
		
		private function _removed( i_event:Event ):void {
			removeEventListener( Event.REMOVED_FROM_STAGE, _removed );
			removeEventListener( Event.ENTER_FRAME, _enterFrame );
			addEventListener( Event.ADDED_TO_STAGE, _added );
		}
		
		/*--------------------------------------------------
		* EnterFrame
		--------------------------------------------------*/
		private function _enterFrame( i_event:Event ):void {
			x += ( parent.mouseX + 10 - x ) * 0.3;
			y += ( parent.mouseY + 10 - y ) * 0.3;
		}
		
		
		/*--------------------------------------------------
		* Getter & Setter for text property
		--------------------------------------------------*/
		public function get label():String { return _label.text; }
		public function set label( i_value:String ):void {
			_label.text = i_value;
			reset();
		}
		
		public function get spec():String { return _spec.text; }
		public function set spec( i_value:String ):void {
			_spec.text = i_value;
			reset();
		}
		
		public function reset():void {
			_label.x = _spec.x = 5;
			_label.y = 5;
			_label.width = _spec.width = _width;
			_label.defaultTextFormat = _labelTextFormat;
			_spec.defaultTextFormat = _specTextFormat;
			_label.text = label;
			_spec.text = spec;
			_spec.y = _label.y + _label.textHeight;
			//
			graphics.clear();
			var w:uint = width + 10 >> 0;
			var h:uint = height + 10 >> 0;
			graphics.lineStyle();
			graphics.beginFill( 0xffffff );
			graphics.drawRect( 0, 0, w, h );
			graphics.endFill();
			graphics.lineStyle( 0, 0x666666 );
			graphics.drawRect( 0, 0, w - 1, h - 1 );
		}
		
		/*--------------------------------------------------
		* 削除
		--------------------------------------------------*/
		public function remove():void {
			if ( parent ) parent.removeChild( this );
		}
	}
}