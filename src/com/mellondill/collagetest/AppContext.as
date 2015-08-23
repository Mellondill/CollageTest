package com.mellondill.collagetest
{
	import com.mellondill.collagetest.command.CalculateScaleAndPositionCommand;
	import com.mellondill.collagetest.command.ImageAddCommand;
	import com.mellondill.collagetest.command.ImageAddCompleteCommand;
	import com.mellondill.collagetest.command.ImageClickedCommand;
	import com.mellondill.collagetest.command.ImageMoveCommand;
	import com.mellondill.collagetest.command.ImageRemoveCommand;
	import com.mellondill.collagetest.command.ImageRemoveCompleteCommand;
	import com.mellondill.collagetest.command.LoadConfigCommand;
	import com.mellondill.collagetest.command.LoadImagesCommand;
	import com.mellondill.collagetest.command.RenderImageCommand;
	import com.mellondill.collagetest.command.ShowImagesCommand;
	import com.mellondill.collagetest.factory.ImageFactory;
	import com.mellondill.collagetest.factory.ResourceLoaderFactory;
	import com.mellondill.collagetest.factory.TextFactory;
	import com.mellondill.collagetest.factory.api.ILoadFactory;
	import com.mellondill.collagetest.factory.api.IResourceLoaderFactory;
	import com.mellondill.collagetest.model.Model;
	import com.mellondill.collagetest.service.LoaderService;
	import com.mellondill.collagetest.service.Logger;
	import com.mellondill.collagetest.service.MultiImageSmartLayoutService;
	import com.mellondill.collagetest.service.RandomImageURLGenerator;
	import com.mellondill.collagetest.service.api.ILogger;
	import com.mellondill.collagetest.signal.CalculateScaleAndPositionSignal;
	import com.mellondill.collagetest.signal.ImageAddCompleteSignal;
	import com.mellondill.collagetest.signal.ImageAddSignal;
	import com.mellondill.collagetest.signal.ImageClickedSignal;
	import com.mellondill.collagetest.signal.ImageMoveSignal;
	import com.mellondill.collagetest.signal.ImageRemoveCompleteSignal;
	import com.mellondill.collagetest.signal.ImageRemoveSignal;
	import com.mellondill.collagetest.signal.LoadConfigSignal;
	import com.mellondill.collagetest.signal.LoadImagesSignal;
	import com.mellondill.collagetest.signal.RenderImagesSignal;
	import com.mellondill.collagetest.signal.ShowImagesSignal;
	import com.mellondill.collagetest.view.component.MainView;
	import com.mellondill.collagetest.view.mediator.MainMediator;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.SignalContext;
	
	public class AppContext extends SignalContext
	{
		private var start:LoadConfigSignal;
		
		public function AppContext( contextView:DisplayObjectContainer )
		{
			start = new LoadConfigSignal();
			super( contextView );
		}
		
		override public function startup():void
		{
			injector.mapSingleton( Model );
			injector.mapSingleton( LoaderService );
			injector.mapSingleton( RandomImageURLGenerator );
			injector.mapSingleton( MultiImageSmartLayoutService );
			
			injector.mapSingletonOf( IResourceLoaderFactory, ResourceLoaderFactory );
			injector.mapSingletonOf( ILogger, Logger );
			injector.mapSingletonOf( ILoadFactory, ImageFactory, "image" );
			injector.mapSingletonOf( ILoadFactory, TextFactory, "text" );
			
			signalCommandMap.mapSignal( start, LoadConfigCommand, true );
			signalCommandMap.mapSignalClass( LoadImagesSignal, LoadImagesCommand );
			signalCommandMap.mapSignalClass( CalculateScaleAndPositionSignal, CalculateScaleAndPositionCommand );
			signalCommandMap.mapSignalClass( RenderImagesSignal, RenderImageCommand );
			signalCommandMap.mapSignalClass( ShowImagesSignal, ShowImagesCommand );
			signalCommandMap.mapSignalClass( ImageAddSignal, ImageAddCommand );
			signalCommandMap.mapSignalClass( ImageAddCompleteSignal, ImageAddCompleteCommand );
			signalCommandMap.mapSignalClass( ImageRemoveSignal, ImageRemoveCommand );
			signalCommandMap.mapSignalClass( ImageRemoveCompleteSignal, ImageRemoveCompleteCommand );
			signalCommandMap.mapSignalClass( ImageClickedSignal, ImageClickedCommand );
			signalCommandMap.mapSignalClass( ImageMoveSignal, ImageMoveCommand );
			
			mediatorMap.mapView( MainView, MainMediator );
			
			start.dispatch( "app.cfg" );
			super.startup();
		}
		
	}
}