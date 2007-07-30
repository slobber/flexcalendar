// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
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
	}
}