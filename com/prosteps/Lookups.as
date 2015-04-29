package com.prosteps
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.rpc.events.ResultEvent;
	
	[Bindable(event="changed")]
	public class Lookups extends EventDispatcher {
		
		private var _app:Object = FlexGlobals.topLevelApplication;
		
		public var id_language:int = 1;
		
		public function Lookups():void {
			
			/*init();
		}
		
		private function init():void {
			if(_app != null && _app.srvBase != null) {
				//this.serviceBase = _app.srvBase;
				
				_app.srvBase.AanspreekTitel.addEventListener('result', AanspreekTitelResult, false, 0, true);
				_app.srvBase.BtwStelsel.addEventListener('result', BtwStelselResult, false, 0, true);
				_app.srvBase.CorrespondentieWijze.addEventListener('result', CorrespondentieWijzeResult, false, 0, true);
				_app.srvBase.Dienst.addEventListener('result', DienstResult, false, 0, true);
				_app.srvBase.Eenheid.addEventListener('result', EenheidResult, false, 0, true);
				_app.srvBase.KlantAdresType.addEventListener('result', KlantAdresTypeResult, false, 0, true);
				_app.srvBase.KlantType.addEventListener('result', KlantTypeResult, false, 0, true);
				_app.srvBase.Kleur.addEventListener('result', KleurResult, false, 0, true);
				_app.srvBase.Land.addEventListener('result', LandResult, false, 0, true);
				_app.srvBase.Languages.addEventListener('result', LanguagesResult, false, 0, true);
				_app.srvBase.Leverstatus.addEventListener('result', LeverstatusResult, false, 0, true);
				_app.srvBase.Merk.addEventListener('result', MerkResult, false, 0, true);
				_app.srvBase.Rayon.addEventListener('result', RayonResult, false, 0, true);
				_app.srvBase.Seizoen.addEventListener('result', SeizoenResult, false, 0, true);
				_app.srvBase.VerkoopsWijze.addEventListener('result', VerkoopsWijzeResult, false, 0, true);
				_app.srvBase.Weekdagen.addEventListener('result', WeekdagenResult, false, 0, true);
				
				
				
			}*/
		}
		
		
		
		
		/* AanspreekTitel */
		private var _AanspreekTitel:ArrayCollection;
		private var _AanspreekTitelInCall:Boolean = false;
		public function initAanspreekTitel():void {
			_app.srvBase.AanspreekTitel(id_language);
		}
		private function AanspreekTitelResult(event:ResultEvent):void {
			_AanspreekTitelInCall = false;
			this._AanspreekTitel = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get AanspreekTitel():ArrayCollection {
			if(!_app.srvBase.AanspreekTitel.hasEventListener('result')){
				_app.srvBase.AanspreekTitel.addEventListener('result', AanspreekTitelResult, false, 0, true);
			}
			if ((_AanspreekTitel == null) && (_AanspreekTitelInCall == false)){
				_AanspreekTitelInCall = true;
				initAanspreekTitel();
			}
			return _AanspreekTitel;
		}
		public function set AanspreekTitel(value:ArrayCollection):void {
			_AanspreekTitel = value;
			this.dispatchEvent( new Event('changed') );
		}
		
		
		
		
		
		
		/* BetalingsConditie */
		private var _BetalingsConditie:ArrayCollection;
		private var _BetalingsConditieInCall:Boolean = false;
		public function initBetalingsConditie():void {
			_app.srvBase.BetalingsConditie(id_language);
		}
		private function BetalingsConditieResult(event:ResultEvent):void {
			_BetalingsConditieInCall = false;
			this._BetalingsConditie = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get BetalingsConditie():ArrayCollection {
			if(!_app.srvBase.BetalingsConditie.hasEventListener('result')){
				_app.srvBase.BetalingsConditie.addEventListener('result', BetalingsConditieResult, false, 0, true);
			}
			if ((_BetalingsConditie == null) && (_BetalingsConditieInCall == false)){
				_BetalingsConditieInCall = true;
				initBetalingsConditie();
			}
			return _BetalingsConditie;
		}
		public function set BetalingsConditie(value:ArrayCollection):void {
			_BetalingsConditie = value;
			this.dispatchEvent( new Event('changed') );
		}
		
		
		
		
		
		/* BtwStelsel */
		private var _BtwStelsel:ArrayCollection;
		private var _BtwStelselInCall:Boolean = false;
		public function initBtwStelsel():void {
			_app.srvBase.BtwStelsel(id_language);
		}
		private function BtwStelselResult(event:ResultEvent):void {
			_BtwStelselInCall = false;
			this._BtwStelsel = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get BtwStelsel():ArrayCollection {
			if(!_app.srvBase.BtwStelsel.hasEventListener('result')){
				_app.srvBase.BtwStelsel.addEventListener('result', BtwStelselResult, false, 0, true);
			}
			if ((_BtwStelsel == null) && (_BtwStelselInCall == false)){
				_BtwStelselInCall = true;
				initBtwStelsel();
			}
			return _BtwStelsel;
		}
		public function set BtwStelsel(value:ArrayCollection):void {
			_BtwStelsel = value;
			this.dispatchEvent( new Event('changed') );
		}
		
		
		
		
		
		/* CorrespondentieWijze */
		private var _CorrespondentieWijze:ArrayCollection;
		private var _CorrespondentieWijzeInCall:Boolean = false;
		public function initCorrespondentieWijze():void {
			_app.srvBase.CorrespondentieWijze(id_language);
		}
		private function CorrespondentieWijzeResult(event:ResultEvent):void {
			_CorrespondentieWijzeInCall = false;
			this._CorrespondentieWijze = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get CorrespondentieWijze():ArrayCollection {
			if(!_app.srvBase.CorrespondentieWijze.hasEventListener('result')){
				_app.srvBase.CorrespondentieWijze.addEventListener('result', CorrespondentieWijzeResult, false, 0, true);
			}
			if ((_CorrespondentieWijze == null) && (_CorrespondentieWijzeInCall == false)){
				_CorrespondentieWijzeInCall = true;
				initCorrespondentieWijze();
			}
			return _CorrespondentieWijze;
		}
		public function set CorrespondentieWijze(value:ArrayCollection):void {
			_CorrespondentieWijze = value;
			this.dispatchEvent( new Event('changed') );
		}
		
		
		
		
		/* Dienst */
		private var _Dienst:ArrayCollection;
		private var _DienstInCall:Boolean = false;
		public function initDienst():void {
			_app.srvBase.Dienst(id_language);
		}
		private function DienstResult(event:ResultEvent):void {
			_DienstInCall = false;
			this._Dienst = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get Dienst():ArrayCollection {
			if(!_app.srvBase.Dienst.hasEventListener('result')){
				_app.srvBase.Dienst.addEventListener('result', DienstResult, false, 0, true);
			}
			if ((_Dienst == null) && (_DienstInCall == false)){
				_DienstInCall = true;
				initDienst();
			}
			return _Dienst;
		}
		public function set Dienst(value:ArrayCollection):void {
			_Dienst = value;
			this.dispatchEvent( new Event('changed') );
		}
		
		
		
		/* Eenheid * /
		private var _Eenheid:ArrayCollection;
		private var _EenheidInCall:Boolean = false;
		public function initEenheid():void {
			_app.srvBase.Eenheid(id_language);
		}
		private function EenheidResult(event:ResultEvent):void {
			_EenheidInCall = false;
			this._Eenheid = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get Eenheid():ArrayCollection {
			if(!_app.srvBase.Eenheid.hasEventListener('result')){
				_app.srvBase.Eenheid.addEventListener('result', EenheidResult, false, 0, true);
			}
			if ((_Eenheid == null) && (_EenheidInCall == false)){
				_EenheidInCall = true;
				initEenheid();
			}
			return _Eenheid;
		}
		public function set Eenheid(value:ArrayCollection):void {
			_Eenheid = value;
			this.dispatchEvent( new Event('changed') );
		}*/
		
		
		
		
		
		/* KlantAdresType */
		private var _KlantAdresType:ArrayCollection;
		private var _KlantAdresTypeInCall:Boolean = false;
		public function initKlantAdresType():void {
			_app.srvBase.KlantAdresType(id_language);
		}
		private function KlantAdresTypeResult(event:ResultEvent):void {
			_KlantAdresTypeInCall = false;
			this._KlantAdresType = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get KlantAdresType():ArrayCollection {
			if(!_app.srvBase.KlantAdresType.hasEventListener('result')){
				_app.srvBase.KlantAdresType.addEventListener('result', KlantAdresTypeResult, false, 0, true);
			}
			if ((_KlantAdresType == null) && (_KlantAdresTypeInCall == false)){
				_KlantAdresTypeInCall = true;
				initKlantAdresType();
			}
			return _KlantAdresType;
		}
		public function set KlantAdresType(value:ArrayCollection):void {
			_KlantAdresType = value;
			this.dispatchEvent( new Event('changed') );
		}
		
		
		
		
		
		/* KlantType */
		private var _KlantType:ArrayCollection;
		private var _KlantTypeInCall:Boolean = false;
		public function initKlantType():void {
			_app.srvBase.KlantType(id_language);
		}
		private function KlantTypeResult(event:ResultEvent):void {
			_KlantTypeInCall = false;
			this._KlantType = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get KlantType():ArrayCollection {
			if(!_app.srvBase.KlantType.hasEventListener('result')){
				_app.srvBase.KlantType.addEventListener('result', KlantTypeResult, false, 0, true);
			}
			if ((_KlantType == null) && (_KlantTypeInCall == false)){
				_KlantTypeInCall = true;
				initKlantType();
			}
			return _KlantType;
		}
		public function set KlantType(value:ArrayCollection):void {
			_KlantType = value;
			this.dispatchEvent( new Event('changed') );
		}
		
		
		
		
		
		/* Kleur */
		private var _Kleur:ArrayCollection;
		private var _KleurInCall:Boolean = false;
		public function initKleur():void {
			_app.srvBase.Kleur(id_language);
		}
		private function KleurResult(event:ResultEvent):void {
			_KleurInCall = false;
			this._Kleur = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get Kleur():ArrayCollection {
			if(!_app.srvBase.Kleur.hasEventListener('result')){
				_app.srvBase.Kleur.addEventListener('result', KleurResult, false, 0, true);
			}
			if ((_Kleur == null) && (_KleurInCall == false)){
				_KleurInCall = true;
				initKleur();
			}
			return _Kleur;
		}
		public function set Kleur(value:ArrayCollection):void {
			_Kleur = value;
			this.dispatchEvent( new Event('changed') );
		}
		
		
		
		
		
		/* Land */
		private var _Land:ArrayCollection;
		private var _LandInCall:Boolean = false;
		public function initLand():void {
			_app.srvBase.Land(id_language);
		}
		private function LandResult(event:ResultEvent):void {
			_LandInCall = false;
			this._Land = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get Land():ArrayCollection {
			if(!_app.srvBase.Land.hasEventListener('result')){
				_app.srvBase.Land.addEventListener('result', LandResult, false, 0, true);
			}
			if ((_Land == null) && (_LandInCall == false)){
				_LandInCall = true;
				initLand();
			}
			return _Land;
		}
		public function set Land(value:ArrayCollection):void {
			_Land = value;
			this.dispatchEvent( new Event('changed') );
		}
		
		
		
		
		
		/* Languages */
		private var _Languages:ArrayCollection;
		private var _LanguagesInCall:Boolean = false;
		public function initLanguages():void {
			_app.srvBase.Languages(id_language);
		}
		private function LanguagesResult(event:ResultEvent):void {
			_LanguagesInCall = false;
			this._Languages = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get Languages():ArrayCollection {
			if(!_app.srvBase.Languages.hasEventListener('result')){
				_app.srvBase.Languages.addEventListener('result', LanguagesResult, false, 0, true);
			}
			if ((_Languages == null) && (_LanguagesInCall == false)){
				_LanguagesInCall = true;
				initLanguages();
			}
			return _Languages;
		}
		public function set Languages(value:ArrayCollection):void {
			_Languages = value;
			this.dispatchEvent( new Event('changed') );
		}
		
		
		
		/* Leverstatus */
		private var _Leverstatus:ArrayCollection;
		private var _LeverstatusInCall:Boolean = false;
		public function initLeverstatus():void {
			_app.srvBase.Leverstatus(id_language);
		}
		private function LeverstatusResult(event:ResultEvent):void {
			_LeverstatusInCall = false;
			this._Leverstatus = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get Leverstatus():ArrayCollection {
			if(!_app.srvBase.Leverstatus.hasEventListener('result')){
				_app.srvBase.Leverstatus.addEventListener('result', LeverstatusResult, false, 0, true);
			}
			if ((_Leverstatus == null) && (_LeverstatusInCall == false)){
				_LeverstatusInCall = true;
				initLeverstatus();
			}
			return _Leverstatus;
		}
		public function set Leverstatus(value:ArrayCollection):void {
			_Leverstatus = value;
			this.dispatchEvent( new Event('changed') );
		}
		
		
		
		/* Merk */
		private var _Merk:ArrayCollection;
		private var _MerkInCall:Boolean = false;
		public function initMerk():void {
			_app.srvBase.Merk(id_language);
		}
		private function MerkResult(event:ResultEvent):void {
			_MerkInCall = false;
			this._Merk = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get Merk():ArrayCollection {
			if(!_app.srvBase.Merk.hasEventListener('result')){
				_app.srvBase.Merk.addEventListener('result', MerkResult, false, 0, true);
			}
			if ((_Merk == null) && (_MerkInCall == false)){
				_MerkInCall = true;
				initMerk();
			}
			return _Merk;
		}
		public function set Merk(value:ArrayCollection):void {
			_Merk = value;
			this.dispatchEvent( new Event('changed') );
		}
		
		
		
		
		/* Rayon */
		private var _Rayon:ArrayCollection;
		private var _RayonInCall:Boolean = false;
		public function initRayon():void {
			_app.srvBase.Rayon(id_language);
		}
		private function RayonResult(event:ResultEvent):void {
			_RayonInCall = false;
			this._Rayon = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get Rayon():ArrayCollection {
			if(!_app.srvBase.Rayon.hasEventListener('result')){
				_app.srvBase.Rayon.addEventListener('result', RayonResult, false, 0, true);
			}
			if ((_Rayon == null) && (_RayonInCall == false)){
				_RayonInCall = true;
				initRayon();
			}
			return _Rayon;
		}
		public function set Rayon(value:ArrayCollection):void {
			_Rayon = value;
			this.dispatchEvent( new Event('changed') );
		}
		
		
		
		
		/* Seizoen */
		private var _Seizoen:ArrayCollection;
		private var _SeizoenInCall:Boolean = false;
		public function initSeizoen():void {
			_app.srvBase.Seizoen(id_language);
		}
		private function SeizoenResult(event:ResultEvent):void {
			_SeizoenInCall = false;
			this._Seizoen = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get Seizoen():ArrayCollection {
			if(!_app.srvBase.Seizoen.hasEventListener('result')){
				_app.srvBase.Seizoen.addEventListener('result', SeizoenResult, false, 0, true);
			}
			if ((_Seizoen == null) && (_SeizoenInCall == false)){
				_SeizoenInCall = true;
				initSeizoen();
			}
			return _Seizoen;
		}
		public function set Seizoen(value:ArrayCollection):void {
			_Seizoen = value;
			this.dispatchEvent( new Event('changed') );
		}
		
		
		
		
		/* VerkoopsWijze */
		private var _VerkoopsWijze:ArrayCollection;
		private var _VerkoopsWijzeInCall:Boolean = false;
		public function initVerkoopsWijze():void {
			_app.srvBase.VerkoopsWijze(id_language);
		}
		private function VerkoopsWijzeResult(event:ResultEvent):void {
			_VerkoopsWijzeInCall = false;
			this._VerkoopsWijze = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get VerkoopsWijze():ArrayCollection {
			if(!_app.srvBase.VerkoopsWijze.hasEventListener('result')){
				_app.srvBase.VerkoopsWijze.addEventListener('result', VerkoopsWijzeResult, false, 0, true);
			}
			if ((_VerkoopsWijze == null) && (_VerkoopsWijzeInCall == false)){
				_VerkoopsWijzeInCall = true;
				initVerkoopsWijze();
			}
			return _VerkoopsWijze;
		}
		public function set VerkoopsWijze(value:ArrayCollection):void {
			_VerkoopsWijze = value;
			this.dispatchEvent( new Event('changed') );
		}
		
		
		
		
		
		/* VerzendWijze */
		private var _VerzendWijze:ArrayCollection;
		private var _VerzendWijzeInCall:Boolean = false;
		public function initVerzendWijze():void {
			_app.srvBase.VerzendWijze(id_language);
		}
		private function VerzendWijzeResult(event:ResultEvent):void {
			_VerzendWijzeInCall = false;
			this._VerzendWijze = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get VerzendWijze():ArrayCollection {
			if(!_app.srvBase.VerzendWijze.hasEventListener('result')){
				_app.srvBase.VerzendWijze.addEventListener('result', VerzendWijzeResult, false, 0, true);
			}
			if ((_VerzendWijze == null) && (_VerzendWijzeInCall == false)){
				_VerzendWijzeInCall = true;
				initVerzendWijze();
			}
			return _VerzendWijze;
		}
		public function set VerzendWijze(value:ArrayCollection):void {
			_VerzendWijze = value;
			this.dispatchEvent( new Event('changed') );
		}
		
		
		
		
		/* Weekdagen */
		private var _Weekdagen:ArrayCollection;
		private var _WeekdagenInCall:Boolean = false;
		public function initWeekdagen():void {
			_app.srvBase.Weekdagen(id_language);
		}
		private function WeekdagenResult(event:ResultEvent):void {
			_WeekdagenInCall = false;
			this._Weekdagen = ArrayCollection(event.result);
			this.dispatchEvent( new Event('changed') );
		}
		public function get Weekdagen():ArrayCollection {
			if(!_app.srvBase.Weekdagen.hasEventListener('result')){
				_app.srvBase.Weekdagen.addEventListener('result', WeekdagenResult, false, 0, true);
			}
			if ((_Weekdagen == null) && (_WeekdagenInCall == false)){
				_WeekdagenInCall = true;
				initWeekdagen();
			}
			return _Weekdagen;
		}
		public function set Weekdagen(value:ArrayCollection):void {
			_Weekdagen = value;
			this.dispatchEvent( new Event('changed') );
		}
		
		
		

	}
}