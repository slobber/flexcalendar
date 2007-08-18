// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal
{
	import mx.collections.ArrayCollection;
	
	public class NullCalendarDescriptor implements CalendarDescriptor
	{
		public function getCalendarColor(calendar:*):Number{return 0;}
		public function getCalendarName(calendar:*):String{return "";}
		public function getCalendar(event:*):*{return null;}
		
		public function getEventStart(event:*):Date{return null;}
		public function getEventEnd(event:*):Date{return null;}
		public function getEventTitle(event:*):String{return "";}
		public function getEventDescription(event:*):String{return "";}
		public function getEventColor(event:*):Number{return 0;}
	}
}