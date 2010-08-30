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
	 * The LineZone zone defines a zone that contains all the points on a line.
	 */

	public class LineZone implements Zone2D
	{
		private var _start:Point;
		private var _end:Point;
		private var _length:Point;
		private var _normal:Point;
		private var _parallel:Point;
		
		/**
		 * The constructor creates a LineZone zone.
		 * 
		 * @param start The point at one end of the line.
		 * @param end The point at the other end of the line.
		 */
		public function LineZone( start:Point = null, end:Point = null )
		{
			if( start == null )
			{
				_start = new Point( 0, 0 );
			}
			else
			{
				_start = start;
			}
			if( end == null )
			{
				_end = new Point( 0, 0 );
			}
			else
			{
				_end = end;
			}
			setLengthAndNormal();
		}
		
		private function setLengthAndNormal():void
		{
			_length = _end.subtract( _start );
			_parallel = _length.clone();
			_parallel.normalize( 1 );
			_normal = new Point( _parallel.y, - _parallel.x );
		}
		
		/**
		 * The point at one end of the line.
		 */
		public function get start() : Point
		{
			return _start;
		}

		public function set start( value : Point ) : void
		{
			_start = value;
			setLengthAndNormal();
		}

		/**
		 * The point at the other end of the line.
		 */
		public function get end() : Point
		{
			return _end;
		}

		public function set end( value : Point ) : void
		{
			_end = value;
			setLengthAndNormal();
		}

		/**
		 * The x coordinate of the point at the start of the line.
		 */
		public function get startX() : Number
		{
			return _start.x;
		}

		public function set startX( value : Number ) : void
		{
			_start.x = value;
			_length = _end.subtract( _start );
		}

		/**
		 * The y coordinate of the point at the start of the line.
		 */
		public function get startY() : Number
		{
			return _start.y;
		}

		public function set startY( value : Number ) : void
		{
			_start.y = value;
			_length = _end.subtract( _start );
		}

		/**
		 * The x coordinate of the point at the end of the line.
		 */
		public function get endX() : Number
		{
			return _end.x;
		}

		public function set endX( value : Number ) : void
		{
			_end.x = value;
			_length = _end.subtract( _start );
		}

		/**
		 * The y coordinate of the point at the end of the line.
		 */
		public function get endY() : Number
		{
			return _end.y;
		}

		public function set endY( value : Number ) : void
		{
			_end.y = value;
			_length = _end.subtract( _start );
		}

		/**
		 * @inheritDoc
		 */
		public function contains( x:Number, y:Number ):Boolean
		{
			// not on line if dot product with perpendicular is not zero
			if ( ( x - _start.x ) * _length.y - ( y - _start.y ) * _length.x != 0 )
			{
				return false;
			}
			// is it between the points, dot product of the vectors towards each point is negative
			return ( x - _start.x ) * ( x - _end.x ) + ( y - _start.y ) * ( y - _end.y ) <= 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLocation():Point
		{
			var ret:Point = _start.clone();
			var scale:Number = Math.random();
			ret.x += _length.x * scale;
			ret.y += _length.y * scale;
			return ret;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getArea():Number
		{
			// treat as one pixel tall rectangle
			return _length.length;
		}

		/**
		 * Manages collisions between a particle and the zone. The particle will collide with the line defined
		 * for this zone. In the interests of speed, the collisions are not exactly accurate at the ends of the
		 * line, but are accurate enough to ensure the particle doesn't pass through the line and to look
		 * realistic in most circumstances. The collisionRadius of the particle is used when calculating the collision.
		 * 
		 * @param particle The particle to be tested for collision with the zone.
		 * @param bounce The coefficient of restitution for the collision.
		 * 
		 * @return Whether a collision occured.
		 */
		public function collideParticle( particle:Particle2D, bounce:Number = 1 ):Boolean
		{
			// if it was moving away from the line, return false
			var previousDistance:Number = ( particle.previousX - _start.x ) * _normal.x + ( particle.previousY - _start.y ) * _normal.y;
			var velDistance:Number = particle.velX * _normal.x + particle.velY * _normal.y;
			if( previousDistance * velDistance >= 0 )
			{
				return false;
			}
			
			// if it is further away than the collision radius and the same side as previously, return false
			var distance:Number = ( particle.x - _start.x ) * _normal.x + ( particle.y - _start.y ) * _normal.y;
			if( distance * previousDistance > 0 && ( distance > particle.collisionRadius || distance < -particle.collisionRadius ) )
			{
				return false;
			}
			
			// move line collisionradius distance in direction particle was, extend it by collision radius
			var offsetX:Number;
			var offsetY:Number;
			if( previousDistance < 0 )
			{
				offsetX = _normal.x * particle.collisionRadius;
				offsetY = _normal.y * particle.collisionRadius;
			}
			else
			{
				offsetX = - _normal.x * particle.collisionRadius;
				offsetY = - _normal.y * particle.collisionRadius;
			}
			var thenX:Number = particle.previousX + offsetX;
			var thenY:Number = particle.previousY + offsetY;
			var nowX:Number = particle.x + offsetX;
			var nowY:Number = particle.y + offsetY;
			var startX:Number = _start.x - _parallel.x * particle.collisionRadius;
			var startY:Number = _start.y - _parallel.y * particle.collisionRadius;
			var endX:Number = _end.x + _parallel.x * particle.collisionRadius;
			var endY:Number = _end.y + _parallel.y * particle.collisionRadius;
			
			var den:Number = 1 / ( ( nowY - thenY ) * ( endX - startX ) - ( nowX - thenX ) * ( endY - startY ) );
			
			var u : Number = den * ( ( nowX - thenX ) * ( startY - thenY ) - ( nowY - thenY ) * ( startX - thenX ) );
			if( u < 0 || u > 1 )
			{
				return false;
			}
			
			var v : Number = - den * ( ( endX - startX ) * ( thenY - startY ) - ( endY - startY ) * ( thenX - startX ) );
			if( v < 0 || v > 1 )
			{
				return false;
			}
			
			particle.x = particle.previousX + v * ( particle.x - particle.previousX );
			particle.y = particle.previousY + v * ( particle.y - particle.previousY );
			
			var normalSpeed:Number = _normal.x * particle.velX + _normal.y * particle.velY;
			var factor:Number = ( 1 + bounce ) * normalSpeed;
			particle.velX -= factor * _normal.x;
			particle.velY -= factor * _normal.y;
			return true;
		}
	}
}
