package managers
{
	import flash.net.SharedObject;
	
		/**
	 * This is a singleton class that manages LocalSharedObject settings.
	 * It also works as a registry of settings objects names. 
	 * 
	 * @author Sascha Balkau
	 */
	public class SettingsManager
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/* Add any keys for settings stored in the Local Shared Object here as
		 * public static constants. These act as the settings key registry. */
		
		public static const DATA_PATH:String = "dataPath";
		public static const WINDOW_POSITION:String = "winPos";
		public static const WINDOW_SIZE:String = "winSize";
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private static var _instance:SettingsManager;
		private var _so:SharedObject;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new SettingsManager instance.
		 */
		public function SettingsManager()
		{
			if (_instance != null)
			{
				throw new Error("Tried to instantiate SettingsManager through"
					+ " it's constructor. Use SettingsManager.instance instead!");
			}
			
			_so = SharedObject.getLocal("localSettings");	
		}
		
		
		/**
		 * Get the given setting value from the LocalSharedObject.
		 */
		public function getSetting(key:String):Object
		{
			return _so.data[key];
		}
		
		
		/**
		 * Set and save the given setting.
		 */
		public function setSetting(key:String, value:Object):void
		{
			_so.data[key] = value;
			_so.flush();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public static function get instance():SettingsManager
		{
			if (!_instance) _instance = new SettingsManager();
			return _instance;
		}
	}
}
