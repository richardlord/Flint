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
	 * The MinimumDistance action applies an acceleration to the particle to maintain a minimum
	 * distance between it and its neighbours.
	 * 
	 * <p>This action has a priority of 10, so that it executes 
	 * before other actions.</p>
	 */

	public class MinimumDistance extends ActionBase
	{
		private var _min:Number;
		private var _acc:Number;
		private var _minSq:Number;
		
		/*
		 * Temporary variables created as class members to avoid creating new objects all the time
		 */
		private var d:Vector3D;
		private var move:Vector3D;
		
		/**
		 * The constructor creates a ApproachNeighbours action for use by 
		 * an emitter. To add a ApproachNeighbours to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param minimum The minimum distance, in pixels, that this action maintains between 
		 * particles.
		 * @param acceleration The acceleration force applied to avoid the other particles.
		 */
		public function MinimumDistance( minimum:Number = 0, acceleration:Number = 0 )
		{
			priority = 10;
			d = new Vector3D();
			move = new Vector3D();
			this.minimum = minimum;
			this.acceleration = acceleration;
		}
		
		/**
		 * The minimum distance, in pixels, that this action maintains between 
		 * particles.
		 */
		public function get minimum():Number
		{
			return _min;
		}
		public function set minimum( value:Number ):void
		{
			_min = value;
			_minSq = value * value;
		}
		
		/**
		 * The acceleration force applied to avoid the other particles.
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
			var distanceInv:Number;
			var distanceSq:Number;
			var factor:Number;
			move.reset( 0, 0, 0 );
			for( i = p.sortID - 1; i >= 0; --i )
			{
				other = particles[sortedX[i]];
				if( ( d.x = p.position.x - other.position.x ) > _min ) break;
				d.y = p.position.y - other.position.y;
				if( d.y > _min || d.y < -_min ) continue;
				d.z = p.position.z - other.position.z;
				if( d.z > _min || d.z < -_min ) continue;
				distanceSq = d.lengthSquared;
				if( distanceSq <= _minSq && distanceSq > 0 )
				{
					distanceInv = 1 / Math.sqrt( distanceSq );
					move.incrementBy( d.scaleBy( distanceInv ) );
				} 
			}
			for( i = p.sortID + 1; i < len; ++i )
			{
				other = particles[sortedX[i]];
				if( ( d.x = p.position.x - other.position.x ) < -_min ) break;
				d.y = p.position.y - other.position.y;
				if( d.y > _min || d.y < -_min ) continue;
				d.z = p.position.z - other.position.z;
				if( d.z > _min || d.z < -_min ) continue;
				distanceSq = d.lengthSquared;
				if( distanceSq <= _minSq && distanceSq > 0 )
				{
					distanceInv = 1 / Math.sqrt( distanceSq );
					move.incrementBy( d.scaleBy( distanceInv ) );
				} 
			}
			if( !move.equals( Vector3D.ZERO ) )
			{
				factor = time * _acc / move.length;
				p.velocity.incrementBy( move.scaleBy( factor ) );
			}
		}
	}
}
