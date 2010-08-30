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
	 * The DeathSpeed action marks the particle as dead if it is travelling faster 
	 * than the specified speed. The behaviour can be switched to instead mark as 
	 * dead particles travelling slower than the specified speed.
	 */

	public class DeathSpeed extends ActionBase
	{
		private var _limit:Number;
		private var _limitSq:Number;
		private var _isMinimum:Boolean;
		
		/**
		 * The constructor creates a DeathSpeed action for use by an emitter. 
		 * To add a DeathSpeed to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param speed The speed limit for the action in pixels per second.
		 * @param isMinimum If true, particles travelling slower than the speed limit
		 * are killed, otherwise particles travelling faster than the speed limit are
		 * killed.
		 */
		public function DeathSpeed( speed:Number = Number.MAX_VALUE, isMinimum:Boolean = false )
		{
			this.limit = speed;
			this.isMinimum = isMinimum;
		}
		
		/**
		 * The speed limit beyond which the particle dies.
		 */
		public function get limit():Number
		{
			return _limit;
		}
		public function set limit( value:Number ):void
		{
			_limit = value;
			_limitSq = value * value;
		}
		
		/**
		 * Whether the speed is a minimum (true) or maximum (false) speed.
		 */
		public function get isMinimum():Boolean
		{
			return _isMinimum;
		}
		public function set isMinimum( value:Boolean ):void
		{
			_isMinimum = value;
		}
		
		/**
		 * Checks the particle's speed and marks it as dead if it is moving faster 
		 * than the speed limit, if this is a mximum speed limit, or slower if 
		 * this is a minimum speed limit.
		 * 
		 * <p>This method is called by the emitter and need not be called by the 
		 * user</p>
		 * 
		 * @param emitter The Emitter that created the particle.
		 * @param particle The particle to be updated.
		 * @param time The duration of the frame - used for time based updates.
		 * 
		 * @see org.flintparticles.common.actions.Action#update()
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var p:Particle2D = Particle2D( particle );
			var speedSq:Number = p.velX * p.velX + p.velY * p.velY;
			if ( ( _isMinimum && speedSq < _limitSq ) || ( !_isMinimum && speedSq > _limitSq ) )
			{
				p.isDead = true;
			}
		}
	}
}
