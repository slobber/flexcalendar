package com.hevery
{
	import mx.controls.TextArea;
	import mx.logging.targets.LineFormattedTarget;
	import mx.logging.targets.TraceTarget;
	
	//import mx.core.mx_internal;
	import mx.core.mx_internal;
	use namespace mx_internal;

	public class TextAreaLineFormatedTarget extends LineFormattedTarget
	{
		public var textArea:TextArea;
		
		override mx_internal function internalLog(message:String):void
		{ 
			if (textArea != null) {
				textArea.text = message + "\n" + textArea.text;
			}
	    }
	}
}