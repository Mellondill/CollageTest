package com.mellondill.collagetest.command
{
	import com.mellondill.collagetest.signal.ImageMoveSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class ImageAddCompleteCommand extends SignalCommand
	{
		[Inject]
		public var move:ImageMoveSignal;
		
		override public function execute():void
		{
			move.dispatch();
		}
	}
}