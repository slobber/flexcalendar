// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal
{
	import com.hevery.cal.decoration.HorizontalTimeRuler;
	import com.hevery.cal.view.CalendarView;
	import com.hevery.cal.view.TimelineViewRenderer;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Spacer;

	public class TimelineView extends VBox
	{
		
		private var ruler:HorizontalTimeRuler = new HorizontalTimeRuler();
		private var view:CalendarView = new CalendarView();
		private var sliders:HBox = new HBox();
		private var spacer:Spacer = new Spacer();
		private var timeSlider:TimelineSlider = new TimelineSlider();
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
			spacer.percentWidth = 100;
			sliders.percentWidth = 100;
			
			label = "Timeline";
			setStyle("horizontalGap", 0);
			setStyle("verticalGap", 0);
			
			view.percentHeight = 100;
			view.percentWidth = 100;
			view.rendererFactory = TimelineViewRenderer;
			BindingUtils.bindProperty(view, "duration", durationSlider, "value");
			
			timeSlider.selectedTime = DateUtil.trimToDay(new Date());
			BindingUtils.bindProperty(view, "date", timeSlider, "selectedTime");
			BindingUtils.bindProperty(timeSlider, "scrollSize", durationSlider, "value");
			
			BindingUtils.bindProperty(ruler, "startDate", view, "date");
			BindingUtils.bindProperty(ruler, "duration", view, "duration");
			
			ruler.percentWidth = 100;
			ruler.height = 20;
			
			addChild(ruler);
			addChild(view);
			addChild(sliders);
			sliders.addChild(spacer);
			sliders.addChild(timeSlider);
			sliders.addChild(durationSlider);
		}
	}
}