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
package com.hevery.cal.view
{
	import com.hevery.cal.CalendarDescriptor;
	import com.hevery.cal.DateUtil;
	import com.hevery.cal.decoration.HorizontalBackgroundRenderer;
	import com.hevery.cal.event.BlockEventRenderer;
	import com.hevery.cal.event.CalendarEvent;
	
	import flash.display.Graphics;
	
	import mx.collections.ArrayCollection;
	
	public class TimelineViewRenderer extends ViewRenderer
	{
		private var horizontalBackgroundRenderer:HorizontalBackgroundRenderer = new HorizontalBackgroundRenderer();
		
		internal override function updateEventRenderer(event:CalendarEvent): void {
			event.rendererFactory = BlockEventRenderer;
		}
		
		private function get pixelsPerMilisecond():Number {
			return view.width / view.duration;
		}
		
		internal override function drawBackground(g:Graphics, width:Number, height:Number, verticalOffset:Number):void {
			var midnightOffset:Number = view.date.time - DateUtil.trimToDay(view.date).time;
			var duration:Number = view.duration;
			horizontalBackgroundRenderer.drawRuler(g, width, height, midnightOffset, duration, pixelsPerMilisecond);
		}
		
		internal override function layoutEvents(events:ArrayCollection, width:Number, height:Number):void {
			var viewStart:Number = view.date.time;
			var calDesc:CalendarDescriptor = view.calendarDescriptor;
			for each (var event:CalendarEvent in events) {
				var eventStart:Date = calDesc.getEventStart(event.eventData);
				var eventEnd:Date = calDesc.getEventEnd(event.eventData);
				var calendar:* = calDesc.getCalendar(event.eventData);
				event.move((eventStart.time - viewStart) * pixelsPerMilisecond, 
				           view.calendars.getItemIndex(calendar) * view.calendarVisualSize);
				event.setActualSize((eventEnd.time - eventStart.time) * pixelsPerMilisecond,
									view.calendarVisualSize);
			}
		}
		
		override internal function updateDisplayList(g:Graphics, width:Number, height:Number):void {
		}
		
		override internal function measure():void {
			super.measure();
		}
		
		override internal function setActualSize(w:Number, h:Number):void {
			super.setActualSize(w, h);
			var count:int = view.calendars.length;
			view.calendarVisualSize = count == 0 ? 0 : h / count;
		}
	}
}