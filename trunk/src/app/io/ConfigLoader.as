/*
 * Alcon - ActionScript Logging & Debugging Console.
 *
 * Licensed under the MIT License
 * Copyright (c) 2009 Sascha Balkau / Hexagon Star Softworks
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package io
{
	import model.Config;

	import util.Log;

	import com.hexagonstar.env.event.FileIOEvent;
	import com.hexagonstar.io.file.types.IFile;
	import com.hexagonstar.io.file.types.TextFile;
	import com.hexagonstar.io.file.types.XMLFile;

	import flash.events.ErrorEvent;
	import flash.events.Event;

	[Event(name="complete", type="flash.events.Event")]
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	
	/**
	 * A class that loads the application configuration/ini file and parses the
	 * loaded properties into the config model. The manager/config model supports
	 * simple string and numeric values, objects, and arrays.<p>
	 * The ConfigModel class should contain all properties that are also found in
	 * the config file. See the Config class for more info.
	 * 
	 * @author Sascha Balkau
	 */
	public class ConfigLoader extends AbstractLoader
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/* The path to the application ini file */
		private static var INI_PATH:String = "app.ini";
		
		/* Should be set to true if the ini file is an XML file */
		private static var IS_XML:Boolean = false;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private var _config:Config;
		private var _hasNotified:Boolean;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new instance of the class.
		 */
		public function ConfigLoader()
		{
			super();
		}
		
		
		/**
		 * Loads the application configuration file.
		 */
		override public function load():void
		{
			super.load();
			
			_hasNotified = false;
			_config = Main.config;
			_config.init();
			
			var file:IFile = (IS_XML) ? new XMLFile() : new TextFile();
			file.path = INI_PATH;
			
			_loader.addFile(file);
			_loader.load();
		}
		
		
		/**
		 * Returns a String Representation of ConfigLoader.
		 * 
		 * @return A String Representation of ConfigLoader.
		 */
		override public function toString():String
		{
			return "[ConfigLoader]";
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Initiates parsing of the loaded config file into the config model object.
		 * @private
		 */
		override public function onAllComplete(e:FileIOEvent):void
		{
			if (e.file.isValid)
			{
				if (IS_XML)
					parseXML(e.file as XMLFile);
				else
					parseText(e.file as TextFile);
			}
			else
			{
				notifyError("Malformed content in " + e.file.toString() + ": "
					+ e.file.errorStatus);
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Notifies any listener that an error occured during loading/checking the config.
		 * @private
		 * 
		 * @param msg the error message.
		 */
		override protected function notifyError(msg:String):void
		{
			/* Only notify once in case of a load error. Without this check
			 * it would also notify a second time for invalid XML if the
			 * file could not be found. */
			if (!_hasNotified)
			{
				_hasNotified = true;
				
				var e:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR);
				e.text = toString() + " Error loading config: " + msg;
				dispatchEvent(e);
			}
		}
		
		
		/**
		 * Parses xml from a XML File into config data.
		 * @private
		 */
		private function parseXML(file:XMLFile):void
		{
			var xml:XML = file.contentAsXML;
			for each (var p:XML in xml..property)
			{
				parseProperty(p.@key, p.@value);
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}

		
		/**
		 * Parses text from a Text File into config data.
		 * @private
		 */
		private function parseText(file:TextFile):void
		{
			var text:String = file.contentAsString;
			var lines:Array = text.match(/([^=\r\n]+)=(.*)/g);
			var key:String;
			var val:String;
			
			for each (var l:String in lines)
			{
				var pos:int = l.indexOf("=");
				key = trim(l.substring(0, pos));
				val = trim(l.substring(pos + 1, l.length));
				parseProperty(key, val);
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		/**
		 * Tries to parse the specified key and value pair into the Config Model.
		 * @private
		 */
		private function parseProperty(key:String, val:String):void
		{
			var keyExists:Boolean = true;
			var p:*;
			
			/* Check if the key found in the config file
			 * is defined in the ConfigModel class */
			try
			{
				p = _config[key];
			}
			catch (e:Error)
			{
				Log.error(toString() + " Error parsing config property: " + e.message);
				keyExists = false;
			}
			
			if (keyExists)
			{
				if (p is Number)
					_config[key] = val;
				else if (p is String)
					_config[key] = val;
				else if (p is Boolean)
					_config[key] = (val.toLowerCase() == "true") ? true : false;
				else if (p is Array)
					_config[key] = parseArray(val);
				else if (p is Object)
					_config[key] = parseObject(val);
			}
		}
		
		
		/**
		 * Parses a string into an array. The string must have the format
		 * [val1, val2, val3] and so on. Note that string type values in
		 * the array string should not be wrapped by any kind of quotation
		 * marks; internally all values are treated as Strings!
		 * @private
		 * 
		 * @param string The string to parse into an array.
		 * @return the array with values from the string or null if the
		 *          string could not be parsed into an array.
		 */
		private function parseArray(string:String):Array
		{
			/* String must start mit [ and end with ] */
			if (string.match("^\\[.*?\\]\\z"))
			{
				string = string.substr(1, string.length - 2);
				if (string.length > 0)
				{
					var a:Array = string.split(",");
					for (var i:String in a)
					{
						a[i] = trim(a[i]);
					}
					return a;
				}
				return null;
			}
			else
			{
				Log.error(toString() + " Error parsing config: malformed syntax"
					+ " in Array property: " + string);
				return null;
			}
		}
		
		
		/**
		 * Parses a string into an object. The string must have the format
		 * {key1: val1, key2: val2, key3: val3} and so on. Note that string type
		 * values in the object string should not be wrapped by any kind of
		 * quotation marks; internally all values are treated as Strings!
		 * @private
		 * 
		 * @param string The string to parse into an object.
		 * @return the object with the key/value pairs from the string or null
		 *          if the string could not be parsed into an object.
		 */
		private function parseObject(string:String):Object
		{
			/* String must start with {, end with }, contain at least one : and
			 * may not contain any {} in it's contents */
			if (string.match("^\\{.[^\\{\\}]*?[:]+.[^\\{\\}]*?\\}\\z"))
			{
				string = string.substr(1, string.length - 2);
				var a:Array = string.split(",");
				var o:Object = {};
				
				for (var i:String in a)
				{
					var d:Array = (a[i] as String).split(":");
					var p:RegExp = new RegExp("[ \n\t\r]", "g");
					var key:String = (d[0] as String).replace(p, "");
					var val:String = (d[1] as String).replace(p, "");
					o[key] = val;
				}
				return o;
			}
			else
			{
				Log.error(toString() + " Error parsing config: malformed syntax"
					+ " in Object property: " + string);
				return null;
			}
		}
	}
}
