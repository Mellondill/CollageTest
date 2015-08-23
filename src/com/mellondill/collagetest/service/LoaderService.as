package com.mellondill.collagetest.service
{
	import com.mellondill.collagetest.factory.api.ILoadFactory;
	import com.mellondill.collagetest.resource.api.IResource;
	
	import org.robotlegs.mvcs.Actor;
	
	public class LoaderService extends Actor
	{
		[Inject(name="text")]
		public var textFactory:ILoadFactory;
		
		[Inject(name="image")]
		public var imageFactory:ILoadFactory;
		
		public function loadImage( url:String, complete:Function ):void
		{
			startLoadResource( imageFactory.createResource( url ), complete );
		}
		
		public function loadText( url:String, complete:Function ):void
		{
			startLoadResource( textFactory.createResource( url ), complete );
		}
		
		private function startLoadResource( resource:IResource, complete:Function ):void
		{
			resource.resourceLoaded.add( complete );
			resource.startLoad();
		}
	}
}