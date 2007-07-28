// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal.event
{
	import flash.display.Graphics;
	import flash.text.TextLineMetrics;
	
	import mx.utils.ColorUtil;
	
	public class BlockEventRenderer extends EventRenderer
	{
		
		public function BlockEventRenderer() {
			super();
		}
		
		public override function positionTextFields(width:Number, height:Number): void {
			var _border:int = event.getStyle("borderThickness");
			var _headerHeight:int = event.getStyle("headerHeight");
			var color:uint = 0x000000;
						
			timeFormat.bold = true;
			timeFormat.color = color;
			titleFormat.color = color;
			textFormat.color = color;
			
			super.positionTextFields(width, height);
			
			titleField.x = _border
			titleField.y = 0;
			titleField.width = width - 2 * _border;
			titleField.height = _headerHeight;
			
			textField.x = _border;
			textField.y = _headerHeight;
			textField.width = width - 2 * _border;
			textField.height =  height - _headerHeight;
		}
		
		public override function updateDisplayList(g:Graphics, w:Number, h:Number):void {
			super.updateDisplayList(g, w, h);
			var width:Number = w - 1;
			var height:Number = h - 1;
			var x:int = 0;
			var y:int = 0;
			var color:uint = calendarDescriptor.getEventColor(eventData);
			
			var _cornerRadius:int = event.getStyle("cornerRadius");
			var _border:int = event.getStyle("borderThickness");
			var _headerHeight:int = event.getStyle("headerHeight");
			_headerHeight = Math.min(_headerHeight, h);
			_cornerRadius = Math.min(_cornerRadius, w / 2, h / 2, _headerHeight);
			
			var headingColor:uint = color;
			var bodyColor:uint = ColorUtil.adjustBrightness2(color, 50);
			g.clear();
			g.lineStyle(1, headingColor, 1, true);
			
			// Heading
			g.beginFill(headingColor, 1);
			g.moveTo(x + _cornerRadius, y);
			g.lineTo(x + width - _cornerRadius, y);
			g.curveTo(x + width, y, x + width, y + _cornerRadius);
			g.lineTo(x + width, y + _headerHeight);
			g.lineTo(x, y + _headerHeight);
			g.lineTo(x, y + _cornerRadius);
			g.curveTo(x, y, x + _cornerRadius, y);
			
			// Body
			g.beginFill(bodyColor);
			g.moveTo(x, y + _headerHeight);
			g.lineTo(x + width, y + _headerHeight);
			g.lineTo(x + width, y + height - _cornerRadius);
			g.curveTo(x + width, y + height, x + width - _cornerRadius, y + height);
			g.lineTo(x + _cornerRadius, y + height);
			g.curveTo(x, y + height, x, y + height - _cornerRadius);
			g.lineTo(x, y + _headerHeight);
		}
	}
}