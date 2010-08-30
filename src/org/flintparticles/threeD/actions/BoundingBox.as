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
	import org.flintparticles.common.events.ParticleEvent;	
	import org.flintparticles.common.actions.ActionBase;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.threeD.particles.Particle3D;	

	/**
	 * The BoundingBox action confines each particle to a box. The 
	 * box is aligned to the coordinate system axes. The 
	 * particle bounces back off the side of the box when it reaches 
	 * the edge. The bounce treats the particle as a circular body
	 * and displays no loss of energy in the collision.
	 * 
	 * This action has a priority of -20, so that it executes after 
	 * all movement has occured.
	 */

	public class BoundingBox extends ActionBase
	{
		private var _minX : Number;
		private var _maxX : Number;
		private var _minY : Number;
		private var _maxY : Number;
		private var _minZ : Number;
		private var _maxZ : Number;
		private var _bounce : Number;

		/**
		 * The constructor creates a BoundingBox action for use by an emitter. 
		 * To add a BoundingBox to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param minX The minX coordinate of the box.
		 * @param maxX The maxX coordinate of the box.
		 * @param minY The minY coordinate of the box.
		 * @param maxY The maxY coordinate of the box.
		 * @param minZ The minZ coordinate of the box.
		 * @param maxZ The maxZ coordinate of the box.
		 * @param bounce The coefficient of restitution when the particles bounce off the
		 * sides of the box. A value of 1 gives a pure elastic collision, with no energy loss. 
		 * A value between 0 and 1 causes the particle to loose enegy in the collision. A value 
		 * greater than 1 causes the particle to gain energy in the collision.
		 */
		public function BoundingBox( minX:Number = 0, maxX:Number = 0, minY:Number = 0, maxY:Number = 0, minZ:Number = 0, maxZ:Number = 0, bounce:Number = 1 )
		{
			priority = -20;
			this.minX = minX;
			this.maxX = maxX;
			this.minY = minY;
			this.maxY = maxY;
			this.minZ = minZ;
			this.maxZ = maxZ;
			this.bounce = bounce;
		}
		
		/**
		 * The minX coordinate of the box.
		 */
		public function get minX():Number
		{
			return _minX;
		}
		public function set minX( value:Number ):void
		{
			_minX = value;
		}

		/**
		 * The maxX coordinate of the box.
		 */
		public function get maxX():Number
		{
			return _maxX;
		}
		public function set maxX( value:Number ):void
		{
			_maxX = value;
		}

		/**
		 * The minY coordinate of the box.
		 */
		public function get minY():Number
		{
			return _minY;
		}
		public function set minY( value:Number ):void
		{
			_minY = value;
		}

		/**
		 * The maxY coordinate of the box.
		 */
		public function get maxY():Number
		{
			return _maxY;
		}
		public function set maxY( value:Number ):void
		{
			_maxY = value;
		}

		/**
		 * The minZ coordinate of the box.
		 */
		public function get minZ():Number
		{
			return _minZ;
		}
		public function set minZ( value:Number ):void
		{
			_minZ = value;
		}

		/**
		 * The maxZ coordinate of the box.
		 */
		public function get maxZ():Number
		{
			return _maxZ;
		}
		public function set maxZ( value:Number ):void
		{
			_maxZ = value;
		}

		/**
		 * The coefficient of restitution when the particles bounce off the
		 * sides of the box. A value of 1 gives a pure pure elastic collision, with no energy loss. 
		 * A value between 0 and 1 causes the particle to loose enegy in the collision. A value 
		 * greater than 1 causes the particle to gain energy in the collision.
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
		 * Tests whether the particle is at the edge of the box and, if so,
		 * adjusts its velocity to bounce in back towards the center of the
		 * box.
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
		override public function update( emitter : Emitter, particle : Particle, time : Number ) : void
		{
			var p:Particle3D = Particle3D( particle );
			var radius:Number = p.collisionRadius;
			var position:Number;
			if ( p.velocity.x > 0 && ( position = p.position.x + radius ) >= _maxX )
			{
				p.velocity.x = -p.velocity.x * _bounce;
				p.position.x += 2 * ( _maxX - position );
				emitter.dispatchEvent( new ParticleEvent( ParticleEvent.BOUNDING_BOX_COLLISION, p ) );
			}
			else if ( p.velocity.x < 0 && ( position = p.position.x - radius ) <= _minX )
			{
				p.velocity.x = -p.velocity.x * _bounce;
				p.position.x += 2 * ( _minX - position );
				emitter.dispatchEvent( new ParticleEvent( ParticleEvent.BOUNDING_BOX_COLLISION, p ) );
			}
			if ( p.velocity.y > 0 && ( position = p.position.y + radius ) >= _maxY )
			{
				p.velocity.y = -p.velocity.y * _bounce;
				p.position.y += 2 * ( _maxY - position );
				emitter.dispatchEvent( new ParticleEvent( ParticleEvent.BOUNDING_BOX_COLLISION, p ) );
			}
			else if ( p.velocity.y < 0 && ( position = p.position.y - radius ) <= _minY )
			{
				p.velocity.y = -p.velocity.y * _bounce;
				p.position.y += 2 * ( _minY - position );
				emitter.dispatchEvent( new ParticleEvent( ParticleEvent.BOUNDING_BOX_COLLISION, p ) );
			}
			if ( p.velocity.z > 0 && ( position = p.position.z + radius ) >= _maxZ )
			{
				p.velocity.z = -p.velocity.z * _bounce;
				p.position.z += 2 * ( _maxZ - position );
				emitter.dispatchEvent( new ParticleEvent( ParticleEvent.BOUNDING_BOX_COLLISION, p ) );
			}
			else if ( p.velocity.z < 0 && ( position = p.position.z - radius ) <= _minZ )
			{
				p.velocity.z = -p.velocity.z * _bounce;
				p.position.z += 2 * ( _minZ - position );
				emitter.dispatchEvent( new ParticleEvent( ParticleEvent.BOUNDING_BOX_COLLISION, p ) );
			}
		}
	}
}
