package com.mellondill.collagetest.signal
{
	import com.mellondill.collagetest.model.vo.ImageVO;
	
	import org.osflash.signals.Signal;
	
	public class ImageClickedSignal extends Signal
	{
		public function ImageClickedSignal()
		{
			super( ImageVO );
		}
	}
}