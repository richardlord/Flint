/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord & Michael Ivanov
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

package org.flintparticles.integration.away3d.v4.initializers
{
	import away3d.core.base.Object3D;

	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.initializers.InitializerBase;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.utils.WeightedArray;
	
	/**
	 * The A3D4CloneObjects Initializer sets the 3D Object to use 
	 * to draw the particle in a 3D scene. It selects one of multiple objects 
	 * that are passed to it and calls the clone method of the object to create
	 * the particle object. It is used with the Away3D 4 renderer when
	 * particles should be represented by a 3D object.
	 * 
	 * @see org.flintparticles.common.Initializers.SetImageProperties
	 */
	public class A3D4CloneObjects extends InitializerBase
	{
		private var _objects:WeightedArray;
		
		/**
		 * The constructor creates an A3D4CloneObjects initializer for use by 
		 * an emitter. To add an A3D4CloneObjects to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param objects An array containing the Object3Ds to use for 
		 * each particle created by the emitter.
		 * @param weights The weighting to apply to each Object3D. If no weighting
		 * values are passed, the images are used with equal probability.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function A3D4CloneObjects( objects:Array = null, weights:Array = null )
		{
			_objects = new WeightedArray();
			if( objects == null )
			{
				return;
			}
			var len:int = objects.length;
			var i:int;
			if( weights != null && weights.length == len )
			{
				for( i = 0; i < len; ++i )
				{
					_objects.add( objects[i], weights[i] );
				}
			}
			else
			{
				for( i = 0; i < len; ++i )
				{
					_objects.add( objects[i], 1 );
				}
			}
		}
		
		public function addObject( object:Object3D, weight:Number = 1 ):void
		{
			_objects.add( object, weight );
		}
		
		public function removeObject( object:Object3D ):void
		{
			_objects.remove( object );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			particle.image = Object3D( _objects.getRandomValue() ).clone();
		}
	}
}
