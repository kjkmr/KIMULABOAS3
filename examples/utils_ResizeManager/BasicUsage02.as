package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import jp.kimulabo.utils.ResizeManager;
	
	public class BasicUsage02 extends Sprite {
		
		/*--------------------------------------------------
		* ResizeManagerの基本的な使い方（２）
		* 
		* DisplayObjectのサイズをステージのサイズに合わせて管理
		--------------------------------------------------*/
		public function BasicUsage02() {
			
			ResizeManager.init( stage );
			
			//ステージの幅／高さに合わせる（width／heightを1にすると幅と高さをステージに対して100%に設定）
			var blue:Shape = new Shape();
			blue.graphics.beginFill( 0x003399, 0.5 );
			blue.graphics.drawCircle( 30, 30, 30 );		//左上基準の円
			addChild( blue );
			ResizeManager.add( blue, { width:1, height:1 } );
			
			//ステージの幅／高さに合わせる（keepRatioをtrueにすると縦横の比率を保持）
			var purple:Shape = new Shape();
			purple.graphics.beginFill( 0x993399, 0.5 );
			purple.graphics.drawCircle( 30, 30, 30 );	//左上基準の円
			addChild( purple );
			ResizeManager.add( purple, { width:1, height:1, keepRatio:true } );
			
			//ステージの幅／高さに合わせる（fillをfalseにすると画面内に収まる）
			var green:Shape = new Shape();
			green.graphics.beginFill( 0x339966, 0.5 );
			green.graphics.drawCircle( 30, 30, 30 );		//左上基準の円
			addChild( green );
			ResizeManager.add( green, { width:1, height:1, keepRatio:true, fill:false } );
			
			//ステージの半分の幅／高さの円を中央に配置
			var yellow:Shape = new Shape();
			yellow.graphics.beginFill( 0xffff00, 0.5 );
			yellow.graphics.drawCircle( 0, 0, 30 );	//中央基準の円
			addChild( yellow );
			ResizeManager.add( yellow, { x:0.5, y:0.5, width:0.5, height:0.5 } );
			
		}
	}
}