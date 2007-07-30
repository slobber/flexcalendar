// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal.view
{
	import com.hevery.cal.event.AgendaEventRenderer;
	import com.hevery.cal.event.CalendarEvent;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class AgendaViewRenderer extends ViewRenderer
	{
		private static const log:ILogger = Log.getLogger("com.hevery.cal.view.AgendaViewRenderer");
		
		internal override function updateEventRenderer(event:CalendarEvent): void {
			event.rendererFactory = AgendaEventRenderer;
		}
		
		internal override function layoutEvents(events:ArrayCollection, width:Number, height:Number):void {
			log.info("layoutEvents()");
			var lastY:Number = 0;
			for each (var event:CalendarEvent in events) {
				event.x = 0;
				event.y = lastY;
				event.width = width;
				event.height = event.measuredHeight;
				lastY += event.height;
			}
		}
	}
}