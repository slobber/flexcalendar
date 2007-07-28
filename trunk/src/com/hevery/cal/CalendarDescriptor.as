// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal
{
	import mx.collections.ArrayCollection;
	
	public interface CalendarDescriptor
	{
		function getCalendarColor(calendar:*):Number;
		function getCalendarName(calendar:*):String;
		function getCalendar(event:*):*;

		function getEventStart(event:*):Date;
		function getEventEnd(event:*):Date;
		function getEventTitle(event:*):String;
		function getEventDescription(event:*):String;
		function getEventColor(event:*):Number;
	}
}