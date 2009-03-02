/* * Alcon - ActionScript Logging & Debugging Console. * * Licensed under the MIT License * Copyright (c) 2009 Sascha Balkau / Hexagon Star Softworks *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package view{	import view.panels.APIBrowser;	import view.panels.HelpPanel;	import view.panels.Inspector;	import view.panels.Logger;		import mx.containers.TabNavigator;	import mx.core.ScrollPolicy;			/**	 * TabNav Class	 * @author Sascha Balkau <sascha@hexagonstar.com>	 */	public class TabNav extends TabNavigator	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				private var _logger:Logger;		private var _inspector:Inspector;		private var _apiBrowser:APIBrowser;		private var _helpPanel:HelpPanel;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new TabNav instance.		 */		public function TabNav()		{			super();		}						/**		 * init		 */		public function init():void		{		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * createChildren		 * @private		 */		override protected function createChildren():void		{			super.createChildren();						percentWidth = 100;			percentHeight = 100;			horizontalScrollPolicy = ScrollPolicy.OFF;			verticalScrollPolicy = ScrollPolicy.OFF;						_logger = new Logger();			addChild(_logger);						_inspector = new Inspector();			addChild(_inspector);						_apiBrowser = new APIBrowser();			addChild(_apiBrowser);						_helpPanel = new HelpPanel();			addChild(_helpPanel);		}	}}