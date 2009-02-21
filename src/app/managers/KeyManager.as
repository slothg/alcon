package managers
{
	import com.hexagonstar.env.event.KeyCombinationEvent;
	import com.hexagonstar.io.key.Key;
	import com.hexagonstar.io.key.KeyCombination;
	
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	
	/**
	 * Manages Keyboard Input.
	 * 
	 * @author Sascha Balkau
	 */
	public class KeyManager
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private static var _instance:KeyManager;
		private var _key:Key;
		
		private var _assignmentsDown:Dictionary;
		private var _assignmentsRelease:Dictionary;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new instance of the class.
		 */
		public function KeyManager()
		{
			if (_instance)
			{
				throw new Error("Tried to instantiate KeyManager through"
					+ " it's constructor. Use KeyManager.instance instead!");
			}
			
			_assignmentsDown = new Dictionary();
			_assignmentsRelease = new Dictionary();
			
			_key = Key.instance;
			_key.addEventListener(KeyCombinationEvent.DOWN, onCombinationDown);
			_key.addEventListener(KeyCombinationEvent.RELEASE, onCombinationRelease);
			_key.addEventListener(KeyCombinationEvent.SEQUENCE, onCombinationTyped);
			_key.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_key.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		
		/**
		 * Assigns a new Key Combination to the KeyManager.
		 * 
		 * @param keyCodes key codes that the key combination consists of.
		 * @param callback the function that should be called when the combination is entered.
		 * @param isRelease true if key comb is triggered when pressed keys are released.
		 */
		public function assignKeyCombination(keyCodes:Array,
												  callback:Function,
												  isRelease:Boolean = false):void
		{
			var c:KeyCombination = new KeyCombination(keyCodes);
			if (isRelease) _assignmentsRelease[c] = callback;
			else _assignmentsDown[c] = callback;
			_key.addKeyCombination(c);
		}
		
		
		/**
		 * Clears all key assignments from the Key manager.
		 */
		public function clearAssignments():void
		{
			var c:Object;
			for (c in _assignmentsDown)
			{
				if (c is KeyCombination)
					_key.removeKeyCombination(c as KeyCombination);
			}
			_assignmentsDown = new Dictionary();
			
			for (c in _assignmentsRelease)
			{
				if (c is KeyCombination)
					_key.removeKeyCombination(c as KeyCombination);
			}
			_assignmentsRelease = new Dictionary();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public static function get instance():KeyManager
		{
			if (!_instance) _instance = new KeyManager();
			return _instance;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private function onCombinationDown(e:KeyCombinationEvent):void
		{
			for (var c:Object in _assignmentsDown)
			{
				if (c is KeyCombination)
				{
					if (e.keyCombination.equals(c as KeyCombination))
					{
						var callback:Function = _assignmentsDown[c];
						callback.apply(null);
					}
				}
			}
		}
		
		
		/**
		 * @private
		 */
		private function onCombinationRelease(e:KeyCombinationEvent):void
		{
			for (var c:Object in _assignmentsRelease)
			{
				if (c is KeyCombination)
				{
					if (e.keyCombination.equals(c as KeyCombination))
					{
						var callback:Function = _assignmentsRelease[c];
						callback.apply(null);
					}
				}
			}
		}
		
		
		/**
		 * @private
		 */
		private function onCombinationTyped(e:KeyCombinationEvent):void
		{
		}
		
		
		/**
		 * @private
		 */
		private function onKeyDown(e:KeyboardEvent):void
		{
		}
		
		
		/**
		 * @private
		 */
		private function onKeyUp(e:KeyboardEvent):void
		{
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
	}
}
