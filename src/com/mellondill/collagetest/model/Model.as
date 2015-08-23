package com.mellondill.collagetest.model
{
	import com.mellondill.collagetest.model.vo.ImageVO;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import org.robotlegs.mvcs.Actor;
	
	public class Model extends Actor
	{
		private var _imageCount:uint;
		private var _numRows:uint;
		
		private var _flickrApiKey:String;
		private var _maxNumOfConcurrentDownloads:int = 3;
		
		private var _currentLoadedCount:uint;
		private var _images:Vector.<ImageVO> = new Vector.<ImageVO>();
		
		private var _containerDimentions:Point;
		
		private var _imagesShown:Boolean;
		
		public function putImageInstance( bitmapData:BitmapData ):void
		{
			var result:ImageVO = new ImageVO();
			result.content = bitmapData;
			_images.push( result );
		}
		
		public function deleteImageInstance( url:String ):void
		{
			var bitmapData:BitmapData = _images[url];
			
			if( bitmapData )
				bitmapData.dispose();
			
			delete _images[url];
		}

		public function get currentLoadedCount():uint
		{
			return _currentLoadedCount;
		}

		public function set currentLoadedCount(value:uint):void
		{
			_currentLoadedCount = value;
		}

		public function get images():Vector.<ImageVO>
		{
			return _images;
		}

		public function get maxNumOfConcurrentDownloads():int
		{
			return _maxNumOfConcurrentDownloads;
		}

		public function set maxNumOfConcurrentDownloads(value:int):void
		{
			_maxNumOfConcurrentDownloads = value;
		}

		public function get flickrApiKey():String
		{
			return _flickrApiKey;
		}

		public function set flickrApiKey(value:String):void
		{
			_flickrApiKey = value;
		}

		public function get numRows():uint
		{
			return _numRows;
		}

		public function set numRows(value:uint):void
		{
			_numRows = value;
		}

		public function get imageCount():uint
		{
			return _imageCount;
		}

		public function set imageCount(value:uint):void
		{
			_imageCount = value;
		}

		public function get containerDimentions():Point
		{
			return _containerDimentions;
		}

		public function set containerDimentions(value:Point):void
		{
			_containerDimentions = value;
		}

		public function get imagesShown():Boolean
		{
			return _imagesShown;
		}

		public function set imagesShown(value:Boolean):void
		{
			_imagesShown = value;
		}


	}
}