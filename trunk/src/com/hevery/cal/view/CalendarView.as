// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal.view
{
	import com.hevery.cal.CalendarDescriptor;
	import com.hevery.cal.DateUtil;
	import com.hevery.cal.NullCalendarDescriptor;
	import com.hevery.cal.UIProperty;
	import com.hevery.cal.event.CalendarEvent;
	
	import flash.utils.Dictionary;
	
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
		
		public function CalendarView() {
			rendererFactory = DayViewRenderer;
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
		
		private var _calendarVisualSize:Number = 50;
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

		internal var visibleEvents:Dictionary = new Dictionary();
		
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
		
		private function eventsChanged():void {
			var start:Number = flash.utils.getTimer();
			var newCalendarEventTime:Number = 0;
			var addChildTime:Number = 0;
			var dayStart:Date = date;
			var dayEnds:Date = new Date(date.time + duration);
			var newVisibleEvents:Dictionary = new Dictionary();
			for each (var event:* in events) {
				var eventStart:Date = _calendarDescriptor.getEventStart(event);
				var eventEnd:Date = _calendarDescriptor.getEventEnd(event);
				if (!DateUtil.timeBlocksOverlap(eventStart, eventEnd, dayStart, dayEnds))
					continue;
				var calendar:* = _calendarDescriptor.getCalendar(event);
				if (!calendars.contains(calendar))
					continue;
					
				var eventUI:CalendarEvent = visibleEvents[event];
				delete visibleEvents[event];
				if (eventUI == null) {
					var startNew:Number = flash.utils.getTimer();
					eventUI = new CalendarEvent();
					_renderer.updateEventRenderer(eventUI);
					newCalendarEventTime += flash.utils.getTimer() - startNew;
					var startAddChild:Number = flash.utils.getTimer();
					addChild(eventUI);
					addChildTime += flash.utils.getTimer() - startAddChild;
				}
				newVisibleEvents[event] = eventUI;
				eventUI.calendarDescriptor = _calendarDescriptor;
				eventUI.eventData = event;
			}
			
			// Remove any extra events.
			for each (var uiEvent:CalendarEvent in visibleEvents) {
				removeChild(uiEvent);
			}
			
			visibleEvents = newVisibleEvents;
			invalidateDisplayList();
			
			var end:Number = flash.utils.getTimer();
			log.info("eventsChanged time= {0} ms.; new CalendarEvent time= {1} ms.; addchild time={2} ms.", end - start, newCalendarEventTime, addChildTime);
		}
		
		private function asCollection(map:Dictionary):ArrayCollection {
			var list:ArrayCollection = new ArrayCollection();
			for each (var item:* in map)
				list.addItem(item);
			return list;
		}
		
		protected override function measure():void {
			super.measure();
			_renderer.measure();
		}
		
		protected override function updateDisplayList(width:Number, height:Number):void {
			var start:Number = flash.utils.getTimer();
			super.updateDisplayList(width, height);
			_renderer.layoutEvents(asCollection(visibleEvents), width, height);
			
			var clipMaks:FlexSprite = mask as FlexSprite;
			clipMaks.graphics.clear();
			clipMaks.graphics.beginFill(0xFF0000);
			clipMaks.graphics.drawRect(0, 0, width, height);
			
			graphics.clear();
			
			_renderer.drawBackground(graphics, width, height, 0);
			_renderer.updateDisplayList(graphics, width, height);
			var end:Number = flash.utils.getTimer();
			log.info("updateDisplayList time= {0} ms.", end - start);
		}

	}
}