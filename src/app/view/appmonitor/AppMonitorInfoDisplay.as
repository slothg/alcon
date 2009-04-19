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
package view.appmonitor
{
	import mx.containers.Form;
	import mx.containers.FormItem;
	import mx.containers.VBox;
	import mx.controls.Label;
	import mx.core.ScrollPolicy;

	
	/**
	 * AppMonitorInfoDisplay Class
	 * @author Sascha Balkau <sascha@hexagonstar.com>
	 */
	public class AppMonitorInfoDisplay extends VBox
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private var _fpsText:Label;
		private var _frtText:Label;
		private var _memText:Label;
		private var _capText:Label;
		private var _item3:FormItem;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new AppMonitorInfoDisplay instance.
		 */
		public function AppMonitorInfoDisplay()
		{
			super();
		}
		
		
		/**
		 * updateLocale
		 */
		public function updateLocale():void
		{
		}
		
		
		/**
		 * Initializes AppMonitorInfoDisplay.
		 */
		public function init():void
		{
			
		}
		
		
		/**
		 * update
		 */
		public function update():void
		{
		}
		
		
		/**
		 * tick
		 */
		public function tick(fps:int, framerate:int, frt:int, mem:int):void
		{
			_fpsText.text = fps + "/" + framerate;
			_frtText.text = frt + "ms";
			_memText.text = bytesToString(mem);
		}
		
		
		/**
		 * resize
		 */
		public function resize():void
		{
		}
		
		
		/**
		 * reset
		 */
		public function reset():void
		{
			_fpsText.text = "-----";
			_frtText.text = "-----";
			_memText.text = "-----";
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * createChildren
		 * @private
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			width = 110;
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
			
			_capText = new Label();
			_capText.styleName = "appMonitorCapText";
			_capText.selectable = false;
			_capText.percentWidth = 100;
			_capText.text = " ";
			addChild(_capText);
			
			var item1:FormItem = new FormItem();
			item1.percentWidth = 100;
			item1.label = "FPS:";
			item1.styleName = "appMonitorFPSText";
			item1.toolTip = "Frames Per Second. How many frames were rendered within one second. Higher is better.";
			_fpsText = new Label();
			_fpsText.percentWidth = 100;
			item1.addChild(_fpsText);
			
			var item2:FormItem = new FormItem();
			item2.percentWidth = 100;
			item2.label = "FRT:";
			item2.styleName = "appMonitorFRTText";
			item2.toolTip = "Frame Render Time. The time it takes to render a frame. Lower is better.";
			_frtText = new Label();
			_frtText.percentWidth = 100;
			item2.addChild(_frtText);
			
			_item3 = new FormItem();
			_item3.percentWidth = 100;
			_item3.label = "MEM:";
			_item3.styleName = "appMonitorMemText";
			_item3.toolTip = "Memory Consumption.";
			_memText = new Label();
			_memText.percentWidth = 100;
			_item3.addChild(_memText);
			
			var form:Form = new Form();
			form.styleName = "appMonitorInfoDisplayForm";
			form.percentWidth = 100;
			addChild(form);
			
			form.addChild(item1);
			form.addChild(item2);
			form.addChild(_item3);
		}
		
		
		/**
		 * bytesToString
		 */
		private function bytesToString(bytes:int):String
		{
			var r:String;
			if (bytes < 0x0400)
			{
				r = (String(bytes) + "b");
			}
			else 
			{
				if (bytes < 0x2800)
				{
					r = (Number((bytes / 0x0400)).toFixed(2) + "kb");
				}
				else 
				{
					if (bytes < 102400)
					{
						r = (Number((bytes / 0x0400)).toFixed(1) + "kb");
					}
					else 
					{
						if (bytes < 0x100000)
						{
							r = ((bytes >> 10) + "kb");
						}
						 else 
						{
							if (bytes < 0xA00000)
							{
								r = (Number((bytes / 0x100000)).toFixed(2) + "mb");
							}
							 else 
							{
								if (bytes < 104857600)
								{
									r = (Number((bytes / 0x100000)).toFixed(1) + "mb");
								}
								else 
								{
									r = ((bytes >> 20) + "mb");
								}
							}
						}
					}
				}
			}
			return r;
		}
	}
}
