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
	import org.flintparticles.common.behaviours.Resetable;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.threeD.geom.Point3D;
	import org.flintparticles.threeD.geom.Vector3D;
	import org.flintparticles.threeD.particles.Particle3D;	

	/**
	 * The Explosion action applies a force on the particle to push it away from
	 * a single point - the center of the explosion. The force occurs instantaneously at the central point 
	 * of the explosion and then ripples out in a shock wave.
	 */

	public class Explosion extends ActionBase implements Resetable, FrameUpdatable
	{
		private static const POWER_FACTOR:Number = 100000;
		
		private var _updateActivity:UpdateOnFrame;
		private var _center:Point3D;
		private var _power:Number;
		private var _depth:Number;
		private var _invDepth:Number;
		private var _epsilonSq:Number;
		private var _oldRadius:Number = 0;
		private var _radius:Number = 0;
		private var _radiusChange:Number = 0;
		private var _expansionRate:Number = 500;
		
		/**
		 * The constructor creates an Explosion action for use by 
		 * an emitter. To add an Explosion to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param power The strength of the explosion - larger numbers produce a stronger 
		 * force.  (The scale of value has been altered from previous versions
		 * so small numbers now produce a visible effect.)
		 * @param center The center of the explosion.
		 * @param expansionRate The rate at which the shockwave moves out from the explosion, in pixels per second.
		 * @param depth The depth (front-edge to back-edge) of the shock wave.
		 * @param epsilon The minimum distance for which the explosion force is calculated. 
		 * Particles closer than this distance experience the explosion as it they were 
		 * this distance away. This stops the explosion effect blowing up as distances get 
		 * small.
		 */
		public function Explosion( power:Number = 0, center:Point3D = null, expansionRate:Number = 300, depth:Number = 10, epsilon:Number = 1 )
		{
			this.power = power;
			this.center = center ? center : Point3D.ZERO;
			this.expansionRate = expansionRate;
			this.depth = depth;
			this.epsilon = epsilon;
		}
		
		/**
		 * The strength of the explosion - larger numbers produce a stronger force.
		 */
		public function get power():Number
		{
			return _power / POWER_FACTOR;
		}
		public function set power( value:Number ):void
		{
			_power = value * POWER_FACTOR;
		}
		
		/**
		 * The strength of the explosion - larger numbers produce a stronger force.
		 */
		public function get expansionRate():Number
		{
			return _expansionRate;
		}
		public function set expansionRate( value:Number ):void
		{
			_expansionRate = value;
		}
		
		/**
		 * The strength of the explosion - larger numbers produce a stronger force.
		 */
		public function get depth():Number
		{
			return _depth * 2;
		}
		public function set depth( value:Number ):void
		{
			_depth = value * 0.5;
			_invDepth = 1 / _depth;
		}
		
		/**
		 * The center of the explosion.
		 */
		public function get center():Point3D
		{
			return _center;
		}
		public function set center( value:Point3D ):void
		{
			_center = value.clone();
		}
		
		/**
		 * The x coordinate of the center of the explosion.
		 */
		public function get x():Number
		{
			return _center.x;
		}
		public function set x( value:Number ):void
		{
			_center.x = value;
		}
		
		/**
		 * The y coordinate of  the center of the explosion.
		 */
		public function get y():Number
		{
			return _center.y;
		}
		public function set y( value:Number ):void
		{
			_center.y = value;
		}
		
		/**
		 * The z coordinate of the center of the explosion.
		 */
		public function get z():Number
		{
			return _center.z;
		}
		public function set z( value:Number ):void
		{
			_center.z = value;
		}

		/**
		 * The minimum distance for which the explosion force is calculated. 
		 * Particles closer than this distance experience the explosion as it they were 
		 * this distance away. This stops the explosion effect blowing up as distances get 
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
		 * Adds an UpdateOnFrame activity to the emitter to call this objects
		 * frameUpdate method once per frame.
		 * 
		 * @param emitter The emitter this action has been added to.
		 * 
		 * @see frameUpdate()
		 * @see org.flintparticles.common.activities.UpdateOnFrame
		 * @see org.flintparticles.common.actions.Action#addedToEmitter()
		 */
		override public function addedToEmitter( emitter:Emitter ):void
		{
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
		 * Resets the explosion to its initial state, so it can start again.
		 */
		public function reset():void
		{
			_radius = 0;
			_oldRadius = 0;
			_radiusChange = 0;
		}
		
		/**
		 * Called every frame before the particles are updated. This method is called via the FrameUpdateable
		 * interface which is called by the emitter by using an UpdateOnFrame activity.
		 */
		public function frameUpdate( emitter:Emitter, time:Number ):void
		{
			_oldRadius = _radius;
			_radiusChange = _expansionRate * time;
			_radius += _radiusChange;
		}
		
		/**
		 * Calculates the effect of the blast and shockwave on the particle at this
		 * time.
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
			var p:Particle3D = Particle3D( particle );
			var dist:Vector3D = _center.vectorTo( p.position );
			var dSq:Number = dist.lengthSquared;
			if( dSq == 0 )
			{
				return;
			}
			var d:Number = Math.sqrt( dSq );
			
			if( d < _oldRadius - _depth )
			{
				return;
			}
			if( d > _radius + _depth )
			{
				return;
			}
			
			var offset:Number = d < _radius ? _depth - _radius + d : _depth - d + _radius;
			var oldOffset:Number = d < _oldRadius ? _depth - _oldRadius + d : _depth - d + _oldRadius;
			offset *= _invDepth;
			oldOffset *= _invDepth;
			if( offset < 0 )
			{
				time = time * ( _radiusChange + offset ) / _radiusChange;
				offset = 0;
			}
			if( oldOffset < 0 )
			{
				time = time * ( _radiusChange + oldOffset ) / _radiusChange;
				oldOffset = 0;
			}
			
			var factor:Number;
			if( d < _oldRadius || d > _radius )
			{
				factor = time * _power * ( offset + oldOffset ) / ( _radius * 2 * d * p.mass );
			}
			else
			{
				var ratio:Number = ( 1 - oldOffset ) / _radiusChange;
				var f1:Number = ratio * time * _power * ( oldOffset + 1 );
				var f2:Number = ( 1 - ratio ) * time * _power * ( offset + 1 );
				factor = ( f1 + f2 ) / ( _radius * 2 * d * p.mass );
			}
			p.velocity.incrementBy( dist.scaleBy( factor ) );
		}
	}
}
