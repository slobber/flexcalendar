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
package com.hevery.cal.event
{
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.core.UIComponent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	
	
	public class AgendaEventRenderer extends EventRenderer
	{
		private static const log:ILogger = Log.getLogger("com.hevery.cal.event.AgendaEventRenderer");
		
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
			event.measuredHeight = textField.y + textField.textHeight + 10;
			
		}
		
	}
}