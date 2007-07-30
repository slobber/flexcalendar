// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal.event
{
	import com.hevery.cal.CalendarDescriptor;
	
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class EventRenderer
	{
		internal var event:CalendarEvent;
		protected var _timeFormat:TextFormat = new TextFormat();
		protected var _titleFormat:TextFormat = new TextFormat();
		protected var _textFormat:TextFormat = new TextFormat();
		
		internal function get calendarDescriptor():CalendarDescriptor { return event.calendarDescriptor; };
		internal function get eventData():* { return event.eventData; };
		
		internal function get titleField():TextField { return event.titleField; };
		internal function get textField():TextField { return event.textField; };
		
		internal function get timeFormat():TextFormat { 
			_timeFormat.bold = true;
			return _timeFormat; 
		};
		internal function get titleFormat():TextFormat { 
			return _titleFormat; 
		};
		internal function get textFormat():TextFormat { 
			return _textFormat; 
		};
		
		public function EventRenderer() {
			_titleFormat.tabStops = [ 35 ];
			_timeFormat.tabStops = _titleFormat.tabStops;
		}

		public function positionTextFields(width:Number, height:Number): void {
		}
		
		public function updateDisplayList(g:Graphics, width:Number, height:Number):void {
			g.clear();
		}
		
		public function measure():void {
			event.measuredMinHeight = event.measuredHeight = 16;
			event.measuredMinWidth = event.measuredWidth = 30;
		}
		
	}
}