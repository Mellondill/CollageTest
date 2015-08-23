package com.mellondill.collagetest.view.component
{
	import com.mellondill.collagetest.model.vo.ImageVO;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	
	public class MainView extends Sprite
	{
		private var _imagesToBitmaps:Dictionary = new Dictionary();
		private var _bitmapsToImages:Dictionary = new Dictionary();
		
		private var _imageClicked:Signal = new Signal( ImageVO );
		
		private var _imageRemoved:Signal = new Signal( ImageVO );
		
		private var _imageAdded:Signal = new Signal( ImageVO );
		
		private var _imageCount:uint;
		private var _movedImages:uint;
		
		public function constructView( data:Vector.<ImageVO> ):void
		{
			var i:uint;
			var bitmap:Image;
			var image:ImageVO;
			
			for( _imageCount = data.length; i < _imageCount; i++ )
			{
				image = data[i];
				bitmap = new Image( image );
				bitmap.initialize();
				_imagesToBitmaps[ image ] = bitmap;
				_bitmapsToImages[ bitmap ] = image;
				addChild( bitmap );
				image.shown = true;
			}
		}
		
		public function fadeInAndMove():void
		{
			removeEventListener( MouseEvent.CLICK, notifyMouseClick );
			_movedImages = 0;
			for each( var bitmap:Image in _imagesToBitmaps )
			{
				bitmap.timelineComplete.addOnce( notifyImageMoveComplete );
				bitmap.fadeInAndMove();
			}
		}
		
		public function move():void
		{
			removeEventListener( MouseEvent.CLICK, notifyMouseClick );
			_movedImages = 0;
			for each( var bitmap:Image in _imagesToBitmaps )
			{
				bitmap.timelineComplete.addOnce( notifyImageMoveComplete );
				bitmap.move();
			}
		}
		
		public function removeImage( image:ImageVO ):void
		{
			removeEventListener( MouseEvent.CLICK, notifyMouseClick );
			var bitmap:Image = _imagesToBitmaps[image];
			bitmap.timelineComplete.addOnce( notifyImageRemoveComplete );
			bitmap.fadeOut();
		}
		
		public function addImage( image:ImageVO ):void
		{
			var bitmap:Image = new Image( image );
			bitmap.initialize();
			_imagesToBitmaps[ image ] = bitmap;
			_bitmapsToImages[ bitmap ] = image;
			addChild( bitmap );
			image.shown = true;
			bitmap.timelineComplete.addOnce( notifyImageAddComplete );
			bitmap.fadeIn();
		}
		
		private function notifyImageMoveComplete( image:ImageVO ):void
		{
			if( ++_movedImages == _imageCount )
			{
				addEventListener( MouseEvent.CLICK, notifyMouseClick );
				trace( numChildren );
			}
		}
		
		private function notifyImageRemoveComplete( image:ImageVO ):void
		{
			var bitmap:Image = _imagesToBitmaps[image];
			delete _imagesToBitmaps[image];
			delete _bitmapsToImages[bitmap];
			removeChild( bitmap );
			bitmap.dispose();
			_imageRemoved.dispatch( image );
		}
		
		private function notifyImageAddComplete( image:ImageVO ):void
		{
			_imageAdded.dispatch( image );
		}
		
		private function notifyMouseClick( event:MouseEvent ):void
		{
			var image:ImageVO;
			var bitmap:Image;
			var arr:Array = stage.getObjectsUnderPoint( new Point( stage.mouseX, stage.mouseY ) );
			
			bitmap = arr[0] as Image;
			if( bitmap )
				image = _bitmapsToImages[bitmap];
			image && _imageClicked.dispatch( image );
		}

		public function get imageClicked():Signal
		{
			return _imageClicked;
		}

		public function get imageRemoved():Signal
		{
			return _imageRemoved;
		}

		public function get imageAdded():Signal
		{
			return _imageAdded;
		}

		public function get imagesToBitmaps():Dictionary
		{
			return _imagesToBitmaps;
		}
	}
}