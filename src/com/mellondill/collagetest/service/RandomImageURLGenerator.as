package com.mellondill.collagetest.service
{
	import com.adobe.webapis.flickr.FlickrService;
	import com.adobe.webapis.flickr.PagedPhotoList;
	import com.adobe.webapis.flickr.Photo;
	import com.adobe.webapis.flickr.events.FlickrResultEvent;
	import com.mellondill.collagetest.model.Model;
	import com.mellondill.collagetest.signal.LoadImagesSignal;
	import com.mellondill.utils.formatString;
	import com.mellondill.utils.random;
	
	import org.robotlegs.mvcs.Actor;
	
	public class RandomImageURLGenerator extends Actor
	{
		private const MIN_WIDTH:uint = 320;
		private const MIN_HEIGHT:uint = 240;
		private const MAX_WIDTH:uint = 1280;
		private const MAX_HEIGHT:uint = 800;
		
		private const STATIC_IMAGE_URL:String = "https://farm{0}.staticflickr.com/{1}/{2}_{3}_{4}.jpg";
		
		[Inject]
		public var model:Model;
		
		[Inject]
		public var imagesSignal:LoadImagesSignal;
		
		private var flickr:FlickrService;
		
		private var photoUrlList:Vector.<String> = new Vector.<String>();
		
		public function init():void
		{
			flickr = new FlickrService(model.flickrApiKey);
			flickr.addEventListener( FlickrResultEvent.INTERESTINGNESS_GET_LIST, notifyGetImageList );
			flickr.interestingness.getList();
		}
		
		public function get url():String
		{
			return formatString( photoUrlList[random(0,photoUrlList.length-1)], randomImageSize );
		}
		
		private function get randomImageSize():String
		{
			return "sqtmn-zo".charAt( random( 0, 6 ) );
		}
		
		private function notifyGetImageList( event:FlickrResultEvent ):void
		{
			var photosList:PagedPhotoList = event.data.photos as PagedPhotoList;
			for each( var p:Photo in photosList.photos )
			{
				photoUrlList.push( formatString( STATIC_IMAGE_URL, p.farm, p.server, p.id, p.secret, "{0}" ) );
			}
			
			imagesSignal.dispatch();
		}
	}
}