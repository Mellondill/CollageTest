package com.mellondill.collagetest.command
{
	import com.mellondill.collagetest.model.Model;
	import com.mellondill.collagetest.model.vo.ImageVO;
	import com.mellondill.collagetest.signal.LoadImagesSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class ImageRemoveCompleteCommand extends SignalCommand
	{
		[Inject]
		public var image:ImageVO;
		
		[Inject]
		public var model:Model;
		
		[Inject]
		public var load:LoadImagesSignal;
		
		override public function execute():void
		{
			var index:int = model.images.indexOf( image );
			
			if( index != -1 )
			{
				model.images.splice( index, 1 );
				model.currentLoadedCount--;
				load.dispatch();
			}
			else
			{
				throw new Error( "Error removing Image" );
			}
		}
		
	}
}