package view.panels{	import mx.containers.Canvas;	import mx.core.ScrollPolicy;				/**	 * AbstractPanel Class	 * @author Sascha Balkau <sascha@hexagonstar.com>	 */	public class AbstractPanel extends Canvas	{		////////////////////////////////////////////////////////////////////////////////////////		// Properties                                                                         //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Public Methods                                                                     //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * Creates a new AbstractPanel instance.		 */		public function AbstractPanel()		{			super();		}						/**		 * init		 */		public function init():void		{		}						////////////////////////////////////////////////////////////////////////////////////////		// Getters & Setters                                                                  //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Event Handlers                                                                     //		////////////////////////////////////////////////////////////////////////////////////////						////////////////////////////////////////////////////////////////////////////////////////		// Private Methods                                                                    //		////////////////////////////////////////////////////////////////////////////////////////				/**		 * createChildren		 * @private		 */		override protected function createChildren():void		{			super.createChildren();						percentWidth = 100;			percentHeight = 100;			horizontalScrollPolicy = ScrollPolicy.OFF;			verticalScrollPolicy = ScrollPolicy.OFF;		}	}}