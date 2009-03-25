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
package com.hexagonstar.util.debug
{
	import flash.display.Stage;
	import flash.net.LocalConnection;	

	
	/**
	 * Debug Class
	 * @author Sascha Balkau <sascha@hexagonstar.com>
	 */
	public class Debug
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * The Debug.LEVEL_DEBUG constant defines the value of the Debug Filtering Level.
		 */
		public static const LEVEL_DEBUG:int	= 0;
		
		/**
		 * The Debug.LEVEL_INFO constant defines the value of the Info Filtering Level.
		 */
		public static const LEVEL_INFO:int	= 1;
		
		/**
		 * The Debug.LEVEL_WARN constant defines the value of the Warn Filtering Level.
		 */
		public static const LEVEL_WARN:int	= 2;
		
		/**
		 * The Debug.LEVEL_ERROR constant defines the value of the Error Filtering Level.
		 */
		public static const LEVEL_ERROR:int	= 3;
		
		/**
		 * The Debug.LEVEL_FATAL constant defines the value of the Fatal Filtering Level.
		 */
		public static const LEVEL_FATAL:int	= 4;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private static var _filterLevel:int				= 0;
		private static var _isEnabled:Boolean			= true;
		private static var _isConnected:Boolean			= false;
		private static var _isMonitoring:Boolean			= false;
		
		private static var _stage:Stage;
		private static var _LoggingConnection:LocalConnection;
		private static var _MonitorConnection:LocalConnection;
		
		
		/**
		 * Creates a new Debug instance.
		 */
		function Debug()
		{
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Monitoring API                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * monitor
		 */
		public static function monitor(stage:Stage, pollInterval:int = 500):void
		{
		}
		
		
		/**
		 * mark
		 */
		public static function mark(color:uint = 0xFF00FF):void
		{
		}
		
		
		/**
		 * stop
		 */
		public static function stop():void
		{
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Trace API                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * trace
		 */
		public static function trace(data:*, level:int = 1):void
		{
		}
		
		
		/**
		 * traceObj
		 */
		public static function traceObj(obj:Object, level:int = 1, depth:int = 64):void
		{
		}
		
		
		/**
		 * hexDump
		 */
		public static function hexDump(obj:Object, level:int = 1):void
		{
		}
		
		
		/**
		 * clear
		 */
		public static function clear():void
		{
		}
		
		
		/**
		 * delimiter
		 */
		public static function delimiter():void
		{
		}
		
		
		/**
		 * pause
		 */
		public static function pause():void
		{
		}
		
		
		/**
		 * timestamp
		 */
		public static function timestamp():void
		{
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Inspect API                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * inspect
		 */
		public static function inspect(obj:Object, depth:int = 64):void
		{
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Timer API                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * timerStart
		 */
		public static function timerStart(title:String = ""):void
		{
		}
		
		
		/**
		 * timerStop
		 */
		public static function timerStop():void
		{
		}
		
		
		/**
		 * timerReset
		 */
		public static function timerReset():void
		{
		}
		
		
		/**
		 * timerToString
		 */
		public static function timerToString():void
		{
		}
		
		
		/**
		 * timerStopToString
		 */
		public static function timerStopToString(reset:Boolean = false):void
		{
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Utility Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * forceGC
		 */
		public static function forceGC():void
		{
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public static function get enabled():Boolean
		{
			return _isEnabled;
		}
		public static function set enabled(v:Boolean):void
		{
			_isEnabled = v;
		}
		
		
		public static function get filterLevel():int
		{
			return _filterLevel;
		}
		public static function set filterLevel(v:int):void
		{
			if (v >= 0 && v < 5) _filterLevel = v;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
	}
}
