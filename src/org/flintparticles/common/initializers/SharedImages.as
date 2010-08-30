/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2010
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
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.utils.WeightedArray;	

	[DefaultProperty("images")]
	
	/**
	 * The SharedImages Initializer sets the DisplayObject to use to draw
	 * the particle. It selects one of multiple images that are passed to it.
	 * It is used with the BitmapRenderer. When using the
	 * DisplayObjectRenderer the ImageClass Initializer must be used.
	 * 
	 * With the BitmapRenderer, the DisplayObject is copied into the bitmap
	 * using the particle's property to place the image correctly. So
	 * many particles can share the same DisplayObject because it is
	 * only indirectly used to display the particle.
	 */

	public class SharedImages extends InitializerBase
	{
		private var _images:WeightedArray;
		private var _mxmlImages:Array;
		private var _mxmlWeights:Array;
		
		/**
		 * The constructor creates a SharedImages initializer for use by 
		 * an emitter. To add a SharedImages to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param images An array containing the DisplayObjects to use for 
		 * each particle created by the emitter.
		 * @param weights The weighting to apply to each displayObject. If no weighting
		 * values are passed, the images are used with equal probability.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function SharedImages( images:Array = null, weights:Array = null )
		{
			_images = new WeightedArray();
			if( images == null )
			{
				return;
			}
			init( images, weights );
		}
		
		override public function addedToEmitter( emitter:Emitter ):void
		{
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
					_images.add( images[i], weights[i] );
				}
			}
			else
			{
				for( i = 0; i < len; ++i )
				{
					_images.add( images[i], 1 );
				}
			}
		}
		
		public function addImage( image:*, weight:Number = 1 ):void
		{
			_images.add( image, weight );
		}
		
		public function removeImage( image:* ):void
		{
			_images.remove( image );
		}
		
		public function set images( value:Array ):void
		{
			_mxmlImages = value;
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
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			particle.image = _images.getRandomValue();
		}
	}
}
