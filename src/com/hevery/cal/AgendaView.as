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
			
			view.percentWidth = 100;
			view.percentHeight = 100;
			view.rendererFactory = AgendaViewRenderer;
			
			addChild(view);
		}
	}
}