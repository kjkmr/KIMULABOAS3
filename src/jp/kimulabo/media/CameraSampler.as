<<<<<<< HEAD
﻿package jp.kimulabo.media {
	
	import flash.events.Event;
	import flash.events.ActivityEvent;
	import flash.media.Video;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.media.Camera;
	import flash.geom.Matrix;
	
	/*--------------------------------------------------
	* ウェブカメラをセットアップしてBitmapDataを取得するためのクラス
	--------------------------------------------------*/
	public class CameraSampler extends Video {
		
		/*--------------------------------------------------
		* プロパティ
		--------------------------------------------------*/
		
		public var mirror:Boolean = false;
		
		//Camera
		private var _camera:Camera;
		private var _width:uint;
		private var _height:uint;
		private var _rate:uint;
		private var _active:Boolean = false;
		
		//Video
		private var _video:Video;
		private var _matrix:Matrix = new Matrix();
		
		
		
		public function get active():Boolean { return _active; }
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function CameraSampler( i_width:uint, i_height:uint, i_rate:uint ) {
			
			_width = i_width;
			_height = i_height;
			_rate = i_rate;
			
			_camera = Camera.getCamera();
			_camera.setMode( _width, _height, _rate );
			_camera.addEventListener( ActivityEvent.ACTIVITY, _onActivity );
			
			_matrix.a = -1;
			_matrix.tx = _width;
			
			//
			super( _width, _height );
			attachCamera( _camera );
		}
		
		/*--------------------------------------------------
		* イベント
		--------------------------------------------------*/
		private function _onActivity( i_event:ActivityEvent ):void {
			_active = i_event.activating;
			if ( _active ) dispatchEvent( new Event( Event.INIT ) );
		}
		
		/*--------------------------------------------------
		* ビットマップデータ取得
		--------------------------------------------------*/
		public function get bitmapData():BitmapData {
			var b:BitmapData = new BitmapData( _width, height, false );
			b.draw( this, ( mirror ? _matrix : null ) );
			return b;
		}
		
	}
}
=======
﻿package jp.kimulabo.media {
	
	import flash.events.Event;
	import flash.media.Video;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.media.Camera;
	import flash.geom.Matrix;
	
	/*--------------------------------------------------
	* カメラからBitmapDataを取得するためのクラス
	--------------------------------------------------*/
	public class CameraSampler extends Video {
		
		/*--------------------------------------------------
		* プロパティ
		--------------------------------------------------*/
		
		public var mirror:Boolean = false;
		
		//Camera
		private var _camera:Camera;
		private var _width:uint;
		private var _height:uint;
		private var _rate:uint;
		
		//Video
		private var _video:Video;
		
		private var _matrix:Matrix = new Matrix();
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function CameraSampler( i_width:uint, i_height:uint, i_rate:uint ) {
			
			_width = i_width;
			_height = i_height;
			_rate = i_rate;
			
			_camera = Camera.getCamera();
			_camera.setMode( _width, _height, _rate );
			
			_matrix.a = -1;
			_matrix.tx = _width;
			
			//
			super( _width, _height );
			attachCamera( _camera );
			
		}
		
		/*--------------------------------------------------
		* ビットマップデータ取得
		--------------------------------------------------*/
		public function get bitmapData():BitmapData {
			var b:BitmapData = new BitmapData( _width, height, false );
			b.draw( this, ( mirror ? _matrix : null ) );
			return b;
		}
		
	}
}
>>>>>>> 667a6aad86ccef3011e4a1c2ce4f8ae619087d82
