package com.mellondill.collagetest.signal
{
	import flash.display.BitmapData;
	
	import org.osflash.signals.Signal;
	
	public class ResourceLoadedImageSignal extends Signal
	{
		public function ResourceLoadedImageSignal()
		{
			super(BitmapData);
		}
	}
}