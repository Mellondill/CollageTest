package com.mellondill.collagetest.factory.api
{
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.system.LoaderContext;
	
	import org.osflash.signals.Signal;
	
	public interface IResourceLoaderFactory extends IFactory
	{
		function getUrlLoader():URLLoader;
		
		function getLoader():Loader;
		
		function get isFreeLoader():Boolean;
		
		function get loaderIsFree():Signal;
		
		function get context():LoaderContext;
	}
}