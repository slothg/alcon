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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;	

	
	/**
	 * FPSMeter can be used to measure the application's framerate and
	 * frame render time. This class can be used on it's own to fetch
	 * fps/frt information or it is used by the Debug class when calling
	 * Debug.monitor().
	 */
	public class FPSMeter extends EventDispatcher
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * The FPSMeter.FPS_UPDATE constant defines the value of the type property
		 * of an fpsUpdate event object.
		 */
		public static const FPS_UPDATE:String = "fpsUpdate";
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		protected var _stage:Stage;
		protected var _timer:Timer;
		protected var _pollInterval:int;
		protected var _fps:int;
		protected var _frt:int;
		protected var _ms:int;
		protected var _isRunning:Boolean;
		
		protected var _delay:int;
		protected var _delayMax:int = 10;
		protected var _prev:int;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructs a new FPSMeter instance.
		 * 
		 * @param stage The Stage object for that the FPS is being measured.
		 * @param pollInterval Interval in milliseconds with that the FPS rate is polled.
		 */
		public function FPSMeter(stage:Stage, pollInterval:int = 50)
		{
			_stage = stage;
			_pollInterval = pollInterval;
			reset();
		}
		
		
		/**
		 * Starts FPS/FRT polling.
		 */
		public function start():void
		{
			if (!_isRunning)
			{
				_isRunning = true;
				_timer = new Timer(_pollInterval, 0);
				_timer.addEventListener(TimerEvent.TIMER, onTimer);
				_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				_timer.start();
			}
		}
		
		
		/**
		 * Stops FPS/FRT polling.
		 */
		public function stop():void
		{
			if (_isRunning)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				_stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_timer = null;
				reset();
			}
		}
		
		
		/**
		 * Resets the FPSMeter to it's default state.
		 */
		public function reset():void
		{
			_fps = 0;
			_frt = 0;
			_ms = 0;
			_delay = 0;
			_prev = 0;
			_isRunning = false;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Returns the current FPS.
		 * 
		 * @return The currently polled frames per second.
		 */
		public function get fps():int
		{
			return _fps;
		}
		
		
		/**
		 * Returns the time that the current frame needed to render.
		 * 
		 * @return The time in milliseconds that the current frame needed to render.
		 */
		public function get frt():int
		{
			return _frt;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Called on every Timer event.
		 * @private
		 */
		protected function onTimer(e:TimerEvent):void
		{
			dispatchEvent(new Event(FPSMeter.FPS_UPDATE));
		}
		
		
		/**
		 * Called on every EnterFrame event.
		 * @private
		 */
		protected function onEnterFrame(e:Event):void
		{
			var t:Number = getTimer();
			_delay++;
			
			if (_delay >= _delayMax)
			{
				_delay = 0;
				_fps = int((1000 * _delayMax) / (t - _prev));
				_prev = t;
			}
			
			_frt = t - _ms;
			_ms = t;
		}
	}
}
