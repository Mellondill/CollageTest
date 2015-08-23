package com.mellondill.collagetest.service
{
	import com.mellondill.collagetest.model.vo.ImageVO;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.robotlegs.mvcs.Actor;
	
	public class MultiImageSmartLayoutService extends Actor
	{
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
			
			tree = createTree( leafs, true );
			calculateAspectRatio( tree );
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
		
		private function createTree( images:Vector.<LeafNode>, splitV:Boolean ):INode
		{
			var count:uint = images.length;
			var node:INode;
			
			if( count >= 2 )
			{
				var left:Vector.<LeafNode> = ( new Vector.<LeafNode> ).concat( images );
				var right:Vector.<LeafNode> = left.splice( 0, count >> 1 );
				
				node = new InternalNode();
				
				node.split = splitV ? InternalNode.VERTICAL : InternalNode.HORIZONTAL;
				
				node.leftChild = createTree( left, !splitV );
				node.rightChild = createTree( right, !splitV );
				
				node.leftChild.parent = node;
				node.rightChild.parent = node;
			}
			else if( count == 1 )
			{
				node = images.pop();
			}
			
			return node;
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