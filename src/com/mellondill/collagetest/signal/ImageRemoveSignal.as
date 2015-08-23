package com.mellondill.collagetest.signal
{
	import com.mellondill.collagetest.model.vo.ImageVO;
	
	import org.osflash.signals.Signal;
	
	public class ImageRemoveSignal extends Signal
	{
		public function ImageRemoveSignal()
		{
			super( ImageVO );
		}
	}
}