/*
 Copyright 2007 Misko Hevery <misko@hevery.com>

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
package com.hevery.cal
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	public class Cache
	{
		private var activeCache:Dictionary = new Dictionary();
		private var nonactivePool:ArrayCollection = new ArrayCollection();
		
		public var factory:Function = unsupported;
		public var activate:Function = noop;
		public var deactivate:Function = noop;
		
		public function activateKeys(keys:Array):Array {
			var oldActiveCache:Dictionary = activeCache;
			activeCache = new Dictionary();
			var values:Array = new Array(keys.length);
			
			var missing:ArrayCollection = reuseExistingKeys(keys, values, oldActiveCache);
			reuseUnNeededActive(keys, values, oldActiveCache, missing);
			reuseKeysFromNonActiveCache(keys, values, missing);
			createMissingKeys(keys, values, missing);
			
			return values;
		}
		
		public function addKey(key:*):void {
			var value:*;
			if (nonactivePool.length > 0) {
				value = nonactivePool.removeItemAt(0);
				activate(key, value);
			} else {
				value = factory(key);
			}
			activeCache[key] = value;
		}
		
		public function removeKey(key:*):void {
			var value:* = activeCache[key];
			if (value != null) {
				delete activeCache[key];
				deactivate(value);
				nonactivePool.addItem(value);
			}
		}
		
		private function reuseExistingKeys(keys:Array, values:Array, oldActiveCache:Dictionary):ArrayCollection {
			// First pass reuse anything where keys match.
			var missing:ArrayCollection = new ArrayCollection();
			for(var i:int=0; i<keys.length; i++) {
				var key:* = keys[i];
				var value:*  = oldActiveCache[key];
				if (value != null) { 
					delete oldActiveCache[key];
					values[i] = value;
					activeCache[key] = value;
				} else {
					missing.addItem(i);
				}
			}
			return missing;
		}
		
		private function reuseUnNeededActive(keys:Array, values:Array, oldActiveCache:Dictionary, missing:ArrayCollection):void {	
			// Second pass reuse any keys which are not needed in active set or deactiveate them.
			for(var oldKey:* in oldActiveCache) {
				var value:* = oldActiveCache[oldKey];
				delete oldActiveCache[oldKey];
				if (missing.length>0) {
					var i:int = int(missing.getItemAt(0));
					missing.removeItemAt(0);
					values[i] = value;
					var key:* = keys[i];
					activate(key, value);
					activeCache[key] = value;
				} else {
					deactivate(value);
					nonactivePool.addItem(value);
				}
			}
		}
		
		private function reuseKeysFromNonActiveCache(keys:Array, values:Array, missing:ArrayCollection):void {
			// Third pass reuse any keys from the nonactive cache
			while(missing.length>0 && nonactivePool.length>0) {
				var value:* = nonactivePool.removeItemAt(0);
				var i:* = int(missing.getItemAt(0));
				missing.removeItemAt(0);
				var key:* = keys[i];
				activate(key, value);
				activeCache[key] = value;
				values[i] = value;
			}			
		}
		
		private function createMissingKeys(keys:Array, values:Array, missing:ArrayCollection):void {
			// Fourth pass, create missing ids using factory.
			while(missing.length>0) {
				var i:* = int(missing.getItemAt(0));
				missing.removeItemAt(0);
				var key:* = keys[i];
				var value:* = factory(key);
				activeCache[key] = value;
				values[i] = value;
			}
		}
		
		public function get activeCollection():ArrayCollection {
			var list:ArrayCollection = new ArrayCollection();
			for each (var item:* in activeCache)
				list.addItem(item);
			return list;
		}
		
		
		private function noop(key:*, value:*):void {}
		private function unsupported(key:*):* {
			throw new IllegalOperationError();
		}
		
		
	}
}