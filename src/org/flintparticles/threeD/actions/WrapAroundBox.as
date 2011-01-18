/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2011
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
	import org.flintparticles.threeD.particles.Particle3D;

	/**
	 * The WrapAroundBox action confines all the particles to a rectangle region. If a
	 * particle leaves the rectangle on one side it reenters on the other.
	 * 
	 * This action has a priority of -20, so that it executes after 
	 * all movement has occured.
	 */

	public class WrapAroundBox extends ActionBase
	{
		private var _minX : Number;
		private var _maxX : Number;
		private var _minY : Number;
		private var _maxY : Number;
		private var _minZ : Number;
		private var _maxZ : Number;
		private var _width : Number;
		private var _height : Number;
		private var _depth : Number;

		/**
		 * The constructor creates a WrapAroundBox action for use by an emitter. 
		 * To add a WrapAroundBox to all particles created by an emitter, use the
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
		 */
		public function WrapAroundBox( minX:Number = 0, maxX:Number = 0, minY:Number = 0, maxY:Number = 0, minZ:Number = 0, maxZ:Number = 0 )
		{
			priority = -20;
			this.minX = minX;
			this.maxX = maxX;
			this.minY = minY;
			this.maxY = maxY;
			this.minZ = minZ;
			this.maxZ = maxZ;
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
			_width = _maxX - _minX;
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
			_width = _maxX - _minX;
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
			_height = _maxY - _minY;
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
			_height = _maxY - _minY;
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
			_depth = _maxZ - _minZ;
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
			_depth = _maxZ - _minZ;
		}

		/**
		 * Tests whether the particle has left the box and, if so, moves it
		 * to enter on the other side.
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
			if ( p.velocity.x > 0 && p.position.x >= _maxX )
			{
				p.position.x -= _width;
			}
			else if ( p.velocity.x < 0 && p.position.x <= _minX )
			{
				p.position.x += _width;
			}
			if ( p.velocity.y > 0 && p.position.y >= _maxY )
			{
				p.position.y -= _height;
			}
			else if ( p.velocity.y < 0 && p.position.y <= _minY )
			{
				p.position.y += _height;
			}
			if ( p.velocity.z > 0 && p.position.z >= _maxZ )
			{
				p.position.z -= _depth;
			}
			else if ( p.velocity.z < 0 && p.position.z <= _minZ )
			{
				p.position.z += _depth;
			}
		}
	}
}
