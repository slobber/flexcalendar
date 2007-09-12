// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal
{
	import com.hevery.cal.decoration.CalendarLabels;
	import com.hevery.cal.decoration.HorizontalTimeRuler;
	import com.hevery.cal.view.CalendarView;
	import com.hevery.cal.view.TimelineViewRenderer;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.containers.Box;
	import mx.containers.HBox;
	import mx.containers.HDividedBox;
	import mx.containers.VBox;
	import mx.controls.Spacer;
	import mx.core.UIComponent;

	public class TimelineView extends VBox
	{
		
		private var rulerSpacer:Spacer = new Spacer();
		private var calendarLabels:CalendarLabels = new CalendarLabels();
		
		private var ruler:HorizontalTimeRuler = new HorizontalTimeRuler();
		private var view:CalendarView = new CalendarView();
		
		// Lower Sliders
		private var sliders:HBox = new HBox();
		private var sliderSpacer:Spacer = new Spacer();
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
			label = "Timeline";
			setStyle("horizontalGap", 0);
			setStyle("verticalGap", 0);
			
			// Sliders
			sliderSpacer.percentWidth = 100;
			sliders.percentWidth = 100;
						
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
			BindingUtils.bindProperty(rulerSpacer, "height", ruler, "height");
			
			calendarLabels.percentWidth = 100;
			calendarLabels.percentHeight = 100;
			calendarLabels.view = view;
			
			addChild(hBox(5, vBox(rulerSpacer, calendarLabels), vBox(ruler, view)));
			addChild(sliders);
			
			sliders.addChild(sliderSpacer);
			sliders.addChild(timeSlider);
			sliders.addChild(durationSlider);
		}
		
		private function hBox(split:int, comp1:UIComponent, comp2:UIComponent):Box {
			var box:Box = new HBox();
			box.setStyle("horizontalGap", 0);
			box.percentHeight = 100;
			box.percentWidth = 100;
			box.addChild(comp1);
			box.addChild(comp2);
			comp1.percentWidth = split;
			comp2.percentWidth = 100 - split;
			return box;
		}
		
		private function vBox(comp1:UIComponent, comp2:UIComponent):VBox {
			var box:VBox = new VBox();
			box.percentHeight = 100;
			box.percentWidth = 100;
			box.setStyle("verticalGap", 0);
			box.addChild(comp1);
			box.addChild(comp2);
			return box;
		}
	}
}