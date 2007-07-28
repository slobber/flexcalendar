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

	public class MonthView extends HBox
	{
		
		private var chromes:ArrayCollection = new ArrayCollection();
		private var views:ArrayCollection = new ArrayCollection();
		private var grid:Grid = new Grid();

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
		
		public function MonthView() {
			for (var j:int = 0; j < 6 ; j++) {
				var gridRow:GridRow = new GridRow();
				gridRow.percentHeight = 100;
				gridRow.percentWidth = 100;
				grid.addChild(gridRow);
				for (var i:int = 0; i < 7 ; i++) {
					var chrome:DayChrome = new DayChrome();
					chromes.addItem(chrome);
					chrome.title = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][i];
					chrome.percentHeight = 100;
					chrome.percentWidth = 100;
					
					var view:CalendarView = new CalendarView();
					view.rendererFactory = MonthViewRenderer;
					views.addItem(view);
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
			
			label = "Month";
			setStyle("horizontalGap", 0);
			grid.percentHeight = 100;
			grid.percentWidth = 100;
			grid.setStyle("horizontalGap", 0);
			grid.setStyle("verticalGap", 0);
			addChild(grid);
		}
	}
}