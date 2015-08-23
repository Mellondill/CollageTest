package com.mellondill.collagetest.view.component
{
	import com.greensock.TimelineLite;
	import com.mellondill.collagetest.model.vo.ImageVO;
	import com.mellondill.core.api.IDisposable;
	
	import flash.display.Bitmap;
	
	import org.osflash.signals.Signal;
	
	public class Image extends Bitmap implements IDisposable
	{
		private const ALPHA_FULL:Number = 1.0;
		private const ALPHA_NONE:Number = 0.0;
		
		private var _timelineComplete:Signal;
		
		private var _imageImpl:ImageVO;
		private var _timeline:TimelineLite;
		
		public function Image( imageImpl:ImageVO )
		{
			_imageImpl = imageImpl;
			super(_imageImpl.content, "auto", true);
		}
		
		public function initialize():void
		{
			this.x = _imageImpl.oldX;
			this.y = _imageImpl.oldY;
			this.width = _imageImpl.width;
			this.height = _imageImpl.height;
			this.alpha = ALPHA_NONE;
			_timelineComplete = new Signal( ImageVO );
			_timeline = new TimelineLite();
		}
		
		public function move():void
		{
			_timeline.clear();
			_timeline.eventCallback( "onComplete", _timelineComplete.dispatch, [_imageImpl] );
			_timeline.to( this, 0.25, { x : _imageImpl.x, y : _imageImpl.y, width : _imageImpl.width, height : _imageImpl.height } );
			_timeline.play();
		}
		
		public function fadeOut():void
		{
			_timeline.clear();
			_timeline.eventCallback( "onComplete", _timelineComplete.dispatch, [_imageImpl] );
			_timeline.to( this, 0.25, { alpha : ALPHA_NONE } );
			_timeline.play();
		}
		
		public function fadeIn():void
		{
			_timeline.clear();
			_timeline.eventCallback( "onComplete", _timelineComplete.dispatch, [_imageImpl] );
			_timeline.to( this, 0.25, { alpha : ALPHA_FULL } );
			_timeline.play();
		}
		
		public function fadeInAndMove():void
		{
			_timeline.clear();
			_timeline.eventCallback( "onComplete", _timelineComplete.dispatch, [_imageImpl] );
			_timeline.to( this, 0.25, { alpha : ALPHA_FULL } );
			_timeline.to( this, 0.25, { x : _imageImpl.x, y : _imageImpl.y } );
			_timeline.play();
		}
		
		public function dispose():void
		{
			bitmapData.dispose();
			_timeline.clear();
			_timeline = null;
			_imageImpl = null;
		}

		public function get timelineComplete():Signal
		{
			return _timelineComplete;
		}

	}
}