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
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.particles.Particle2D;	

	/**
	 * The MatchRotateVelocity action applies an angular acceleration to each 
	 * particle to match its angular velocity to that of its nearest neighbours.
	 * 
	 * <p>This action has a priority of 10, so that it executes 
	 * before other actions.</p>
	 */

	public class MatchRotateVelocity extends ActionBase
	{
		private var _max:Number;
		private var _maxSq:Number;
		private var _acc:Number;
		
		/**
		 * The constructor creates a MatchRotateVelocity action for use by an 
		 * emitter. To add a MatchRotateVelocity to all particles created by an 
		 * emitter, use the emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param maxDistance The maximum distance, in pixels, over which this 
		 * action operates. The particle will match its angular velocity to other 
		 * particles that are at most this close to it.
		 * @param acceleration The angular acceleration applied to adjust the
		 * angular velocity to match that of the other particles.
		 */
		public function MatchRotateVelocity( maxDistance:Number = 0, acceleration:Number = 0 )
		{
			priority = 10;
			this.maxDistance = maxDistance;
			this.acceleration = acceleration;
		}
		
		/**
		 * The maximum distance, in pixels, over which this action operates.
		 * The particle will match its angular velocity other particles that are 
		 * at most this close to it.
		 */
		public function get maxDistance():Number
		{
			return _max;
		}
		public function set maxDistance( value:Number ):void
		{
			_max = value;
			_maxSq = value * value;
		}
		
		/**
		 * The angular acceleration applied to adjust the angular velocity to 
		 * match that of the other particles.
		 */
		public function get acceleration():Number
		{
			return _acc;
		}
		public function set acceleration( value:Number ):void
		{
			_acc = value;
		}

		/**
		 * Instructs the emitter to produce a sorted particle array for optimizing
		 * the calculations in the update method of this action.
		 * 
		 * @param emitter The emitter this action has been added to.
		 * 
		 * @see org.flintparticles.common.actions.Action#addedToEmitter()
		 */
		override public function addedToEmitter( emitter:Emitter ) : void
		{
			Emitter2D( emitter ).spaceSort = true;
		}
		
		/**
		 * Checks all particles near the current particle and applies the 
		 * angular acceleration to alter the particle's angular velocity
		 * towards their average angular velocity.
		 * 
		 * <p>This method is called by the emitter and need not be called by the 
		 * user.</p>
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
			var e:Emitter2D = Emitter2D( emitter );
			var particles:Array = e.particles;
			var sortedX:Array = e.spaceSortedX;
			var other:Particle2D;
			var i:int;
			var len:int = particles.length;
			var distanceSq:Number;
			var dx:Number;
			var dy:Number;
			var vel:Number = 0;
			var count:int = 0;
			var factor:Number;
			for( i = p.sortID - 1; i >= 0; --i )
			{
				other = particles[sortedX[i]];
				if( ( dx = p.x - other.x ) > _max ) break;
				dy = other.y - p.y;
				if( dy > _max || dy < -_max ) continue;
				distanceSq = dy * dy + dx * dx;
				if( distanceSq <= _maxSq )
				{
					vel += other.angVelocity;
					++count;
				}
			}
			for( i = p.sortID + 1; i < len; ++i )
			{
				other = particles[sortedX[i]];
				if( ( dx = other.x - p.x ) > _max ) break;
				dy = other.y - p.y;
				if( dy > _max || dy < -_max ) continue;
				distanceSq = dy * dy + dx * dx;
				if( distanceSq <= _maxSq )
				{
					vel += other.angVelocity;
					++count;
				}
			}
			if( count != 0 )
			{
				vel = vel / count - p.angVelocity;
				if( vel != 0 )
				{
					var velSign:Number = 1;
					if( vel < 0 )
					{
						velSign = -1;
						vel = -vel;
					}
					factor = time * _acc;
					if( factor > vel ) factor = vel;
					p.angVelocity += factor * velSign;
				}
			}
		}
	}
}
