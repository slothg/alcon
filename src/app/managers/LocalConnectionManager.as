/* * Alcon - ActionScript Logging & Debugging Console. * * Licensed under the MIT License * Copyright (c) 2009 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package managers{	import model.DataPackage;		import flash.net.LocalConnection;		
		/**	 * @author Sascha Balkau	 */	public class LocalConnectionManager	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				private static const LOGGING_CONNECTION_NAME:String = "_alcon_logging";		private static const MONITOR_CONNECTION_NAME:String = "_alcon_monitor";						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				private static var _instance:LocalConnectionManager;				private var _alconLoggingLC:LocalConnection;		private var _alconMonitorLC:LocalConnection;				private var _isLoggingConnected:Boolean = false;		private var _isMonitorConnected:Boolean = false;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new instance of the class.		 */		public function LocalConnectionManager()		{			if (_instance)			{				throw new Error("Tried to instantiate LocalConnectionManager through"					+ " it's constructor. Use LocalConnectionManager.instance instead!");			}		}						/**		 * Initializes LocalConnectionManager.		 */		public function init():void		{			connectLogging();			connectMonitoring();		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns the Singleton instance of LocalConnectionManager.		 */		public static function get instance():LocalConnectionManager		{			if (!_instance) _instance = new LocalConnectionManager();			return _instance;		}						////////////////////////////////////////////////////////////////////////////////////////		// Local Connection Handlers                                                          //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Receiver handler for monitoring data from Alcon's monitoring API.		 * @private		 * 		 * @param fps Frames per second		 * @param framerate Current framerate of the monitored application.		 * @param frt Frame render time		 * @param mem Memory consumption of the monitored application.		 */		public function onMonitorData(fps:int, framerate:int, frt:int, mem:int):void		{					}						/**		 * Receiver handler for app monitor markers.		 * @private		 * 		 * @param color The color value of the marker.		 */		public function onMarkerData(color:uint):void		{					}						/**		 * Receiver handler for capabilities data sent from Alcon.		 * @private		 * 		 * @param data An array with capabilities data.		 */		public function onCapabilitiesData(data:Array):void		{					}						/**		 * Receiver handler for logging data from Alcon's trace API.		 * @private		 * 		 * @param data The data to trace.		 * @param level The log level of the trace output.		 */		public function onTraceData(data:Vector.<DataPackage>, level:int):void		{					}						/**		 * Receiver handler for object tracing data from Alcon's trace API.		 * @private		 * 		 * @param obj The object to trace.		 * @param level The log level of the trace output.		 * @param depth The recursive depth with that to trace the object.		 */		public function onTraceObjData(obj:Object, level:int, depth:int):void		{					}						/**		 * Receiver handler for stopwatch data from Alcon's stopwatch API.		 * @private		 * 		 * @param title Title of the stopwatch.		 * @param startTimeKeys Array with start time keys.		 * @param stopTimeKeys Array with stop time keys.		 */		public function onStopWatchData(title:String,											startTimeKeys:Array,											stopTimeKeys:Array):void		{					}						/**		 * Receiver handler for hex dump data from Alcon's hexdump API.		 * @private		 * 		 * @param obj The object to hex dump.		 * @param level The log level of the hex dump output.		 * @param startPos The start position of the hex dump (byte).		 * @param endPos The end position of the hex dump (byte).		 */		public function onHexDumpData(obj:*, level:int, startPos:int, endPos:int):void		{					}						/**		 * Receiver handler for trace API commands like clear, pause, delimiter etc.		 * @private		 * 		 * @param cmd The command string.		 */		public function onTraceCommand(cmd:String):void		{			switch (cmd)			{				case "clear":					break;				case "delimiter":					break;				case "pause":					break;				case "timestamp":			}		}						/**		 * Receiver handler for object inspect data from Alcon's inspect API.		 * @private		 * 		 * @param obj The object to inspect.		 * @param depth The recursive depth with that to inspect the object.		 */		public function onInpectData(obj:*, depth:int):void		{					}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * connectLogging		 * @private		 */		private function connectLogging():void		{			if (!_isLoggingConnected)			{				_isLoggingConnected = true;								_alconLoggingLC = new LocalConnection();				_alconLoggingLC.allowDomain("*");				_alconLoggingLC.allowInsecureDomain("*");				_alconLoggingLC.client = this;								try				{					_alconLoggingLC.connect(LOGGING_CONNECTION_NAME);				}				catch (e:Error)				{					_isLoggingConnected = false;					// TODO Display error to user!				}			}		}						/**		 * connectMonitoring		 * @private		 */		private function connectMonitoring():void		{			if (!_isMonitorConnected)			{				_isMonitorConnected = true;								_alconMonitorLC = new LocalConnection();				_alconMonitorLC.allowDomain("*");				_alconMonitorLC.allowInsecureDomain("*");				_alconMonitorLC.client = this;								try				{					_alconMonitorLC.connect(MONITOR_CONNECTION_NAME);				}				catch (e:Error)				{					_isMonitorConnected = false;					// TODO Display error to user!				}			}		}	}}