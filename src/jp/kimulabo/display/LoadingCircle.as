﻿package jp.kimulabo.display {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/*--------------------------------------------------
	* ローディングの円を描画するクラス
	--------------------------------------------------*/
	public class LoadingCircle extends Sprite {
		
		/*--------------------------------------------------
		* プロパティ
		--------------------------------------------------*/
		private var _index:Number = 0;
		private var _bitmaps:Array = [];
		private var _speed:Number = 0.5;
		private var _bitmap:Bitmap = new Bitmap();
		
		/*--------------------------------------------------
		* コンストラクタ
		*
		* i_color:uint	色
		* i_size:uint	直径
		* i_barLength	半径に対するバーの長さ
		* i_barWidth	バーの長さに対するバーの幅
		* i_steps		バーの本数
		* i_speed		フレームレートに対するスピード（ 1だと1フレーム毎にコマが進み、0.5だと2フレーム毎にコマが進む）
		* i_minAlpha	最も色が薄くなるalpha値
		*
		--------------------------------------------------*/
		public function LoadingCircle( i_color:uint = 0x999999, i_size:uint = 30, i_barLength:Number = 0.5, i_barWidth:Number = 0.3, i_steps:uint = 12, i_speed:Number = 0.5, i_minAlpha:Number = 0.25 ) {
			
			_speed = i_speed;
			
			
			//棒の幅、長さを計算
			var barLength:int = i_size * i_barLength * 0.5 >> 0;
			if ( barLength < 1 ) barLength = 1;
			var barWidth:int = barLength * i_barWidth >> 0;
			if ( barWidth < 1 ) barWidth = 1;
			
			//ひとつ分の棒作成
			var s:Shape = new Shape();		//一本の棒を描画するためのShape
			var g:Graphics = s.graphics;
			var w:Sprite = new Sprite();
			g.beginFill( i_color );
			g.drawRoundRect( -barWidth * 0.5, -i_size * 0.5, barWidth, barLength, barWidth, barWidth );
			g.endFill();
			
			s.x = s.y = i_size * 0.5;
			w.addChild( s );
			
			//回転させながらBitmapDataにdraw
			
			var rotStep:Number = 360 / i_steps;
			var alphaStep:Number = ( 1 - i_minAlpha ) / i_steps;
			var i:uint, j:uint;
			var b:BitmapData;
			
			for ( i=0; i<i_steps; i++ ) {
				b = new BitmapData( i_size, i_size, true, 0 );
				b.lock();
				for ( j=0; j<i_steps; j++ ) {
					s.rotation = rotStep * ( i+j );
					s.alpha = i_minAlpha + alphaStep * j;
					if ( s.alpha > 1 ) s.alpha = 1;
					b.draw( w, null, null, null, null, true );
				}
				b.unlock();
				_bitmaps.push( b );
			}
			
			
			_bitmap.bitmapData = _bitmaps[_index];
			_bitmap.x = _bitmap.y = - i_size * 0.5;
			addChild( _bitmap );
			
			//
			addEventListener( Event.ADDED_TO_STAGE, _added );
		}
		
		/*--------------------------------------------------
		* 配置イベント
		--------------------------------------------------*/
		private function _added( i_event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, _added );
			addEventListener( Event.ENTER_FRAME, _enterFrame );
			addEventListener( Event.REMOVED_FROM_STAGE, _removed );
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
			_index += _speed;
			if ( _index >= _bitmaps.length ) _index = 0;
			var i:uint = _index >> 0;
			_bitmap.bitmapData = _bitmaps[i];
		}
	}
}