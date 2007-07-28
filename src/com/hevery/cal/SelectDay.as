// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal
{
	import flash.events.Event;

	public class SelectDay extends Event
	{
		public static const SELECT_DAY:String = "selectDay";
		public var date:Date;
		
		public function SelectDay(date:Date) {
			super(SELECT_DAY);
			this.date = date;
		}
	}
}