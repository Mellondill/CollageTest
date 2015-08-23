package com.mellondill.collagetest.view.mediator
{
	import com.mellondill.collagetest.model.Model;
	import com.mellondill.collagetest.model.vo.ImageVO;
	import com.mellondill.collagetest.signal.ImageAddCompleteSignal;
	import com.mellondill.collagetest.signal.ImageAddSignal;
	import com.mellondill.collagetest.signal.ImageClickedSignal;
	import com.mellondill.collagetest.signal.ImageMoveSignal;
	import com.mellondill.collagetest.signal.ImageRemoveCompleteSignal;
	import com.mellondill.collagetest.signal.ImageRemoveSignal;
	import com.mellondill.collagetest.signal.ShowImagesSignal;
	import com.mellondill.collagetest.view.component.MainView;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class MainMediator extends Mediator
	{
		[Inject]
		public var show:ShowImagesSignal;
		
		[Inject]
		public var add:ImageAddSignal;
		
		[Inject]
		public var move:ImageMoveSignal;
		
		[Inject]
		public var remove:ImageRemoveSignal;
		
		[Inject]
		public var click:ImageClickedSignal;
		
		[Inject]
		public var addComplete:ImageAddCompleteSignal;
		
		[Inject]
		public var removeComplete:ImageRemoveCompleteSignal;
		
		[Inject]
		public var view:MainView;
		
		[Inject]
		public var model:Model;
		
		override public function onRegister():void
		{
			show.addOnce( notifyShow );
			add.add( notifyAdd );
			remove.add( notifyRemove );
			move.add( notifyMove );
			view.imageAdded.add( notifyImageAdded );
			view.imageClicked.add( notifyImageClicked );
			view.imageRemoved.add( notifyImageRemoved );
		}
		
		private function notifyShow():void
		{
			model.imagesShown = true;
			view.constructView( model.images );
			view.fadeInAndMove();
		}
		
		private function notifyImageAdded( image:ImageVO ):void
		{
			addComplete.dispatch( image );
		}
		
		private function notifyImageClicked( image:ImageVO ):void
		{
			click.dispatch( image );
		}
		
		private function notifyImageRemoved( image:ImageVO ):void
		{
			removeComplete.dispatch( image );
		}
		
		private function notifyAdd( image:ImageVO ):void
		{
			view.addImage( image );
		}
		
		private function notifyRemove( image:ImageVO ):void
		{
			view.removeImage( image );
		}
		
		private function notifyMove():void
		{
			view.move();
		}
		
		override public function onRemove():void
		{
		}
	}
}