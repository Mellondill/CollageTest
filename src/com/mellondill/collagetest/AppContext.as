package com.mellondill.collagetest
{
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.SignalContext;
	
	public class AppContext extends SignalContext
	{
		public function AppContext( contextView:DisplayObjectContainer )
		{
			super( contextView );
		}
		
		override public function startup():void
		{
			
			super.startup();
		}
		
	}
}