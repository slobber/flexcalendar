package com.hevery.cal.decoration
{
	import com.hevery.cal.DateUtil;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	public class HorizontalBackgroundRenderer
	{
		public var cutOffWidth:Number = 5;
		public var showLines:Boolean = true;
		
		public function drawRuler(g:Graphics, width:Number, height:Number, midnightOffset:Number, duration:Number, pixelsPerMilisecond:Number):void {
			var dayWidth:Number = width * (DateUtil.DAY / duration);
			var visibleWidth:Number = width * pixelsPerMilisecond;
			var dayOffset:Number = midnightOffset * pixelsPerMilisecond;
			
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
			
			if (showLines) {
				var lineEvery:Number;
				if (pixelsPerMilisecond > cutOffWidth / DateUtil.HOUR )
					lineEvery = DateUtil.HOUR * pixelsPerMilisecond;
				else if (pixelsPerMilisecond > cutOffWidth / DateUtil.DAY )
					lineEvery = DateUtil.DAY * pixelsPerMilisecond;
				else if (pixelsPerMilisecond > cutOffWidth / DateUtil.WEEK )
					lineEvery = DateUtil.WEEK * pixelsPerMilisecond;
				else
					lineEvery = DateUtil.MONTH * pixelsPerMilisecond;
				
				g.lineStyle(1, 0, .5);
				for (var lineLoc:Number = -dayOffset % lineEvery; lineLoc < width; lineLoc += lineEvery) {
					g.moveTo(lineLoc, 0);
					g.lineTo(lineLoc, height);
				}
			}
		}
	}
}