// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal.decoration
{
	import com.hevery.cal.DateUtil;
	
	import flash.text.TextField;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexSprite;
	import mx.core.UIComponent;

	[Bindable]
	public class VerticalTimeRuler extends UIComponent {
		public const WIDTH:int = 50;
		
		public var pixelsPerMilisecond:Number = 50.0 / DateUtil.HOUR;
		
		public var showBackground:Boolean;
		public var backgroundRenderer:VerticalBackgroundRenderer = new VerticalBackgroundRenderer();
		
		private var labels:ArrayCollection = new ArrayCollection();
		
		public function VerticalTimeRuler() {
			width = 50;
			percentHeight = 100;
		}
		
		override protected function createChildren():void {
			mask = new FlexSprite();
			addChild(mask);
			for (var hour:int = 0; hour < 24; hour++) {
				var label:TextField = new TextField();
				if (hour == 0)
					label.text = "Midnight";
				else if (hour < 12)
					label.text = hour + " am";
				else if (hour == 12)
					label.text = "Noon";
				else
					label.text = (hour - 12) + " pm";
				label.width = width;
				label.height = pixelsPerMilisecond * DateUtil.HOUR;
				label.y = hour * pixelsPerMilisecond * DateUtil.HOUR;
				labels.addItem(label);
				addChild(label);
			}
		}
		
		protected override function updateDisplayList(width:Number, height:Number):void {
			super.updateDisplayList(width, height);
			var clip:FlexSprite = mask as FlexSprite;
			clip.graphics.clear();
			clip.graphics.beginFill(0xFF0000);
			clip.graphics.drawRect(0, 0, width, height);
			graphics.clear();
			backgroundRenderer.drawRuler(graphics, 0, 
				pixelsPerMilisecond * DateUtil.DAY, width, height);
		}
		
		
	}
}