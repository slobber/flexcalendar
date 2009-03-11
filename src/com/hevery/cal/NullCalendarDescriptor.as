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
	import mx.collections.ArrayCollection;
	
	public class NullCalendarDescriptor implements CalendarDescriptor
	{
		public function getCalendarColor(calendar:*):Number{return 0;}
		public function getCalendarName(calendar:*):String{return "";}
		public function getCalendar(event:*):*{return null;}
		
		public function getEventStart(event:*):Date{return null;}
		public function getEventEnd(event:*):Date{return null;}
		public function getEventTitle(event:*):String{return "";}
		public function getEventDescription(event:*):String{return "";}
		public function getEventColor(event:*):Number{return 0;}
	}
}