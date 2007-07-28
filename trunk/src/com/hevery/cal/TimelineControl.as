// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal
{
	import com.hevery.cal.event.CalendarEvent;
	import com.hevery.cal.decoration.CalendarLabel;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.core.ScrollPolicy;

	public class TimelineControl extends Canvas
	{
		private var _events:ArrayCollection = new ArrayCollection();
		private var _eventsChanged:Boolean = false;
		public function get events():ArrayCollection {return _events};
		public function set events(events:ArrayCollection):void { setValue("events", events); }
		
		private var _calendarMap:Dictionary = new Dictionary(true);
		private var _eventMap:Dictionary = new Dictionary(true);
		
		private var _calendars:ArrayCollection = new ArrayCollection();
		private var _calendarsChanged:Boolean = false;
		public function get calendars():ArrayCollection {return _calendars};
		public function set calendars(calendars:ArrayCollection):void { setValue("calendars", calendars); }
		
		public function get timeWidth():Number {return _startDate.time - _endDate.time; }
		public function set timeWidth(timeWidth:Number):void { endDate = new Date(endDate.time + timeWidth); }

		private var _startDate:Date = DateUtil.trimToDay(new Date());
		private var _startDateChanged:Boolean = false;
		public function get startDate():Date {return _startDate};
		public function set startDate(startDate:Date):void { setValue("startDate", startDate); }
		
		private var _endDate:Date = new Date(_startDate.time + DateUtil.DAY);
		private var _endDateChanged:Boolean = false;
		public function get endDate():Date {return _endDate};
		public function set endDate(endDate:Date):void { setValue("endDate", endDate); }
		
		private var _calendarDescriptor:CalendarDescriptor;
		private var _calendarDescriptorChanged:Boolean = false;
		public function get calendarDescriptor():CalendarDescriptor {return _calendarDescriptor};
		public function set calendarDescriptor(value:CalendarDescriptor):void { setValue("calendarDescriptor", value); }
		
		private var _stage:Canvas;
		
		public function TimelineControl() {
			percentHeight = 100;
			percentWidth = 100;
			horizontalScrollPolicy = ScrollPolicy.OFF;
			styleName = "Timeline";
		}
		
		protected override function createChildren():void {
			super.createChildren();
			_stage = new Canvas();
			addChild(_stage);
			_stage.setStyle("backgroundColor", 0xAAAAAA);
			_stage.verticalScrollPolicy = ScrollPolicy.OFF;
			_stage.horizontalScrollPolicy = ScrollPolicy.OFF;
			_stage.x = getStyle("calendarLabelWidth");
			_stage.percentWidth = 100;
			_stage.y = 0;
			_stage.percentHeight = 100;
		}
		
		private function setValue(property:String, value:*):void {
			var _property:String = "_" + property;
			var _propertyChanged:String = "_" + property + "Changed";
			if (this[_property] == value) return;
			this[_property] = value; 
			try {
				this[_propertyChanged] = true;
				invalidateProperties();
			} catch (e:Error) {
				invalidateDisplayList();
			}
		}

		protected override function commitProperties():void {
			super.commitProperties();
			if (_calendarDescriptorChanged) {
				_calendarDescriptorChanged = false;
				_eventsChanged = true;
				_calendarsChanged = true;
				_startDateChanged = true;
				_endDateChanged = true;
			}
			if (_calendarsChanged) {
				_calendarsChanged = false;
				pupulateCalendarLabels();
			}
			if (_eventsChanged) {
				_eventsChanged = false;
				pupulateEvents();
			}
			if (_startDateChanged) {
				_startDateChanged = false;
			}
			if (_endDateChanged) {
				_endDateChanged = false;
			}
		}
		
		private function pupulateEvents():void {
			var offset:int = getStyle("calendarLabelWidth");
			var pixelsPerMilisecond:Number = (width - offset) / (_endDate.time - _startDate.time);
			for each (var event:* in _events) {
				var eventStart:Date = _calendarDescriptor.getEventStart(event);
				var eventEnd:Date = _calendarDescriptor.getEventEnd(event);
				if (!DateUtil.timeBlocksOverlap(_startDate, _endDate, eventStart, eventEnd)) 
					continue;
				
				var calendar:* = _calendarDescriptor.getCalendar(event);
				var eventUI:CalendarEvent = new CalendarEvent();
				eventUI.x = offset + pixelsPerMilisecond * (eventStart.time - _startDate.time)
				eventUI.width = offset + pixelsPerMilisecond * (eventStart.time - _startDate.time)
				eventUI.y = _calendarMap[calendar].row * getStyle("calendarRowHeight");
				eventUI.height = getStyle("calendarRowHeight");
				eventUI.calendarDescriptor = calendarDescriptor;
				eventUI.eventData = event;
				_eventMap[event] = {event:event, uiComponent:eventUI};
				_stage.addChild(eventUI);
			}	
		}
		
		private function pupulateCalendarLabels():void {
			var row:int = 0;
			for each (var calendar:* in _calendars) {
				var label:CalendarLabel = new CalendarLabel();
				label.calendarDescriptor = calendarDescriptor;
				label.calendarData = calendar;
				label.x = 0;
				label.y = row * getStyle("calendarRowHeight");
				label.width = getStyle("calendarLabelWidth");
				label.height = getStyle("calendarRowHeight");
				addChild(label);
				_calendarMap[calendar] = {calendar:calendar, row:row, uiComponent:label};
				row++;
				_stage.height = row * getStyle("calendarRowHeight");
			}
		}
		
		protected override function updateDisplayList(width:Number, height:Number):void {
			super.updateDisplayList(width, height);
		}

	}
}