// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal.event
{
	import flash.text.TextFormat;
	
	
	
	public class AgendaEventRenderer extends EventRenderer
	{
		
		override internal function get timeFormat():TextFormat { 
			var format:TextFormat = super.timeFormat;
			format.color = Number(calendarDescriptor.getEventColor(eventData));
			return format; 
		};
		override internal function get titleFormat():TextFormat { 
			var format:TextFormat = super.titleFormat;
			format.color = Number(calendarDescriptor.getEventColor(eventData));
			return format; 
		};
		override internal function get textFormat():TextFormat { 
			var format:TextFormat = super.textFormat;
			format.color = Number(calendarDescriptor.getEventColor(eventData));
			return format; 
		};
		
		public override function positionTextFields(width:Number, height:Number): void {
			super.positionTextFields(width, height);
			var _border:int = event.getStyle("borderThickness");
			var _headerHeight:int = event.getStyle("headerHeight");
			var offset:int = 35;
			
			titleField.x = _border
			titleField.y = 0;
			titleField.width = width - 2 * _border;
			titleField.height = _headerHeight;
			
			textField.x = _border + offset;
			textField.y = _headerHeight;
			textField.width = width - 2 * _border - offset;
			textField.height =  height - _headerHeight;
			
		}
		
		public override function measure():void {
			event.measuredHeight = 70;
		}
		
	}
}