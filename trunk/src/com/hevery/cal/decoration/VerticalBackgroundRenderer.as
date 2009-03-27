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
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	public class VerticalBackgroundRenderer
	{
		public static const ALPHA:Number = 1;
		private static const H:Number = 255 / 24;
		public static const colors:Array = [0x505080, 0x524F8F, 0xC58860,  0xF6F5BE, 0xFFFFFF, 0xF6F5BE, 0xC58860, 0x524F8F, 0x505080];
		public static function alphas(alpha:Number):Array {
			                        return [   alpha,    alpha,    alpha,     alpha,    alpha,    alpha,    alpha,    alpha,    alpha];
		}
		public static const positn:Array = [       0,      5*H,      6*H,       7*H,     12*H,     18*H,     19*H,     20*H,     24*H];
		
		public var myColors:Array = colors;
		
		public function drawRuler(g:Graphics, yOffset:Number, dayHeight:Number, width:Number, height:Number):void {
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(width, dayHeight, Math.PI / 2, 0, -yOffset);
			g.beginGradientFill(GradientType.LINEAR, myColors, alphas(ALPHA), positn, matrix );
			g.drawRect(0, 0, width, height);
			g.endFill();

			var skip30MinLine:Boolean = dayHeight/24/2 <= 10;
						
			for (var hour:int = 0; hour < 24; hour++) {
				var y:int = hour * dayHeight / 24 - yOffset; 
				if (0 < y && y < height) {
					g.lineStyle(1, 0, .5);
					g.moveTo(0, y);
					g.lineTo(width, y);
				}
			
				y = y + dayHeight/24 / 2;
				if (0 < y && y < height && !skip30MinLine) {
					g.lineStyle(1, 0, .25);
					g.moveTo(0, y);
					g.lineTo(width, y);
				}
			}
		}
	}
}