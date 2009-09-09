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
package com.hevery.cal
{
	import flash.display.DisplayObject;
	import flash.text.TextField;
	
	import mx.controls.scrollClasses.ScrollBar;
	import mx.core.FlexSprite;
	import mx.core.UIComponent;
	import mx.events.ScrollEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import flash.text.TextFormat;


	[Style(name="backgroundColor", type="Color", inherit="no")]
	[Style(name="textColor", type="Color", inherit="no")]
	[Style(name="font", type="String", inherit="no")] 
	public class DayChrome extends UIComponent
	{
		private static const log:ILogger = Log.getLogger("com.hevery.cal.DayChrome");
		
		public function setProp(property:String, value:*):void {this[property] = value; }
		public function getProp(property:String):* {return this[property];}
	
		internal var titleField:TextField = new TextField();		
		internal var clipView:UIComponent = new UIComponent();
		
		private var _title:*;
		private var _titleChanged:Boolean = false;
		public function get title():* { return _title; };
		public function set title(value:*):void {UIProperty.setValue(this, "title", value);};
		
		private var _verticalScrollBar:ScrollBar;
		private var _verticalScrollBarChanged:Boolean = false;
		public function get verticalScrollBar():ScrollBar { return null; };
		public function set verticalScrollBar(value:ScrollBar):void {
			if (_verticalScrollBar != null)
				_verticalScrollBar.removeEventListener(ScrollEvent.SCROLL, onVerticalScrollBarScroll);
			_verticalScrollBar = value;
			if (_verticalScrollBar != null)
				_verticalScrollBar.addEventListener(ScrollEvent.SCROLL, onVerticalScrollBarScroll);
			invalidateDisplayList();
		}
		private function onVerticalScrollBarScroll(event:ScrollEvent):void {
			invalidateDisplayList();
		}
		
		public function DayChrome() {
			super();
			styleName = "DayChrome";
		}
		
		protected override function commitProperties():void {
			super.commitProperties();
			if (_titleChanged) {
				_titleChanged = false;
				titleField.text = title;
			}
			if (_verticalScrollBarChanged) {
				_verticalScrollBarChanged = false;
			}
		}
		
		override protected function createChildren():void {
			super.createChildren();
			super.addChildAt(clipView, 0);
			super.addChildAt(titleField, 0);
			clipView.mask = new FlexSprite();
			clipView.addChild(clipView.mask);
			titleField.selectable = false;
			titleField.textColor = getStyle("textColor");
			var font:String = getStyle("font");
			var tf:TextFormat;
			if (font != null && font != "") {
				tf = new TextFormat();
				tf.font = font;
			}
			var fontSize:int = getStyle("fontSize");
			if (fontSize != 0) {
				if (tf == null) {
					tf = new TextFormat();
				}
				tf.size = fontSize;
			}
			if (tf != null) {
				titleField.defaultTextFormat = tf;
			}
		}
		
		override public function setActualSize(w:Number, h:Number):void {
			super.setActualSize(w, h);
			titleField.x = 0;
			titleField.y = 0;
			titleField.height = Math.min(16, h);
			titleField.width = width;
		}
		
		public function get viewHeight():Number {
			return height - 16 - 1;
		}
				
		override protected function updateDisplayList(width:Number, height:Number):void {
			log.info("");
			// TODO: Why is this metod called way too many times per cycle
			super.updateDisplayList(width, height);
			clipView.move(1, 16);
			clipView.setActualSize(width - 2, viewHeight);
			var clip:FlexSprite = clipView.mask as FlexSprite;
			clip.graphics.clear();
			clip.graphics.beginFill(0xFF0000);
			clip.graphics.drawRect(0, 0, width - 2, viewHeight);
			
			for (var i:int=0; i<clipView.numChildren; i++) {
				var child:UIComponent = clipView.getChildAt(i) as UIComponent;
				if (child == null) continue;
				var childW:Number = child.percentWidth ? clipView.width : child.getExplicitOrMeasuredWidth();
				var childH:Number = child.percentHeight ? clipView.height : child.getExplicitOrMeasuredHeight();
				var verticalOffset:Number = _verticalScrollBar==null ? 0 : _verticalScrollBar.scrollPosition;
				child.move(0, -verticalOffset);
				child.setActualSize(childW, childH);
			}
			graphics.clear();
			graphics.beginFill(getStyle("backgroundColor"));
			graphics.drawRect(0, 0, width, height);
			log.info("DayChrome.updateDisplayList");
		}
		
		override public function addChild(child:DisplayObject):DisplayObject {return clipView.addChild(child);}
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {return clipView.addChildAt(child, index);}
		override public function getChildAt(index:int):DisplayObject {return clipView.getChildAt(index);}
		override public function getChildByName(name:String):DisplayObject {return clipView.getChildByName(name);}
		override public function getChildIndex(child:DisplayObject):int {return clipView.getChildIndex(child);}
		override public function removeChild(child:DisplayObject):DisplayObject {return clipView.removeChild(child)}
		override public function removeChildAt(index:int):DisplayObject {return clipView.removeChildAt(index);}
		override public function get numChildren():int {return clipView.numChildren;}
	}
}