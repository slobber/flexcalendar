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