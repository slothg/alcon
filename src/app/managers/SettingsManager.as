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
package managers
{
	import flash.net.SharedObject;
	
		/**
	 * This is a singleton class that manages LocalSharedObject settings.
	 * It also works as a registry of settings objects names. 
	 * 
	 * @author Sascha Balkau
	 */
	public class SettingsManager
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/* Add any keys for settings stored in the Local Shared Object here as
		 * public static constants. These act as the settings key registry. */
		
		public static const DATA_PATH:String = "dataPath";
		public static const WINDOW_POSITION:String = "winPos";
		public static const WINDOW_SIZE:String = "winSize";
		
		public static const MAX_GRAPH_MEM:String = "maxGraphMem";
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private static var _instance:SettingsManager;
		private var _so:SharedObject;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new SettingsManager instance.
		 */
		public function SettingsManager()
		{
			if (_instance != null)
			{
				throw new Error("Tried to instantiate SettingsManager through"
					+ " it's constructor. Use SettingsManager.instance instead!");
			}
			
			_so = SharedObject.getLocal("localSettings");	
		}
		
		
		/**
		 * Get the given setting value from the LocalSharedObject.
		 */
		public function getSetting(key:String):*
		{
			return _so.data[key];
		}
		
		
		/**
		 * Set and save the given setting.
		 */
		public function setSetting(key:String, value:*):void
		{
			_so.data[key] = value;
			_so.flush();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public static function get instance():SettingsManager
		{
			if (!_instance) _instance = new SettingsManager();
			return _instance;
		}
	}
}
