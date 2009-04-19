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
package commands.env
{
	import commands.file.LoadConfigCommand;
	import commands.file.LoadLocaleCommand;
	import model.Config;
	import com.hexagonstar.env.command.CompositeCommand;
	import com.hexagonstar.env.command.ICommandListener;
	import com.hexagonstar.env.event.CommandCompleteEvent;
	import com.hexagonstar.env.event.CommandErrorEvent;
	import flash.events.ErrorEvent;
			/**
	 * This composite command is used to manage initialization of the application.
	 * 
	 * The following tasks are taken care of by this command in order:
	 * 1. Load App Config
	 * 2. Load Locale
	 * 3. Check for Update if startup check is enabled
	 * 4. Init KeyManager
	 * 
	 * @author Sascha Balkau
	 */
	public class InitApplicationCommand extends CompositeCommand
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private var _cmd1:LoadConfigCommand;
		private var _cmd2:LoadLocaleCommand;
		private var _cmd3:CheckUpdateCommand;
		private var _cmd4:InitKeyManagerCommand;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new InitApplicationCommand instance.
		 */
		public function InitApplicationCommand(listener:ICommandListener)
		{
			super(listener);
		}
		
		
		/**
		 * Execute the application initialization command.
		 */ 
		override public function execute():void
		{
			super.execute();
			execute1();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		override public function get name():String
		{
			return "appInit";
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		override public function onCommandComplete(e:CommandCompleteEvent):void
		{
			next();
		}
		
		
		/**
		 * @private
		 */
		override public function onCommandError(e:CommandErrorEvent):void
		{
			notifyError(e.text);
			next();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * next
		 * @private
		 */
		private function next():void
		{
			switch (_progress)
			{
				case 0:
					setEarlySettings();
					notifyProgress("Config file loading complete.");
					execute2();
					break;
				case 1:
					notifyProgress("Locale loading complete.");
					execute3();
					break;
				case 2:
					notifyProgress("Update checking done.");
					execute4();
					break;
				case 3:
					notifyProgress("KeyManager initialization complete.");
					complete();
			}
		}
		
		
		/**
		 * @private
		 */
		private function execute1():void
		{
			_cmd1 = new LoadConfigCommand(this);
			_cmd1.addEventListener(CommandCompleteEvent.COMPLETE, onCommandComplete);
			_cmd1.addEventListener(ErrorEvent.ERROR, onCommandError);
			_cmd1.execute();
		}
		
		
		/**
		 * @private
		 */
		private function execute2():void
		{
			_cmd2 = new LoadLocaleCommand(this);
			_cmd2.addEventListener(CommandCompleteEvent.COMPLETE, onCommandComplete);
			_cmd2.addEventListener(ErrorEvent.ERROR, onCommandError);
			_cmd2.execute();
		}
		
		
		/**
		 * @private
		 */
		private function execute3():void
		{
			_cmd3 = new CheckUpdateCommand(this);
			_cmd3.addEventListener(CommandCompleteEvent.COMPLETE, onCommandComplete);
			_cmd3.addEventListener(ErrorEvent.ERROR, onCommandError);
			_cmd3.execute();
		}
		
		
		/**
		 * @private
		 */
		private function execute4():void
		{
			_cmd4 = new InitKeyManagerCommand(this);
			_cmd4.addEventListener(CommandCompleteEvent.COMPLETE, onCommandComplete);
			_cmd4.addEventListener(ErrorEvent.ERROR, onCommandError);
			_cmd4.execute();
		}
		
		
		/**
		 * Sets config properties that should be available as soon as possible.
		 * @private
		 */
		private function setEarlySettings():void
		{
			var config:Config = Main.config;
			
			/* Set the default locale as the currently used locale. */
			config.currentLocale = config.defaultLocale.toLocaleLowerCase();
		}

		
		/**
		 * @private
		 */
		override protected function complete():void
		{
			_cmd1.removeEventListener(CommandCompleteEvent.COMPLETE, onCommandComplete);
			_cmd1.removeEventListener(ErrorEvent.ERROR, onCommandError);
			_cmd1.dispose();
			_cmd1 = null;
			
			_cmd2.removeEventListener(CommandCompleteEvent.COMPLETE, onCommandComplete);
			_cmd2.removeEventListener(ErrorEvent.ERROR, onCommandError);
			_cmd2.dispose();
			_cmd2 = null;
			
			_cmd3.removeEventListener(CommandCompleteEvent.COMPLETE, onCommandComplete);
			_cmd3.removeEventListener(ErrorEvent.ERROR, onCommandError);
			_cmd3.dispose();
			_cmd3 = null;
			
			_cmd4.removeEventListener(CommandCompleteEvent.COMPLETE, onCommandComplete);
			_cmd4.removeEventListener(ErrorEvent.ERROR, onCommandError);
			_cmd4.dispose();
			_cmd4 = null;
			
			super.complete();
		}
	}
}
