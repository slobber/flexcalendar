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
	import flexunit.framework.TestCase;
	
	public class CacheTest extends TestCase
	{
		private var cache:Cache = new Cache();
		private var counter:int = 0;
		private var activate:String = "";
		
		override public function setUp():void {
			super.setUp();
			cache.factory = function (key:*):String { return "" + (counter++) };	
			cache.activate = function (key:*, value:*):void {activate+="+"+key+"->"+value};
			cache.deactivate = function (value:*):void {activate+="-"+value};
		}
		
		public function testCreateNew():void {
			assertArray(["0", "1"], cache.activateKeys(["A", "B"]));
			assertEquals("", activate);
		}
		
		public function testCreateTwice():void {
			assertArray(["0"], cache.activateKeys(["A"]));
			assertArray(["0"], cache.activateKeys(["A"]));
			assertEquals("", activate);
		}
		
		public function testActivateDifferentSets():void {
			assertArray(["0"], cache.activateKeys(["A"]));
			assertArray(["0"], cache.activateKeys(["B"]));
			assertEquals("+B->0", activate);
		}
		
		public function testActivateDifferentOverlapSets():void {
			assertArray(["0", "1"], cache.activateKeys(["A", "B"]));
			assertArray(["1", "0"], cache.activateKeys(["B", "C"]));
			assertEquals("+C->0", activate);
		}
		
		public function testActivateTooMuch():void {
			assertArray(["0", "1"], cache.activateKeys(["A", "B"]));
			assertArray(["1"], cache.activateKeys(["B"]));
			assertArray(["1", "0"], cache.activateKeys(["B", "A"]));
			assertEquals("-0+A->0", activate);
		}
		
		public function assertArray(array1:Array, array2:Array):void {
			var msg:String = "["+array1 + "]!=[" + array2 + "]";
			assertEquals(msg, array1.length, array2.length);
			for (var i:int=0; i<array1.length; i++) {
				assertEquals(msg, array1[i], array2[i]);
			}
		}
	}
}