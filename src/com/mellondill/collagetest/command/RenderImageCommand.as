package com.mellondill.collagetest.command
{
	import com.mellondill.collagetest.model.Model;
	import com.mellondill.collagetest.model.vo.ImageVO;
	import com.mellondill.collagetest.signal.ImageAddSignal;
	import com.mellondill.collagetest.signal.ShowImagesSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class RenderImageCommand extends SignalCommand
	{
		[Inject]
		public var model:Model;
		
		[Inject]
		public var show:ShowImagesSignal;
		
		[Inject]
		public var add:ImageAddSignal;
		
		override public function execute():void
		{
			if( !model.imagesShown )
			{
				show.dispatch();
			}
			else
			{
				for each( var image:ImageVO in model.images )
				{
					if( !image.shown )
						add.dispatch( image );
				}
			}
		}
	}
}