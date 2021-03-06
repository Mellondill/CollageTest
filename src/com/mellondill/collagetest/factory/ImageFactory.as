package com.mellondill.collagetest.factory
{
	import com.mellondill.collagetest.enum.ResourceFactory;
	import com.mellondill.collagetest.factory.api.ILoadFactory;
	import com.mellondill.collagetest.resource.ImageResource;
	import com.mellondill.collagetest.resource.api.IResource;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.mvcs.Actor;
	
	public class ImageFactory extends Actor implements ILoadFactory
	{
		[Inject]
		public var injector:IInjector;
		
		public function createResource(url:String):IResource
		{
			var result:IResource = new ImageResource();
			injector.injectInto( result );
			result.init( url );
			return result;
		}
		
		public function get type():uint
		{
			return ResourceFactory.IMAGE;
		}
		
		public function dispose():void
		{
			injector = null;
		}
	}
}