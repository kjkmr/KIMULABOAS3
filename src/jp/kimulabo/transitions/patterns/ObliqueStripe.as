﻿package jp.kimulabo.transitions.patterns {
	
	import flash.display.Shape;
	import flash.display.BitmapData;
	
	public class ObliqueStripe implements IPattern {
		
		/*--------------------------------------------------
		* スタティック変数
		--------------------------------------------------*/
		private static var _instances:Object = {};
		
		
		/*--------------------------------------------------
		* メンバ変数
		--------------------------------------------------*/
		private var _bitmaps:Array;
		private var _size:uint;
		
		
		/*--------------------------------------------------
		* Getter
		--------------------------------------------------*/
		public function get bitmaps():Array { return _bitmaps; }
		public function get size():uint { return _size; }
		
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function ObliqueStripe( i_size:uint = 60 ) {
			_size = i_size;
			
			if ( _instances[_size] ) {
				_bitmaps = _instances[_size].bitmaps;
				return;
			}
			
			var i:uint, b:BitmapData, s:Shape;
			_bitmaps = [];
			s = new Shape();
			
			//完全に非表示
			bitmaps.push( new BitmapData( 60, 60, true, 0 ) );
			
			//表示されていくコマのビットマップを生成
			for ( i=1; i<_size; i++ ) {
				
				//シェイプ描画
				s.graphics.clear();
				s.graphics.moveTo( 0, 0 );
				s.graphics.beginFill( 0 );
				s.graphics.lineTo( i, 0 );
				s.graphics.lineTo( 0, i );
				s.graphics.lineTo( 0, 0 );
				s.graphics.endFill();
				
				s.graphics.moveTo( _size, 0 );
				s.graphics.beginFill( 0 );
				s.graphics.lineTo( _size, i );
				s.graphics.lineTo( i, _size );
				s.graphics.lineTo( 0, _size );
				s.graphics.lineTo( _size, 0 );
				s.graphics.endFill();
				
				//ビットマップ生成
				b = new BitmapData( _size, _size, true, 0 );
				b.draw( s );
				
				//配列に追加
				bitmaps.push( b );
			}
			
			//完全に表示
			bitmaps.push( new BitmapData( _size, _size, false, 0 ) );
			
			//消えて行くコマのビットマップを生成
			for ( i=1; i<_size; i++ ) {
				
				//シェイプ描画
				s.graphics.clear();
				s.graphics.moveTo( i, 0 );
				s.graphics.beginFill( 0 );
				s.graphics.lineTo( _size, 0 );
				s.graphics.lineTo( 0, _size );
				s.graphics.lineTo( 0, i );
				s.graphics.lineTo( i, 0 );
				s.graphics.endFill();
				
				s.graphics.moveTo( _size, i );
				s.graphics.beginFill( 0 );
				s.graphics.lineTo( _size, _size );
				s.graphics.lineTo( i, _size );
				s.graphics.lineTo( _size, i );
				s.graphics.endFill();
				
				//ビットマップ生成
				b = new BitmapData( _size, _size, true, 0 );
				b.draw( s );
				
				//配列に追加
				bitmaps.push( b );
			}
			
			//完全に非表示
			bitmaps.push( new BitmapData( _size, _size, true, 0 ) );
			
			//
			_instances[_size] = this;
		}
		
	}
}