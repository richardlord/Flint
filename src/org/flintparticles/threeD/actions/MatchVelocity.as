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
	import org.flintparticles.threeD.emitters.Emitter3D;
	import org.flintparticles.threeD.geom.Vector3D;
	import org.flintparticles.threeD.particles.Particle3D;	

	/**
	 * The MatchVelocity action applies an acceleration to the particle to match
	 * its velocity to that of its nearest neighbours.
	 * 
	 * <p>This action has a priority of 10, so that it executes 
	 * before other actions.</p>
	 */

	public class MatchVelocity extends ActionBase
	{
		private var _max:Number;
		private var _acc:Number;
		private var _maxSq:Number;
		
		/*
		 * Temporary variables created as class members to avoid creating new objects all the time
		 */
		private var d:Vector3D;
		private var vel:Vector3D;

		/**
		 * The constructor creates a MatchVelocity action for use by 
		 * an emitter. To add a MatchVelocity to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param maxDistance The maximum distance, in pixels, over which this action operates.
		 * The particle will match its velocity other particles that are this close or closer to it.
		 * @param acceleration The acceleration force applied to adjust velocity to match that
		 * of the other particles.
		 */
		public function MatchVelocity( maxDistance:Number = 0, acceleration:Number = 0 )
		{
			priority = 10;
			d = new Vector3D();
			vel = new Vector3D();
			this.maxDistance = maxDistance;
			this.acceleration = acceleration;
		}
		
		/**
		 * The maximum distance, in pixels, over which this action operates.
		 * The particle will match its velocity other particles that are this close or closer to it.
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
		 * The acceleration force applied to adjust velocity to match that
		 * of the other particles.
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
		 * @inheritDoc
		 */
		override public function addedToEmitter( emitter:Emitter ) : void
		{
			Emitter3D( emitter ).spaceSort = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var p:Particle3D = Particle3D( particle );
			var e:Emitter3D = Emitter3D( emitter );
			var particles:Array = e.particles;
			var sortedX:Array = e.spaceSortedX;
			var other:Particle3D;
			var i:int;
			var len:int = particles.length;
			var distanceSq:Number;
			var count:int = 0;
			var factor:Number;
			vel.reset( 0, 0, 0 );
			for( i = p.sortID - 1; i >= 0; --i )
			{
				other = particles[sortedX[i]];
				if( ( d.x = other.position.x - p.position.x ) < -_max ) break;
				d.y = other.position.y - p.position.y;
				if( d.y > _max || d.y < -_max ) continue;
				d.z = other.position.z - p.position.z;
				if( d.z > _max || d.z < -_max ) continue;
				distanceSq = d.lengthSquared;
				if( distanceSq <= _maxSq && distanceSq > 0 )
				{
					vel.incrementBy( other.velocity );
					++count;
				}
			}
			for( i = p.sortID + 1; i < len; ++i )
			{
				other = particles[sortedX[i]];
				if( ( d.x = other.position.x - p.position.x ) > _max ) break;
				d.y = other.position.y - p.position.y;
				if( d.y > _max || d.y < -_max ) continue;
				d.z = other.position.z - p.position.z;
				if( d.z > _max || d.z < -_max ) continue;
				distanceSq = d.lengthSquared;
				if( distanceSq <= _maxSq && distanceSq > 0 )
				{
					vel.incrementBy( other.velocity );
					++count;
				}
			}
			if( count != 0 )
			{
				vel.scaleBy( 1 / count ).decrementBy( p.velocity );
				if( !vel.equals( Vector3D.ZERO ) )
				{
					factor = time * _acc / vel.length;
					if( factor > 1 ) factor = 1;
					p.velocity.incrementBy( vel.scaleBy( factor ) );
				}
			}
		}
	}
}
