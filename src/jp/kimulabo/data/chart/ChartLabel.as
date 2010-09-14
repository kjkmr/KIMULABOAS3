﻿package jp.kimulabo.data.chart {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	
	/*--------------------------------------------------
	* グラフの凡例を構成するパーツの基本クラス
	--------------------------------------------------*/
	public class ChartLabel extends Sprite {
		
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
		
		protected var _icon:Shape = new Shape();
		protected var _label:TextField = new TextField();
		protected var _spec:TextField = new TextField();
		
		protected var _data:XML;
		protected var _color:uint;
		protected var _width:Number;
		protected var _value:String;
		protected var _tooltip:String;
		protected var _iconSize:uint = 10;
		protected var _embedFonts:Boolean = false;
		protected var _labelFont:String;
		protected var _labelTextFormat:TextFormat = LABEL_FORMAT;
		protected var _specFont:String;
		protected var _specTextFormat:TextFormat = SPEC_FORMAT;
		
		public function get data():XML { return _data; }
		public function get value():String { return _value; }
		public function get tooltip():String { return _tooltip; }
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function ChartLabel( i_data:XML, i_color:uint, i_width:Number ) {
			_data = i_data;
			_color = i_color;
			_width = i_width;
			_tooltip = _data.@tooltip.toString();
			if ( !_tooltip ) _tooltip = _value;
			
			//アイコン描画
			_icon.graphics.beginFill( _color );
			_icon.graphics.drawRect( 0, 0, _iconSize, _iconSize );
			
			//
			_label.x = _spec.x = _iconSize + 2;
			_label.y = _spec.y = - 4;
			_label.embedFonts = _spec.embedFonts = _embedFonts;
			_label.autoSize = _spec.autoSize = TextFieldAutoSize.LEFT;
			_label.defaultTextFormat = _labelTextFormat;
			_spec.defaultTextFormat = _specTextFormat;
			
			addChild( _icon );
			addChild( _label );
			addChild( _spec );
			
			label = _data.children().toString();
		}
		
		
		/*--------------------------------------------------
		* Setter for width
		--------------------------------------------------*/
		public override function set width( i_value:Number ):void {
			_width = i_value;
			reset();
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
			_label.width = _spec.width = _width;
			_label.defaultTextFormat = _labelTextFormat;
			_spec.defaultTextFormat = _specTextFormat;
			_label.text = label;
			_spec.text = spec;
			_spec.y = _label.textHeight - 4;
		}
		
		/*--------------------------------------------------
		* 削除
		--------------------------------------------------*/
		public function remove():void {
			if ( parent ) parent.removeChild( this );
		}
	}
}