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
			var res:Boolean;
			if (start1 == null || start2 == null || end1 == null || end2 == null)
				res = false;
			else if (start1.time > end1.time) 
				// week wraps around
				res = start1.time >= start2.time && start1.time < end2.time ||
					  end1.time > start2.time && end1.time <= end2.time;	
			else if (start1.time < start2.time)
				res = end1.time > start2.time;
			else
				res =  start1.time < end2.time;
			return res;
		}
	}
}