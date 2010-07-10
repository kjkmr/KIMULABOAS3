﻿package jp.kimulabo.utils {		import flash.display.DisplayObject;		public class ResizeManagedObject {				/*--------------------------------------------------		* instanceプロパティ		--------------------------------------------------*/		public var enabled:Boolean = false;				public var x:Number;						//ステージの幅に対するX座標（0 <= x <= 1）		public var y:Number;						//ステージの高さに対するY座標（0 <= y <= 1）		public var width:Number;					//ステージの幅に対するオブジェクトの幅（0 <= width <= 1）		public var height:Number;					//ステージの高さに対するオブジェクトの高さ（0 <= height <= 1）		public var offsetX:Number = 0;		public var offsetY:Number = 0;		public var offsetWidth:Number = 0;		public var offsetHeight:Number = 0;		public var considerWidth:Boolean = false;		public var considerHeight:Boolean = false;		public var round:Boolean = false;		public var keepRatio:Boolean = false;		public var fill:Boolean = true;				private var _target:DisplayObject;		private var _delayed:Boolean;				public function get target():DisplayObject { return _target; }		public function get delayed():Boolean { return _delayed; }						/*--------------------------------------------------		* Constructor		--------------------------------------------------*/		public function ResizeManagedObject( i_target:DisplayObject, i_settings:Object, i_delayed:Boolean = true ):void {			_target = i_target;			_delayed = i_delayed;			settings( i_settings );		}				/*--------------------------------------------------		* settings		--------------------------------------------------*/		public function settings( i_settings:Object ):void {			var p:String;			for ( p in i_settings ) {				if ( this.hasOwnProperty(p) ) this[p] = i_settings[p];				else throw( "Invalid property : "+p);			}		}			}}