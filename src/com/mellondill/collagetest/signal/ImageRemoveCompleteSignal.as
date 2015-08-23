package com.mellondill.collagetest.signal
{
	import com.mellondill.collagetest.model.vo.ImageVO;
	
	import org.osflash.signals.Signal;
	
	public class ImageRemoveCompleteSignal extends Signal
	{
		public function ImageRemoveCompleteSignal()
		{
			super( ImageVO );
		}
	}
}