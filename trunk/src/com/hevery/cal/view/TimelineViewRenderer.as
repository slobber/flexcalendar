// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal.view
{
	import com.hevery.cal.CalendarDescriptor;
	import com.hevery.cal.DateUtil;
	import com.hevery.cal.decoration.VerticalBackgroundRenderer;
	import com.hevery.cal.event.BlockEventRenderer;
	import com.hevery.cal.event.CalendarEvent;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	import mx.collections.ArrayCollection;
	
	public class TimelineViewRenderer extends ViewRenderer
	{
		internal override function updateEventRenderer(event:CalendarEvent): void {
			event.rendererFactory = BlockEventRenderer;
		}
		
		private function get pixelsPerMilisecond():Number {
			return view.width / view.duration;
		}
		
		internal override function drawBackground(g:Graphics, width:Number, height:Number, verticalOffset:Number):void {
			var dayWidth:Number = view.width * (DateUtil.DAY / view.duration);
			var visibleWidth:Number = view.width;
			var dayOffset:Number = view.date.time - DateUtil.trimToDay(view.date).time;
			
			var matrix:Matrix = new Matrix();
			var alpha:Number = 1;
			if (dayWidth < 30) {
				alpha = Math.max(0, (dayWidth - 15) / 15);
			}
			matrix.createGradientBox(dayWidth, height, 0, -dayOffset, 0);
			g.beginGradientFill(GradientType.LINEAR, 
				VerticalBackgroundRenderer.colors, 
				VerticalBackgroundRenderer.alphas(alpha), 
				VerticalBackgroundRenderer.positn, 
				matrix, SpreadMethod.REPEAT );
			g.drawRect(0, 0, width, height);
			g.endFill();
			
			var lineEvery:Number;
			var cutOffWidth:Number = 5;
			if (pixelsPerMilisecond > cutOffWidth / DateUtil.HOUR )
				lineEvery = DateUtil.HOUR * pixelsPerMilisecond;
			else if (pixelsPerMilisecond > cutOffWidth / DateUtil.DAY )
				lineEvery = DateUtil.DAY * pixelsPerMilisecond;
			else if (pixelsPerMilisecond > cutOffWidth / DateUtil.WEEK )
				lineEvery = DateUtil.WEEK * pixelsPerMilisecond;
			else
				lineEvery = DateUtil.MONTH * pixelsPerMilisecond;
			
			g.lineStyle(1, 0, .5);
			for (var lineLoc:Number = 0; lineLoc < width; lineLoc += lineEvery) {
				g.moveTo(lineLoc, 0);
				g.lineTo(lineLoc, height);
			}
		}
		
		internal override function layoutEvents(events:ArrayCollection):void {
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
			if (view != null && view.calendars != null)
				view.height = view.calendars.length * view.calendarVisualSize;
		}
	}
}