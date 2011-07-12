/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2011
 * http://flintparticles.org
 * 
 * 
 * Licence Agreement
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package org.flintparticles.common.initializers 
{
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.utils.WeightedArray;
	import org.flintparticles.common.utils.construct;

	/**
	 * The ImageClasses Initializer sets the DisplayObject to use to draw
	 * the particle. It selects one of multiple images that are passed to it.
	 * It is used with the DisplayObjectRenderer. When using the
	 * BitmapRenderer it is more efficient to use the SharedImage Initializer.
	 * 
	 * <p>This class includes an object pool for reusing DisplayObjects when particles die.</p>
	 */
	public class ImageClasses extends ImageInitializerBase
	{
		private var _images:WeightedArray;
		private var _mxmlImages:Array;
		private var _mxmlWeights:Array;
		
		/**
		 * The constructor creates a ImageClasses initializer for use by 
		 * an emitter. To add a ImageClasses to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param images An array containing the classes to use for 
		 * each particle created by the emitter. Each item in the array may be a class or an array 
		 * containing a class and a number of parameters to pass to the constructor.
		 * @param weights The weighting to apply to each displayObject. If no weighting
		 * values are passed, the images are used with equal probability.
		 * @param usePool Indicates whether particles should be reused when a particle dies.
		 * @param fillPool Indicates how many particles to create immediately in the pool, to
		 * avoid creating them when the particle effect is running.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function ImageClasses( images:Array = null, weights:Array = null, usePool:Boolean = false, fillPool:uint = 0 )
		{
			super( usePool );
			_images = new WeightedArray();
			if( images == null )
			{
				return;
			}
			init( images, weights );
			if( fillPool > 0 )
			{
				this.fillPool( fillPool );
			}
			
		}
		
		override public function addedToEmitter( emitter:Emitter ):void
		{
			super.addedToEmitter( emitter );
			if( _mxmlImages )
			{
				init( _mxmlImages, _mxmlWeights );
				_mxmlImages = null;
				_mxmlWeights = null;
			}
		}
		
		private function init( images:Array = null, weights:Array = null ):void
		{
			_images.clear();
			var len:int = images.length;
			var i:int;
			if( weights != null && weights.length == len )
			{
				for( i = 0; i < len; ++i )
				{
					addImage( images[i], weights[i] );
				}
			}
			else
			{
				for( i = 0; i < len; ++i )
				{
					addImage( images[i], 1 );
				}
			}
		}
		
		public function addImage( image:*, weight:Number = 1 ):void
		{
			if( image is Array )
			{
				var parameters:Array = ( image as Array ).concat();
				var img:Class = parameters.shift();
				_images.add( new Pair( img, parameters ), weight );
			}
			else
			{
				_images.add( new Pair( image, [] ), weight );
			}
			if( _usePool )
			{
				clearPool();
			}
		}
		
		public function removeImage( image:* ):void
		{
			_images.remove( image );
			if( _usePool )
			{
				clearPool();
			}
		}

		public function set images( value:Array ):void
		{
			_mxmlImages = value;
			checkStartValues();
			if( _usePool )
			{
				clearPool();
			}
		}
		
		public function set weights( value:Array ):void
		{
			if( value.length == 1 && value[0] is String )
			{
				_mxmlWeights = String( value[0] ).split( "," );
			}
			else
			{
				_mxmlWeights = value;
			}
			checkStartValues();
			if( _usePool )
			{
				clearPool();
			}
		}
		
		private function checkStartValues():void
		{
			if( _mxmlImages && _mxmlWeights )
			{
				init( _mxmlImages, _mxmlWeights );
				_mxmlImages = null;
				_mxmlWeights = null;
			}
		}

		/**
		 * Used internally, this method creates an image object for displaying the particle 
		 * by calling the constructor of one of the supplied image classes.
		 */
		override public function createImage() : Object
		{
			var img:Pair = _images.getRandomValue();
			return construct( img.image, img.parameters );
		}
	}
}
class Pair
{
	internal var image:Class;
	internal var parameters:Array;
	
	public function Pair( image:Class, parameters:Array )
	{
		this.image = image;
		this.parameters = parameters;
	}
}
