/* * Alcon - ActionScript Logging & Debugging Console. * * Licensed under the MIT License * Copyright (c) 2009 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package view{	import managers.ViewActionsManager;
	
	import com.hexagonstar.display.StageReference;
	import com.hexagonstar.util.debug.Debug;
	
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.Stage;
	import flash.events.Event;	
	
	/**	 * MainMenu Class	 * @author Sascha Balkau <sascha@hexagonstar.com>	 */	public class MainMenu	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				private static var _instance:MainMenu;				private var _stage:Stage;		private var _viewActionsManager:ViewActionsManager;		private var _nativeMenu:NativeMenu;				private var _fileMenu:NativeMenuItem;		private var _editMenu:NativeMenuItem;		private var _viewMenu:NativeMenuItem;		private var _helpMenu:NativeMenuItem;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new MainMenu instance.		 */		public function MainMenu()		{			if (_instance)			{				throw new Error("Tried to instantiate MainMenu through"					+ " it's constructor. Use MainMenu.instance instead!");			}						_stage = StageReference.stage;			createChildren();		}				/**		 * init		 */		public function init():void		{			//callLater(setToggledMenuItems);		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns the Singleton instance of MainMenu.		 */		public static function get instance():MainMenu		{			if (!_instance) _instance = new MainMenu();			return _instance;		}						public function get enabled():Boolean		{			return _fileMenu.enabled;		}		public function set enabled(v:Boolean):void		{			_fileMenu.enabled = v;			_editMenu.enabled = v;			_viewMenu.enabled = v;			_helpMenu.enabled = v;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		private function onMenuSelect(e:Event):void		{			if (e.currentTarget["parent"])			{				var item:NativeMenuItem = findItemForMenu(e.currentTarget as NativeMenu);				if (item)				{					Debug.trace("Select event for \"" + e.target["label"]						+ "\" command handled by menu: " + item.label); 				}			}			else			{				Debug.trace("Select event for \"" + e.target["label"]					+ "\" command handled by root menu.");			}		}						/**		 * @private		 */		private function onItemSelect(e:Event):void		{			var name:String = (e.target as NativeMenuItem).name;			Debug.trace(name);						switch (name)			{				case "about":					_viewActionsManager.showAboutDialog();					break;				default:					_viewActionsManager.showErrorDialog(						"Menu item '" + name + "' has not yet been implemented!");			}		}				////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * createChildren		 * @private		 */		private function createChildren():void		{			_viewActionsManager = ViewActionsManager.instance;						_nativeMenu = new NativeMenu();			_nativeMenu.addEventListener(Event.SELECT, onMenuSelect);						if (NativeWindow.supportsMenu)			{				_stage.nativeWindow.menu = _nativeMenu;			}			else if (NativeApplication.supportsMenu)			{				NativeApplication.nativeApplication.menu = _nativeMenu;			}						var m1:NativeMenu = new NativeMenu();			m1.addEventListener(Event.SELECT, onMenuSelect);			m1.addItem(createMenuItem("saveAs", "Save As...", "s"));			m1.addItem(createMenuItem());			m1.addItem(createMenuItem("pause", "Pause", "p"));			m1.addItem(createMenuItem("clear", "Clear", "e"));			m1.addItem(createMenuItem("reset", "Reset", "r"));			m1.addItem(createMenuItem());			m1.addItem(createMenuItem("options", "Options...", "O"));			m1.addItem(createMenuItem());			m1.addItem(createMenuItem("exit", "Exit", "q"));						_fileMenu = _nativeMenu.addItem(new NativeMenuItem("File"));			_fileMenu.submenu = m1;						var m2:NativeMenu = new NativeMenu();			m2.addEventListener(Event.SELECT, onMenuSelect);			m2.addItem(createMenuItem("copyOutput", "Copy output", "g"));			m2.addItem(createMenuItem("copyOutputAsHTML", "Copy output as HTML", "G"));						_editMenu = _nativeMenu.addItem(new NativeMenuItem("Edit"));			_editMenu.submenu = m2;						var m3:NativeMenu = new NativeMenu();			m3.addEventListener(Event.SELECT, onMenuSelect);			// TODO this item should go into logger context menu!			m3.addItem(createMenuItem("displayKeywords", "Display Keywords", "k"));			m3.addItem(createMenuItem());			m3.addItem(createMenuItem("toggleAppMonitor", "App Monitor", "A"));			m3.addItem(createMenuItem("toggleLogger", "Logger", "L"));			m3.addItem(createMenuItem("toggleObjectInspector", "Inspector", "I"));			m3.addItem(createMenuItem("toggleAPIBrowser", "API Browser", "B"));			m3.addItem(createMenuItem("toggleInputBar", "Input Bar", "F"));			m3.addItem(createMenuItem());			m3.addItem(createMenuItem("stayOnTop", "Stay on top", "t"));						_viewMenu = _nativeMenu.addItem(new NativeMenuItem("View"));			_viewMenu.submenu = m3;						var m4:NativeMenu = new NativeMenu();			m4.addEventListener(Event.SELECT, onMenuSelect);			m4.addItem(createMenuItem("help", "Help...", "H"));			m4.addItem(createMenuItem("about", "About..."));						_helpMenu = _nativeMenu.addItem(new NativeMenuItem("Help"));			_helpMenu.submenu = m4;		}						/**		 * createMenuItem		 * @private		 */		private function createMenuItem(name:String = null,											label:String = null,											key:String = null):NativeMenuItem		{			var item:NativeMenuItem;						if (name && label)			{				item = new NativeMenuItem(label, false);				item.name = name;				if (key) item.keyEquivalent = key;				item.addEventListener(Event.SELECT, onItemSelect);			}			else			{				item = new NativeMenuItem("", true);			}						return item;		}				/**		 * @private		 */		private function findItemForMenu(menu:NativeMenu):NativeMenuItem		{			for each (var item:NativeMenuItem in menu.parent.items)			{				if (item)				{					if (item.submenu == menu) return item;				}			}			return null;		}						/**		 * @private		 */		private function setToggledMenuItems():void		{		}	}}