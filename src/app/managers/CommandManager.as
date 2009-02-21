package managers
{
	import util.Log;
	
	import com.hexagonstar.env.command.Command;
	import com.hexagonstar.env.command.ICommandListener;
	import com.hexagonstar.env.event.CommandCompleteEvent;
	import com.hexagonstar.env.event.CommandErrorEvent;
	import com.hexagonstar.env.event.CommandProgressEvent;
	
	import flash.events.ErrorEvent;		
	/**
	 * @author Sascha Balkau
	 */
	public class CommandManager implements ICommandListener
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private static var _instance:CommandManager;
		private var _executingCommands:Vector.<Command>;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new instance of the class.
		 */
		public function CommandManager()
		{
			if (_instance)
			{
				throw new Error("Tried to instantiate CommandManager through"
					+ " it's constructor. Use CommandManager.instance instead!");
			}
			
			_executingCommands = new Vector.<Command>();
		}

		
		/**
		 * Executes the specified command.
		 */
		public function execute(command:Command):Boolean
		{
			if (!isExecuting(command))
			{
				_executingCommands.push(command);
				addCommandListeners(command);
				command.execute();
				return true;
			}
			else
			{
				Log.warn(toString() + " The command '" + command.name
					+ "' is already being executed.");
				return false;
			}
		}
		
		
		/**
		 * Aborts the specified command if it is currently being executed.
		 */
		public function abort(command:Command):void
		{
			// TODO
		}
		
		
		/**
		 * Checks if the specified command is currently being executed.
		 */
		public function isExecuting(command:Command):Boolean
		{
			for each (var c:Command in _executingCommands)
			{
				if (command.name == c.name) return true;
			}
			return false;
		}
		
		
		/**
		 * Returns a String Representation of CommandManager.
		 * 
		 * @return A String Representation of CommandManager.
		 */
		public function toString():String
		{
			return "[CommandManager]";
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Returns the Singleton instance of CommandManager.
		 */
		public static function get instance():CommandManager
		{
			if (!_instance) _instance = new CommandManager();
			return _instance;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		public function onCommandProgress(e:CommandProgressEvent):void
		{
		}
		
		
		public function onCommandError(e:CommandErrorEvent):void
		{
		}
		
		
		public function onCommandComplete(e:CommandCompleteEvent):void
		{
			removeCommand(e.command);
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * removeCommand
		 * @private
		 */
		private function removeCommand(command:Command):void
		{
			removeCommandListeners(command);
			
			for (var i:int = 0; i < _executingCommands.length; i++)
			{
				if (command.name == _executingCommands[i].name)
				{
					_executingCommands.splice(i, 1);
					break;
				}
			}
		}
		
		
		/**
		 * addCommandListeners
		 * @private
		 */
		private function addCommandListeners(command:Command):void
		{
			var l:ICommandListener = command.listener;
			
			command.addEventListener(CommandProgressEvent.PROGRESS, l.onCommandProgress);
			command.addEventListener(CommandCompleteEvent.COMPLETE, l.onCommandComplete);
			command.addEventListener(ErrorEvent.ERROR, l.onCommandError);
			
			command.addEventListener(CommandProgressEvent.PROGRESS, onCommandProgress);
			command.addEventListener(CommandCompleteEvent.COMPLETE, onCommandComplete);
			command.addEventListener(ErrorEvent.ERROR, onCommandError);
		}
		
		
		/**
		 * removeCommandListeners
		 * @private
		 */
		private function removeCommandListeners(command:Command):void
		{
			var l:ICommandListener = command.listener;
			
			command.removeEventListener(CommandProgressEvent.PROGRESS, l.onCommandProgress);
			command.removeEventListener(CommandCompleteEvent.COMPLETE, l.onCommandComplete);
			command.removeEventListener(ErrorEvent.ERROR, l.onCommandError);
			
			command.removeEventListener(CommandProgressEvent.PROGRESS, onCommandProgress);
			command.removeEventListener(CommandCompleteEvent.COMPLETE, onCommandComplete);
			command.removeEventListener(ErrorEvent.ERROR, onCommandError);
		}
	}
}
