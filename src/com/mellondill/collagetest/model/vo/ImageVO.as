package com.mellondill.collagetest.model.vo
{
	import flash.display.BitmapData;

	public class ImageVO
	{
		private var _content:BitmapData;
		private var _width:int;
		private var _height:int;
		private var _originalWidth:int;
		private var _originalHeight:int;
		private var _x:int;
		private var _y:int;
		private var _oldX:int;
		private var _oldY:int;
		private var _shown:Boolean;
		
		public function get content():BitmapData
		{
			return _content;
		}

		public function set content(value:BitmapData):void
		{
			_content = value;
			_width = _content.width;
			_height = _content.height;
			_originalWidth = _content.width;
			_originalHeight = content.height;
		}

		public function get width():int
		{
			return _width;
		}

		public function get height():int
		{
			return _height;
		}

		public function get originalWidth():int
		{
			return _originalWidth;
		}

		public function get originalHeight():int
		{
			return _originalHeight;
		}
		
		public function get scale():Number
		{
			return _width / _originalWidth;
		}
		
		public function set scale( value:Number ):void
		{
			_width = _originalWidth * value;
			_height = _originalHeight * value;
		}
		
		public function get aspectRatio():Number
		{
			return _originalWidth / _originalHeight;
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_oldX = _x;
			_x = value;
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_oldY = _y;
			_y = value;
		}

		public function get oldX():int
		{
			return _oldX;
		}

		public function get oldY():int
		{
			return _oldY;
		}

		public function get shown():Boolean
		{
			return _shown;
		}

		public function set shown(value:Boolean):void
		{
			_shown = value;
		}

	}
}