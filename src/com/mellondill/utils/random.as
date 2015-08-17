package com.mellondill.utils
{
	/**
	 * random int in range
	 * @param min
	 * @param max
	 * @return 
	 */
	public function random( min:int = int.MIN_VALUE, max:int = int.MAX_VALUE ):int
	{
		return int( Math.random() * ( max - min ) ) + min;
	}
}
