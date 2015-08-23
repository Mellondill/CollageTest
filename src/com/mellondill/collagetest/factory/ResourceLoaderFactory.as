package com.mellondill.collagetest.factory
{
	import com.mellondill.collagetest.factory.api.IResourceLoaderFactory;
	import com.mellondill.collagetest.model.Model;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	import org.robotlegs.mvcs.Actor;
	
	public class ResourceLoaderFactory extends Actor implements IResourceLoaderFactory
	{
		[Inject]
		public var model:Model;
		
		private var _urlLoaderPull:Dictionary = new Dictionary();
		private var _loaderPull:Dictionary = new Dictionary();
		private var _currentLoadCount:uint;
		
		private var _urlLoaderIsFree:Signal = new Signal();
		
		public function getUrlLoader():URLLoader
		{
			if( !isFreeLoader )
				throw new Error( "maximum number of concurrent downloads has reached, try " +
					"IResourceLoaderFactory::isFreeLoader for looking if there are avalaible urlLoaders" );
			
			var result:URLLoader = freeUrlLoader;
			
			if( !result )
			{
				result = new URLLoader();
				result.addEventListener( Event.COMPLETE, notifyUrlLoaderComplete, false, -100000 );
			}
			
			_urlLoaderPull[result] = false;
			_currentLoadCount++;
			
			return result;
		}
		
		private function notifyUrlLoaderComplete( event:Event ):void
		{
			_urlLoaderPull[event.currentTarget] = true;
			_currentLoadCount--;
			_urlLoaderIsFree.dispatch();
		}
		
		private function get freeUrlLoader():URLLoader
		{
			for( var item:URLLoader in _urlLoaderPull )
			{
				if( _urlLoaderPull[item] )
					return item;
			}
			
			return null;
		}
		
		public function get isFreeLoader():Boolean
		{
			return _currentLoadCount < model.maxNumOfConcurrentDownloads;
		}
		
		public function get loaderIsFree():Signal
		{
			return _urlLoaderIsFree;
		}
		
		public function getLoader():Loader
		{
			if( !isFreeLoader )
				throw new Error( "maximum number of concurrent downloads has reached, try " +
					"IResourceLoaderFactory::isFreeLoader for looking if there are avalaible urlLoaders" );
			
			var result:Loader = freeLoader;
			
			if( !result )
			{
				result = new Loader();
				result.contentLoaderInfo.addEventListener( Event.COMPLETE, notifyLoaderComplete, false, -100000 );
			}
			
			_loaderPull[result] = false;
			_currentLoadCount++;
			
			return result;
		}
		
		private function notifyLoaderComplete( event:Event ):void
		{
			_loaderPull[( event.currentTarget as LoaderInfo ).loader] = true;
			_currentLoadCount--;
			_urlLoaderIsFree.dispatch();
		}
		
		private function get freeLoader():Loader
		{
			for( var item:Loader in _loaderPull )
			{
				if( _loaderPull[item] )
					return item;
			}
			
			return null;
		}
		
		public function dispose():void
		{
			for( var item1:URLLoader in _urlLoaderPull )
			{
				if( item1.hasEventListener( Event.COMPLETE ) )
					item1.removeEventListener( Event.COMPLETE, notifyUrlLoaderComplete );
				item1.close();
				delete _urlLoaderPull[item1];
			}
			
			for( var item2:Loader in _loaderPull )
			{
				if( item2.contentLoaderInfo.hasEventListener( Event.COMPLETE ) )
					item2.contentLoaderInfo.removeEventListener( Event.COMPLETE, notifyLoaderComplete );
				item2.unloadAndStop();
				delete _loaderPull[item2];
			}
			
			_urlLoaderPull = null;
			_loaderPull = null;
			
			_urlLoaderIsFree.removeAll();
			_urlLoaderIsFree = null;
			
			model = null;
		}
		
		public function get context():LoaderContext
		{
			return new LoaderContext( false, ApplicationDomain.currentDomain );
		}
		
	}
}