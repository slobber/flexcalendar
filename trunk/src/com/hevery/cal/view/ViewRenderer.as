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
	import com.hevery.cal.event.CalendarEvent;
	
	import flash.display.Graphics;
	
	import mx.collections.ArrayCollection;
	
	public class ViewRenderer
	{
		internal var view:CalendarView;
		
		internal function updateDisplayList(g:Graphics, width:Number, height:Number):void {
		}
		
		internal function drawBackground(g:Graphics, width:Number, height:Number, verticalOffset:Number):void {
			g.clear();
			g.beginFill(0xFFFFFF);
			g.drawRect(0, 0, width, height);
		}
		
		internal function updateEventRenderer(event:CalendarEvent): void {
		}
		
		internal function layoutEvents(events:ArrayCollection, width:Number, height:Number):void {
		}
		
		internal function measure():void {
		}
		
		internal function setActualSize(w:Number, h:Number):void {
		}
	}
}