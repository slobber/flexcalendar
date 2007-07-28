// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal.decoration
{
	import com.hevery.cal.CalendarControl;
	
	import mx.controls.VScrollBar;
	import mx.events.FlexEvent;
	import mx.events.ScrollEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;

	
	public class DecorationControler
	{
		private var calendar:CalendarControl;
		private var verticalRuler:VerticalTimeRuler = new VerticalTimeRuler();
		private var verticalScroll:VScrollBar = new VScrollBar();
		
		public function get top():Number{return 0}
		public function get bottom():Number{return 0}
		public function get left():Number{return verticalRuler.visible ? verticalRuler.width : 0;}
		public function get right():Number{return verticalScroll.visible ? verticalScroll.width : 0;}
		
		public function DecorationControler (calendar:CalendarControl) {
			this.calendar = calendar;
			calendar.addChild(verticalRuler);
			calendar.addChild(verticalScroll);
			calendar.addEventListener(FlexEvent.CREATION_COMPLETE, function(evenr:FlexEvent):void{
				verticalScroll.scrollPosition = verticalScroll.maxScrollPosition / 2;
				calendar.timeOfDayScrollPosition = verticalScroll.scrollPosition;
			});
			verticalScroll.addEventListener(ScrollEvent.SCROLL, function(event:ScrollEvent):void {
				calendar.timeOfDayScrollPosition = event.currentTarget.scrollPosition;
			});
		}
		
		public function invalidateDisplayList():void {
			if (verticalRuler != null) {
				verticalRuler.visible = calendar.viewMode == CalendarControl.DAY || calendar.viewMode == CalendarControl.WEEK;
				verticalRuler.invalidateDisplayList();
				verticalRuler.verticalScrollPosition = calendar.timeOfDayScrollPosition;
				verticalRuler.y = getDayHeaderHeight();
			}
			if (verticalScroll != null) {
				verticalScroll.visible = verticalRuler.visible;
				verticalScroll.scrollPosition = calendar.timeOfDayScrollPosition;
			}
		}
		
		public function setActualSize(w:Number, h:Number):void {
			verticalScroll.x = w - verticalScroll.width;
			verticalScroll.width = 16;
			verticalScroll.height = h;
			verticalRuler.height = h;
			verticalScroll.setScrollProperties(Config.HEIGHT, 0, 
				Config.HEIGHT - calendar.height + getDayHeaderHeight() , Config.HEIGHT);
		}
		
		private function getDayHeaderHeight():Number {
			var declaration:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".Day");
			if (declaration != null) {
				var headerHeight:* = declaration.getStyle("headerHeight");
				if (headerHeight != null) {
					return Number(headerHeight);
				}
			}
			return 0;
		}
		
	}
}