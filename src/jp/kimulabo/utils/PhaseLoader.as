package jp.kimulabo.utils {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.Bitmap;
	import flash.system.Security;

	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.BulkLoader;

	/**
	 * @author kimura
	 */
	public class PhaseLoader extends EventDispatcher {
		
		/*--------------------------------------------------
		* 定数
		--------------------------------------------------*/
		public static const PHASE_COMPLETE:String = "phaseComplete";
		public static const ALL_COMPLETE:String = "complete";
		public static const PROGRESS:String = "progress";
		
		/*--------------------------------------------------
		* プライベート変数
		--------------------------------------------------*/
		private var _phases:Array;
		
		private var _loading:Boolean = false;
		
		private var _phase:uint = 0;
		private var _phaseProgress:Number = 0;
		private var _progress:Number = 0;
		
		/*--------------------------------------------------
		* パブリック変数
		--------------------------------------------------*/
		
		public function get phases():Array { return _phases.concat(); }
		public function get phase():uint { return _phase; }
		public function get phaseProgress():Number { return _phaseProgress; }
		public function get progress():Number { return _progress; }
		
		/*--------------------------------------------------
		* コンストラクタ
		--------------------------------------------------*/
		public function PhaseLoader( i_phases:Array ) {
			_phases = i_phases
		}
		
		/*--------------------------------------------------
		* ロード
		--------------------------------------------------*/
		public function load():void {
			//weightの設定と自動計算
			var totalWeight:Number = 0;
			var noWeightedPhases:uint = 0;
			var phase:LoadingPhase;
			var i:uint;
			var l:uint = _phases.length;
			for ( i=0; i<l; i++ ) {
				phase = _phases[i];
				if ( phase.weight ) totalWeight += phase.weight;
				else noWeightedPhases++;
			}
			var weightedPhases:uint = l - noWeightedPhases;
			var noWeightedWeight:Number;
			if ( totalWeight ) {
				if ( noWeightedPhases ) {
					noWeightedWeight = totalWeight / weightedPhases;
					totalWeight += noWeightedWeight * noWeightedPhases;
				}
			} else {
				totalWeight = 1;
				noWeightedWeight = totalWeight / l;
			}
			for ( i=0; i<l; i++ ) {
				phase = _phases[i];
				if ( phase.weight ) phase.weight = phase.weight / totalWeight;
				else phase.weight = noWeightedWeight;
			}
			//
			_load();
		}
		
		/*--------------------------------------------------
		* 現在のフェーズのロードを開始
		--------------------------------------------------*/
		private function _load():void {
			//
			_phases[_phase].addEventListener( BulkProgressEvent.PROGRESS, _onProgress );
			_phases[_phase].addEventListener( BulkProgressEvent.COMPLETE, _onPhaseComplete );
			_phases[_phase].load();
		}
		
		/*--------------------------------------------------
		* ローディング中
		--------------------------------------------------*/
		private function _onProgress ( i_event:BulkProgressEvent ):void {
			_phaseProgress = _phases[_phase].progress;
			_progress = 0;
			var i:uint;
			for ( i=0; i<_phase; i++ ) _progress += _phases[i].weight;
			_progress += _phases[_phase].progress * _phases[_phase].weight;
			dispatchEvent( new Event( PROGRESS ) );
		}
		
		/*--------------------------------------------------
		* １つのローディングフェーズの完了
		--------------------------------------------------*/
		private function _onPhaseComplete( i_event:BulkProgressEvent ):void {
			
			_phases[_phase].removeEventListener( BulkProgressEvent.PROGRESS, _onProgress );
			_phases[_phase].removeEventListener( BulkProgressEvent.COMPLETE, _onPhaseComplete );
			dispatchEvent( new Event( PHASE_COMPLETE ) );
			
			//次のフェーズへ
			_phase++;
			if ( _phase >= _phases.length ) _complete();
			else _load();
		}
		
		/*--------------------------------------------------
		* 全てのローディングフェーズの完了
		--------------------------------------------------*/
		private function _complete():void {
			_progress = 1;
			dispatchEvent( new Event( ALL_COMPLETE ) );
		}
		
		/*--------------------------------------------------
		* データの取得
		--------------------------------------------------*/
		public function get( i_key:String, i_type:Class = null, i_clearMemory:Boolean = false ):* {
			var b:BulkLoader = BulkLoader.whichLoaderHasItem( i_key );
			if ( !b ) return null;
			if ( i_type ) {
				return b.getContentAsType( i_key, i_type, i_clearMemory );
			}
			if ( i_key.match(/^.+\.([a-z0-9]+)/) ) {
				var img:Array = BulkLoader.IMAGE_EXTENSIONS;
				var ext:String = i_key.replace(/^.+\.([a-z0-9]+)/i,"$1").toLowerCase();
				if ( ext && img.indexOf(ext) >= 0 ) return b.getBitmapData( i_key, i_clearMemory );
			}
			var c:* = b.getContent( i_key, i_clearMemory );
			if ( c is Bitmap ) return c.bitmapData;
			return c;
		}
		
		/*--------------------------------------------------
		* ロードするファイルの追加
		--------------------------------------------------*/
		public function add( i_path:String, i_phase:uint = 0 ):void {
			var p:uint = i_phase;
			if ( p <= _phase ) p = _phase + 1;
			if ( p >= _phases.length ) throw("PhaseLoader.add : There is no phase to add file.");
			_phases[p].add( i_path );
		}
	}
}
