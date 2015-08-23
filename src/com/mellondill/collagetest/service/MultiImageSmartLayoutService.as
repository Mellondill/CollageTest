package com.mellondill.collagetest.service
{
	import com.mellondill.collagetest.model.vo.ImageVO;
	import com.mellondill.utils.Range;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.robotlegs.mvcs.Actor;
	
	public class MultiImageSmartLayoutService extends Actor
	{
		private var _sortedLeafs:Vector.<LeafNode> = new Vector.<LeafNode>();
		private var _expectedAspectRatioRange:Range;
		
		public function layout( images:Vector.<ImageVO>, containerDimentions:Point ):Vector.<ImageVO>
		{
			var leafs:Vector.<LeafNode> = new <LeafNode>[];
			var leafRefs:Dictionary = new Dictionary();
			var image:ImageVO;
			var leaf:LeafNode;
			var tree:INode;
			
			for each( image in images )
			{
				leaf = new LeafNode();
				leaf.width = image.width;
				leaf.height = image.height;
				leaf.currentAspectRatio = image.aspectRatio;
				leaf.expectedAspectRatio = image.aspectRatio;
				leafs.push( leaf );
				leafRefs[leaf] = image;
			}
			
			var expectedAR:Number = containerDimentions.x / containerDimentions.y;
			
			_expectedAspectRatioRange = new Range( expectedAR - ( expectedAR * 0.05 ), expectedAR + ( expectedAR * 0.05 ) );
			
			var treeIsGood:Boolean;
			var percent:Number = 1.05;
			
			while( !treeIsGood )
			{
				_sortedLeafs = ( new Vector.<LeafNode> ).concat( leafs.sort( sortLeafNodes ) );
				
				tree = createTree( leafs, true, expectedAR );
				calculateAspectRatio( tree );
				
				var t:uint = 20;
				
				var treeRange:Range = new Range( expectedAR, expectedAR * percent );
				
				while( t-- )
				{
					adjustTree( tree, 1.1 );
					
					if( treeRange.inRange( calculateAspectRatio( tree ) ) )
					{
						treeIsGood = true;
						break;
					}
				}
				
				percent += 0.05;
			}
			
			tree.width = containerDimentions.x;
			tree.height = containerDimentions.x / tree.currentAspectRatio;
			
			calculatePosition( tree );
			
			for each( leaf in leafs )
			{
				image = leafRefs[leaf];
				
				image.x = leaf.x;
				image.y = leaf.y;
				image.scale = leaf.width / image.originalWidth;
			}
			
			return images;
		}
		
		private function sortLeafNodes( item1:LeafNode, item2:LeafNode ):Number
		{
			var result:Number = 0;
			
			if( item1.currentAspectRatio > item2.currentAspectRatio )
			{
				result = 1;
			}
			else if( item1.currentAspectRatio < item2.currentAspectRatio )
			{
				result = -1;
			}
			
			return result;
		}
		
		private function createTree( images:Vector.<LeafNode>, splitV:Boolean, expectedAR:Number ):INode
		{
			var count:uint = images.length;
			var node:INode;
			
			if( count >= 2 )
			{
				var left:Vector.<LeafNode> = ( new Vector.<LeafNode> ).concat( images );
				var right:Vector.<LeafNode> = left.splice( 0, count >> 1 );
				
				node = new InternalNode();
				node.numImages = count;
				node.expectedAspectRatio = expectedAR;
				splitV = Math.random() - 0.5 > 0;
				node.split = splitV ? InternalNode.VERTICAL : InternalNode.HORIZONTAL;
				
				var childExpectedAR:Number = splitV ? expectedAR * 2 : expectedAR / 2;
				
				node.leftChild = createTree( left, !splitV, childExpectedAR );
				node.rightChild = createTree( right, !splitV, childExpectedAR );
				var n:uint = uint( node.leftChild is LeafNode ) + uint( node.rightChild is LeafNode );
				
				if( n == 2 )
				{
					var leafPair:Vector.<LeafNode> = getExpectedAspectRatioLeafPair();
					node.leftChild = leafPair[0];
					node.rightChild = leafPair[1];
					trace("n==2");
				}
				else if( n == 1 )
				{
					var leaf:LeafNode = getExpectedAspectRatioLeaf();
					if( leaf )
					{
						node.rightChild = leaf;
						trace("n==1");
					}
						
				}
				
				node.leftChild.parent = node;
				node.rightChild.parent = node;
			}
			else if( count == 1 )
			{
				node = images.pop();
			}
			
			return node;
		}
		
		private function adjustTree( node:INode, treshhold:Number ):void
		{
			if( node.type == Node.INTERNAL_NODE )
			{
				if( node.currentAspectRatio > node.expectedAspectRatio * treshhold )
				{
					node.split = InternalNode.HORIZONTAL;
				}
				
				if( node.currentAspectRatio < node.expectedAspectRatio / treshhold )
				{
					node.split = InternalNode.VERTICAL;
				}
				
				if( node.split == InternalNode.VERTICAL )
				{
					node.leftChild.expectedAspectRatio = node.expectedAspectRatio / 2;
					node.rightChild.expectedAspectRatio = node.leftChild.expectedAspectRatio;
				}
				else
				{
					node.leftChild.expectedAspectRatio = node.expectedAspectRatio * 2;
					node.rightChild.expectedAspectRatio = node.leftChild.expectedAspectRatio;
				}
				adjustTree( node.leftChild, treshhold );
				adjustTree( node.rightChild, treshhold );
			}
		}
		
		private function getExpectedAspectRatioLeaf():LeafNode
		{
			var i:uint;
			var length:uint;
			
			for( length = _sortedLeafs.length; i < length; i++ )
			{
				if( _expectedAspectRatioRange.inRange( _sortedLeafs[i].expectedAspectRatio ) )
				{
					return _sortedLeafs.splice( i, 1 )[0];
				}
			}
			
			return _sortedLeafs.splice( 0, 1 )[0];
		}
		
		private function getExpectedAspectRatioLeafPair():Vector.<LeafNode>
		{
			var i:int;
			var j:int;
			var front:int;
			var rear:int = _sortedLeafs.length - 1;
			var arExp:Number = _expectedAspectRatioRange.median;
			var arExpI:Number = _sortedLeafs[front].currentAspectRatio;
			var arExpJ:Number = _sortedLeafs[rear].currentAspectRatio;
			var minDiff:Number = Math.abs( arExpI + arExpJ - arExp );
			
			while( front <= rear )
			{
				arExpI = _sortedLeafs[front].currentAspectRatio;
				arExpJ = _sortedLeafs[rear].currentAspectRatio;
				if( arExpI + arExpJ > arExp )
				{
					if( Math.abs( arExpI + arExpJ - arExp ) < minDiff )
					{
						minDiff = Math.abs( arExpI + arExpJ - arExp );
						i = front;
						j = rear;
					}
					rear--;
				}
				else if( arExpI + arExpJ < arExp )
				{
					if( Math.abs( arExpI + arExpJ - arExp ) < minDiff )
					{
						minDiff = Math.abs( arExpI + arExpJ - arExp );
						i = front;
						j = rear;
					}
					front++;
				}
				else
				{
					i = front;
					j = rear;
				}
			}
			
			var result:Vector.<LeafNode> = _sortedLeafs.splice( j, 1 );
			result = result.concat( _sortedLeafs.splice( i, 1 ) );
			
			return result;
		}
		
		private function calculateAspectRatio( node:INode ):Number
		{
			if( node.type == Node.INTERNAL_NODE )
			{
				var leftAR:Number = calculateAspectRatio( node.leftChild );
				var rightAR:Number = calculateAspectRatio( node.rightChild );
				
				if( node.split == InternalNode.VERTICAL )
				{
					node.currentAspectRatio = leftAR + rightAR;
				}
				else
				{
					node.currentAspectRatio = ( leftAR * rightAR ) / ( leftAR + rightAR );
				}
			}
			return node.currentAspectRatio;
		}
		
		private function calculatePosition( node:INode ):void
		{
			node.leftChild && calculatePositions( node.leftChild, true );
			node.rightChild && calculatePositions( node.rightChild, false );
			
			node.leftChild && calculatePosition( node.leftChild );
			node.rightChild && calculatePosition( node.rightChild );
		}
		
		private function calculatePositions( node:INode, isLeft:Boolean ):void
		{
			if( node.parent.split == InternalNode.VERTICAL )
			{
				node.height = node.parent.height;
				node.width = node.height * node.currentAspectRatio;
			}
			else
			{
				node.width = node.parent.width;
				node.height = node.width / node.currentAspectRatio;
			}
			
			if( isLeft )
			{
				node.x = node.parent.x;
				node.y = node.parent.y;
			}
			else
			{
				if( node.parent.split == InternalNode.VERTICAL )
				{
					node.x = node.parent.x + node.parent.width - node.width;
					node.y = node.parent.y;
				}
				else
				{
					node.x = node.parent.x;
					node.y = node.parent.y + node.parent.height - node.height;
				}
			}
		}
	}
}

interface INode
{
	function get type():uint;
	
	function get x():int;
	function set x( value:int ):void;
	function get y():int;
	function set y( value:int ):void;
	function get width():int;
	function set width( value:int ):void;
	function get height():int;
	function set height( value:int ):void;
	
	function get currentAspectRatio():Number;
	function set currentAspectRatio(value:Number ):void;
	function get expectedAspectRatio():Number;
	function set expectedAspectRatio( value:Number ):void;
	function get leftChild():INode;
	function set leftChild( value:INode ):void;
	function get rightChild():INode;
	function set rightChild( value:INode ):void;
	function get parent():INode;
	function set parent( value:INode ):void;
	
	function get numImages():uint;
	function set numImages( value:uint ):void;
	
	function get split():String;
	function set split( value:String ):void;
}

class Node implements INode
{
	public static const INTERNAL_NODE:uint = 1;
	public static const LEAF_NODE:uint = 2;
	
	private var _split:String;
	private var _currentAspectRatio:Number;
	private var _expectedAspectRatio:Number;
	private var _width:int;
	private var _height:int;
	private var _x:int;
	private var _y:int;
	private var _leftChild:INode;
	private var _rightChild:INode;
	private var _parent:INode;
	private var _numImages:uint;

	public function get split():String
	{
		return _split;
	}

	public function set split(value:String):void
	{
		_split = value;
	}

	public function get currentAspectRatio():Number
	{
		return _currentAspectRatio;
	}

	public function set currentAspectRatio(value:Number):void
	{
		_currentAspectRatio = value;
	}

	public function get expectedAspectRatio():Number
	{
		return _expectedAspectRatio;
	}

	public function set expectedAspectRatio(value:Number):void
	{
		_expectedAspectRatio = value;
	}

	public function get width():int
	{
		return _width;
	}

	public function set width(value:int):void
	{
		_width = value;
	}

	public function get height():int
	{
		return _height;
	}

	public function set height(value:int):void
	{
		_height = value;
	}

	public function get x():int
	{
		return _x;
	}

	public function set x(value:int):void
	{
		_x = value;
	}

	public function get y():int
	{
		return _y;
	}

	public function set y(value:int):void
	{
		_y = value;
	}

	public function get leftChild():INode
	{
		return _leftChild;
	}

	public function set leftChild(value:INode):void
	{
		_leftChild = value;
	}

	public function get rightChild():INode
	{
		return _rightChild;
	}

	public function set rightChild(value:INode):void
	{
		_rightChild = value;
	}

	public function get parent():INode
	{
		return _parent;
	}

	public function set parent(value:INode):void
	{
		_parent = value;
	}
	
	public function get type():uint
	{
		return 0;
	}

	public function get numImages():uint
	{
		return _numImages;
	}

	public function set numImages(value:uint):void
	{
		_numImages = value;
	}

}

class InternalNode extends Node
{
	public static const VERTICAL:String = "vertical";
	public static const HORIZONTAL:String = "horizontal";
	
	override public function get type():uint
	{
		return Node.INTERNAL_NODE;
	}
}

class LeafNode extends Node
{
	override public function get type():uint
	{
		return Node.LEAF_NODE;
	}
}