package com.mellondill.collagetest.factory.api
{
	import com.mellondill.collagetest.resource.api.IResource;

	public interface ILoadFactory extends IFactory
	{
		function createResource( url:String ):IResource;
		
		function get type():uint;
	}
}