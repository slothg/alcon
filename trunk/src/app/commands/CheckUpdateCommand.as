package commands{	import com.hexagonstar.env.command.Command;	import com.hexagonstar.env.command.ICommandListener;		import flash.events.ErrorEvent;	import flash.events.Event;			/**	 * CheckUpdateCommand Class	 * @author Sascha Balkau <sascha@hexagonstar.com>	 */	public class CheckUpdateCommand extends Command	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new CheckUpdateCommand instance.		 */		public function CheckUpdateCommand(listener:ICommandListener)		{			super(listener);		}						/**		 * Execute the command.		 */ 		override public function execute():void		{			super.execute();						// TODO			complete();		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////				override public function get name():String		{			return "checkUpdate";		}						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * @private		 */		private function onComplete(e:Event):void		{			complete();		}						/**		 * @private		 */		private function onError(e:ErrorEvent):void		{			notifyError(e.text);			complete();		}						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * finish		 * @private		 */		override protected function complete():void		{			super.complete();		}	}}