package com.mellondill.collagetest.factory
{
	import com.mellondill.collagetest.factory.api.IResourceLoaderFactory;
	
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	import org.osflash.signals.Signal;
	import org.robotlegs.mvcs.Actor;
	
	public class ResourceLoaderFactory extends Actor implements IResourceLoaderFactory
	{
		public function ResourceLoaderFactory()
		{
			super();
		}
		
		public function get urlLoader():URLLoader
		{
			return null;
		}
		
		public function get isFreeUrlLoader():Boolean
		{
			return false;
		}
		
		public function get urlLoaderIsFree():Signal
		{
			return null;
		}
		
		public function get loader():Loader
		{
			return null;
		}
		
		public function get isFreeLoader():Boolean
		{
			return false;
		}
		
		public function get loaderIsFree():Signal
		{
			return null;
		}
		
		public function dispose():void
		{
		}
		
		public function get context():LoaderContext
		{
			return new LoaderContext( false, ApplicationDomain.currentDomain, SecurityDomain.currentDomain );
		}
		
	}
}