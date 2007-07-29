// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal.event
{
	import com.hevery.cal.CalendarDescriptor;
	import com.hevery.cal.NullCalendarDescriptor;
	import com.hevery.cal.UIProperty;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.core.ClassFactory;
	import mx.core.FlexSprite;
	import mx.core.IFactory;
	import mx.core.UIComponent;
	import mx.events.PropertyChangeEvent;
	import mx.formatters.DateFormatter;

	[Style(name="headerHeight", type="Number", inherit="no")]
	[Style(name="cornerRadius", type="Number", inherit="no")]
	[Style(name="borderThickness", type="Number", inherit="no")]
	public class CalendarEvent extends UIComponent
	{
		
		public function setProp(property:String, value:*):void {this[property] = value; }
		public function getProp(property:String):* {return this[property];}
	
		internal var titleField:TextField = new TextField();
		internal var textField:TextField = new TextField();
		private var timeFormater:DateFormatter = new DateFormatter();
		
		private var _renderer:EventRenderer;
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
				_renderer.event = this;
			} else {
				_renderer = null;
			}
		};
		
		private var _eventData:*;
		private var _eventDataChanged:Boolean = false;
		public function get eventData():* { return _eventData; };
		public function set eventData(value:*):void {UIProperty.setValue(this, "eventData", value);};
		private function eventDataChange(event:PropertyChangeEvent):void {_eventDataChanged = true; invalidateProperties();}

		private var _calendarDescriptor:CalendarDescriptor = new NullCalendarDescriptor();
		private var _calendarDescriptorChanged:Boolean = false;
		public function get calendarDescriptor():CalendarDescriptor { return _calendarDescriptor; };
		public function set calendarDescriptor(value:CalendarDescriptor):void {UIProperty.setValue(this, "calendarDescriptor", value);};

		internal function get timeText():String {
			var start:Date = _calendarDescriptor.getEventStart(_eventData);
			return timeFormater.format(start);			
		}

		public function CalendarEvent() {
			super();
			styleName = "CalendarEvent";
			timeFormater.formatString = "L:NN"
			rendererFactory = new ClassFactory(BlockEventRenderer);
		}

		protected override function commitProperties():void {
			super.commitProperties();
			if (_rendererFactoryChanged) {
				_rendererFactoryChanged = false;
				_eventDataChanged = true;
			}
			if (_calendarDescriptorChanged) {
				_calendarDescriptorChanged = false;
				_eventDataChanged = true;
			}
			if (_eventDataChanged) {
				_eventDataChanged = false;
				var titleText:String = timeText;
				titleField.text = titleText + "\t" + _calendarDescriptor.getEventTitle(_eventData);
				textField.text = _calendarDescriptor.getEventDescription(_eventData);
				titleField.setTextFormat(_renderer.timeFormat, 0, titleText.length);
				titleField.setTextFormat(_renderer.titleFormat, titleText.length, titleField.text.length);
				textField.setTextFormat(_renderer.textFormat);
				toolTip = titleField.text + "\n" + textField.text;
				invalidateDisplayList();
			}
		}
		
		protected override function createChildren():void {
			titleField.tabEnabled = true;
			textField.wordWrap = true;
			
			titleField.selectable = false;
			textField.selectable = false;
			
			addChild(titleField);
			addChild(textField);

			mask = new FlexSprite();
			addChild(mask);
		}
		
		protected override function updateDisplayList(width:Number, height:Number):void{
			super.updateDisplayList(width, height);
			var clip:FlexSprite = mask as FlexSprite;
			clip.graphics.clear();
			clip.graphics.beginFill(0xFF0000);
			clip.graphics.drawRect(0, 0, width, height);
			_renderer.updateDisplayList(graphics, width, height);
			_renderer.positionTextFields(width, height);
		}
		
		protected override function measure():void {
			super.measure();
			_renderer.measure();
		}
	}
}