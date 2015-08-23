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
		
		private var _loadCompleteListener:Function;
		
		private var _child:IEventDispatcher;
		
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
			if( _child )
			{
				_child.removeEventListener( Event.COMPLETE, notifyLoadComplete );
				_child.removeEventListener( IOErrorEvent.IO_ERROR, notifyIOError );
				_child.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, notifySecurityError );
			}
			_dispose();
			_loadCompleteListener = null;
			_child = null;
			_url = null;
			logger = null;
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
		
		protected function set child( value:IEventDispatcher ):void
		{
			_child = value;
		}
		
		protected function listenLoadComplete( listener:Function ):void
		{
			_loadCompleteListener = listener;
			_child.addEventListener( Event.COMPLETE, notifyLoadComplete );
		}
		
		protected function listenIOError():void
		{
			_child.addEventListener( IOErrorEvent.IO_ERROR, notifyIOError );
		}
		
		protected function listenSecurityError():void
		{
			_child.addEventListener( SecurityErrorEvent.SECURITY_ERROR, notifySecurityError );
		}
		
		protected function notifyLoadComplete( event:Event ):void
		{
			_child.removeEventListener( Event.COMPLETE, notifyLoadComplete );
			_loadCompleteListener();
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