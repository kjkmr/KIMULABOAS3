package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import caurina.transitions.Tweener;
	
	import jp.kimulabo.utils.ResizeManager;
	import jp.kimulabo.utils.ResizeManagedObject;
	
	public class BasicUsage04 extends Sprite {
		
		
		/*--------------------------------------------------
		* ResizeManagerの基本的な使い方（４）
		* 
		* ResizeManager.addの戻り値のResizeManagedObjectの
		* インスタンスのプロパティーをトゥイーンさせる
		--------------------------------------------------*/
		public function BasicUsage04() {
			
			stage.align = "LT";
			stage.scaleMode = "noScale";
			
			ResizeManager.init( stage );
			
			var r:ResizeManagedObject;
			
			//x／yを0から1に
			var green:Shape = new Shape();
			green.graphics.beginFill( 0x339966, 0.5 );
			green.graphics.drawCircle( 0, 0, 30 );		//中央基準の円
			addChild( green );
			r = ResizeManager.add( green, { x:0, y:0 } );
			Tweener.addTween( r, { x:1, y:1, time:20, transition:"linear" } );
			
			//width／heightを0から1に
			var orange:Shape = new Shape();
			orange.graphics.beginFill( 0xff6600, 0.5 );
			orange.graphics.drawCircle( 0, 0, 30 );		//中央基準の円
			addChild( orange );
			r = ResizeManager.add( orange, { x:0.5, y:0.5, width:0, height:0 } );
			Tweener.addTween( r, { width:1, height:1, time:20, transition:"linear" } );
		}
	}
}