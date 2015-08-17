package com.mellondill.collagetest.service
{
	import com.mellondill.collagetest.service.api.ILogger;
	
	public class Logger implements ILogger
	{
		public function Logger()
		{
		}
		
		public function log(...args):void
		{
			args.unshift( "log: " );
			trace.apply( null, args );
		}
		
		public function warn(...args):void
		{
			args.unshift( "warn: " );
			trace.apply( null, args );
		}
		
		public function error(...args):void
		{
			args.unshift( "error: " );
			trace.apply( null, args );
		}
		
		public function critical(...args):void
		{
			args.unshift( "critical: " );
			trace.apply( null, args );
		}
	}
}