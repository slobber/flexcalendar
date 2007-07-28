// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal.decoration
{
	import com.hevery.cal.CalendarDescriptor;
	
	import mx.controls.Text;
	import mx.core.UIComponent;

	public class CalendarLabel extends UIComponent
	{
		private var textField:Text = new Text();
		
		private var _calendarData:*;
		private var _calendarDataChanged:Boolean = false;
		public function get calendarData():* { return _calendarData; };
		public function set calendarData(value:*):void {setValue("calendarData", value);};

		private var _calendarDescriptor:CalendarDescriptor;
		private var _calendarDescriptorChanged:Boolean = false;
		public function get calendarDescriptor():CalendarDescriptor { return _calendarDescriptor; };
		public function set calendarDescriptor(value:CalendarDescriptor):void {setValue("calendarDescriptor", value);};
		
		protected override function createChildren():void {
			super.createChildren();
			textField.truncateToFit = true;
			textField.x = 0;
			textField.y = 0;
			addChild(textField);
		}
		
		protected override function commitProperties():void {
			super.commitProperties();
			if (_calendarDescriptorChanged) {
				_calendarDescriptorChanged = false;
				_calendarDataChanged = true;
			}
			if (_calendarDataChanged) {
				_calendarDataChanged = false;
				textField.text = _calendarDescriptor.getCalendarName(_calendarData);
				textField.toolTip = textField.text;
			}
		}
		
		public override function setActualSize(w:Number, h:Number):void {
			super.setActualSize(w, h);
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var color:uint = _calendarDescriptor.getCalendarColor(_calendarData);
			textField.width = unscaledWidth;
			textField.height = unscaledHeight;
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
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
	}
}