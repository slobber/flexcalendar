// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.calsample
{
	import com.hevery.cal.CalendarDescriptor;

	public class SampleCalendarDescriptor implements CalendarDescriptor
	{
		public function getCalendarColor(calendar:*):Number {
			return (calendar as Calendar).color;
		}
		
		public function getCalendarName(calendar:*):String {
			return (calendar as Calendar).name;
		}
		
		public function getCalendar(event:*):* {
			return (event as Event).calendar;
		}


		
		public function getEventStart(event:*):Date {
			return (event as Event).start;
		}
		
		public function getEventEnd(event:*):Date {
			return (event as Event).end;
		}
		
		public function getEventTitle(event:*):String {
			return (event as Event).what;
		}
		
		public function getEventDescription(event:*):String {
			return (event as Event).description;
		}
		
		public function getEventColor(event:*):Number {
			return (event as Event).calendar.color;
		}
		
		
	}
}