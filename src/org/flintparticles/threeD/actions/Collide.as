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
	import org.flintparticles.common.activities.FrameUpdatable;
	import org.flintparticles.common.activities.UpdateOnFrame;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.threeD.emitters.Emitter3D;
	import org.flintparticles.threeD.geom.Vector3D;
	import org.flintparticles.threeD.particles.Particle3D;	

	/**
	 * The Collide action detects collisions between particles and modifies their velocities
	 * in response to the collision. All paticles are approximated to a circular shape for
	 * the collisions and they are assumed to be off even density.
	 * 
	 * <p>If the particles reach a stationary, or near stationary, state under an accelerating 
	 * force (e.g. gravity) then they will fall through each other. This is due to the nature
	 * of the alogorithm used, which is designed for speed of execution and sufficient accuracy 
	 * when the particles are in motion, not for absolute precision.</p>
	 * 
	 * <p>This action has a priority of -20, so that it executes 
	 * after other actions.</p>
	 */

	public class Collide extends ActionBase implements FrameUpdatable
	{
		private var _bounce:Number;
		private var _maxDistance:Number;
		private var _updateActivity:UpdateOnFrame;
		
		/*
		 * Temporary variables created as class members to avoid creating new objects all the time
		 */
		private var d:Vector3D;
		private var _temp:Vector3D;

		/**
		 * The constructor creates a Collide action for use by  an emitter.
		 * To add a Collide to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param bounce The coefficient of restitution when the particles collide. A value of 
		 * 1 gives a pure elastic collision, with no energy loss. A value
		 * between 0 and 1 causes the particle to loose enegy in the collision. A value greater 
		 * than 1 causes the particle to gain energy in the collision.
		 */
		public function Collide( bounce:Number= 1 )
		{
			priority = -20;
			_maxDistance = 0;
			d = new Vector3D();
			_temp = new Vector3D();
			this.bounce = bounce;
		}
		
		/**
		 * The coefficient of restitution when the particles collide. A value of 
		 * 1 gives a pure elastic collision, with no energy loss. A value
		 * between 0 and 1 causes the particle to loose enegy in the collision. A value greater 
		 * than 1 causes the particle to gain energy in the collision.
		 */
		public function get bounce():Number
		{
			return _bounce;
		}
		public function set bounce( value:Number ):void
		{
			_bounce = value;
		}

		/**
		 * Instructs the emitter to produce a sorted particle array for optimizing
		 * the calculations in the update method of this action and
		 * adds an UpdateOnFrame activity to the emitter to call this objects
		 * frameUpdate method once per frame.
		 * 
		 * @param emitter The emitter this action has been added to.
		 * 
		 * @see frameUpdate()
		 * @see org.flintparticles.common.activities.UpdateOnFrame
		 * @see org.flintparticles.common.actions.Action#addedToEmitter()
		 */
		override public function addedToEmitter( emitter:Emitter ) : void
		{
			Emitter3D( emitter ).spaceSort = true;
			_updateActivity = new UpdateOnFrame( this );
			emitter.addActivity( _updateActivity );
		}

		/**
		 * Removes the UpdateOnFrame activity that was added to the emitter in the
		 * addedToEmitter method.
		 * 
		 * @param emitter The emitter this action has been added to.
		 * 
		 * @see addedToEmitter()
		 * @see org.flintparticles.common.activities.UpdateOnFrame
		 * @see org.flintparticles.common.actions.Action#removedFromEmitter()
		 */
		override public function removedFromEmitter( emitter:Emitter ):void
		{
			if( _updateActivity )
			{
				emitter.removeActivity( _updateActivity );
			}
		}
		
		/**
		 * Called every frame before the particles are updated, this method
		 * calculates the collision radius of the largest two particles, which
		 * aids in optimizing the collision calculations.
		 * 
		 * <p>This method is called using an UpdateOnFrame activity that is
		 * created in the addedToEmitter method.</p>
		 * 
		 * @param emitter The emitter that is using this action.
		 * @param time The duration of the current animation frame.
		 * 
		 * @see org.flintparticles.common.activities.UpdateOnFrame
		 */
		public function frameUpdate( emitter:Emitter, time:Number ):void
		{
			var particles:Array = emitter.particles;
			var max1:Number = 0;
			var max2:Number = 0;
			for each( var p:Particle in particles )
			{
				if( p.collisionRadius > max1 )
				{
					max2 = max1;
					max1 = p.collisionRadius;
		}
				else if( p.collisionRadius > max2 )
				{
					max2 = p.collisionRadius;
				}
			}
			_maxDistance = max1 + max2;
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
			var factor:Number;
			var distanceSq:Number;
			var collisionDist:Number;
			var n1:Number, n2:Number;
			var relN:Number;
			var m1:Number, m2:Number;
			var f1:Number, f2:Number;
			for( i = p.sortID + 1; i < len; ++i )
			{
				other = particles[sortedX[i]];
				if( ( d.x = other.position.x - p.position.x ) > _maxDistance ) break;
				collisionDist = other.collisionRadius + p.collisionRadius;
				if( d.x > collisionDist ) continue;
				d.y = other.position.y - p.position.y;
				if( d.y > collisionDist || d.y < -collisionDist ) continue;
				d.z = other.position.z - p.position.z;
				if( d.z > collisionDist || d.z < -collisionDist ) continue;
				distanceSq = d.lengthSquared;
				if( distanceSq <= collisionDist * collisionDist && distanceSq > 0 )
				{
					d.normalize();
					n1 = p.velocity.dotProduct( d );
					n2 = other.velocity.dotProduct( d );
					relN = n1 - n2;
					if( relN > 0 ) // colliding, not separating
					{
						m1 = p.mass;
						m2 = other.mass;
						factor = ( ( 1 + _bounce ) * relN ) / ( m1 + m2 );
						f1 = factor * m2;
						f2 = -factor * m1;
						p.velocity.decrementBy( d.multiply( f1, _temp ) );
						other.velocity.decrementBy( d.multiply( f2, _temp ) );
						var ev:ParticleEvent = new ParticleEvent( ParticleEvent.PARTICLES_COLLISION, p );
						ev.otherObject = other;
						emitter.dispatchEvent( ev );
					}
				} 
			}
		}
	}
}
