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

	/**
	 * The CollisionRadiusInit Initializer sets the collision radius of the particle.
	 * During collisions the particle is treated as a sphere (3D) or circle (2D), regardless of its actual
	 * shape. This sets the size of that sphere or circle.
	 */

	public class CollisionRadiusInit extends InitializerBase
	{
		private var _radius:Number;
		
		/**
		 * The constructor creates a CollisionRadiusInit initializer for use by 
		 * an emitter. To add a CollisionRadiusInit to all particles created by an emitter, use the
		 * emitter's addInitializer method.
		 * 
		 * @param radius The collision radius for particles
		 * initialized by the instance.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer().
		 */
		public function CollisionRadiusInit( radius:Number= 1 )
		{
			_radius = radius;
		}
		
		/**
		 * The collision radius for particles
		 * initialized by the instance.
		 */
		public function get radius():Number
		{
			return _radius;
		}
		public function set radius( value:Number ):void
		{
			_radius = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			particle.collisionRadius = _radius;
		}
	}
}
