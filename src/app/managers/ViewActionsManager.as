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
	import view.dialogs.AboutDialog;

	 * @author Sascha Balkau
	 */
	public class ViewActionsManager
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private static var _instance:ViewActionsManager;
		
		private var _app:Application;

		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new instance of the class.
		 */
		public function ViewActionsManager()
		{
			if (_instance)
			{
				throw new Error("Tried to instantiate ViewActionsManager through"
					+ " it's constructor. Use ViewActionsManager.instance instead!");
			}
		}
		
		
		/**
		 * Initializes ViewActionsManager.
		 */
		public function init():void
		{
			_app = Main.instance.app;
		}

		
		/**
		 * showAboutDialog
		 */
		public function showAboutDialog():void
		{
			PopUpManager.createPopUp(DisplayObject(_app), AboutDialog, true);
		}
		
		
		/**
		 * showErrorDialog
		 */
		public function showErrorDialog(msg:String, title:String = ""):void
		{
			var dialog:ErrorDialog = ErrorDialog(PopUpManager.createPopUp(DisplayObject(_app),
				ErrorDialog, true));
			if (title != "") dialog.messageTitle = title;
			dialog.messageText = msg;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Returns the Singleton instance of ViewActionsManager.
		 */
		public static function get instance():ViewActionsManager
		{
			if (!_instance) _instance = new ViewActionsManager();
			return _instance;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
	}
}