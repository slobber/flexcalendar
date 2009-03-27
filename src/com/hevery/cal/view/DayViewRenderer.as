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
	import com.hevery.cal.decoration.VerticalBackgroundRenderer;
	import com.hevery.cal.event.BlockEventRenderer;
	import com.hevery.cal.event.CalendarEvent;
	
	import flash.display.Graphics;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	public class DayViewRenderer extends ViewRenderer
	{
		public var background:VerticalBackgroundRenderer = new VerticalBackgroundRenderer();
		
		internal override function updateEventRenderer(event:CalendarEvent): void {
			event.rendererFactory = BlockEventRenderer;
		}
		
		private function get pixelsPerMilisecond():Number {
			return view.height / view.duration;
		}
		
		internal override function drawBackground(g:Graphics, width:Number, height:Number, verticalOffset:Number):void {
			background.drawRuler(g, verticalOffset, view.duration * pixelsPerMilisecond, width, height);
		}
		
		internal override function layoutEvents(events:ArrayCollection, width:Number, height:Number):void {
			events.sort = new Sort();
			events.sort.fields = [ new SortField("y") ];	
			events.refresh();
			var overlap:ArrayCollection = new ArrayCollection();
			
			var dayStart:Date = view.date;
			var calDesc:CalendarDescriptor = view.calendarDescriptor;
			for each (var event:CalendarEvent in events) {
				var eventStart:Date = calDesc.getEventStart(event.eventData);
				var eventEnd:Date = calDesc.getEventEnd(event.eventData);
				event.x = 0;
				event.y = (eventStart.time - dayStart.time) * pixelsPerMilisecond;
				event.height = (eventEnd.time - eventStart.time) * pixelsPerMilisecond;
				event.width = width;
				updateEventRenderer(event);
				var currentY:int = event.y;
				
				// Remove non relevant items.
				var i:int = 0;
				while (i < overlap.length) {
					var overlapEvent:CalendarEvent = overlap.getItemAt(i) as CalendarEvent;
					if (overlapEvent.y + overlapEvent.height <= currentY) {
						overlap.removeItemAt(i);
					} else {
						i++;
					}
				}
				
				// find a location for the new item.
				var offset:int = 0;
				while(true) {
					if (collides(overlap, offset))
						offset += 20;
					else
						break;
				}
				event.x = offset;
				overlap.addItem(event);
				
				// Set width depending on count in overlap
				i = 0;
				for each (var e:CalendarEvent in overlap) {
					e.width = e.width - e.x
						- Math.min(10, e.width / overlap.length) * (overlap.length - i - 1)
					i++;
				} 
			}
		}
		
		private function collides(events:ArrayCollection, offset:int):Boolean {
			for each (var event:CalendarEvent in events) {
				if (event.x == offset) 
					return true;
			} 
			return false;
		}
	}
}