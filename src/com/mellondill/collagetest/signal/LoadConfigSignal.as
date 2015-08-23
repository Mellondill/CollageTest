package com.mellondill.collagetest.signal
{
	import org.osflash.signals.Signal;
	
	public class LoadConfigSignal extends Signal
	{
		public function LoadConfigSignal()
		{
			super(String);
		}
	}
}