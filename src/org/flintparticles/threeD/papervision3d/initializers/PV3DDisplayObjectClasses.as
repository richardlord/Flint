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

package org.flintparticles.threeD.papervision3d.initializers
{
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.initializers.InitializerBase;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.utils.WeightedArray;
	import org.flintparticles.common.utils.construct;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.primitives.Plane;
	
	import flash.display.DisplayObject;	

	/**
	 * The ImageClass Initializer sets the DisplayObject to use to draw
	 * the particle. It is used with the DisplayObjectRenderer. When using the
	 * BitmapRenderer it is more efficient to use the SharedImage Initializer.
	 */

	public class PV3DDisplayObjectClasses extends InitializerBase
	{
		private var _images:WeightedArray;
		
		/**
		 * The constructor creates a ImageClasses initializer for use by 
		 * an emitter. To add a ImageClasses to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param images An array containing the classes to use for 
		 * each particle created by the emitter.
		 * @param weights The weighting to apply to each displayObject. If no weighting
		 * values are passed, the images are used with equal probability.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function PV3DDisplayObjectClasses( images:Array, weights:Array = null )
		{
			_images = new WeightedArray;
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
		}
		
		public function removeImage( image:* ):void
		{
			_images.remove( image );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			var img:Pair = _images.getRandomValue();
			var clip:DisplayObject = construct( img.image, img.parameters );
			var material:MovieMaterial = new MovieMaterial( clip, true, true, false, clip.getBounds( clip ) );
			particle.image = new Plane( material, clip.width, clip.height );
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