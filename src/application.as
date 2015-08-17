package
{
	import com.mellondill.collagetest.AppContext;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class application extends Sprite
	{
		private var _context:AppContext;
		
		public function application()
		{
			addEventListener( Event.ADDED_TO_STAGE, notifyStageAdded );
		}
		
		private function notifyStageAdded( event:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, notifyStageAdded );
			
			_context = new AppContext(this);
		}
	}
}