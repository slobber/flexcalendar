// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal
{
	public class DateUtil
	{
		public static const MILISECOND:Number = 1;
		public static const SECOND:Number = 1000 * MILISECOND;
		public static const MINUTE:Number = 60 * SECOND;
		public static const HOUR:Number = 60 * MINUTE;
		public static const DAY:Number = 24 * HOUR;
		public static const WEEK:Number = 7 * DAY;
		public static const MONTH:Number = 31 * DAY;
		
		public static function trimToMonth(date:Date):Date {
			return new Date(date.fullYear, date.month);
		}
		
		public static function trimToWeek(date:Date):Date {
			var trim:Date = trimToDay(date);
			return new Date(trim.time - trim.day * DAY);
		}
		
		public static function trimToDay(date:Date):Date {
			return new Date(date.fullYear, date.month, date.date);
		}
		
		public static function trimToHour(date:Date):Date {
			return new Date(date.fullYear, date.month, date.date, date.hours);
		}
		
		public static function timeBlocksOverlap(start1:Date, end1:Date, start2:Date, end2:Date):Boolean {
			if (start1 == null || start2 == null || end1 == null || end2 == null)
				return false;
			else if (start1.time < start2.time)
				return end1.time > start2.time;
			else
				return start1.time < end2.time;
		}
	}
}