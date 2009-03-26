/* * Alcon - ActionScript Logging & Debugging Console. * * Licensed under the MIT License * Copyright (c) 2009 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package {	import commands.CommandInvoker;	import commands.env.CloseApplicationCommand;	import commands.env.InitApplicationCommand;		import managers.CommandManager;	import managers.WindowBoundsManager;		import util.Log;		import view.ApplicationUI;		import com.hexagonstar.display.StageReference;	import com.hexagonstar.env.command.ICommandListener;	import com.hexagonstar.env.console.CLICommand;	import com.hexagonstar.env.event.CommandCompleteEvent;	import com.hexagonstar.env.event.CommandErrorEvent;	import com.hexagonstar.env.event.CommandProgressEvent;		import mx.core.Application;		import flash.desktop.NativeApplication;	import flash.events.Event;	import flash.events.EventDispatcher;			/** 	 * An event indicating that the application is ready for	 * user interaction after initialization steps are done.	 */	[Event(name="applicationInitialized", type="flash.events.Event")]			/**	 * The central class, or 'Mediator' of the application.	 * @author Sascha Balkau	 */	public class Main extends EventDispatcher implements ICommandListener	{		////////////////////////////////////////////////////////////////////////////////////////		// Constants                                                                          //		////////////////////////////////////////////////////////////////////////////////////////				public static const APPLICATION_INITIALIZED:String = "applicationInitialized";						////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				private static var _instance:Main;				private var _app:Application;		private var _appInfo:AppInfo;		private var _ui:ApplicationUI;		private var _commandManager:CommandManager;		private var _commandInvoker:CommandInvoker;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new instance of Main. As Main is a Singleton it is required		 * to use the instance getter instead of direct instantiation.		 */		public function Main()		{			if (_instance)			{				throw new Error("Tried to instantiate Main through"					+ " it's constructor. Use Main.instance instead!");			}		}						/**		 * Invokes the application's (user-defined) initialization process.		 * @private		 */		public function init():void		{			_commandManager = CommandManager.instance;			_commandManager.execute(new InitApplicationCommand(this));		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				public static function get instance():Main		{			if (!_instance) _instance = new Main();			return _instance;		}						public function get app():Application		{			return _app;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Invoked by App after the application has finished loading.		 * 		 * @param app a reference to the application class.		 */		public function onApplicationLoaded(app:Application):void		{			_app = app;			_app.callLater(preInit);		}						/**		 * Invoked whenever the ApplicationInitCommand dispatches a progress event.		 * @private		 */		public function onCommandProgress(e:CommandProgressEvent):void		{			Log.debug("ApplicationInitProgress #" + e.progress + ": "  + e.progressMessage);		}						/**		 * Invoked if the ApplicationInitCommand dispatches an error event.		 * @private		 */		public function onCommandError(e:CommandErrorEvent):void		{			Log.error("ApplicationInitError: " + e.text);		}						/**		 * Invoked when the ApplicationInitCommand dispatches a complete event.		 * @private		 */		public function onCommandComplete(e:CommandCompleteEvent):void		{			Log.debug("ApplicationInitComplete.");						Application.application["visible"] = true;			_app.stage.nativeWindow.activate();						/* Dispatch event to signal that the app is ready */			dispatchEvent(new Event(APPLICATION_INITIALIZED));		}						/**		 * @private		 */		private function onApplicationClosing(e:Event):void		{			e.preventDefault();			var cmd:CloseApplicationCommand = new CloseApplicationCommand(null);			cmd.execute();		}						/**		 * @private		 */		private function onApplicationClose(e:Event):void		{			NativeApplication.nativeApplication.exit();		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Executes tasks that need to be done before the init process is executed.		 * This usually includes creating the application's user interface. This method		 * should only need to be called once at application start.		 * @private		 */		private function preInit():void		{			StageReference.stage = _app.stage;						/* set this to false, when we close the application we first do an update. */			NativeApplication.nativeApplication.autoExit = false;						/* recall app window bounds */			WindowBoundsManager.instance.init(_app.stage.nativeWindow);						_ui = new ApplicationUI();			_app.addChild(_ui);						/* TODO Command creation should go somewhere else! */			var cmd1:CLICommand = new CLICommand();			cmd1.command = "appInit";			cmd1.help = "Initializes the application.";			cmd1.handler = "appInit";			var cmd2:CLICommand = new CLICommand();			cmd2.command = "appInfo";			cmd2.help = "Displays application information string.";			cmd2.handler = "appInfo";						_commandInvoker = new CommandInvoker();						/* We listen to CLOSING from both the stage and the UI. If the user closes the			 * app through the taskbar, Event.CLOSING is emitted from the stage. Otherwise,			 * it could be emitted from TitleBarConrols. */			_ui.addEventListener(Event.CLOSING, onApplicationClosing);			_app.stage.nativeWindow.addEventListener(Event.CLOSING, onApplicationClosing);			_app.stage.nativeWindow.addEventListener(Event.CLOSE, onApplicationClose);						init();		}
	}}