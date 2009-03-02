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
package commands
{
	import io.LocaleLoader;
	
	import com.hexagonstar.env.command.Command;
	import com.hexagonstar.env.command.ICommandListener;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	
	/**
	 * LoadLocaleCommand Class
	 * @author Sascha Balkau
	 */
	public class LoadLocaleCommand extends Command
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private var _loader:LocaleLoader;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new LoadLocaleCommand instance.
		 */
		public function LoadLocaleCommand(listener:ICommandListener)
		{
			super(listener);
		}
		
		
		/**
		 * Execute the command.
		 */ 
		override public function execute():void
		{
			super.execute();
			
			_loader = new LocaleLoader();
			_loader.addEventListener(Event.COMPLETE, onComplete);
			_loader.addEventListener(ErrorEvent.ERROR, onError);
			_loader.load();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		override public function get name():String
		{
			return "loadLocale";
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private function onComplete(e:Event):void
		{
			complete();
		}
		
		
		/**
		 * @private
		 */
		private function onError(e:ErrorEvent):void
		{
			notifyError(e.text);
			complete();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * finish
		 * @private
		 */
		override protected function complete():void
		{
			_loader.removeEventListener(Event.COMPLETE, onComplete);
			_loader.removeEventListener(ErrorEvent.ERROR, onError);
			_loader.dispose();
			_loader = null;
			
			super.complete();
		}
	}
}
