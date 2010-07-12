package jp.kimulabo.utils {
	
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.geom.Rectangle;
	
	/*--------------------------------------------------
	* Resize時の挙動を一元管理するクラス
	* --------------------------------------------------
	* ステージリサイズ時に何かする必要のあるオブジェクトは処理する
	* functionの参照をResizeManager.add()で登録する。
	* minWidthとminHeightプロパティを有効に使うにためにステージの幅と高さの取得は常に
	* ResizeManager.width・ResizeManager.heightを使う。
	--------------------------------------------------*/
	
	public class ResizeManager {
		/*--------------------------------------------------
		* staticプロパティ
		--------------------------------------------------*/
		//定数
		
		//パブリックプロパティ
		public static const registeredFunctions:Dictionary = new Dictionary( true );//登録された全てのfunction（Functionがキー）
		public static const immediateFunctions:Dictionary = new Dictionary( true );	//すぐに実行するfunction（Functionがキー）
		public static const delayedFunctions:Dictionary = new Dictionary( true );	//遅延実行するfunction（Functionがキー）
		public static const functionsByObject:Dictionary = new Dictionary( true );	//配置されていないFunction（DisplayObjectがキー）
		
		public static const registeredObjects:Dictionary = new Dictionary( true );	//登録された全てのobject（DisplayObjectがキー）
		public static const immediateObjects:Dictionary = new Dictionary( true );	//すぐに実行するobject（DisplayObjectがキー）
		public static const delayedObjects:Dictionary = new Dictionary( true );		//遅延実行するobject（DisplayObjectがキー）
		
		public static var minWidth:uint;							//最低の幅
		public static var minHeight:uint;							//最低の高さ
		
		//プライベートプロパティ
		private static var _stage:Stage;							//ステージの参照
		private static var _delay:uint = 300;						//遅延（ミリ秒）
		private static const _timer:Timer = new Timer(_delay);		//遅延用タイマー
		private static var _init:Boolean = false;					//初期化完了フラグ
		private static var _width:uint;								//ステージの幅を保持
		private static var _height:uint;							//ステージの高さを保持
		private static var _centerX:Number;							//中央のX座標
		private static var _centerY:Number;							//中央のY座標
		
		
		//Getter & Setter
		public static function get stage():Stage { return _stage; }
		public static function get delay():uint { return _delay; }
		public static function set delay( i_value:uint ):void { _delay = i_value; _timer.delay = _delay; }
		public static function get width():uint { return _width; }
		public static function get height():uint { return _height; }
		public static function get centerX():Number { return _centerX; }
		public static function get centerY():Number { return _centerY; }
		
		//
		
		/*--------------------------------------------------
		* Constructor
		--------------------------------------------------*/
		public function ResizeManager():void {
			throw("Can't create instance of this class.");
		}
		
		/*--------------------------------------------------
		* 初期化
		--------------------------------------------------*/
		public static function init( i_displayObject:DisplayObject, i_minWidth:uint = 0, i_minHeight:uint = 0 ):void {
			minWidth = i_minWidth;
			minHeight = i_minHeight;
			
			if ( _init ) return;
			if ( i_displayObject is Stage ) {
				_stage = i_displayObject as Stage;
			} else if ( i_displayObject.stage ) {
				_stage = i_displayObject.stage;
			} else {
				i_displayObject.addEventListener( Event.ADDED_TO_STAGE, _setup, false, 0, true );
				return;
			}
			_setup();
		}
		
		private static function _setup( i_event:Event = null ):void {
			if ( i_event ) i_event.target.removeEventListener( i_event.type, arguments.callee );
			_width = _stage.stageWidth;
			if ( minWidth && _width < minWidth ) _width = minWidth;
			_height = _stage.stageHeight;
			if ( minHeight && _height < minHeight ) _height = minHeight;
			_stage.addEventListener( Event.RESIZE, _onResize, false, 0, true );
			_timer.addEventListener( TimerEvent.TIMER, _delayed, false, 0, true );
			_init = true;
			resize();
		}
		
		
		/*--------------------------------------------------
		* 登録
		*
		* 
		* 
		--------------------------------------------------*/
		public static function add( ... args ):* {
			if ( args.length < 1 ) throw("Invalid arguments.");
			if ( args[0] is DisplayObject ) {
				return addObject.apply( ResizeManager, args );
			} else if ( args[0] is Function ) {
				return addFunction.apply( ResizeManager, args );
			}
		}
		
		public static function remove( i_target:* ):void {
			if ( i_target is DisplayObject ) {
				removeObject( i_target );
			} else if ( i_target is Function ) {
				removeFunction( i_target );
			}
		}
		
		/*--------------------------------------------------
		* 表示オブジェクトを登録
		* 
		* i_target:DisplayObject	
		* i_settings:Object			
		--------------------------------------------------*/
		public static function addObject( i_target:DisplayObject, i_settings:Object, i_delayed:Boolean = false ):ResizeManagedObject {
			var obj:ResizeManagedObject = new ResizeManagedObject( i_target, i_settings, i_delayed );
			registeredObjects[i_target] = obj;
			if ( i_target.stage ) {
				_addObject( obj );
				i_target.addEventListener( Event.REMOVED_FROM_STAGE, _onObjectStatusChange, false, 0, true );
			} else {
				i_target.addEventListener( Event.ADDED_TO_STAGE, _onObjectStatusChange, false, 0, true );
			}
			return obj;
		}
		
		/*--------------------------------------------------
		* 表示オブジェクトを実際の実行用Dictionaryに登録する
		--------------------------------------------------*/
		private static function _addObject( i_obj:ResizeManagedObject ):void {
			if ( i_obj.delayed ) {
				delete immediateObjects[i_obj.target];
				delayedObjects[i_obj.target] = i_obj;
			} else {
				delete delayedObjects[i_obj.target];
				immediateObjects[i_obj.target] = i_obj;
			}
			_fit( i_obj );
		}
		
		/*--------------------------------------------------
		* 表示オブジェクトを実際の実行用Dictionaryから削除
		--------------------------------------------------*/
		private static function _removeObject( i_obj:ResizeManagedObject ):void {
			delete immediateFunctions[i_obj.target];
			delete delayedFunctions[i_obj.target];
		}
		
		
		/*--------------------------------------------------
		* 登録された表示オブジェクトのステータス（ステージへの配置状況）が変わったとき
		--------------------------------------------------*/
		private static function _onObjectStatusChange( i_event:Event ):void {
			i_event.target.removeEventListener( i_event.type, arguments.callee );
			
			if ( i_event.type == Event.ADDED_TO_STAGE ) {
				_addObject( registeredObjects[i_event.target] );
				_fit( registeredObjects[i_event.target] );
				i_event.target.addEventListener( Event.REMOVED_FROM_STAGE, arguments.callee, false, 0, true );
			} else if ( i_event.type == Event.REMOVED_FROM_STAGE ) {
				_removeObject( registeredObjects[i_event.target] );
				i_event.target.addEventListener( Event.ADDED_TO_STAGE, arguments.callee, false, 0, true );
			}
		}
		
		
		/*--------------------------------------------------
		* 表示オブジェクトを削除
		*
		* i_target:DisplayObject	
		--------------------------------------------------*/
		public static function removeObject( i_target:DisplayObject ):void {
			var obj:ResizeManagedObject = registeredObjects[i_target];
			if( !obj ) return;
			_removeObject( obj );
			delete registeredObjects[i_target];
		}
		
		/*--------------------------------------------------
		* イベントハンドラの登録
		*
		* i_function:Function	リサイズ時に実行するfunctionの参照
		* i_delayed:Boolean		遅延実行するかどうか
		--------------------------------------------------*/
		public static function addFunction( i_function:Function, i_delayed:Boolean = false, i_dependsOn:DisplayObject = null ):ResizeManagedFunction {
			var funcObj:ResizeManagedFunction = new ResizeManagedFunction( i_function, i_delayed, i_dependsOn );
			registeredFunctions[funcObj.func] = funcObj;
			if ( funcObj.dependsOn ) {
				functionsByObject[funcObj.dependsOn] = funcObj;
				if ( funcObj.dependsOn.stage ) {
					funcObj.dependsOn.addEventListener( Event.REMOVED_FROM_STAGE, _onFuncStatusChange, false, 0, true );
					_addFunction( funcObj );
				} else {
					funcObj.dependsOn.addEventListener( Event.ADDED_TO_STAGE, _onFuncStatusChange, false, 0, true );
				}
			} else {
				_addFunction( funcObj );
			}
			return funcObj;
		}
		
		/*--------------------------------------------------
		* 登録されているイベントハンドラの削除
		*
		* i_function:Function	登録したfunctionの参照
		--------------------------------------------------*/
		public static function removeFunction( i_function:Function ):void {
			var funcObj:ResizeManagedFunction = registeredFunctions[i_function];
			_removeFunction( funcObj );
			if ( funcObj.dependsOn ) {
				funcObj.dependsOn.removeEventListener( Event.REMOVED_FROM_STAGE, _onFuncStatusChange );
				funcObj.dependsOn.removeEventListener( Event.ADDED_TO_STAGE, _onFuncStatusChange );
				delete functionsByObject[funcObj.dependsOn];
			}
			delete registeredFunctions[i_function];
		}
		
		/*--------------------------------------------------
		* functionを実際の実行用Dictionaryに登録する
		--------------------------------------------------*/
		private static function _addFunction( i_funcObj:ResizeManagedFunction ):void {
			if ( i_funcObj.delayed ) {
				delete immediateFunctions[i_funcObj.func];
				delayedFunctions[i_funcObj.func] = i_funcObj;
			} else {
				delete delayedFunctions[i_funcObj.func];
				immediateFunctions[i_funcObj.func] = i_funcObj;
			}
		}
		
		/*--------------------------------------------------
		* functionを実際の実行用Dictionaryから削除
		--------------------------------------------------*/
		private static function _removeFunction( i_funcObj:ResizeManagedFunction ):void {
			delete immediateFunctions[i_funcObj.func];
			delete delayedFunctions[i_funcObj.func];
		}
		
		/*--------------------------------------------------
		* 登録されたfunctionが依存するDisplayObjectのステータス（ステージへの配置状況）が変わったとき
		--------------------------------------------------*/
		private static function _onFuncStatusChange( i_event:Event ):void {
			i_event.target.removeEventListener( i_event.type, arguments.callee );
			
			if ( i_event.type == Event.ADDED_TO_STAGE ) {
				_addFunction( functionsByObject[i_event.target] );
				functionsByObject[i_event.target].func();
				i_event.target.addEventListener( Event.REMOVED_FROM_STAGE, arguments.callee, false, 0, true );
			} else if ( i_event.type == Event.REMOVED_FROM_STAGE ) {
				_removeFunction( functionsByObject[i_event.target] );
				i_event.target.addEventListener( Event.ADDED_TO_STAGE, arguments.callee, false, 0, true );
			}
		}
		
		/*--------------------------------------------------
		* Resizeイベントハンドラ
		--------------------------------------------------*/
		private static function _onResize( i_event:Event = null ):void {
			_width = _stage.stageWidth;
			_height = _stage.stageHeight;
			if ( minWidth && _width < minWidth ) _width = minWidth;
			if ( minHeight && _height < minHeight ) _height = minHeight;
			_centerX = _width * 0.5;
			_centerY = _height * 0.5;
			_timer.reset();
			_timer.start();
			_immediate();
		}
		
		/*--------------------------------------------------
		* すぐに実行するfunctionを実行
		--------------------------------------------------*/
		private static function _immediate():void {
			if ( !_init ) return;
			var i:*;
			for ( i in immediateFunctions ) immediateFunctions[i].func();
			for ( i in immediateObjects ) _fit ( immediateObjects[i] );
		}
		
		/*--------------------------------------------------
		* 遅延実行するfunctionを実行
		--------------------------------------------------*/
		private static function _delayed( i_event:TimerEvent = null ):void {
			_timer.stop();
			if ( !_init ) return;
			for ( var i:* in delayedFunctions ) delayedFunctions[i].func();
			for ( i in delayedObjects ) _fit ( delayedObjects[i] );
		}
		
		/*--------------------------------------------------
		* リサイズの強制トリガー
		--------------------------------------------------*/
		public static function resize():void {
			_onResize();
			_delayed();
		}
		
		/*--------------------------------------------------
		* DisplayObjectをリサイズ
		--------------------------------------------------*/
		public static function fit( i_obj:ResizeManagedObject ):void {
			_fit( i_obj );
		}
		
		/*--------------------------------------------------
		* DisplayObjectをリサイズする計算
		--------------------------------------------------*/
		private static function _fit( i_obj:ResizeManagedObject ):void {
			var t:DisplayObject = i_obj.target;
			
			var xx:Number = t.x;
			var yy:Number = t.y;
			var ww:Number = t.width;
			var hh:Number = t.height;
			
			if ( i_obj.keepRatio && ( !isNaN(i_obj.width) || !isNaN(i_obj.height) ) ) {//縦横比率を保持したままリサイズする場合
				
				t.scaleX = t.scaleY = 1;
				
				var sw:Number = _width * i_obj.width;			//ステージの幅に対する比率を元に目的の幅を取得
				var sh:Number = _height * i_obj.height;			//ステージの高さに対する比率を元に目的の幅を取得
				
				var rw:Number = 0;
				var rh:Number = 0;
				
				if ( i_obj.width ) rw = sw / t.width;			//オブジェクトの幅に対する比率
				if ( i_obj.height ) rh = sh / t.height;			//オブジェクトの高さに対する比率
				
				
				var r:Number;
				if ( i_obj.fill ) r = rw > rh ? rw : rh;			//幅／高さの大きい方を取得
				else r = rw < rh ? rw : rh;						//幅／高さの小さい方を取得
					
				ww = t.width * r;			//幅の決定
				hh = t.height * r;			//高さの決定
				
				if ( i_obj.round ) {
					ww = ww + 0.5 >> 0;		//四捨五入
					hh = hh + 0.5 >> 0;		//四捨五入
				}
				
			} else {
				if ( !isNaN(i_obj.width) ) ww = _width * i_obj.width;
				if ( !isNaN(i_obj.height) ) hh = _height * i_obj.height;
			}
			
			ww += i_obj.offsetWidth;
			hh += i_obj.offsetHeight;
			t.width = ww;
			t.height = hh;
			
			var rect:Rectangle = t.getBounds(t);
			
			rect.x *= t.scaleX;
			rect.y *= t.scaleY;
			
			//位置調整
			if ( !isNaN( i_obj.x ) ) {
				xx = _width * i_obj.x;
				if ( !isNaN( i_obj.offsetX ) ) xx += i_obj.offsetX;			//差分調整
				if ( i_obj.considerWidth ) xx -= ww * i_obj.x + rect.x;		//幅を考慮してX座標を調整
				if ( i_obj.round ) xx = xx + 0.5 >> 0;						//四捨五入
			}
			
			if ( !isNaN(i_obj.y) ) {
				yy = _height * i_obj.y;
				if ( !isNaN(i_obj.offsetY) ) yy += i_obj.offsetY;			//差分調整
				if ( i_obj.considerHeight ) yy -= hh * i_obj.y + rect.y;	//高さを考慮してY座標を調整
				if ( i_obj.round ) yy = yy + 0.5 >> 0;						//四捨五入
			}
			
			//プロパティの設定
			t.x = xx;
			t.y = yy;
			
		}
		
	}
}