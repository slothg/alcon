package managers{	import flash.display.NativeWindow;	import flash.display.Screen;	import flash.events.NativeWindowBoundsEvent;	import flash.geom.Point;			/**	 * @author Sascha Balkau	 */	public class WindowBoundsManager	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////				private static var _instance:WindowBoundsManager;				private var _settingsManager:SettingsManager;		private var _window:NativeWindow;		private var _isInitialized:Boolean;						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new instance of the class.		 */		public function WindowBoundsManager()		{			if (_instance)			{				throw new Error("Tried to instantiate WindowBoundsManager through"					+ " it's constructor. Use WindowBoundsManager.instance instead!");			}						_settingsManager = SettingsManager.instance;			_isInitialized = false;		}						/**		 * Init the manager for the given window.		 */		public function init(window:NativeWindow):void		{			if (!_isInitialized)			{				_isInitialized = true;				_window = window;								var maxWinSize:Point = getMaxWinSize();				var lastPos:Object = _settingsManager.getSetting(SettingsManager.WINDOW_POSITION);				var lastSize:Object = _settingsManager.getSetting(SettingsManager.WINDOW_SIZE);								if (lastPos)				{					_window.x = lastPos["x"];					_window.y = lastPos["y"];				}								if (lastSize)				{					_window.width = lastSize["x"];					_window.height = lastSize["y"];				}								_window.addEventListener(NativeWindowBoundsEvent.RESIZE, onWindowResize);				_window.addEventListener(NativeWindowBoundsEvent.MOVE, onWindowMove);			}		}						/**		 * Save the window position when the application closes.		 */		public function saveWindowPosition():void		{			var winPos:Point = _window.bounds.topLeft;			var winSize:Point = new Point();			winSize.x = _window.bounds.bottomRight.x - winPos.x;			winSize.y = _window.bounds.bottomRight.y - winPos.y;			_settingsManager.setSetting(SettingsManager.WINDOW_POSITION, winPos);			_settingsManager.setSetting(SettingsManager.WINDOW_SIZE, winSize);		}						/**		 * Check the position of the window, ensuring that its onscreen.		 * (Does nothing at the moment).		 */		public function ensureWindowOnscreen():void		{		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Returns the Singleton instance of WindowBoundsManager.		 */		public static function get instance():WindowBoundsManager		{			if (!_instance) _instance = new WindowBoundsManager();			return _instance;		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		private function onWindowResize(e:NativeWindowBoundsEvent = null):void		{			ensureWindowOnscreen();		}						/**		 * @private		 */		private function onWindowMove(e:NativeWindowBoundsEvent):void		{			ensureWindowOnscreen();		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Helper function to get the maximum window position, as best we can.		 */ 		private function getMaxWinSize():Point		{			var screen:Screen = Screen.getScreensForRectangle(_window.bounds)[0] as Screen;			return screen.visibleBounds.bottomRight;		}	}}