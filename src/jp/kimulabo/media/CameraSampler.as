package jp.kimulabo.media {
	
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