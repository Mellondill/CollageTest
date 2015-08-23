package com.mellondill.collagetest.command
{
	import com.mellondill.collagetest.model.Model;
	import com.mellondill.collagetest.model.vo.ImageVO;
	import com.mellondill.collagetest.signal.ImageRemoveSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class ImageClickedCommand extends SignalCommand
	{
		[Inject]
		public var image:ImageVO;
		
		[Inject]
		public var model:Model;
		
		[Inject]
		public var remove:ImageRemoveSignal;
		
		override public function execute():void
		{
			remove.dispatch( image );
		}
	}
}