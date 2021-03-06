﻿package {
	
	import flash.display.Sprite;
	import jp.kimulabo.transitions.TimeLine;
	import jp.kimulabo.transitions.Cue;
	import jp.kimulabo.transitions.Easing;
	import jp.kimulabo.display.RectangleSprite;
	import jp.kimulabo.utils.ResizeManager;
	
	public class Clock extends Sprite {
		
		private var _master:TimeLine;
		private var _shakutorimushi:TimeLine;
		private var _mowamowa:TimeLine;
		private var _rect:RectangleSprite = new RectangleSprite( 0, 5, 5 );
		private var _container:Sprite = new Sprite();
		private var _rotationY = 0;
		
		public function Clock() {
			
			
			ResizeManager.init(this);
			
			//
			_container.addChild( _rect );
			ResizeManager.add( _container, { x:0.5, y:0.5 } );
			addChild( _container );
			
			
			//
			_master = new TimeLine();
			_shakutorimushi = new TimeLine();
			_mowamowa = new TimeLine();
			
			_mowamowa.addTween( _rect, "height", [
				new Cue( 0, 5, Easing.cubicOut ),
				new Cue( 0.25, 9, Easing.cubicIn ),
				new Cue( 0.5, 5 )
			] );
			
			_mowamowa.addTween( _rect, "y", [
				new Cue( 0, -2.5, Easing.cubicOut ),
				new Cue( 0.25, -4.5, Easing.cubicIn ),
				new Cue( 0.5, -2.5 )
			] );
			
			_mowamowa.loop = true;
			_shakutorimushi.addSlave( _mowamowa );
			
			var fade:Number = 0.5;
			_shakutorimushi.addTween( _rect, "alpha", [
				new Cue( 0.5, 1, Easing.cubicInOut ),
				new Cue( 1, fade, Easing.cubicInOut ),
				new Cue( 1.5, 1, Easing.cubicInOut ),
				new Cue( 2, fade, Easing.cubicInOut ),
				new Cue( 2.5, 1, Easing.cubicInOut ),
				new Cue( 3, fade, Easing.cubicInOut ),
				new Cue( 3.5, 1, Easing.cubicInOut )
			] );
			
			_shakutorimushi.addTween( _rect, "x", [
				new Cue( 0, 0, Easing.cubicInOut ),
				new Cue( 0.5, 50 ),
				new Cue( 1, 50, Easing.cubicInOut ),
				new Cue( 1.5, 100 ),
				new Cue( 2, 100, Easing.cubicInOut ),
				new Cue( 2.5, 150, Easing.cubicInOut ),
				new Cue( 3, 160, Easing.cubicInOut )
			], 1 );
			
			_shakutorimushi.addTween( _rect, "width", [
				new Cue( 0, 0, Easing.cubicInOut ),
				new Cue( 0.5, 10, Easing.cubicInOut ),
				new Cue( 1, 60, Easing.cubicInOut ),
				new Cue( 1.5, 10, Easing.cubicInOut ),
				new Cue( 2, 60, Easing.cubicInOut ),
				new Cue( 2.5, 10, Easing.cubicInOut ),
				new Cue( 3, 60, Easing.cubicInOut ),
				new Cue( 3.5, 10, Easing.cubicInOut ),
				new Cue( 4, 0, Easing.cubicInOut )
			] );
			
			_shakutorimushi.loop = true;
			
			/*
			slave.addFunction( [
				new Cue( 0, func1 ),
				new Cue( 5.5, func2 ),
			] );
			*/
			
			//_shakutorimushi.duration = 2;
			/*
			_shakutorimushi.slaveIn = 1;
			_shakutorimushi.slaveOut = 9;
			*/
			
			_master.addSlave( _shakutorimushi );
			
			_master.addTween( _container, "rotation", [
				new Cue( 0, -90 ),
				new Cue( 60, 270 )
			] );
			
			_master.loop = true;
			_master.start();
			
			
			/*
			//時を操る
			var timeControler:TimeLine = new TimeLine();
			timeControler.addTween( _master, "time", [
				new Cue( 0, 0 ),
				new Cue( 5, 30 ),
				new Cue( 10, 15 ),
				new Cue( 15, 20 ),
				new Cue( 20, 60 ),
				new Cue( 30, 0 )
			] );
			timeControler.start();
			*/
			
		}
	}
}