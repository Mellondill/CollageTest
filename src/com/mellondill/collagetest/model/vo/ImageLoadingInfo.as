package com.mellondill.collagetest.model.vo
{
	public class ImageLoadingInfo
	{
		private var _url:String;
		private var _loaded:Boolean;

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}

		public function get loaded():Boolean
		{
			return _loaded;
		}

		public function set loaded(value:Boolean):void
		{
			_loaded = value;
		}
	}
}