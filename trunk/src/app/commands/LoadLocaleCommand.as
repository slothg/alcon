package commands
{
	import io.LocaleLoader;
	
	import com.hexagonstar.env.command.Command;
	import com.hexagonstar.env.command.ICommandListener;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	
	/**
	 * LoadLocaleCommand Class
	 * @author Sascha Balkau
	 */
	public class LoadLocaleCommand extends Command
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private var _loader:LocaleLoader;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new LoadLocaleCommand instance.
		 */
		public function LoadLocaleCommand(listener:ICommandListener)
		{
			super(listener);
		}
		
		
		/**
		 * Execute the command.
		 */ 
		override public function execute():void
		{
			super.execute();
			
			_loader = new LocaleLoader();
			_loader.addEventListener(Event.COMPLETE, onComplete);
			_loader.addEventListener(ErrorEvent.ERROR, onError);
			_loader.load();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		override public function get name():String
		{
			return "loadLocale";
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private function onComplete(e:Event):void
		{
			complete();
		}
		
		
		/**
		 * @private
		 */
		private function onError(e:ErrorEvent):void
		{
			notifyError(e.text);
			complete();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * finish
		 * @private
		 */
		override protected function complete():void
		{
			_loader.removeEventListener(Event.COMPLETE, onComplete);
			_loader.removeEventListener(ErrorEvent.ERROR, onError);
			_loader.dispose();
			_loader = null;
			
			super.complete();
		}
	}
}
