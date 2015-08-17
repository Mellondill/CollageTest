package com.mellondill.collagetest.model.vo
{
	import flash.display.BitmapData;

	public class ImageImpl
	{
		private var _content:BitmapData;
		private var _width:int;
		private var _height:int;
		
		public function get content():BitmapData
		{
			return _content;
		}

		public function set content(value:BitmapData):void
		{
			_content = value;
			_width = _content.width;
			_height = _content.height;
		}

		public function get width():int
		{
			return _width;
		}

		public function get height():int
		{
			return _height;
		}
	}
}