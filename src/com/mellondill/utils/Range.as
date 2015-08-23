package com.mellondill.utils
{

	/**
	 * 
	 * @author Mellondill
	 */
	public class Range
	{
		private var _min:Number;
		private var _max:Number;
		private var _median:Number;

		/**
		 * 
		 * @param min
		 * @param max
		 */
		public function Range( min:Number = 0, max:Number = int.MAX_VALUE )
		{
			_min = min;
			_max = max;
			_median = ( _min + _max ) / 2;
		}

		/**
		 * 
		 * @param val
		 * @return 
		 */
		public function inRange( val:Number ):Boolean
		{
			return ( val <= _max && val >= _min );
		}

		/**
		 * 
		 * @return 
		 */
		public function get min():Number
		{
			return _min;
		}

		/**
		 * 
		 * @return 
		 */
		public function get max():Number
		{
			return _max;
		}
		
		public function get median():Number
		{
			return _median;
		}
	}
}
