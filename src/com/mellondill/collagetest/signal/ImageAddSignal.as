package com.mellondill.collagetest.signal
{
	import com.mellondill.collagetest.model.vo.ImageVO;
	
	import org.osflash.signals.Signal;
	
	public class ImageAddSignal extends Signal
	{
		public function ImageAddSignal()
		{
			super( ImageVO );
		}
	}
}