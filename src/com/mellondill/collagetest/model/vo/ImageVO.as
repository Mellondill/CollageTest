package com.mellondill.collagetest.model.vo
{
	public class ImageVO
	{
		private var _loadingInfo:ImageLoadingInfo = new ImageLoadingInfo();
		private var _implementation:ImageImpl = new ImageImpl();

		public function get loadingInfo():ImageLoadingInfo
		{
			return _loadingInfo;
		}

		public function get implementation():ImageImpl
		{
			return _implementation;
		}
	}
}