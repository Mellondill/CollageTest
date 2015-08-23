package com.mellondill.utils
{
	/**
	 * @author Mellondill
	 */
	public function planeXMLToObject( xml:XML ):Object
	{
		var result:Object = {};
		
		for each( var x:XML in xml.children() )
		{
			result[ String( x.name() ) ] = x.children().toXMLString();
		}
		
		return result;
	}	
}