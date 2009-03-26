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
package view.components
{
	import managers.SettingsManager;
	
	import mx.controls.Image;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;		

	
	/**
	 * AppMonitorGraph Class
	 * @author Sascha Balkau <sascha@hexagonstar.com>
	 */
	public class AppMonitorGraph extends Image
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private var _graph:BitmapData;
		private var _bitmap:Bitmap;
		private var _rectangle:Rectangle;
		private var _width:int;
		private var _graphWidth:int;
		private var _ticks:int;
		private var _maxMemory:Number;
		private var _isSetMarker:Boolean;
		private var _markerColor:uint;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new AppMonitorGraph instance.
		 */
		public function AppMonitorGraph()
		{
			super();
		}
		
		
		/**
		 * Initializes AppMonitorGraph.
		 */
		public function init():void
		{
			_width = width - 5;
			_ticks = 0;
			_isSetMarker = false;
			_rectangle = new Rectangle(0, 0, 1, height);
		}
		
		
		/**
		 * update
		 */
		public function update():void
		{
			// TODO
			//_maxMemory = SettingsManager.instance.getSetting(SettingsManager.MAX_GRAPH_MEM);
			_maxMemory = 128000000;
		}

		
		/**
		 * resize
		 */
		public function resize():void
		{
			_width = width - 5;
			resetTickWidth();
			_bitmap.width = _width;
		}
		
		
		/**
		 * reset
		 */
		public function reset():void
		{
			if (_graph)
			{
				_graph.dispose();
				removeChild(_bitmap);
			}
			
			resetTickWidth();
			
			_graph = new BitmapData(_graphWidth, height, true, 0xFF222222);
			_bitmap = new Bitmap(_graph);
			addChild(_bitmap);
			
			resize();
			update();
		}
		
		
		/**
		 * tick
		 */
		public function tick(fps:int, framerate:int, frt:int, mem:int):void
		{
			var c:uint = 0xFF222222;
			var p:Number = fps > framerate ? 1 : (fps / framerate);
			var m:Number = (mem / _maxMemory);
			var f:int = frt >> 1;
			
			if (f > height) f = height;
			else if (f < 1) f = 1;
			
			/* Draw a vertical grid line every x ticks */
			if (_ticks == 19)
			{
				_ticks = 0;
				c = 0xFF282828;
			}
			
			if (_isSetMarker)
			{
				_isSetMarker = false;
				c = Number("0x66" + _markerColor.toString(16));
			}
			
			_graph.scroll(1, 0);
			_graph.fillRect(_rectangle, c);
			_graph.setPixel32(0, (height * (1 - p)), 0xFFCCCCCC);
			_graph.setPixel32(0, (height - f), 0xFF55D4FF);
			_graph.setPixel32(0, (height * (1 - m)), 0xFFCCCC00);
			
			++_ticks;
		}
		
		
		/**
		 * mark
		 */
		public function mark(color:uint):void
		{
			_markerColor = color;
			_isSetMarker = true;
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
			
			percentWidth = 100;
			percentHeight = 100;
		}
		
		
		/**
		 * resetTickWidth
		 * @private
		 */
		private function resetTickWidth():void
		{
			_graphWidth = _width;// / 2;
		}
	}
}
