﻿package jp.kimulabo.data.chart {		import flash.display.Sprite;	import flash.net.URLRequest;	import flash.net.URLLoader;	import flash.events.Event;	import flash.utils.getTimer;		import jp.kimulabo.display.LoadingCircle;		/*--------------------------------------------------	* 円グラフを表示するクラス	--------------------------------------------------*/	public class PieChart extends Chart {				/*--------------------------------------------------		* インスタンス変数		--------------------------------------------------*/				protected var _chart:Sprite = new Sprite();			//円グラフ		protected var _legend:Sprite = new Sprite();		//凡例				protected var _parts:Array;		protected var _labels:Array;				protected var _total:Number;		protected var _max:Number;				protected var _legendWidth:Number = 100;			//凡例の幅				/*--------------------------------------------------		* コンストラクタ		--------------------------------------------------*/		public function PieChart( i_xml:* = null ) {						super( i_xml );						_container.addChild( _legend );			_container.addChild( _chart );					}				/*--------------------------------------------------		* Getter & Setter		--------------------------------------------------*/				public function get legendWidth():Number { return _legendWidth; }		public function set legendWidth( i_value:Number ):void {			_legendWidth = i_value;			_display();		}				/*--------------------------------------------------		* XMLの解析		--------------------------------------------------*/		protected override function _parse():void {			if ( !_xml ) return;			if ( !_xml.content ) throw( "Invalid XML format." );						clear();						var i:uint;			var unit:String = _xml.rows.@unit.toString();			var xmlRows:XMLList = _xml.rows.row;			var xmlRow:XML;			var data:XML;			var part:PieChartPart;			var label:ChartLabel;						i = 0;			_total = 0;			_max = 0;						for each ( xmlRow in xmlRows ) {				if ( i >= _colors.length ) i = 0;				data = xmlRow.data[0];								//ラベル				label = new ChartLabel( xmlRow.@label.toString(), _colors[i], _legendWidth );				_labels.push( label );								//グラフ				part = new PieChartPart( _chartWidth * 0.5, parseFloat( data.children().toString() ), _colors[i], _tooltipContainer, unit );				if ( _max < part.value ) _max = part.value;				_total += part.value;				_parts.push( part );								i++;			}						//表示			_display();		}				/*--------------------------------------------------		* 表示		--------------------------------------------------*/				protected override function _display():void {						if ( !_parts || !_labels || !_parts.length || !_labels.length ) return;						var i:uint, l:uint;			var part:PieChartPart;			var label:ChartLabel;			var start:Number = 0;			var p:Number;						l = _parts.length;						for ( i=0; i<l; i++ ) {				//グラフ				part = _parts[i];				part.percent = part.value / _total;				part.start = start;				part.draw();				_chart.addChild( part );				start += part.percent;								//ラベル				label = _labels[i];				label.width = _legendWidth;				label.spec = part.spec;				if ( i ) label.y = _labels[i-1].y + _labels[i-1].height - 1;				_legend.addChild( label );								//				part.label = label.label;				part.spec = label.spec;			}						//			_chart.x = _chart.y = _chartWidth * 0.5;			_legend.x = _chartWidth + 20;			_legend.y = _chartWidth > _legend.height ? _chartWidth - _legend.height : 0;						super._display();		}				/*--------------------------------------------------		* クリア		--------------------------------------------------*/		public override function clear():void {			if ( !_parts ) _parts = [];			if ( !_labels ) _labels = [];						var label:ChartLabel;			for each ( label in _labels ) label.remove();			_labels = [];						var part:ChartPart;			for each ( part in _parts ) part.remove();			_parts = [];		}	}}