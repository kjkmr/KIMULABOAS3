package jp.kimulabo.utils {
	
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	/*--------------------------------------------------
	* ローディングのフェーズを管理するクラス
	--------------------------------------------------*/
	public class LoadingPhase extends EventDispatcher {
		
		/*--------------------------------------------------
		* インスタンス変数
		--------------------------------------------------*/
		private var _name:String;
		private var _paths:Array = [];
		private var _loader:BulkLoader;
		private var _connection:int;
		
		public var weight:Number;
		public function get paths():Array { return _paths.concat(); }
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function LoadingPhase( i_name:String, i_paths:Array = null, i_weight:Number = 0, i_connection:int = 1 ) {
			_name = i_name;
			if ( i_paths ) _paths = i_paths;
			weight = i_weight;
			_connection = i_connection;
		}
		
		/*--------------------------------------------------
		* 追加／削除
		--------------------------------------------------*/
		public function add( i_path:String ):void {
			_paths.push( i_path );
		}
		
		/*--------------------------------------------------
		* ロード
		--------------------------------------------------*/
		public function load():void {
			if ( !_paths.length ) {
				dispatchEvent( new BulkProgressEvent( BulkProgressEvent.COMPLETE ) );
				return;
			}
			_loader = new BulkLoader( _name, _connection );
			var path:String;
			for each ( path in _paths ) _loader.add( path, { context:new LoaderContext(false, ApplicationDomain.currentDomain) } );
			_loader.addEventListener( BulkProgressEvent.PROGRESS, dispatchEvent );
			_loader.addEventListener( BulkProgressEvent.COMPLETE, dispatchEvent );
			_loader.start();
		}
		
		public function get progress():Number { return _loader.percentLoaded; }
	}
}