package com.mellondill.collagetest.factory.api
{
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.system.LoaderContext;
	
	import org.osflash.signals.Signal;
	
	public interface IResourceLoaderFactory extends IFactory
	{
		function get urlLoader():URLLoader;
		
		function get isFreeUrlLoader():Boolean;
		
		function get urlLoaderIsFree():Signal;
		
		function get loader():Loader;
		
		function get isFreeLoader():Boolean;
		
		function get loaderIsFree():Signal;
		
		function get context():LoaderContext;
	}
}