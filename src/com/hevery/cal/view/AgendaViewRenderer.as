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
		
		override internal function measure():void {
			super.measure();
			var height:Number = 0;
			for each (var event:CalendarEvent in view.visibleEvents) {
				height += event.measuredHeight;
			}
			view.measuredHeight = height;
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