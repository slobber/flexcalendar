// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal.view
{
	import com.hevery.cal.event.AgendaEventRenderer;
	import com.hevery.cal.event.CalendarEvent;
	
	import mx.collections.ArrayCollection;
	
	public class AgendaViewRenderer extends ViewRenderer
	{
		internal override function updateEventRenderer(event:CalendarEvent): void {
			event.rendererFactory = AgendaEventRenderer;
		}
		
		internal override function layoutEvents(events:ArrayCollection):void {
			var lastY:Number = 0;
			for each (var event:CalendarEvent in events) {
				updateEventRenderer(event);
				event.x = 0;
				event.y = lastY;
				event.width = view.width;
				event.height = 50;
				lastY += event.height;
			}
		}
	}
}