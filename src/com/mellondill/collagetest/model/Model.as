package com.mellondill.collagetest.model
{
	import com.mellondill.collagetest.model.vo.ImageImpl;
	import com.mellondill.collagetest.model.vo.ImageLoadingInfo;
	
	import flash.utils.Dictionary;
	
	import org.robotlegs.mvcs.Actor;
	
	public class Model extends Actor
	{
		private var _images:Dictionary = new Dictionary();
		
		public function creaImageInstance( url:String ):ImageLoadingInfo
		{
			var result:ImageLoadingInfo = new ImageLoadingInfo();
			
			result.url = url;
			_images[result] = new ImageImpl();
			
			return result;
		}
		
		public function getImageInstance( info:ImageLoadingInfo ):ImageImpl
		{
			return _images[info];
		}
	}
}