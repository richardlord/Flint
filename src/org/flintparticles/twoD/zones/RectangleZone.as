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

package org.flintparticles.twoD.zones 
{
	import org.flintparticles.twoD.particles.Particle2D;

	import flash.geom.Point;

	/**
	 * The RectangleZone zone defines a rectangular shaped zone.
	 */

	public class RectangleZone implements Zone2D
	{
		private var _left : Number;
		private var _top : Number;
		private var _right : Number;
		private var _bottom : Number;
		private var _width : Number;
		private var _height : Number;
		
		/**
		 * The constructor creates a RectangleZone zone.
		 * 
		 * @param left The left coordinate of the rectangle defining the region of the zone.
		 * @param top The top coordinate of the rectangle defining the region of the zone.
		 * @param right The right coordinate of the rectangle defining the region of the zone.
		 * @param bottom The bottom coordinate of the rectangle defining the region of the zone.
		 */
		public function RectangleZone( left:Number = 0, top:Number = 0, right:Number = 0, bottom:Number = 0 )
		{
			_left = left;
			_top = top;
			_right = right;
			_bottom = bottom;
			_width = right - left;
			_height = bottom - top;
		}
		
		/**
		 * The left coordinate of the rectangle defining the region of the zone.
		 */
		public function get left() : Number
		{
			return _left;
		}

		public function set left( value : Number ) : void
		{
			_left = value;
			if( !isNaN( _right ) && !isNaN( _left ) )
			{
				_width = right - left;
			}
		}

		/**
		 * The right coordinate of the rectangle defining the region of the zone.
		 */
		public function get right() : Number
		{
			return _right;
		}

		public function set right( value : Number ) : void
		{
			_right = value;
			if( !isNaN( _right ) && !isNaN( _left ) )
			{
				_width = right - left;
			}
		}

		/**
		 * The top coordinate of the rectangle defining the region of the zone.
		 */
		public function get top() : Number
		{
			return _top;
		}

		public function set top( value : Number ) : void
		{
			_top = value;
			if( !isNaN( _top ) && !isNaN( _bottom ) )
			{
				_height = bottom - top;
			}
		}

		/**
		 * The bottom coordinate of the rectangle defining the region of the zone.
		 */
		public function get bottom() : Number
		{
			return _bottom;
		}

		public function set bottom( value : Number ) : void
		{
			_bottom = value;
			if( !isNaN( _top ) && !isNaN( _bottom ) )
			{
				_height = bottom - top;
			}
		}

		/**
		 * The contains method determines whether a point is inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @param x The x coordinate of the location to test for.
		 * @param y The y coordinate of the location to test for.
		 * @return true if point is inside the zone, false if it is outside.
		 */
		public function contains( x:Number, y:Number ):Boolean
		{
			return x >= _left && x <= _right && y >= _top && y <= _bottom;
		}
		
		/**
		 * The getLocation method returns a random point inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getLocation():Point
		{
			return new Point( _left + Math.random() * _width, _top + Math.random() * _height );
		}
		
		/**
		 * The getArea method returns the size of the zone.
		 * This method is used by the MultiZone class. Usually, 
		 * it need not be called directly by the user.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getArea():Number
		{
			return _width * _height;
		}

		/**
		 * Manages collisions between a particle and the zone. Particles will collide with the edges 
		 * of the rectangle defined for this zone, from inside or outside the zone. The collisionRadius
		 * of the particle is used when calculating the collision.
		 * 
		 * @param particle The particle to be tested for collision with the zone.
		 * @param bounce The coefficient of restitution for the collision.
		 * 
		 * @return Whether a collision occured.
		 */
		public function collideParticle(particle:Particle2D, bounce:Number = 1):Boolean
		{
			var position:Number;
			var previousPosition:Number;
			var intersect:Number;
			var collision:Boolean = false;
			
			if ( particle.velX > 0 )
			{
				position = particle.x + particle.collisionRadius;
				previousPosition = particle.previousX + particle.collisionRadius;
				if( previousPosition < _left && position >= _left )
				{
					intersect = particle.previousY + ( particle.y - particle.previousY ) * ( _left - previousPosition ) / ( position - previousPosition );
					if( intersect >= _top - particle.collisionRadius && intersect <= _bottom + particle.collisionRadius )
					{
						particle.velX = -particle.velX * bounce;
						particle.x += 2 * ( _left - position );
						collision = true;
					}
				}
				else if( previousPosition <= _right && position > _right )
				{
					intersect = particle.previousY + ( particle.y - particle.previousY ) * ( _right - previousPosition ) / ( position - previousPosition );
					if( intersect >= _top - particle.collisionRadius && intersect <= _bottom + particle.collisionRadius )
					{
						particle.velX = -particle.velX * bounce;
						particle.x += 2 * ( _right - position );
						collision = true;
					}
				}
			}
			else if ( particle.velX < 0 )
			{
				position = particle.x - particle.collisionRadius;
				previousPosition = particle.previousX - particle.collisionRadius;
				if( previousPosition > _right && position <= _right )
				{
					intersect = particle.previousY + ( particle.y - particle.previousY ) * ( _right - previousPosition ) / ( position - previousPosition );
					if( intersect >= _top - particle.collisionRadius && intersect <= _bottom + particle.collisionRadius )
					{
						particle.velX = -particle.velX * bounce;
						particle.x += 2 * ( _right - position );
						collision = true;
					}
				}
				else if( previousPosition >= _left && position < _left )
				{
					intersect = particle.previousY + ( particle.y - particle.previousY ) * ( _left - previousPosition ) / ( position - previousPosition );
					if( intersect >= _top - particle.collisionRadius && intersect <= _bottom + particle.collisionRadius )
					{
						particle.velX = -particle.velX * bounce;
						particle.x += 2 * ( _left - position );
						collision = true;
					}
				}
			}

			if ( particle.velY > 0 )
			{
				position = particle.y + particle.collisionRadius;
				previousPosition = particle.previousY + particle.collisionRadius;
				if( previousPosition < _top && position >= _top )
				{
					intersect = particle.previousX + ( particle.x - particle.previousX ) * ( _top - previousPosition ) / ( position - previousPosition );
					if( intersect >= _left - particle.collisionRadius && intersect <= _right + particle.collisionRadius )
					{
						particle.velY = -particle.velY * bounce;
						particle.y += 2 * ( _top - position );
						collision = true;
					}
				}
				else if( previousPosition <= _bottom && position > _bottom )
				{
					intersect = particle.previousX + ( particle.x - particle.previousX ) * ( _bottom - previousPosition ) / ( position - previousPosition );
					if( intersect >= _left - particle.collisionRadius && intersect <= _right + particle.collisionRadius )
					{
						particle.velY = -particle.velY * bounce;
						particle.y += 2 * ( _bottom - position );
						collision = true;
					}
				}
			}
			else if ( particle.velY < 0 )
			{
				position = particle.y - particle.collisionRadius;
				previousPosition = particle.previousY - particle.collisionRadius;
				if( previousPosition > _bottom && position <= _bottom )
				{
					intersect = particle.previousX + ( particle.x - particle.previousX ) * ( _bottom - previousPosition ) / ( position - previousPosition );
					if( intersect >= _left - particle.collisionRadius && intersect <= _right + particle.collisionRadius )
					{
						particle.velY = -particle.velY * bounce;
						particle.y += 2 * ( _bottom - position );
						collision = true;
					}
				}
				else if( previousPosition >= _top && position < _top )
				{
					intersect = particle.previousX + ( particle.x - particle.previousX ) * ( _top - previousPosition ) / ( position - previousPosition );
					if( intersect >= _left - particle.collisionRadius && intersect <= _right + particle.collisionRadius )
					{
						particle.velY = -particle.velY * bounce;
						particle.y += 2 * ( _top - position );
						collision = true;
					}
				}
			}
			
			return collision;
		}
	}
}
