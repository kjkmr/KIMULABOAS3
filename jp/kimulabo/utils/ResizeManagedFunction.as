package jp.kimulabo.utils {
	
	import flash.display.DisplayObject;
	
	public class ResizeManagedFunction {
		
		/*--------------------------------------------------
		* instanceプロパティ
		--------------------------------------------------*/
		public var enabled:Boolean = false;
		public var func:Function;
		private var _dependsOn:DisplayObject;
		private var _delayed:Boolean;
		
		public function get dependsOn():DisplayObject { return _dependsOn; }
		public function get delayed():Boolean { return _delayed; }
		
		
		/*--------------------------------------------------
		* Constructor
		--------------------------------------------------*/
		public function ResizeManagedFunction( i_func:Function, i_delayed:Boolean = true, i_dependsOn:DisplayObject = null ):void {
			func = i_func;
			_delayed = i_delayed;
			_dependsOn = i_dependsOn;
		}
		
	}
}