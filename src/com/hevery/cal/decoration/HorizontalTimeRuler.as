// Copyright 2007
// Author: Misko Hevery <misko@hevery.com>
package com.hevery.cal.decoration
{
	import com.hevery.cal.DateUtil;
	import com.hevery.cal.UIProperty;
	
	import flash.display.Sprite;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Label;
	import mx.core.FlexSprite;
	import mx.core.UIComponent;
	import mx.formatters.DateFormatter;

	[Bindable]
	public class HorizontalTimeRuler extends UIComponent {
		
		public function setProp(property:String, value:*):void {this[property] = value; }
		public function getProp(property:String):* {return this[property];}

		private var _startDate:Date = new Date();
		private var _startDateChanged:Boolean = false;
		public function get startDate():Date { return _startDate; };
		public function set startDate(value:Date):void { UIProperty.setValue(this, "startDate", value);};

		private var _duration:Number = DateUtil.DAY;
		private var _durationChanged:Boolean = false;
		public function get duration():Number { return _duration; };
		public function set duration(value:Number):void { UIProperty.setValue(this, "duration", value);};

		public var dateFormatter:DateFormatter = new DateFormatter();

		private var backgroundRenderer:HorizontalBackgroundRenderer = new HorizontalBackgroundRenderer();
		private var labels:ArrayCollection = new ArrayCollection();
		private var labelsValid:Boolean = false;
		private var labelWidth:int = 50;
		
		private function get pixelsPerMilisecond():Number {return width / duration;}
		private function get midnightOffset():Number {return _startDate.time - DateUtil.trimToDay(_startDate).time;}
		
		public function HorizontalTimeRuler() {
			height = 20;
			percentWidth = 100;
			backgroundRenderer.showLines = false;
			dateFormatter.formatString = "M/D/YY"
		}
		
		override protected function createChildren():void {
			mask = new FlexSprite();
			addChild(mask);
		}
		
		protected override function commitProperties():void {
			super.commitProperties();
			if (_startDateChanged) {
				_startDateChanged = false;
				invalidateDisplayList();
				invalidateLabels();
			}
			if (_durationChanged) {
				_durationChanged = false;
				invalidateDisplayList();
				invalidateLabels();
			}
		}
		
		protected function invalidateLabels():void {
			labelsValid = false;
		}
		
		protected override function updateDisplayList(width:Number, height:Number):void {
			super.updateDisplayList(width, height);
			var clip:Sprite = mask as Sprite;
			clip.graphics.clear();
			clip.graphics.beginFill(0xFF0000);
			clip.graphics.drawRect(0, 0, width, height);
			graphics.clear();
			backgroundRenderer.drawRuler(graphics, width, height, midnightOffset, duration, pixelsPerMilisecond);
			updateLabels(width, height);
			graphics.lineStyle(1, 0, .5);
			for each (var label:UIComponent in labels) {
				var x:Number = label.x + label.width / 2;
				graphics.moveTo(x, height - 4);
				graphics.lineTo(x, height);
			}
		}
		
		protected function updateLabels(width:Number, height:Number):void {
			if (!labelsValid) {
				var pixelsPerDay:Number = DateUtil.DAY * pixelsPerMilisecond;
				if (pixelsPerDay > 200) 
					updateHourLabels(width, height)
				else
					updateDateLabels(width, height);
			}
			labelsValid = true;
		}
		
		protected function updateHourLabels(width:Number, height:Number):void {
			var numberOfLabels:int = 24;
			var dayWidth:Number = DateUtil.DAY * pixelsPerMilisecond;
			while(dayWidth < numberOfLabels * labelWidth) {
				numberOfLabels /= 2;
			}
			
			var hoursPerLabel:int = 24 / numberOfLabels;
			var time:Number = DateUtil.trimToHour(_startDate).time - DateUtil.HOUR * hoursPerLabel;
			var newLabels:ArrayCollection = new ArrayCollection();
			
			while(time < _startDate.time + duration + DateUtil.HOUR) {
				var hour:int = new Date(time).hours;
				var label:Label;
				if (labels.length > 0) {
					label = labels.removeItemAt(0) as Label;
				} else {
					label = new Label();
					addChild(label);
				}
				if (hour == 0)
					label.text = "Midnight";
				else if (hour == 12)
					label.text = "Noon";
				else if (hour < 12)
					label.text = hour + " am";
				else 
					label.text = (hour - 12) + " pm";
				
				label.setStyle("textAlign", "center");
				label.width = labelWidth * 2;
				label.height = height;
				label.x = (time - _startDate.time) * pixelsPerMilisecond - labelWidth;
				label.y = 0;
					
				newLabels.addItem(label);
				time += DateUtil.HOUR * hoursPerLabel;
			}
			for each (var x:* in labels) {
				removeChild(x);
			}
			labels = newLabels;
		}
		
		protected function updateDateLabels(width:Number, height:Number):void {
			var dayWidth:Number = DateUtil.DAY * pixelsPerMilisecond;
			var daysPerLabel:int;
			var time:Number;
			if (1 * dayWidth > labelWidth) {
				daysPerLabel = 1;
				time = DateUtil.trimToDay(_startDate).time - DateUtil.DAY;
			} else if (7 * dayWidth > labelWidth) { 
				daysPerLabel = 7;
				time = DateUtil.trimToWeek(_startDate).time - DateUtil.WEEK;
			} else {
				daysPerLabel = 28;
				time = DateUtil.trimToMonth(_startDate).time - DateUtil.MONTH;
			}
			
			var newLabels:ArrayCollection = new ArrayCollection();
			
			while(time < _startDate.time + duration + DateUtil.HOUR) {
				var hour:int = new Date(time).hours;
				var label:Label;
				if (labels.length > 0) {
					label = labels.removeItemAt(0) as Label;
				} else {
					label = new Label();
					addChild(label);
				}
				label.text = dateFormatter.format(new Date(time));
				label.setStyle("textAlign", "center");
				label.width = labelWidth * 2;
				label.height = height;
				label.x = (time - _startDate.time) * pixelsPerMilisecond - labelWidth;
				label.y = 0;
					
				newLabels.addItem(label);
				time += DateUtil.DAY * daysPerLabel;
			}
			for each (var x:* in labels) {
				removeChild(x);
			}
			labels = newLabels;
		}
	}
}