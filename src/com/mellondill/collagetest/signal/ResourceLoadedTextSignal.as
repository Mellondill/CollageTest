package com.mellondill.collagetest.signal
{
	import org.osflash.signals.Signal;
	
	public class ResourceLoadedTextSignal extends Signal
	{
		public function ResourceLoadedTextSignal()
		{
			super(String);
		}
	}
}