package com.mellondill.collagetest.command
{
	import com.mellondill.collagetest.model.Model;
	import com.mellondill.collagetest.service.LoaderService;
	import com.mellondill.collagetest.service.RandomImageURLGenerator;
	import com.mellondill.collagetest.view.component.MainView;
	import com.mellondill.utils.planeXMLToObject;
	
	import flash.geom.Point;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class LoadConfigCommand extends SignalCommand
	{
		[Inject]
		public var configPath:String;
		
		[Inject]
		public var loader:LoaderService;
		
		[Inject]
		public var model:Model;
		
		[Inject]
		public var urlGenerator:RandomImageURLGenerator;
		
		override public function execute():void
		{
			loader.loadText( configPath, notifyConfigLoaded );
		}
		
		
		private function notifyConfigLoaded( value:String ):void
		{
			var data:Object = planeXMLToObject( XML( value ) );
			model.imageCount ||= int( data.image_count );
			model.numRows ||= int( data.image_rows );
			model.flickrApiKey ||= data.flickr_api_key;
			
			model.containerDimentions = new Point( contextView.stage.stageWidth, contextView.stage.stageHeight );
			
			contextView.addChild( new MainView() );
			
			urlGenerator.init();
		}
	}
}