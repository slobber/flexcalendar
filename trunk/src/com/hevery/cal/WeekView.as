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
	import com.hevery.cal.DateUtil;
	import com.hevery.cal.decoration.VerticalTimeRuler;
	import com.hevery.cal.view.CalendarView;
	
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.controls.VScrollBar;
	import mx.formatters.DateFormatter;

	public class WeekView extends HBox
	{
		
		private var rulerChrome:DayChrome = new DayChrome();
		private var ruler:VerticalTimeRuler = new VerticalTimeRuler();
		private var scrollBar:VScrollBar = new VScrollBar();
		private var chromes:ArrayCollection = new ArrayCollection();
		private var views:ArrayCollection = new ArrayCollection();
		
		public var dateFormatter:DateFormatter = new DateFormatter();
		
		public var hourHeight:Number = 50;

		public function set calendarDescriptor(calendarDescriptor:CalendarDescriptor):void {
			for each (var view:CalendarView in views)
				view.calendarDescriptor = calendarDescriptor;
		}
		
		public function set events(events:ArrayCollection):void {
			for each (var view:CalendarView in views)
				view.events = events;
		}
		
		public function set calendars(calendars:ArrayCollection):void {
			for each (var view:CalendarView in views)
				view.calendars = calendars;
		}
		
		public function set date(date:Date):void {
			date = DateUtil.trimToWeek(date);
			for (var i:int = 0; i < 7 ; i++) {
				var chrome:DayChrome = chromes.getItemAt(i) as DayChrome;
				var view:CalendarView = views.getItemAt(i) as CalendarView;
				chrome.title = dateFormatter.format(date);
				view.date = date;
				
				date = new Date(date.time + DateUtil.DAY);
			}
		}
		
		public function WeekView(hrHeight:Number=50) {
			hourHeight = hrHeight;
			ruler.pixelsPerMilisecond = hourHeight / DateUtil.HOUR;
			for (var i:int = 0; i < 7 ; i++) {
				views.addItem(new CalendarView());
				chromes.addItem(new DayChrome());
			}
			dateFormatter.formatString = "EEEE MMM D";
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			rulerChrome.title = "";
			rulerChrome.percentHeight = 100;
			rulerChrome.width = 52;
			rulerChrome.verticalScrollBar = scrollBar;
			rulerChrome.addChild(ruler);
			addChild(rulerChrome);

			ruler.height = 24 * hourHeight;
			
			label = "Week";
			setStyle("horizontalGap", 0);
			
			scrollBar.percentHeight = 100;
			
			for (var i:int = 0; i < 7 ; i++) {
				var chrome:DayChrome = chromes.getItemAt(i) as DayChrome;
				chrome.percentHeight = 100;
				chrome.percentWidth = 100;
				chrome.verticalScrollBar = scrollBar;
				
				var view:CalendarView = views.getItemAt(i) as CalendarView;
				view.height = 24 * hourHeight;
				view.percentWidth = 100;
				
				chrome.addChild(view);
				addChild(chrome);
			}
			addChild(scrollBar);
//			date = new Date();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			updateScrollSize();
		}
		
		private function updateScrollSize():void {
			var viewHeight:Number = chromes.getItemAt(0).viewHeight;
			var actualHeight:Number = 24 * hourHeight;
			if (actualHeight > viewHeight) {
				scrollBar.visible = true;
				scrollBar.setScrollProperties(viewHeight, 0, actualHeight - viewHeight, viewHeight);
			} else {
				scrollBar.visible = false;
			}
		}
	}
}