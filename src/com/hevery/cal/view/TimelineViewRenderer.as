// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
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
			view.calendarVisualSize = h / view.calendars.length;
		}
	}
}