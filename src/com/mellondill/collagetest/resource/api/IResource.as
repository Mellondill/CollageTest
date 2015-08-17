package com.mellondill.collagetest.resource.api
{
	import com.mellondill.core.api.IDisposable;
	
	import org.osflash.signals.Signal;

	public interface IResource extends IDisposable
	{
		function init( url:String ):void;
		function startLoad():void;
		
		function get url():String;
		function get resourceLoaded():Signal;
	}
}