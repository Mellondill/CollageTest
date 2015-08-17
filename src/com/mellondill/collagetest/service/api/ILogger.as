package com.mellondill.collagetest.service.api
{
	public interface ILogger
	{
		function log( ... args ):void;
		function warn( ... args ):void;
		function error( ... args ):void;
		function critical( ... args ):void;
	}
}