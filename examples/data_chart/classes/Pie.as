﻿package {		import flash.display.Sprite;	import flash.display.StageScaleMode;	import flash.display.StageAlign;	import jp.kimulabo.data.chart.PieChart;		/*--------------------------------------------------	* 円グラフ	--------------------------------------------------*/	public class Pie extends Sprite {				public function Pie() {						stage.scaleMode = StageScaleMode.NO_SCALE;			stage.align = StageAlign.TOP_LEFT;						var pie:PieChart = new PieChart( "pie.xml" );			pie.x = pie.y = 50;			addChild( pie );			//pie.chartWidth = 150;		//円グラフの直径			//pie.legendWidth = 100;	//凡例の幅			//pie.load( "pie.xml" );	//後からXMLロード					}			}	}