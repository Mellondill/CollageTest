package com.mellondill.collagetest.command
{
	import com.mellondill.collagetest.model.Model;
	import com.mellondill.collagetest.model.vo.ImageVO;
	import com.mellondill.collagetest.service.MultiImageSmartLayoutService;
	import com.mellondill.collagetest.signal.RenderImagesSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class CalculateScaleAndPositionCommand extends SignalCommand
	{
		[Inject]
		public var model:Model;
		
		[Inject]
		public var render:RenderImagesSignal;
		
		[Inject]
		public var misls:MultiImageSmartLayoutService;
		
		override public function execute():void
		{
			misls.layout( model.images, model.containerDimentions );
			
			render.dispatch();
		}
		
		private function calculateMinHeight():int
		{
			var image:ImageVO;
			var i:uint;
			var length:uint;
			var arr:Array = [];
			
			for( length = model.images.length ; i < length; i++ )
			{
				image = model.images[i];
				arr.push( image.height );
			}
			
			return Math.min.apply( null, arr );
		}
		
	}
}