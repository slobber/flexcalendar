// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.calsample
{
	import com.hevery.cal.DateUtil;
	
	import mx.collections.ArrayCollection;
	
	public class RandomCalendarGenerator
	{
		public var events:ArrayCollection = new ArrayCollection();
		public var calendars:ArrayCollection = new ArrayCollection();
		public var numberOfCalendars:int = 5;
		public var colors:Array = [0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0x00FFFF];
		public var words:Array = [
				"lorem", "ipsum", "dolor", "dit", "amet", "consectetuer", 
				"adipiscing", "elit", "molestie", "imperdiet", "ante", 
				"praesent", "at", "metus", "in", "nunc", "malesuada", "aliquet"
			];
		
		public function generate():void {
			for(var i:int=0; i<numberOfCalendars; i++) {
				var calendar:Calendar = new Calendar();
				calendars.addItem(calendar);
				calendar.color = colors[i];
				calendar.name = generateName();
				generateEvents(events, calendar);
			}
		}
		
		private function generateEvents(events:ArrayCollection, calendar:Calendar):void {
			var time:Number = DateUtil.trimToDay(new Date()).time;
			time = time - new Date(time).day * DateUtil.DAY;
			for(var i:int=0; i<100; i++) {
				time = time + randomDuration(20);
				var event:Event = new Event();
				event.calendar = calendar;
				event.what = generateName();
				event.where = generateName();
				event.description = generateDescription();
				event.start = new Date(time);
				time = time + randomDuration(5, 1);
				event.end = new Date(time);
				events.addItem(event);
			}
		}
		
		private function randomDuration(hours:int, min:int=0):Number {
			return 1000 * 60 * 15 * Math.floor((Math.random() * (hours-min) + min) * 4);
		}
		
		private function generateName():String {
			return words[Math.floor(Math.random() * words.length)];
		}
		
		private function generateDescription():String {
			var description:String = "";
			var sep:String = "";
			var size:int = Math.random() * 25;
			for(var i:int=0; i<size; i++) {
				description = description + sep + generateName();
				sep = " ";
			}
			return description;
		}
	}
}