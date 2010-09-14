package jp.kimulabo.data.chart {
	
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	
	import jp.kimulabo.display.CircleSprite;
	import jp.kimulabo.display.RectangleSprite;
	
	/*--------------------------------------------------
	* 円グラフを表示するクラス
	--------------------------------------------------*/
	public class PieChart extends Sprite {
		
		/*--------------------------------------------------
		* インスタンス変数
		--------------------------------------------------*/
		
		protected var _xml:XML;
		protected var _chart:Sprite = new Sprite();			//円グラフ
		protected var _legend:Sprite = new Sprite();		//凡例
		protected var _parts:Array;
		protected var _labels:Array;
		
		protected var _total:Number;
		protected var _max:Number;
		
		protected var _chartWidth:Number = 180;				//グラフの直径
		protected var _legendWidth:Number = 100;			//凡例の幅
		
		protected var _colors:Array = [ 0x5390CD, 0x4CBFDD, 0x34B7AF, 0x8FC31F, 0xF4EC2E, 0xFABE00, 0xEF7A00, 0xEC7FAF, 0xB9B078, 0xBBBCBC ];
		protected var _loader:URLLoader;
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function PieChart( i_xml:* = null ) {
			
			addChild( _legend );
			addChild( _chart );
			
			if ( i_xml is XML ) xml = i_xml;
			else if ( i_xml is String ) load( i_xml );
		}
		
		/*--------------------------------------------------
		* Getter & Setter
		--------------------------------------------------*/
		public function get chartWidth():Number { return _chartWidth; }
		public function set chartWidth( i_value:Number ):void {
			_chartWidth = i_value;
			_display();
		}
		
		public function get legendWidth():Number { return _legendWidth; }
		public function set legendWidth( i_value:Number ):void {
			_legendWidth = i_value;
			_display();
		}
		
		/*--------------------------------------------------
		* XMLをロード
		--------------------------------------------------*/
		public function load( i_url:String ):void {
			if ( _loader ) {
				_loader.removeEventListener( Event.COMPLETE, _onLoad );
				_loader.close();
			}
 			_loader = new URLLoader();
			_loader.addEventListener( Event.COMPLETE, _onLoad );
			_loader.load(  new URLRequest( i_url ) );
		}
		
		protected function _onLoad( i_event:Event ):void {
			var loader:URLLoader = i_event.target as URLLoader;
			loader.removeEventListener( i_event.type, _onLoad );
			xml = new XML( loader.data );
		}
		
		/*--------------------------------------------------
		* Getter & Setter for XML
		--------------------------------------------------*/
		public function get xml():XML { return _xml; }
		public function set xml( i_value:XML ):void {
			_xml = i_value;
			_parse();
		}
		
		/*--------------------------------------------------
		* XMLの解析
		--------------------------------------------------*/
		protected function _parse():void {
			if ( !_xml ) return;
			if ( !_xml.content ) throw( "Invalid XML format." );
			
			clear();
			
			var i:uint;
			var xmlLabel:XMLList = _xml.content.label;
			var xmlRows:XMLList = _xml.content.row;
			var xmlRow:XML;
			var data:XML;
			var part:PiePart;
			var label:ChartLabel;
			
			//ラベル
			i = 0;
			for each ( data in xmlLabel.data ) {
				if ( i >= _colors.length ) i = 0;
				label = new ChartLabel( data, _colors[i], _legendWidth );
				_labels.push( label );
				i++;
			}
			
			//データ
			i = 0;
			_total = 0;
			_max = 0;
			xmlRow = xmlRows[0];
			for each ( data in xmlRow.data ) {
				if ( i >= _colors.length ) i = 0;
				part = new PiePart( _chartWidth * 0.5, data, _colors[i], xmlRow.@unit.toString() );
				if ( _max < part.value ) _max = part.value;
				_total += part.value;
				_parts.push( part );
				i++;
			}
			
			//表示
			_display();
		}
		
		/*--------------------------------------------------
		* 表示
		--------------------------------------------------*/
		
		private function _display():void {
			
			if ( !_parts || !_labels || !_parts.length || !_labels.length ) return;
			
			var i:uint, l:uint;
			var part:PiePart;
			var label:ChartLabel;
			var start:Number = 0;
			
			l = _parts.length;
			
			for ( i=0; i<l; i++ ) {
				//グラフ
				part = _parts[i];
				part.percent = part.value / _total;
				part.start = start;
				part.redraw();
				_chart.addChild( part );
				start += part.percent;
				
				//ラベル
				label = _labels[i];
				label.width = _legendWidth;
				label.spec = part.tooltip + " [ " + Math.round( part.percent * 1000 ).toString().replace(/([0-9])$/,".$1")+ "% ] ";
				if ( i ) label.y = _labels[i-1].y + _labels[i-1].height - 2;
				_legend.addChild( label );
				
				//
				part.label = label.label;
				part.spec = label.spec;
			}
			
			//
			_chart.x = _chart.y = _chartWidth * 0.5;
			_legend.x = _chartWidth + 20;
			_legend.y = _chartWidth > _legend.height ? _chartWidth - _legend.height : 0;
		}
		
		
		/*--------------------------------------------------
		* クリア
		--------------------------------------------------*/
		public function clear():void {
			if ( !_parts ) _parts = [];
			if ( !_labels ) _labels = [];
			
			var label:ChartLabel;
			for each ( label in _labels ) label.remove();
			_labels = [];
			
			var part:ChartPart;
			for each ( part in _parts ) part.remove();
			_parts = [];
		}
		
	}
}