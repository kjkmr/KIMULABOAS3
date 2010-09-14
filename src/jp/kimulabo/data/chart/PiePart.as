﻿package jp.kimulabo.data.chart {
	
	import flash.display.Sprite;
	
	/*--------------------------------------------------
	* 円グラフを構成するパーツ
	--------------------------------------------------*/
	public class PiePart extends ChartPart {
		
		/*--------------------------------------------------
		* インスタンス変数
		--------------------------------------------------*/
		public var percent:Number;
		public var start:Number = 0;
		private var _radius:Number;
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function PiePart( i_radius:Number, i_data:XML, i_color:uint, i_unit:String = "" ) {
			_radius = i_radius;
			super( i_data, i_color, i_unit );
		}
		
		
		/*--------------------------------------------------
		* 描画し直し
		--------------------------------------------------*/
		public function redraw():void {
			graphics.clear();
			if ( !percent ) return;
			graphics.beginFill( _color );
			graphics.moveTo( 0,0 );
			
			var i:uint;
			var tx:Number, ty:Number;
			var split:uint = percent * _radius * 2 >> 0;	//分割数
			if ( split < 10 ) split = 10;
			var startRad:Number = Math.PI * 2 * start - Math.PI * 0.5;		//開始位置ラジアン
			var rad:Number = Math.PI * 2 * percent ;		//ラジアン
			var radStep:Number = rad / ( split - 1);		//分割したラジアン
			var r:Number;
			
			for ( i=0; i<split; i++ ) {
				r = startRad + radStep * i;
				tx = Math.cos(r) * _radius;
				ty = Math.sin(r) * _radius;
				graphics.lineTo( tx, ty );
			}
			
			
			graphics.lineTo( 0, 0 );
			graphics.endFill();
			
			graphics.lineStyle( 1, 0xffffff, 1, true );
			graphics.moveTo( Math.cos(startRad + rad) * _radius, Math.sin(startRad + rad) * _radius );
			graphics.lineTo( 0, 0 );
			graphics.lineTo( Math.cos(startRad) * _radius, Math.sin(startRad) * _radius );
			
		}
		
	}
}