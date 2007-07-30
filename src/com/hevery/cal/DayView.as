// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal
{
	import com.hevery.cal.decoration.VerticalTimeRuler;
	import com.hevery.cal.view.CalendarView;
	
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.controls.VScrollBar;
	import mx.formatters.DateFormatter;
	import mx.logging.ILogger;
	import mx.logging.Log;

	public class DayView extends HBox
	{
		private static const log:ILogger = Log.getLogger("com.hevery.cal.DayView");
		
		private var rulerChrome:DayChrome = new DayChrome();
		private var ruler:VerticalTimeRuler = new VerticalTimeRuler();
		private var scrollBar:VScrollBar = new VScrollBar();
		private var dayChrome:DayChrome = new DayChrome();
		private var view:CalendarView = new CalendarView();

		public var dateFormatter:DateFormatter = new DateFormatter();
		
		public function set calendarDescriptor(calendarDescriptor:CalendarDescriptor):void {
			view.calendarDescriptor = calendarDescriptor;
		}
		
		public function set events(events:ArrayCollection):void {
			view.events = events;
		}
		
		public function set calendars(calendars:ArrayCollection):void {
			view.calendars = calendars;
		}
		
		public function set date(date:Date):void {
			date = DateUtil.trimToDay(date);
			dayChrome.title = dateFormatter.format(date);
			view.date = date;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			dateFormatter.formatString = "EEEE MMMMM D, YYYY";
			
			label = "Day";
			setStyle("horizontalGap", 0);
			
			scrollBar.percentHeight = 100;
			
			rulerChrome.title = "";
			rulerChrome.percentHeight = 100;
			rulerChrome.width = 52;
			rulerChrome.verticalScrollBar = scrollBar;
			rulerChrome.addChild(ruler);
			
			dayChrome.percentHeight = 100;
			dayChrome.percentWidth = 100;
			dayChrome.verticalScrollBar = scrollBar;
			dayChrome.addChild(view);
			
			ruler.height = 24 * 50;
			
			view.height = 24 * 50;
			view.percentWidth = 100;
			
			addChild(rulerChrome);
			addChild(dayChrome);
			addChild(scrollBar);
			
			date = new Date();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			updateScrollSize();
		}
		
		private function updateScrollSize():void {
			var viewHeight:Number = dayChrome.viewHeight;
			var actualHeight:Number = 24 * 50;
			scrollBar.setScrollProperties(viewHeight, 0, actualHeight - viewHeight, viewHeight);
		}
		
	}
}