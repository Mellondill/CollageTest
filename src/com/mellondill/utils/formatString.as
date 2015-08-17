package com.mellondill.utils
{
	/**
	 * formats string like <p>skins/{0}/{1}</p> into <p>skins/skin001/skin001.swf{1}</p> as example
	 * @param format
	 * @param args
	 * @return 
	 */
	public function formatString( format:String, ... args ):String
	{
		for( var i:int = 0; i < args.length; ++i )
			format = format.replace( new RegExp( "\\{" + i + "\\}", "g" ), args[i]);

		return format;
	}
}
