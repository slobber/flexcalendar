// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal
{
	import flash.events.Event;

	public class ChooseDay extends Event
	{
		public static const CHOOSE_DAY:String = "chooseDay";
		public var date:Date;
		
		public function ChooseDay(date:Date) {
			super(CHOOSE_DAY);
			this.date = date;
		}
	}
}