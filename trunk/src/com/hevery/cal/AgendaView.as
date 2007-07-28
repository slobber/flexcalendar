// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal
{
	import com.hevery.cal.decoration.VerticalTimeRuler;
	import com.hevery.cal.view.AgendaViewRenderer;
	import com.hevery.cal.view.CalendarView;
	
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.controls.VScrollBar;

	public class AgendaView extends HBox
	{
		
		private var ruler:VerticalTimeRuler = new VerticalTimeRuler();
		private var view:CalendarView = new CalendarView();

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
			
			label = "Agenda";
			setStyle("horizontalGap", 0);
			
			view.height = 24 * 50;
			view.percentWidth = 100;
			view.rendererFactory = AgendaViewRenderer;
			
			addChild(view);
		}
	}
}