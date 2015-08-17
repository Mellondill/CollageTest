package com.mellondill.collagetest.resource
{
	import com.mellondill.collagetest.factory.api.IResourceLoaderFactory;
	import com.mellondill.collagetest.signal.ResourceLoadedImageSignal;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	
	public class ImageResource extends BaseResource
	{
		[Inject]
		public var loaderFactory:IResourceLoaderFactory;
		
		private var _loader:Loader;
		
		override protected function _init():void
		{
			_resourceLoaded = new ResourceLoadedImageSignal();
		}
		
		override protected function _startLoad():void
		{
			if( loaderFactory.isFreeLoader )
			{
				notifyStartLoad();
			}
			else
			{
				loaderFactory.loaderIsFree.add( notifyTryGetFreeLoader );
			}
		}
		
		private function notifyTryGetFreeLoader():void
		{
			if( loaderFactory.isFreeLoader )
			{
				loaderFactory.loaderIsFree.remove( notifyTryGetFreeLoader );
				notifyStartLoad();
			}
		}
		
		private function notifyStartLoad():void
		{
			_loader = loaderFactory.loader;
			listenIOError( _loader.contentLoaderInfo );
			listenLoadComplete( _loader.contentLoaderInfo, notifyImageLoaded );
			_loader.load( request, loaderFactory.context );
		}
		
		private function notifyImageLoaded():void
		{
			_resourceLoaded.dispatch( ( _loader.content as Bitmap ).bitmapData.clone() );
			dispose();
		}
		
		override protected function _dispose():void
		{
			_loader.unloadAndStop();
		}
		
	}
}