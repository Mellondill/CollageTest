package com.mellondill.collagetest.command
{
	import com.mellondill.collagetest.model.Model;
	import com.mellondill.collagetest.service.LoaderService;
	import com.mellondill.collagetest.service.RandomImageURLGenerator;
	import com.mellondill.collagetest.signal.CalculateScaleAndPositionSignal;
	
	import flash.display.BitmapData;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class LoadImagesCommand extends SignalCommand
	{
		[Inject]
		public var model:Model;
		
		[Inject]
		public var loader:LoaderService;
		
		[Inject]
		public var urlGenerator:RandomImageURLGenerator;
		
		[Inject]
		public var calculationSignal:CalculateScaleAndPositionSignal;
		
		override public function execute():void
		{
			var imageToLoadCount:uint = model.imageCount - model.currentLoadedCount;
			
			while( imageToLoadCount-- )
			{
				loader.loadImage( urlGenerator.url, notifyImageComplete );
			}
		}
		
		private function notifyImageComplete( bitmapData:BitmapData ):void
		{
			model.currentLoadedCount++;
			model.putImageInstance( bitmapData );
			
			if( model.currentLoadedCount == model.imageCount )
			{
				calculationSignal.dispatch();
			}
		}
	}
}