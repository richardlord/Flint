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

package org.flintparticles.twoD.particles
{
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.particles.ParticleFactory;
	
	import flash.geom.Matrix;	

	/**
	 * The Particle class is a set of public properties shared by all particles.
	 * It is deliberately lightweight, with only one method. The Initializers
	 * and Actions modify these properties directly. This means that the same
	 * particles can be used in many different emitters, allowing Particle 
	 * objects to be reused.
	 * 
	 * Particles are usually created by the ParticleCreator class. This class
	 * just simplifies the reuse of Particle objects which speeds up the
	 * application. 
	 */
	public class Particle2D extends Particle
	{
		/**
		 * The x coordinate of the particle in pixels.
		 */
		public var x:Number = 0;
		/**
		 * The y coordinate of the particle in pixels.
		 */
		public var y:Number = 0;
		/**
		 * The x coordinate of the particle prior to the latest update.
		 */
		public var previousX:Number = 0;
		/**
		 * The y coordinate of the particle prior to the latest update.
		 */
		public var previousY:Number = 0;
		/**
		 * The x coordinate of the velocity of the particle in pixels per second.
		 */
		public var velX:Number = 0;
		/**
		 * The y coordinate of the velocity of the particle in pixels per second.
		 */
		public var velY:Number = 0;
		
		/**
		 * The rotation of the particle in radians.
		 */
		public var rotation:Number = 0;
		/**
		 * The angular velocity of the particle in radians per second.
		 */
		public var angVelocity:Number = 0;

		private var _previousMass:Number;
		private var _previousRadius:Number;
		private var _inertia:Number;
		
		/**
		 * The moment of inertia of the particle about its center point
		 */
		public function get inertia():Number
		{
			if( mass != _previousMass || collisionRadius != _previousRadius )
			{
				_inertia = mass * collisionRadius * collisionRadius * 0.5;
				_previousMass = mass;
				_previousRadius = collisionRadius;
			}
			return _inertia;
		}

		/**
		 * The position in the emitter's horizontal spacial sorted array
		 */
		public var sortID:int = -1;
		
		/**
		 * Creates a particle. Alternatively particles can be reused by using the ParticleCreator to create
		 * and manage them. Usually the emitter will create the particles and the user doesn't need
		 * to create them.
		 */
		public function Particle2D()
		{
			super();
		}
		
		/**
		 * Sets the particles properties to their default values.
		 */
		override public function initialize():void
		{
			super.initialize();
			x = 0;
			y = 0;
			previousX = 0;
			previousY = 0;
			velX = 0;
			velY = 0;
			rotation = 0;
			angVelocity = 0;
			sortID = -1;
		}
		
		/**
		 * A transformation matrix for the position, scale and rotation of the particle.
		 */
		public function get matrixTransform():Matrix
		{
			var cos:Number = scale * Math.cos( rotation );
			var sin:Number = scale * Math.sin( rotation );
			return new Matrix( cos, sin, -sin, cos, x, y );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone( factory:ParticleFactory = null ):Particle
		{
			var p:Particle2D;
			if( factory )
			{
				p = factory.createParticle() as Particle2D;
			}
			else
			{
				p = new Particle2D();
			}
			cloneInto( p );
			p.x = x;
			p.y = y;
			p.velX = velX;
			p.velY = velY;
			p.rotation = rotation;
			p.angVelocity = angVelocity;
			return p;
		}
	}
}
