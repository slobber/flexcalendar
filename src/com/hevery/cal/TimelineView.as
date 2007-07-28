// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal
{
	import com.hevery.cal.view.CalendarView;
	import com.hevery.cal.view.TimelineViewRenderer;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;

	public class TimelineView extends VBox
	{
		
		private var view:CalendarView = new CalendarView();
		private var durationSlider:TimelineDurationSlider = new TimelineDurationSlider();

		public function set calendarDescriptor(calendarDescriptor:CalendarDescriptor):void {
			view.calendarDescriptor = calendarDescriptor;
		}
		
		public function set events(events:ArrayCollection):void {
			view.events = events;
		}
		
		public function set calendars(calendars:ArrayCollection):void {
			view.calendars = calendars;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			label = "Timeline";
			setStyle("horizontalGap", 0);
			
			view.percentHeight = 100;
			view.percentWidth = 100;
			view.rendererFactory = TimelineViewRenderer;
			BindingUtils.bindProperty(view, "duration", durationSlider, "value");
			
			addChild(view);
			addChild(durationSlider);
		}
	}
}