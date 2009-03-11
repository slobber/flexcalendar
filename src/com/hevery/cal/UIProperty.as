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
	import flash.events.IEventDispatcher;
	import mx.events.PropertyChangeEvent;
	import flash.display.DisplayObject;
	import mx.core.UIComponent;
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import flash.events.Event;
	
	public class UIProperty
	{
		public static function setValue(uiComponent:*, property:String, value:*):void {
			var _property:String = "_" + property;
			var _propertyChanged:String = "_" + property + "Changed";
			var _changeListener:String = property + "Change";
			var _changeCollectionListener:String = property + "CollectionChange";
			var oldValue:* = uiComponent.getProp(_property);
			var onPropertyChangeListener:Function = null;
			var onPropertyCollectionChangeListener:Function = null;
			if (oldValue == value) return;

			try {
				onPropertyChangeListener = uiComponent.getProp(_changeListener);
			} catch (e:Error) { }
			try {
				onPropertyCollectionChangeListener = uiComponent.getProp(_changeCollectionListener);
			} catch (e:Error) { }

			if (onPropertyChangeListener !=null && oldValue is IEventDispatcher)
				(oldValue as IEventDispatcher).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChangeListener);
			if (onPropertyCollectionChangeListener !=null && oldValue is ArrayCollection)
				(oldValue as ArrayCollection).removeEventListener(CollectionEvent.COLLECTION_CHANGE, onPropertyCollectionChangeListener);

			uiComponent.setProp(_property, value);
			if (uiComponent is IEventDispatcher)
				IEventDispatcher(uiComponent).dispatchEvent(new Event(property + "Changed"));

			if (onPropertyChangeListener != null && value is IEventDispatcher)
				(value as IEventDispatcher).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChangeListener);
			if (onPropertyCollectionChangeListener !=null && value is ArrayCollection)
				(value as ArrayCollection).addEventListener(CollectionEvent.COLLECTION_CHANGE, onPropertyCollectionChangeListener);
			try {
				uiComponent.setProp(_propertyChanged, true);
				uiComponent.invalidateProperties();
			} catch (e:Error) {
				uiComponent.invalidateDisplayList();
			}
		}
	}
}