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

	public class DateUtilTest extends TestCase
	{
		public function testTimeBlocksOverlap1():void {
			assertTrue(DateUtil.timeBlocksOverlap(new Date(2000), new Date(2002), new Date(1999), new Date(2003)));
		}
		
		public function testTimeBlocksOverlap2():void {
			assertTrue(DateUtil.timeBlocksOverlap(new Date(2000), new Date(2002), new Date(2001), new Date(2003)));
		}
		
		public function testTimeBlocksOverlap3():void {
			assertTrue(DateUtil.timeBlocksOverlap(new Date(2000), new Date(2002), new Date(2001), new Date(2004)));
		}
		public function testTimeBlocksOverlap4():void {
			assertFalse(DateUtil.timeBlocksOverlap(new Date(2000), new Date(2002), new Date(2002), new Date(2004)));
		}
		
	}
}