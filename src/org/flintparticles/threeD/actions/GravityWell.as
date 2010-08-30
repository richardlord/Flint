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

package org.flintparticles.threeD.actions 
{
	import org.flintparticles.common.actions.ActionBase;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.threeD.geom.Point3D;
	import org.flintparticles.threeD.geom.Vector3D;
	import org.flintparticles.threeD.particles.Particle3D;	

	/**
	 * The GravityWell action applies a force on the particle to draw it towards
	 * a single point. The force applied is inversely proportional to the square
	 * of the distance from the particle to the point.
	 */

	public class GravityWell extends ActionBase
	{
		private var _position:Point3D;
		private var _power:Number;
		private var _epsilonSq:Number;
		private var _gravityConst:Number = 10000; // just scales the power to a more reasonable number
		
		/**
		 * The constructor creates a GravityWell action for use by 
		 * an emitter. To add a GravityWell to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param power The strength of the force - larger numbers produce a stringer force.
		 * @param position The point towards which the force draws the particles.
		 * @param epsilon The minimum distance for which gravity is calculated. Particles closer
		 * than this distance experience a gravity force as it they were this distance away.
		 * This stops the gravity effect blowing up as distances get small. For realistic gravity 
		 * effects you will want a small epsilon ( ~1 ), but for stable visual effects a larger
		 * epsilon (~100) is often better.
		 */
		public function GravityWell( power:Number = 0, position:Point3D = null, epsilon:Number = 100 )
		{
			this.power = power;
			this.position = position ? position : Point3D.ZERO;
			this.epsilon = epsilon;
		}
		
		/**
		 * The strength of the gravity force.
		 */
		public function get power():Number
		{
			return _power / _gravityConst;
		}
		public function set power( value:Number ):void
		{
			_power = value * _gravityConst;
		}
		
		/**
		 * The x coordinate of the center of the gravity force.
		 */
		public function get position():Point3D
		{
			return _position;
		}
		public function set position( value:Point3D ):void
		{
			_position = value.clone();
		}
		
		/**
		 * The x coordinate of the point that the force pulls the particles towards.
		 */
		public function get x():Number
		{
			return _position.x;
		}
		public function set x( value:Number ):void
		{
			_position.x = value;
		}
		
		/**
		 * The y coordinate of the point that the force pulls the particles towards.
		 */
		public function get y():Number
		{
			return _position.y;
		}
		public function set y( value:Number ):void
		{
			_position.y = value;
		}
		
		/**
		 * The z coordinate of the point that the force pulls the particles towards.
		 */
		public function get z():Number
		{
			return _position.z;
		}
		public function set z( value:Number ):void
		{
			_position.z = value;
		}
		
		/**
		 * The minimum distance for which the gravity force is calculated. 
		 * Particles closer than this distance experience the gravity as it they were 
		 * this distance away. This stops the gravity effect blowing up as distances get 
		 * small.
		 */
		public function get epsilon():Number
		{
			return Math.sqrt( _epsilonSq );
		}
		public function set epsilon( value:Number ):void
		{
			_epsilonSq = value * value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			if( particle.mass == 0 )
			{
				return;
			}
			var p:Particle3D = Particle3D( particle );
			var offset:Vector3D = p.position.vectorTo( _position );
			var dSq:Number = offset.lengthSquared;
			if( dSq == 0 )
			{
				return;
			}
			var d:Number = Math.sqrt( dSq );
			if( dSq < _epsilonSq ) dSq = _epsilonSq;
			var factor:Number = ( _power * time ) / ( dSq * d );
			p.velocity.incrementBy( offset.scaleBy( factor ) );
		}
	}
}
