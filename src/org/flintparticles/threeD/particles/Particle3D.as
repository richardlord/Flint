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

package org.flintparticles.threeD.particles
{
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.particles.ParticleFactory;
	import org.flintparticles.threeD.geom.Point3D;
	import org.flintparticles.threeD.geom.Quaternion;
	import org.flintparticles.threeD.geom.Vector3D;	

	/**
	 * The Particle3D class extends the Particle class to include state properties 
	 * that are relevant to particles in 3D space.
	 */
	public class Particle3D extends Particle
	{
		/**
		 * The position of the particle (in the renderer's units).
		 */
		public var position:Point3D;
		/**
		 * The velocity of the particle (in the renderer's units per second).
		 */
		public var velocity:Vector3D;
		
		/**
		 * The rotation of the particle, represented as a unit quaternion.
		 */
		public var rotation:Quaternion;
		
		/**
		 * The rate of rotation of the particle, represented as a vector in the direction of 
		 * the axis of rotation and whose magnitude indicates the number of rotations per second.
		 */
		public var angVelocity:Vector3D;
		
		/**
		 * The axis in the particle's own coordinate space that
		 * indicates the direction that the particle is facing.
		 */
		public var faceAxis:Vector3D;

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
				_inertia = mass * collisionRadius * collisionRadius * 0.4;
				_previousMass = mass;
				_previousRadius = collisionRadius;
			}
			return _inertia;
		}

		/**
		 * The position of the particle in the emitter's x-axis spacial sorted array
		 */
		public var sortID:int = -1;
		
		/**
		 * Position vector projected into screen space. Used by renderers.
		 */
		public var projectedPosition:Point3D;
		
		/**
		 * z depth of particle in renderer's camera space
		 */
		public var zDepth:Number = 0;
		
		/**
		 * Creates a Particle3D. Alternatively particles can be reused by using an
		 * instance of the Particle3DCreator class to create them. Usually the 
		 * emitter will create the particles and the user doesn't need to create 
		 * them.
		 */
		public function Particle3D()
		{
			super();
			position = new Point3D( 0, 0, 0 );
			projectedPosition = new Point3D( 0, 0, 0 );
			faceAxis = new Vector3D( 1, 0, 0 );
			velocity = new Vector3D( 0, 0, 0 );
			rotation = new Quaternion( 1, 0, 0, 0 );
			angVelocity = new Vector3D( 0, 0, 0 );
		}
		
		/**
		 * Sets the particles properties to their default values.
		 */
		override public function initialize():void
		{
			super.initialize();
			position.reset( 0, 0, 0 );
			projectedPosition.reset( 0, 0, 0 );
			faceAxis.reset( 1, 0, 0 );
			velocity.reset( 0, 0, 0 );
			rotation.reset( 1, 0, 0 );
			angVelocity.reset( 0, 0, 0 );
			sortID = -1;
			zDepth = 0;
		}

		/**
		 * @inheritDoc
		 */
		override public function clone( factory:ParticleFactory = null ):Particle
		{
			var p:Particle3D;
			if( factory )
			{
				p = factory.createParticle() as Particle3D;
			}
			else
			{
				p = new Particle3D();
			}
			cloneInto( p );
			p.position = position.clone();
			p.projectedPosition = projectedPosition.clone();
			p.faceAxis = faceAxis.clone();
			p.velocity = velocity.clone();
			p.rotation = rotation.clone();
			p.angVelocity = angVelocity.clone();
			p.zDepth = zDepth;
			return p;
		}
	}
}
