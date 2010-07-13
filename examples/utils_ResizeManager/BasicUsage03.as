package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import jp.kimulabo.utils.ResizeManager;
	
	public class BasicUsage03 extends Sprite {
		
		/*--------------------------------------------------
		* ResizeManagerの基本的な使い方（３）
		* 
		* functionと遅延実行
		--------------------------------------------------*/
		public function BasicUsage03() {
			
			stage.align = "LT";
			stage.scaleMode = "noScale";
			
			ResizeManager.init( stage );
			
			//サンプルを分かりやすくするため遅延時間を大きい値に設定（デフォルトは300ミリ秒）
			ResizeManager.delay = 1000;
			
			//functionの参照を登録
			ResizeManager.add( function(){ trace("リサイズされた"); } );
			
			//functionの参照を登録（２つ目の引数をtrueにすると遅延実行される）
			ResizeManager.add( function(){ trace("遅延実行"); }, true );
			
			//表示オブジェクトも遅延実行可能（３つ目の引数をtrueに）
			var green:Shape = new Shape();
			green.graphics.beginFill( 0x339966, 0.5 );
			green.graphics.drawCircle( 0, 0, 30 );		//中央基準の円
			addChild( green );
			ResizeManager.add( green, { x:0.5, y:0.5, width:1, height:1, keepRatio:true }, true );
			
		}
	}
}