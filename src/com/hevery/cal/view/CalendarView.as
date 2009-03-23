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
package com.hevery.cal.view
{
	import com.hevery.cal.Cache;
	import com.hevery.cal.CalendarDescriptor;
	import com.hevery.cal.DateUtil;
	import com.hevery.cal.NullCalendarDescriptor;
	import com.hevery.cal.UIProperty;
	import com.hevery.cal.event.CalendarEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.ClassFactory;
	import mx.core.FlexSprite;
	import mx.core.IFactory;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	[Event(name="selectDay", type="com.hevery.cal.SelectDay")]
	[Event(name="chooseDay", type="com.hevery.cal.ChooseDay")]
	[Bindable]
	public class CalendarView extends UIComponent
	{
		
		private static const log:ILogger = Log.getLogger("com.hevery.cal.view.CalendarView");
		
		public var calendarEventClass:Class = CalendarEvent;
		
		public function CalendarView() {
			rendererFactory = DayViewRenderer;
			visibleEvents.factory = function (event:*):CalendarEvent {
					var eventUI:CalendarEvent = new calendarEventClass();
					eventUI.calendarDescriptor = calendarDescriptor;
					eventUI.eventData = event;
					_renderer.updateEventRenderer(eventUI);
					addChild(eventUI);
					return eventUI;
				}
			visibleEvents.activate = function (event:*, eventUI:CalendarEvent):void {
				eventUI.visible = true;
				eventUI.eventData = event;
				//addChild(eventUI);
			}
			visibleEvents.deactivate = function (eventUI:CalendarEvent):void {
				eventUI.visible = false;
				eventUI.eventData = null;
				//removeChild(eventUI);
			}
		}
		
		protected override function createChildren():void {
			super.createChildren();
			mask = new FlexSprite();
			addChild(mask);
		}
		
		public function setProp(property:String, value:*):void {this[property] = value; }
		public function getProp(property:String):* {return this[property];}
		
		private var _renderer:ViewRenderer;
		private var _rendererFactory:IFactory;
		private var _rendererFactoryChanged:Boolean = false;
		public function get rendererFactory():* { return _rendererFactory; };
		public function set rendererFactory(value:*):void {
		 	if (value is Class) 
		 		value = new ClassFactory(value as Class);
		 	if (!(value is IFactory))
		 		throw new Error("Expecting Class or IFactory");
			UIProperty.setValue(this, "rendererFactory", value);
			if ( rendererFactory != null) {
				_renderer = rendererFactory.newInstance();
				_renderer.view = this;
			} else {
				_renderer = null;
			}
		};
		
		private var _calendarDescriptor:CalendarDescriptor = new NullCalendarDescriptor();
		private var _calendarDescriptorChanged:Boolean = false;
		public function get calendarDescriptor():CalendarDescriptor { return _calendarDescriptor; };
		public function set calendarDescriptor(value:CalendarDescriptor):void { UIProperty.setValue(this, "calendarDescriptor", value);};
		
		private var _events:ArrayCollection = new ArrayCollection();
		private var _eventsChanged:Boolean = false;
		private function eventsCollectionChange(event:CollectionEvent):void { _eventsChanged = true; invalidateProperties();};
		public function get events():ArrayCollection { return _events; };
		public function set events(value:ArrayCollection):void { UIProperty.setValue(this, "events", value);};
		
		private var _calendars:ArrayCollection = new ArrayCollection();
		private var _calendarsChanged:Boolean = false;
		private function calendarsCollectionChange(event:CollectionEvent):void { _calendarsChanged = true; invalidateProperties();};
		public function get calendars():ArrayCollection { return _calendars; };
		public function set calendars(value:ArrayCollection):void { UIProperty.setValue(this, "calendars", value);};
		
		private var _calendarVisualSize:Number = 100;
		private var _calendarVisualSizeChanged:Boolean = false;
		public function get calendarVisualSize():Number { return _calendarVisualSize; };
		public function set calendarVisualSize(value:Number):void { UIProperty.setValue(this, "calendarVisualSize", value); };

		private var _date:Date = DateUtil.trimToDay(new Date());
		private var _dateChanged:Boolean = false;
		public function get date():Date { return _date; };
		public function set date(value:Date):void { UIProperty.setValue(this, "date", value); };

		private var _duration:Number = DateUtil.DAY;
		private var _durationChanged:Boolean = false;
		public function get duration():Number { return _duration; };
		public function set duration(value:Number):void { UIProperty.setValue(this, "duration", value); };
		
		public function get endDate():Date { return new Date(date.time + duration); } 

		internal var visibleEvents:Cache = new Cache();
		
		protected override function commitProperties():void {
			if (_rendererFactoryChanged) {
				_rendererFactoryChanged = false;
				for each (var event:CalendarEvent in events) {
					_renderer.updateEventRenderer(event);
				}
				invalidateSize();
			}
			if (_durationChanged) {
				_durationChanged = false;
				invalidateDisplayList();
				_eventsChanged = true;
			}
			if (_calendarDescriptorChanged) {
				_calendarDescriptorChanged = false;
				_eventsChanged = true;
			}
			if (_dateChanged) {
				_dateChanged = false;
				_eventsChanged = true;
				invalidateDisplayList();
			}
			if (_eventsChanged) {
				_eventsChanged = false;
				eventsChanged();
			}
		}
		
		public function addEvent(event:*):void {
			// add event but don't trigger modification event
			if (events.source.indexOf(event) == -1) {
				events.source.push(event);
			}
			var dayStart:Date = date;
			var dayEnds:Date = new Date(date.time + duration);
			
			if (DateUtil.timeBlocksOverlap(_calendarDescriptor.getEventStart(event),
										   _calendarDescriptor.getEventEnd(event),
										   dayStart, dayEnds)) {
				this.visibleEvents.addKey(event);
				invalidateDisplayList();
			}
		}
		
		public function removeEvent(event:*):void {
			var idx:int = events.source.indexOf(event);
			if (idx != -1) {
				events.source.splice(idx, 1);
			}
			var dayStart:Date = date;
			var dayEnds:Date = new Date(date.time + duration);
			
			if (DateUtil.timeBlocksOverlap(_calendarDescriptor.getEventStart(event),
										   _calendarDescriptor.getEventEnd(event),
										   dayStart, dayEnds)) {
				this.visibleEvents.removeKey(event);
				invalidateDisplayList();
			}
		}

		private function eventsChanged():void {
			var dayStart:Date = date;
			var dayEnds:Date = new Date(date.time + duration);
			var visibleEvents:Array = new Array();

			invalidateDisplayList();

			for each (var event:* in events) {
				var eventStart:Date = _calendarDescriptor.getEventStart(event);
				var eventEnd:Date = _calendarDescriptor.getEventEnd(event);
				var calendar:* = _calendarDescriptor.getCalendar(event);
				if (DateUtil.timeBlocksOverlap(eventStart, eventEnd, dayStart, dayEnds) && calendars.contains(calendar))
					visibleEvents.push(event);
			}
			
			this.visibleEvents.activateKeys(visibleEvents);
		}
		
		protected override function measure():void {
			super.measure();
			_renderer.measure();
		}
		
		public override function setActualSize(w:Number, h:Number):void {
			super.setActualSize(w, h);
			_renderer.setActualSize(w, h);
		}
		
		protected override function updateDisplayList(width:Number, height:Number):void {
			super.updateDisplayList(width, height);
			_renderer.layoutEvents(visibleEvents.activeCollection, width, height);
			
			var clipMaks:FlexSprite = mask as FlexSprite;
			clipMaks.graphics.clear();
			clipMaks.graphics.beginFill(0xFF0000);
			clipMaks.graphics.drawRect(0, 0, width, height);
			
			graphics.clear();
			
			_renderer.drawBackground(graphics, width, height, 0);
			_renderer.updateDisplayList(graphics, width, height);
		}

	}
}