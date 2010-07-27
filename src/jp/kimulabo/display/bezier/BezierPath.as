﻿package jp.kimulabo.display.bezier {		import flash.display.Graphics;	import flash.geom.Point;	import fl.motion.BezierSegment;		/*--------------------------------------------------	* ３次ベジェ曲線のパスのデータ	--------------------------------------------------*/		public class BezierPath {				/*--------------------------------------------------		* 定数		--------------------------------------------------*/		public static const DIVISION:uint = 8;		public static const DATA_REG:RegExp = /[MmLlCcHhVvSs][0-9,.-]+/;				/*--------------------------------------------------		* インスタンス変数		--------------------------------------------------*/		public var anchors:Array = [];		public var random:Number = 2;				/*--------------------------------------------------		* コンストラクタ		--------------------------------------------------*/		public function BezierPath( ... args ) {			if ( args[0] is XML ) parseSVG( args[0] );			else push.apply( this, args );		}				/*--------------------------------------------------		* アンカーポイントを最後に追加		--------------------------------------------------*/		public function push( ... args ):void {			var i:uint, l:uint = args.length;			for ( i=0; i<l; i++ ) {				if ( args[i] is Anchor ) {					anchors.push( args[i] );				} else if ( args[i] is Array ) {					push.apply( this, args[i] );				} else {					throw("Invalid Argument ( "+ args[i] + " )");				}			}		}				/*--------------------------------------------------		* 最後のアンカーポイントを削除		--------------------------------------------------*/		public function pop():Anchor {			var a:Anchor = anchors.pop();			return a;		}				/*--------------------------------------------------		* 特定のアンカーポイントの前にアンカーポイントを追加		--------------------------------------------------*/		public function before( i_anchor:Anchor, ... args ):void {			var i:uint, index:int = -1, l:uint = anchors.length;			for ( i=0; i<l; i++ ) {				if ( anchors[i] == i_anchor ) {					index = i;					break;				}			}						if ( index < 0 ) return;						var b:Array = anchors.splice( 0, index );			l = args.length;			for ( i=0; i<l; i++ ) {				if ( args[i] is Anchor ) b.push( args[i] );				else if ( args[i] is Array ) b = b.concat( args[i] );				else throw("Invalid Argument ( "+args[i]+" )");			}			anchors = b.concat( anchors );					}				/*--------------------------------------------------		* アンカーポイントの数		--------------------------------------------------*/		public function get length():uint { return anchors.length; }		public function set length( i_value:uint ):void {			while ( anchors.length < i_value ) anchors.push( anchors[ anchors.length - 1].clone() );		}				/*--------------------------------------------------		* 特定のアンカーポイントの後にアンカーポイントを追加		--------------------------------------------------*/		public function after( i_anchor:Anchor, ... args ):void {			var i:uint, index:int = -1, l:uint = anchors.length;			for ( i=0; i<l; i++ ) {				if ( anchors[i] == i_anchor ) {					index = i;					break;				}			}						if ( index < 0 ) return;			var b:Array = anchors.splice( 0, index + 1 );			l = args.length;			for ( i=0; i<l; i++ ) {				if ( args[i] is Anchor ) b.push( args[i] );				else if ( args[i] is Array ) b = b.concat( args[i] );				else throw("Invalid Argument ( "+args[i]+" )");			}			anchors = b.concat( anchors );		}				/*--------------------------------------------------		* 複製		--------------------------------------------------*/		public function clone():BezierPath {			var i:uint, l:uint = anchors.length;			var a:Array = [];			for ( i=0; i<l; i++ ) a.push( anchors[i].clone() );			return new BezierPath( a );		}				/*--------------------------------------------------		* SVGをパース		--------------------------------------------------*/		public function parseSVG( i_xml:XML ):void {			var d:String = i_xml.@d;			var pt:Point = new Point();			var px:Number, py:Number, nx:Number, ny:Number;			var s:int, m:String, t:String, tt:String, n:Array;			var prev:Anchor;			s = d.search( DATA_REG );			if ( s < 0 ) return;			anchors = [];			while( s >= 0 ) {				m = d.match( DATA_REG )[0];				t = m.substr(0,1);				tt = m.substr(1);				while( tt.match(/([0-9])-/) ) tt = tt.replace(/([0-9])-/,"$1,-");				n = tt.split(",");				switch( t ) {					/* 移動 */					case "m":						pt.x += parseFloat(n[0]);						pt.y += parseFloat(n[1]);						push( new Anchor( pt.x, pt.y ) );						break;					case "M":						pt.x = parseFloat(n[0]);						pt.y = parseFloat(n[1]);						push( new Anchor( pt.x, pt.y ) );						break;										/* 水平線 */					case "h":						pt.x += parseFloat(n[0]);						push( new Anchor( pt.x, pt.y ) );						break;					case "H":						pt.x = parseFloat(n[0]);						push( new Anchor( pt.x, pt.y ) );						break;										/* 垂直線 */					case "v":						pt.y += parseFloat(n[0]);						push( new Anchor( pt.x, pt.y ) );						break;					case "V":						pt.y = parseFloat(n[0]);						push( new Anchor( pt.x, pt.y ) );						break;										/* 直線 */					case "l":						pt.x += parseFloat(n[0]);						pt.y += parseFloat(n[1]);						push( new Anchor( pt.x, pt.y ) );						break;					case "L":						pt.x = parseFloat(n[0]);						pt.y = parseFloat(n[1]);						push( new Anchor( pt.x, pt.y ) );						break;										/* 三次ベジェ */					case "c":						nx = pt.x + parseFloat(n[0]);						ny = pt.y + parseFloat(n[1]);						px = pt.x + parseFloat(n[2]);						py = pt.y + parseFloat(n[3]);						pt.x += parseFloat(n[4]);						pt.y += parseFloat(n[5]);						if ( anchors.length ) {							prev = anchors[anchors.length - 1];							prev.nextX = nx;							prev.nextY = ny;						}						push( new Anchor( pt.x, pt.y, px, py ) );						break;					case "C":						nx = parseFloat(n[0]);						ny = parseFloat(n[1]);						px = parseFloat(n[2]);						py = parseFloat(n[3]);						pt.x += parseFloat(n[4]);						pt.y += parseFloat(n[5]);						if ( anchors.length ) {							prev = anchors[anchors.length - 1];							prev.nextX = nx;							prev.nextY = ny;						}						push( new Anchor( pt.x, pt.y, px, py ) );						break;											/* 省略型滑三次ベジェ  */					case "s":						px = pt.x + parseFloat(n[0]);						py = pt.y + parseFloat(n[1]);						pt.x += parseFloat(n[2]);						pt.y += parseFloat(n[3]);						if ( anchors.length ) {							prev = anchors[anchors.length - 1];							prev.nextX = isNaN(prev.prevX) ? prev.x : prev.x + ( prev.x - prev.prevX );							prev.nextY = isNaN(prev.prevY) ? prev.y : prev.y + ( prev.y - prev.prevY );						}						push( new Anchor( pt.x, pt.y, px, py ) );						break;					case "S":						nx = parseFloat(n[0]);						ny = parseFloat(n[1]);						px = parseFloat(n[2]);						py = parseFloat(n[3]);						pt.x += parseFloat(n[4]);						pt.y += parseFloat(n[5]);						if ( anchors.length ) {							prev = anchors[anchors.length - 1];							prev.nextX = isNaN(prev.prevX) ? prev.x : prev.x + ( prev.x - prev.prevX );							prev.nextY = isNaN(prev.prevY) ? prev.y : prev.y + ( prev.y - prev.prevY );						}						push( new Anchor( pt.x, pt.y, px, py ) );						break;					default:						trace(t);						break;				}				//				d = d.substr( m.length );				s = d.search( DATA_REG );			}		}				/*--------------------------------------------------		* Graphics描画		* 分割して３次ベジェを２次ベジェに変換して描画		--------------------------------------------------*/		public function redraw( i_graphics:Graphics ):void {			i_graphics.clear();			draw( i_graphics );		}				public function draw( i_graphics:Graphics ):void {			//初期化			if ( !anchors.length ) return;						var i:uint;			var l:uint = anchors.length - 1;			var t:Number;			var offset:Number = 1 / DIVISION;			var pt1:Point;			var pt2:Point;			var pt3:Point;			var sa:Anchor, ea:Anchor;			var s:Boolean, e:Boolean;			var b:BezierSegment;						i_graphics.lineStyle( 1, 0 );			i_graphics.moveTo( anchors[0].x,  anchors[0].y );			for ( i=0; i<l; i++ ) {				sa = anchors[i];				ea = anchors[i+1];				if ( sa.x == ea.x && sa.y == ea.y ) continue;				//コントロールポイントの有無				s = ( !isNaN( sa.nextX ) && !isNaN( sa.nextY ) ) as Boolean;				e = ( !isNaN( ea.prevX ) && !isNaN( ea.prevY ) ) as Boolean;				if ( s && e ) {					//３次ベジェを分割して近似２次ベジェに変換					b = new BezierSegment(						new Point( sa.x, sa.y ),						new Point( sa.nextX || 0, sa.nextY || 0 ), 						new Point( ea.prevX || 0, ea.prevY || 0 ), 						new Point( ea.x, ea.y )					);					t = 0;					while ( t < 1.0 - offset ) {						pt1 = b.getValue(t);						t += offset;						pt2 = b.getValue(t);						t += offset;						pt3 = b.getValue(t);												pt2 = new Point(							pt2.x * 2 - ( pt1.x + pt3.x ) * 0.5,							pt2.y * 2 - ( pt1.y + pt3.y ) * 0.5						);						if ( random != 0 ) {							pt2.x += Math.random() * random - random * 0.5;							pt2.y += Math.random() * random - random * 0.5;							pt3.x += Math.random() * random - random * 0.5;							pt3.y += Math.random() * random - random * 0.5;						}						i_graphics.curveTo( pt2.x, pt2.y, pt3.x, pt3.y );					}				} else {					//直線					i_graphics.lineTo( ea.x, ea.y );				}			}		}			}}