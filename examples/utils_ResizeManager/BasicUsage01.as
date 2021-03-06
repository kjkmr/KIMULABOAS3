package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import jp.kimulabo.utils.ResizeManager;
	
	
	public class BasicUsage01 extends Sprite {
		
		/*--------------------------------------------------
		* ResizeManagerの基本的な使い方（１）
		* 
		* DisplayObjectの位置をステージのサイズに合わせて管理
		--------------------------------------------------*/
		public function BasicUsage01() {
			
			ResizeManager.init( this, "R" );
			
			graphics.beginFill( 0xff0000 );
			graphics.drawCircle( 0, 0, 30 );
			
			//中央に配置（xが0なら左端、0.5なら中央、1なら右端。左上基準のものを右端にするとステージ外）
			var blue:Shape = new Shape();
			blue.graphics.beginFill( 0x003399, 0.5 );
			blue.graphics.drawCircle( 30, 30, 30 );	//左上基準の円
			addChild( blue );
			ResizeManager.add( blue, { x:0.5, y:0.5 } );
			
			//中央に配置（considerWidth／considerHeightをtrueにすると自身の幅／高さを考慮）
			var purple:Shape = new Shape();
			purple.graphics.beginFill( 0x993399, 0.5 );
			purple.graphics.drawCircle( 30, 30, 30 );	//左上基準の円
			addChild( purple );
			ResizeManager.add( purple, { x:0.5, y:0.5, considerWidth:true, considerHeight:true } );
			
			//右端中央に配置（considerWidth／considerHeightをfalseに）
			var red:Shape = new Shape();
			red.graphics.beginFill( 0x990000, 0.5 );
			red.graphics.drawCircle( 0, 0, 30 );	//中央基準の円
			addChild( red );
			ResizeManager.add( red, { x:1, y:0.5 } );
			
			//右下に配置（considerWidth／considerHeightをtrueに）
			var orange:Shape = new Shape();
			orange.graphics.beginFill( 0xff6600, 0.5 );
			orange.graphics.drawCircle( 0, 0, 30 );	//中央基準の円
			addChild( orange );
			ResizeManager.add( orange, { x:1, y:1, considerWidth:true, considerHeight:true } );
			
		}
	}
}