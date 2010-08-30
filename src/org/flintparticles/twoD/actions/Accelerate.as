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

package org.flintparticles.twoD.actions 
{
	import org.flintparticles.common.actions.ActionBase;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.twoD.particles.Particle2D;	

	/**
	 * The Accelerate Action adjusts the velocity of each particle by a 
	 * constant acceleration. This can be used, for example, to simulate
	 * gravity.
	 */
	public class Accelerate extends ActionBase
	{
		private var _x:Number;
		private var _y:Number;
		
		/**
		 * The constructor creates an Acceleration action for use by an emitter. 
		 * To add an Accelerator to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param accelerationX The x coordinate of the acceleration to apply, in
		 * pixels per second per second.
		 * @param accelerationY The y coordinate of the acceleration to apply, in 
		 * pixels per second per second.
		 */
		public function Accelerate( accelerationX:Number = 0, accelerationY:Number = 0 )
		{
			this.x = accelerationX;
			this.y = accelerationY;
		}
		
		/**
		 * The x coordinate of the acceleration, in
		 * pixels per second per second.
		 */
		public function get x():Number
		{
			return _x;
		}
		public function set x( value:Number ):void
		{
			_x = value;
		}
		
		/**
		 * The y coordinate of the acceleration, in
		 * pixels per second per second.
		 */
		public function get y():Number
		{
			return _y;
		}
		public function set y( value:Number ):void
		{
			_y = value;
		}
		
		/**
		 * Applies the acceleration to a particle for the specified time period.
		 * 
		 * <p>This method is called by the emitter and need not be called by the 
		 * user</p>
		 * 
		 * @param emitter The Emitter that created the particle.
		 * @param particle The particle to be updated.
		 * @param time The duration of the frame.
		 * 
		 * @see org.flintparticles.common.actions.Action#update()
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var p:Particle2D = Particle2D( particle );
			p.velX += _x * time;
			p.velY += _y * time;
		}
	}
}
