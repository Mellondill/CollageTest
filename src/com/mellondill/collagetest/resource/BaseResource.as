package com.mellondill.collagetest.resource
{
	import com.mellondill.collagetest.resource.api.IResource;
	import com.mellondill.collagetest.service.api.ILogger;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	import org.osflash.signals.Signal;
	
	public class BaseResource implements IResource
	{
		[Inject]
		public var logger:ILogger;
		
		protected var _url:String;
		
		protected var _resourceLoaded:Signal;
		
		final public function init(url:String):void
		{
			_url = url;
			_init();
		}
		
		public function get url():String
		{
			return _url;
		}
		
		final public function startLoad():void
		{
			_startLoad();
		}
		
		public function get resourceLoaded():Signal
		{
			return _resourceLoaded;
		}
		
		final public function dispose():void
		{
			_dispose();
			_url = null;
		}
		
		protected function _init():void
		{
			throw new Error( "_init function need to be implemented in child class" );
		}
		
		protected function _startLoad():void
		{
			throw new Error( "_startLoad function need to be implemented in child class" );
		}
		
		protected function _dispose():void
		{
			throw new Error( "_dispose function need to be implemented in child class" );
		}
		
		protected function listenLoadComplete( child:IEventDispatcher, listener:Function ):void
		{
			child.addEventListener( Event.COMPLETE, function( event:Event ):void{ event.currentTarget.removeEventListener( event.type, arguments.callee ); listener(); } );
		}
		
		protected function listenIOError( child:IEventDispatcher ):void
		{
			child.addEventListener( IOErrorEvent.IO_ERROR, notifyIOError );
		}
		
		protected function listenSecurityError( child:IEventDispatcher ):void
		{
			child.addEventListener( SecurityErrorEvent.SECURITY_ERROR, notifySecurityError );
		}
		
		protected function notifyIOError( event:IOErrorEvent ):void
		{
			event.stopImmediatePropagation();
			logger.error( event.errorID, event.text );
			dispose();
		}
		
		protected function notifySecurityError( event:SecurityErrorEvent ):void
		{
			event.stopImmediatePropagation();
			logger.error( event.errorID, event.text );
			dispose();
		}
		
		protected function get request():URLRequest
		{
			var result:URLRequest = new URLRequest( _url );
			return result;
		}
	}
}