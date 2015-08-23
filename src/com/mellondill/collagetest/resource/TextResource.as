package com.mellondill.collagetest.resource
{
	import com.mellondill.collagetest.factory.api.IResourceLoaderFactory;
	import com.mellondill.collagetest.signal.ResourceLoadedTextSignal;
	
	import flash.net.URLLoader;

	public class TextResource extends BaseResource
	{
		[Inject]
		public var loaderFactory:IResourceLoaderFactory;
		
		private var _loader:URLLoader;
		
		override protected function _init():void
		{
			_resourceLoaded = new ResourceLoadedTextSignal();
		}
		
		override protected function _startLoad():void
		{
			if( loaderFactory.isFreeLoader )
			{
				notifyStartLoad();
			}
			else
			{
				loaderFactory.loaderIsFree.add( notifyTryGetFreeUrlLoader );
			}
		}
		
		private function notifyTryGetFreeUrlLoader():void
		{
			if( loaderFactory.isFreeLoader )
			{
				loaderFactory.loaderIsFree.remove( notifyTryGetFreeUrlLoader );
				notifyStartLoad();
			}
		}
		
		private function notifyStartLoad():void
		{
			_loader = loaderFactory.getUrlLoader();
			child = _loader;
			listenIOError();
			listenSecurityError();
			listenLoadComplete( notifyImageLoaded );
			_loader.load( request );
		}
		
		private function notifyImageLoaded():void
		{
			_resourceLoaded.dispatch( _loader.data );
			dispose();
		}
		
		override protected function _dispose():void
		{
			_loader.close();
			_resourceLoaded.removeAll();
			_resourceLoaded = null;
			_loader = null;
			loaderFactory = null;
		}
	}
}