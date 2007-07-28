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