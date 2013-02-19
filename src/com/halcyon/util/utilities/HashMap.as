package com.halcyon.util.utilities{	
	import com.halcyon.util.utilities.Map;
	
	public class HashMap {
	
		private var map:Map;
		private var mapValues:Array;
		private var mapKeys:Array;
		private var mapSize:int = 0;
		private var id:String = "HashMap";
		
		public function HashMap( id:String = "HashMap") {
			if ( id != null ) this.id = id;
			this.mapValues = new Array();
			this.mapKeys = new Array();
			this.map = new Map();
		}
		
		public function toString( ) :String { 
			var s:String = "[HashMap]";
			var keys:Array = this.keys();
			var len:int = keys.length;
			var key:Object;
			var value:Object;
			for( var i:int = 0; i < len; i++) {
				key = keys[i];
				value = this.get(key); 
				s+= "\nkey: " + key + ", value: " + value;
			}
			return s;
		}
		
		private function calcValues( ) :void {
			this.mapValues = this.getValues();
			this.mapKeys = this.getKeys();
			this.mapSize = this.mapValues.length;			
		}
		
		public function clear( ) :void {
			for( var o:Object in this.map ) {
				delete this[o];
			}
			this.calcValues();	
		}	
		
		
		public function containsKey( key:Object ) :Boolean {
			key = Object(key);
			return ( this.map[key] != null );	
		}
		
		public function containsValue( value:Object ) :Boolean {			
			var aValue:Object;
			for( var o:Object in this.map ) {
				aValue = this.map[o];
				if ( aValue.equals(value) ) return true;
			}
			return false;
		}
		
		public function get( key:Object ) :Object {
			key = Object(key);
			return this.map[key];
		}
		
		public function put( key:Object, value:Object ) :void {
			key = Object(key);
			this.map[key] = value;		
			this.calcValues();	
		}
	
		public function putAll( newMap:HashMap ) :void {					
			var newKeys:Array = newMap.keys();
			var len:int = newKeys.length;		
			var key:Object;
			var value:Object;
			for( var i:int = 0; i < len; i++ ) {
				key = newKeys[i];
				value = newMap.get(key);
				this.put(  key, value );
			}		
		}
		
		public function remove( key:Object ) :Object {
			key = Object(key);
			var value:Object = this.map[key];
			delete this.map[key];
			this.calcValues();	
			return value;
		}
		
		public function size( ) :int {
			return this.mapSize;
		}
		
		public function keys( ) :Array {
			return this.mapKeys;
		}
		
		public function values( ) :Array {
			return this.mapValues;
		}
		
		
		private function getKeys( ) :Array {
			var aKeys:Array = new Array();
			for( var id:Object in this.map ) {			
				aKeys.push(id);
			}
			return aKeys;		
		}
		
		public function getValues( ) :Array {
			var aValues:Array = new Array();
			for( var id:Object in this.map ) {					
				aValues.push( this.map[id] );
			}
			return aValues;
		}
		
		
		
	}
}	