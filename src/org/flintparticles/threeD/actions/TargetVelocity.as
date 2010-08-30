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
	import org.flintparticles.threeD.geom.Vector3D;
	import org.flintparticles.threeD.particles.Particle3D;	

	/**
	 * The TargetVelocity action adjusts the velocity of the particle towards the target velocity.
	 */
	public class TargetVelocity extends ActionBase
	{
		private var _vel:Vector3D;
		private var _rate:Number;
		private var _temp:Vector3D;
		
		/**
		 * The constructor creates a TargetVelocity action for use by 
		 * an emitter. To add a TargetVelocity to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param velX The x coordinate of the target velocity, in pixels per second.
		 * @param velY The y coordinate of the target velocity, in pixels per second.
		 * @param rate Adjusts how quickly the particle reaches the target velocity.
		 * Larger numbers cause it to approach the target velocity more quickly.
		 */
		public function TargetVelocity( targetVelocity:Vector3D = null, rate:Number = 0.1 )
		{
			_temp = new Vector3D();
			this.targetVelocity = targetVelocity ? targetVelocity : Vector3D.ZERO;
			this.rate = rate;
		}
		
		/**
		 * The x coordinate of the target velocity, in pixels per second.s
		 */
		public function get targetVelocity():Vector3D
		{
			return _vel;
		}
		public function set targetVelocity( value:Vector3D ):void
		{
			_vel = value.clone();
		}
		
		/**
		 * Adjusts how quickly the particle reaches the target angular velocity.
		 * Larger numbers cause it to approach the target angular velocity more quickly.
		 */
		public function get rate():Number
		{
			return _rate;
		}
		public function set rate( value:Number ):void
		{
			_rate = value;
		}
		
		/**
		 * The x coordinate of the target velocity.
		 */
		public function get x():Number
		{
			return _vel.x;
		}
		public function set x( value:Number ):void
		{
			_vel.x = value;
		}
		
		/**
		 * The y coordinate of  the target velocity.
		 */
		public function get y():Number
		{
			return _vel.y;
		}
		public function set y( value:Number ):void
		{
			_vel.y = value;
		}
		
		/**
		 * The z coordinate of the target velocity.
		 */
		public function get z():Number
		{
			return _vel.z;
		}
		public function set z( value:Number ):void
		{
			_vel.z = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var p:Particle3D = Particle3D( particle );
			p.velocity.incrementBy( _vel.subtract( p.velocity, _temp ).scaleBy( _rate * time ) );
		}
	}
}
