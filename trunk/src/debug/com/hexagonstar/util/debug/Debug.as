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
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.describeType;	

	
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
		
		protected static const MAX_PACKAGE_BYTES:int = 40000;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		protected static var _filterLevel:int				= 0;
		protected static var _isEnabled:Boolean				= true;
		protected static var _isMonitoring:Boolean			= false;
		protected static var _isLoggingConnected:Boolean		= false;
		protected static var _isMonitorConnected:Boolean		= false;
		
		protected static var _stage:Stage;
		protected static var _byteArray:ByteArray;
		
		protected static var _loggingConnection:LocalConnection;
		protected static var _monitorConnection:LocalConnection;
		
		protected static var _fpsMeter:FPSMeter;
		protected static var _stopWatch:StopWatch;
		
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
		public static function monitor(stage:Stage, pollInterval:int = 50):void
		{
			if (_isMonitoring) Debug.stop();
			
			if (_isEnabled && !_fpsMeter)
			{
				if (!_isMonitorConnected) connectMonitoring();
				
				_isMonitoring = true;
				_stage = stage;
				sendCapabilities();
				_fpsMeter = new FPSMeter(_stage, pollInterval);
				_fpsMeter.addEventListener(FPSMeter.FPS_UPDATE, onFPSUpdate);
				_fpsMeter.start();
			}
		}
		
		
		/**
		 * mark
		 */
		public static function mark(color:uint = 0xFF00FF):void
		{
			if (_isMonitoring)
				send("onMarkerData", color);
		}
		
		
		/**
		 * stop
		 */
		public static function stop():void
		{
			if (_fpsMeter)
			{
				_fpsMeter.stop();
				_fpsMeter.removeEventListener(FPSMeter.FPS_UPDATE, onFPSUpdate);
				_fpsMeter = null;
				_stage = null;
				_isMonitoring = false;
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Trace API                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * trace
		 */
		public static function trace(data:*, level:int = 1):void
		{
			if (level >= _filterLevel)
				sendPkg("onTraceData", data, level);
		}
		
		
		/**
		 * traceObj
		 */
		public static function traceObj(obj:Object, level:int = 1, depth:int = 64):void
		{
			if (level >= _filterLevel)
				sendObj("onTraceObjData", obj, level, depth);
		}
		
		
		/**
		 * hexDump
		 */
		public static function hexDump(obj:Object, level:int = 1, startPos:int = 0,
			endPos:int = -1):void
		{
			if (level >= _filterLevel)
				sendHex("onHexDumpData", obj, level, startPos, endPos);
		}
		
		
		/**
		 * clear
		 */
		public static function clear():void
		{
			send("onTraceCommand", "clear");
		}
		
		
		/**
		 * delimiter
		 */
		public static function delimiter():void
		{
			send("onTraceCommand", "delimiter");
		}
		
		
		/**
		 * pause
		 */
		public static function pause():void
		{
			send("onTraceCommand", "pause");
		}
		
		
		/**
		 * timestamp
		 */
		public static function timestamp():void
		{
			send("onTraceCommand", "timestamp");
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Inspect API                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * inspect
		 */
		public static function inspect(obj:Object, depth:int = 64):void
		{
			sendObj("onInpectData", obj, 1, depth);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Timer API                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * timerStart
		 */
		public static function timerStart(title:String = ""):void
		{
			if (_isEnabled)
			{
				if (!_stopWatch) _stopWatch = new StopWatch();
				_stopWatch.start(title);
			}
		}
		
		
		/**
		 * timerStop
		 */
		public static function timerStop():void
		{
			if (_stopWatch) _stopWatch.stop();
		}
		
		
		/**
		 * timerReset
		 */
		public static function timerReset():void
		{
			if (_stopWatch) _stopWatch.reset();
		}
		
		
		/**
		 * timerToString
		 */
		public static function timerToString():void
		{
			if (_isEnabled)
			{
				if (_stopWatch)
				{
					if (!_isLoggingConnected) connectLogging();
					
					_loggingConnection.send("_alcon_logging", "onStopWatchData",
						_stopWatch.title,
						_stopWatch.startTimeKeys,
						_stopWatch.stopTimeKeys);
				}
			}
		}
		
		
		/**
		 * timerStopToString
		 */
		public static function timerStopToString(reset:Boolean = false):void
		{
			if (_stopWatch)
			{
				_stopWatch.stop();
				Debug.timerToString();
				if (reset) _stopWatch.reset();
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Utility Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * forceGC
		 */
		public static function forceGC():void
		{
			try
			{
				System["gc"]();
			}
			catch (e1:Error)
			{
				try
				{
					new LocalConnection().connect("forceGC");
					new LocalConnection().connect("forceGC");
				}
				catch (e2:Error)
				{
				}
			}
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
			if (v >= 0) _filterLevel = v;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		protected static function onAsyncError(e:AsyncErrorEvent):void
		{
			throw new Error("[Alcon Debug] A Asynchronous Error occured!"
				+ " The error message was: " + e.error.message);
		}
		
		
		protected static function onSecurityError(e:SecurityErrorEvent):void
		{
			throw new Error("[Alcon Debug] A Security Error occured!"
				+ " The error message was: " + e.text);
		}
		
		
		protected static function onStatus(e:StatusEvent):void
		{
		}
		
		
		protected static function onFPSUpdate(e:Event):void
		{
			if (_isEnabled)
			{
				_monitorConnection.send("_alcon_monitor", "onMonitorData",
					_fpsMeter.fps,
					_stage.frameRate,
					_fpsMeter.frt,
					System.totalMemory);
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Sends the specified data to Alcon.
		 * @private
		 */
		protected static function send(m:String, o:Object):void
		{
			if (_isEnabled)
			{
				if (!_isLoggingConnected) connectLogging();
				_loggingConnection.send("_alcon_logging", m, o);
			}
		}
		
		
		/**
		 * Sends the specified data to Alcon.
		 * @private
		 */
		protected static function sendPkg(m:String, o:Object = null, l:int = 1):void
		{
			if (_isEnabled)
			{
				if (!_isLoggingConnected) connectLogging();
				
				var pkg:Vector.<DataPackage> = compress(o);
				for (var i:int = 0; i < pkg.length; i++)
				{
					var p:DataPackage = pkg[i];
					_loggingConnection.send("_alcon_logging", m, l, p.t, p.n, p.b);
				}
			}
		}
		
		
		/**
		 * Sends the specified object to Alcon.
		 * @private
		 */
		protected static function sendObj(m:String, o:Object, l:int, depth:int):void
		{
			if (_isEnabled)
			{
				if (!_isLoggingConnected) connectLogging();
				
				var p:Vector.<DataPackage> = compress(o);
				for (var i:int = 0; i < p.length; i++)
				{
					_loggingConnection.send("_alcon_logging", m, p[i], l, depth);
				}
			}
		}
		
		
		/**
		 * Sends the specified object to Alcon for a hexdump.
		 * @private
		 */
		protected static function sendHex(m:String, o:Object, l:int, s:int, e:int):void
		{
			if (_isEnabled)
			{
				if (!_isLoggingConnected) connectLogging();
				
				var p:Vector.<DataPackage> = compress(o);
				for (var i:int = 0; i < p.length; i++)
				{
					_loggingConnection.send("_alcon_logging", m, p[i], l, s, e);
				}
			}
		}
		
		/**
		 * compress
		 * @private
		 */
		protected static function compress(o:Object):Vector.<DataPackage>
		{
			var size:int = 0;
			var packages:Vector.<DataPackage> = new Vector.<DataPackage>();
			
			_byteArray.clear();
			_byteArray.writeObject(o);
			size = _byteArray.length;
			
			/* If data is smaller than max. package size, just send it like it is */
			if (_byteArray.length < MAX_PACKAGE_BYTES)
			{
				packages.push(new DataPackage(1, 1, _byteArray));
				return packages;
			}
			else
			{
				/* Compress data and check if it can go through */
				_byteArray.compress();
				if (_byteArray.length < MAX_PACKAGE_BYTES)
				{
					packages.push(new DataPackage(1, 1, _byteArray));
					return packages;
				}
				/* If data size is still too large, divide into smaller packages */
				else
				{
					/* Save the length */
					var bytesAvailable:int = _byteArray.length;
					var offset:int = 0;
					
					/* Calculate the total package count */
					var total:int = Math.ceil(_byteArray.length / MAX_PACKAGE_BYTES);
					
					/* Loop through the bytes / chunks */
					for (var i:int = 0; i < total; i++)
					{
						/* Set the length to read */
						var length:int = bytesAvailable;
						if (length > MAX_PACKAGE_BYTES)
						{
							length = MAX_PACKAGE_BYTES;
						}
						
						/* Read a chunk of data */
						var tmp:ByteArray = new ByteArray();
						tmp.writeBytes(_byteArray, offset, length);
						
						/* Create a data package */
						packages.push(new DataPackage(total, (i + 1), tmp));
						
						/* Update the bytes available and offset */
						bytesAvailable -= length;
						offset += length;
					}
					
					return packages;
				}
			}
		}
		
		
		/**
		 * connectLogging
		 * @private
		 */
		protected static function connectLogging():void
		{
			_isLoggingConnected = true;
			
			_loggingConnection = new LocalConnection();
			_loggingConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_loggingConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_loggingConnection.addEventListener(StatusEvent.STATUS, onStatus);
			
			_byteArray = new ByteArray();
		}

		
		/**
		 * connectMonitoring
		 * @private
		 */
		protected static function connectMonitoring():void
		{
			_isMonitorConnected = true;
			
			_monitorConnection = new LocalConnection();
			_monitorConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_monitorConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_monitorConnection.addEventListener(StatusEvent.STATUS, onStatus);
		}
		
		
		/**
		 * sendCapabilities
		 * @private
		 */
		protected static function sendCapabilities():void
		{
			var xml:XML = describeType(Capabilities);
			var a:Array = [];
			
			for each (var node:XML in xml.*)
			{
				var n:String = node.@name.toString();
				if (n.length > 0 && n != "_internal" && n != "prototype")
				{
					a.push({p: n, v: Capabilities[n].toString()});
				}
			}
			
			a.sortOn (["p"], Array.CASEINSENSITIVE);
			send("onCapabilitiesData", a);
		}
	}
}


// ------------------------------------------------------------------------------------------

import flash.utils.ByteArray;


class DataPackage
{
	public var t:int;
	public var n:int;
	public var b:ByteArray;
	
	public function DataPackage(t:int, n:int, b:ByteArray)
	{
		this.t = t;
		this.n = n;
		this.b = b;
	}
}
