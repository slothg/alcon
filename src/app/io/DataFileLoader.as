package io
{
	import model.Config;
	
	import util.Log;
	
	import com.hexagonstar.data.structures.queues.Queue;
	import com.hexagonstar.env.event.FileIOEvent;
	import com.hexagonstar.io.file.types.BinaryFile;
	
	import flash.events.Event;
	
	
	/**
	 * @author Sascha Balkau
	 */
	public class DataFileLoader extends AbstractLoader
	{
		////////////////////////////////////////////////////////////////////////////////////////
		// Properties                                                                         //
		////////////////////////////////////////////////////////////////////////////////////////
		
		private var _files:Queue;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new instance of the class.
		 */
		public function DataFileLoader()
		{
			super();
		}
		
		
		/**
		 * Loads the data files.
		 */
		override public function load():void
		{
			super.load();
			
			var files:Array = Config.instance.dataFiles;
			
			if (files)
			{
				var amount:int = files.length;
				if (amount > 0)
				{
					_files = new Queue();
					for (var i:int = 0; i < amount; i++)
					{
						var path:String = files[i];
						var file:BinaryFile = new BinaryFile(path);
						_files.enqueue(file);
					}
					
					_loader.fileQueue = _files;
					_loader.load();
				}
				else
				{
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
			else
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		
		/**
		 * Returns a String Representation of DataLoader.
		 * 
		 * @return A String Representation of DataLoader.
		 */
		override public function toString():String
		{
			return "[DataFileLoader]";
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Event Handlers                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		override public function onComplete(e:FileIOEvent):void
		{
			Log.debug(toString() + " Loaded: " + e.file.path);
		}
		
		
		/**
		 * @private
		 */
		override public function onAllComplete(e:FileIOEvent):void
		{
			// TODO initiate data parsing from here!
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Notifies any listener that an error occured during loading.
		 * @private
		 * 
		 * @param msg the error message.
		 */
		override protected function notifyError(msg:String):void
		{
			Log.error(toString() + " Error loading file: " + msg);
			
			//var e:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR);
			//e.text = toString() + " Error loading file: " + msg;
			//dispatchEvent(e);
		}
	}
}
