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
	import flash.utils.getTimer;
	
	/**
	 * Stopwatch can be used to stop the time.
	 * 
	 * Instantiate this class as follows:
	 * <p><pre>
	 *     import com.hexagonstar.util.StopWatch;
	 *     var stopWatch:StopWatch = new StopWatch();
	 * </pre>
	 * 
	 * This will create a still standing stopwatch. You can start and stop the
	 * stopwatch to record time as you please:
	 * <p><pre>
	 *     stopWatch.start();
	 *     // Do something
	 *     stopWatch.stop();
	 * </pre>
	 * 
	 * The recored time is available in milliseconds and seconds.
	 * <p><pre>
	 *     Debug.trace(stopWatch.getTimeInMilliSeconds() + " ms");
	 *     Debug.trace(stopWatch.getTimeInSeconds() + " s");
	 * </pre>
	 */
	public class StopWatch
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private var _started:Boolean = false;
		private var _startTimeKeys:Array;
		private var _stopTimeKeys:Array;
		private var _title:String;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/** 
		 * Constructs a new StopWatch instance.
		 */
		public function StopWatch()
		{
			reset();
		}
		
		
		/**
		 * Starts the time recording process.
		 * 
		 * @param title An optional title for the Stopwatch.
		 */
		public function start(title:String = ""):void
		{
			if (!_started)
			{
				_title = title;
				_started = true;
				_startTimeKeys.push(getTimer());
			}
		}
		
		
		/**
		 * Stops the time recording process if the process has been started before.
		 */
		public function stop():void
		{
			if (_started)
			{
				var stopTime:int = getTimer();
				_stopTimeKeys[_startTimeKeys.length - 1] = stopTime;
				_started = false;
			}
		}
		
		
		/**
		 * Resets the Stopwatch total running time.
		 */
		public function reset():void
		{
			_startTimeKeys = [];
			_stopTimeKeys = [];
			_started = false;
		}
		
		
		/**
		 * Generates a string representation of the Stopwatch that includes
		 * all start and stop times in milliseconds.
		 * 
		 * @return the string representation of the Stopwatch.
		 */
		public function toString():String
		{
			var s:String = "\n ********************* [STOPWATCH] *********************";
			if (_title != "") s += "\n * " + _title;
			
			for (var i:int = 0; i < _startTimeKeys.length; i++)
			{
				var s1:int = _startTimeKeys[i];
				var s2:int = _stopTimeKeys[i];
				s += "\n * started ["
					+ format(s1) + "ms] stopped ["
					+ format(s2) + "ms] time ["
					+ format(s2 - s1) + "ms]";
			}
			
			if (i == 0) s += "\n * never started.";
			else s += "\n * total runnning time: " + timeInSeconds + "s";
			
			s += "\n *******************************************************";
			return s;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Returns whether the Stopwatch has been started or not.
		 */
		public function get started():Boolean
		{
			return _started;
		}
		
		
		/**
		 * Calculates and returns the elapsed time in milliseconds. The Stopwatch
		 * will not be stopped by calling this method. If the Stopwatch
		 * is still running it takes the current time as stoptime for the result.
		 */
		public function get timeInMilliSeconds():int
		{
			if (_started)
			{
				_stopTimeKeys[_startTimeKeys.length - 1] = getTimer();
			}
			var r:int = 0;
			for (var i:int = 0; i < _startTimeKeys.length; i++)
			{
				r += (_stopTimeKeys[i] - _startTimeKeys[i]);
			}
			return r;		
		}
		
		
		/**
		 * Calculates and returns the elapsed time in seconds. The Stopwatch
		 * will not be stopped by calling this method. If the Stopwatch is still
		 * running it takes the current time as stoptime for the result.
		 */
		public function get timeInSeconds():Number
		{
			return timeInMilliSeconds / 1000;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Formats a value for toString Output.
		 * 
		 * @private
		 */
		private function format(v:int):String
		{
			var s:String = "";
			var l:int = v.toString().length;
			for (var i:int = 0; i < (5 - l); i++)
			{
				s += "0";
			}
			return s + v;
		}
	}
}
