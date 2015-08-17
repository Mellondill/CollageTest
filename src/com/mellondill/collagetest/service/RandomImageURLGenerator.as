package com.mellondill.collagetest.service
{
	import com.mellondill.utils.formatString;
	import com.mellondill.utils.random;
	
	import org.robotlegs.mvcs.Actor;
	
	public class RandomImageURLGenerator extends Actor
	{
		private const URL_PATTERN:String = "http://loremflickr.com/{0}/{1}";
		private const MIN_WIDTH:uint = 320;
		private const MIN_HEIGHT:uint = 240;
		private const MAX_WIDTH:uint = 1280;
		private const MAX_HEIGHT:uint = 800;
		
		public function get url():String
		{
			return formatString( URL_PATTERN, random( MIN_WIDTH, MAX_WIDTH ), random( MIN_HEIGHT, MAX_HEIGHT ) );
		}
	}
}