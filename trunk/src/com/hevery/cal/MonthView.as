// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal
{
	import com.hevery.cal.view.CalendarView;
	import com.hevery.cal.view.MonthViewRenderer;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Grid;
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.containers.HBox;
	import mx.formatters.DateFormatter;

	public class MonthView extends HBox
	{
		
		private var chromes:ArrayCollection = new ArrayCollection(new Array(6));
		private var views:ArrayCollection = new ArrayCollection(new Array(6));
		private var grid:Grid = new Grid();
		public var dateFormatter:DateFormatter = new DateFormatter();

		public function set calendarDescriptor(calendarDescriptor:CalendarDescriptor):void {
			for (var j:int = 0; j < 6 ; j++) {
				for (var i:int = 0; i < 7 ; i++) {
					var view:CalendarView = views[j][i] as CalendarView;
					view.calendarDescriptor = calendarDescriptor;
				}
			}
		}
		
		public function set events(events:ArrayCollection):void {
			for (var j:int = 0; j < 6 ; j++) {
				for (var i:int = 0; i < 7 ; i++) {
					var view:CalendarView = views[j][i] as CalendarView;
					view.events = events;
				}
			}
		}
		
		public function set calendars(calendars:ArrayCollection):void {
			for (var j:int = 0; j < 6 ; j++) {
				for (var i:int = 0; i < 7 ; i++) {
					var view:CalendarView = views[j][i] as CalendarView;
					view.calendars = calendars;
				}
			}
		}
		
		public function set date(date:Date):void {
			var monthDate:Date = DateUtil.trimToMonth(date);
			var firstDate:Date = DateUtil.trimToWeek(monthDate);
			if (firstDate.month == date.month && firstDate.day < 3) 
				firstDate = new Date(firstDate.time - DateUtil.WEEK);
			date = firstDate;

			for (var j:int = 0; j < 6 ; j++) {
				for (var i:int = 0; i < 7 ; i++) {
					var chrome:DayChrome = chromes[j][i] as DayChrome;
					var view:CalendarView = views[j][i] as CalendarView;
					
					chrome.title = dateFormatter.format(date);
					chrome.styleName = monthDate.month == date.month ? "ThisMonth" : "NotThisMonth"
					view.date = date;
					
					date = new Date(date.time + DateUtil.DAY);
				}
			}
		}
		
		
		public function MonthView() {
			for (var j:int = 0; j < 6 ; j++) {
				var gridRow:GridRow = new GridRow();
				gridRow.percentHeight = 100;
				gridRow.percentWidth = 100;
				grid.addChild(gridRow);
				views[j] = new ArrayCollection(new Array(7));
				chromes[j] = new ArrayCollection(new Array(7));
				for (var i:int = 0; i < 7 ; i++) {
					var chrome:DayChrome = new DayChrome();
					chromes.addItem(chrome);
					chrome.title = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][i];
					chrome.percentHeight = 100;
					chrome.percentWidth = 100;
					chromes[j][i] = chrome;
					
					var view:CalendarView = new CalendarView();
					view.rendererFactory = MonthViewRenderer;
					views[j][i] = view;
					view.percentHeight = 100;
					view.percentWidth = 100;
					
					var gridItem:GridItem = new GridItem();
					gridRow.addChild(gridItem);
					gridItem.percentHeight = 100;
					gridItem.percentWidth = 100;
					gridItem.addChild(chrome);
					chrome.addChild(view);
				}
			}
		}
		
		override protected function createChildren():void {
			super.createChildren();
			dateFormatter.formatString = "EEE MMM D";
			
			label = "Month";
			setStyle("horizontalGap", 0);
			grid.percentHeight = 100;
			grid.percentWidth = 100;
			grid.setStyle("horizontalGap", 0);
			grid.setStyle("verticalGap", 0);
			addChild(grid);
			
			date = new Date();
		}
	}
}