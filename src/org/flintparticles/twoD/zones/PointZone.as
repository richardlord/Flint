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
	 * The PointZone zone defines a zone that contains a single point.
	 */

	public class PointZone implements Zone2D
	{
		private var _point:Point;
		
		/**
		 * The constructor defines a PointZone zone.
		 * 
		 * @param point The point that is the zone.
		 */
		public function PointZone( point:Point = null )
		{
			if( point == null )
			{
				_point = new Point( 0, 0 );
			}
			else
			{
			_point = point;
		}
		}
		
		/**
		 * The point that is the zone.
		 */
		public function get point() : Point
		{
			return _point;
		}

		public function set point( value : Point ) : void
		{
			_point = value;
		}

		/**
		 * The x coordinate of the point that is the zone.
		 */
		public function get x() : Number
		{
			return _point.x;
		}

		public function set x( value : Number ) : void
		{
			_point.x = value;
		}

		/**
		 * The y coordinate of the point that is the zone.
		 */
		public function get y() : Number
		{
			return _point.y;
		}

		public function set y( value : Number ) : void
		{
			_point.y = value;
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
			return _point.x == x && _point.y == y;
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
			return _point.clone();
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
			// treat as one pixel square
			return 1;
		}

		/**
		 * Manages collisions between a particle and the zone. Particles will colide with the point defined 
		 * for this zone. The collisionRadius of the particle is used when calculating the collision.
		 * 
		 * @param particle The particle to be tested for collision with the zone.
		 * @param bounce The coefficient of restitution for the collision.
		 * 
		 * @return Whether a collision occured.
		 */
		public function collideParticle(particle:Particle2D, bounce:Number = 1):Boolean
		{
			var relativePreviousX:Number = particle.previousX - _point.x;
			var relativePreviousY:Number = particle.previousY - _point.y;
			var dot:Number = relativePreviousX * particle.velX + relativePreviousY * particle.velY;
			if( dot >= 0 )
			{
				return false;
			}
			var relativeX:Number = particle.x - _point.x;
			var relativeY:Number = particle.y - _point.y;
			var radius:Number = particle.collisionRadius;
			dot = relativeX * particle.velX + relativeY * particle.velY;
			if( dot <= 0 )
			{
				if( relativeX > radius || relativeX < -radius )
				{
					return false;
				}
				if( relativeY > radius || relativeY < -radius )
				{
					return false;
				}
				if( relativeX * relativeX + relativeY * relativeY > radius * radius )
				{
					return false;
				}
			}
			
			var frameVelX:Number = relativeX - relativePreviousX;
			var frameVelY:Number = relativeY - relativePreviousY;
			var a:Number = frameVelX * frameVelX + frameVelY * frameVelY;
			var b:Number = 2 * ( relativePreviousX * frameVelX + relativePreviousY * frameVelY );
			var c:Number = relativePreviousX * relativePreviousX + relativePreviousY * relativePreviousY - radius * radius;
			var sq:Number = b * b - 4 * a * c;
			if( sq < 0 )
			{
				return false;
			}
			var srt:Number = Math.sqrt( sq );
			var t1:Number = ( -b + srt ) / ( 2 * a );
			var t2:Number = ( -b - srt ) / ( 2 * a );
			var t:Array = new Array();
			
			if( t1 > 0 && t1 <= 1 )
			{
				t.push( t1 );
			}
			if( t2 > 0 && t2 <= 1 )
			{
				t.push( t2 );
			}
			var time:Number;
			if( t.length == 0 )
			{
				return false;
			}
			if( t.length == 1 )
			{
				time = t[0];
			}
			else
			{
				time = Math.min( t1, t2 );
			}
			var cx:Number = relativePreviousX + time * frameVelX + _point.x;
			var cy:Number = relativePreviousY + time * frameVelY + _point.y;
			var nx:Number = cx - _point.x;
			var ny:Number = cy - _point.y;
			var d:Number = Math.sqrt( nx * nx + ny * ny );
			nx /= d;
			ny /= d;
			var n:Number = frameVelX * nx + frameVelY * ny;
			frameVelX -= 2 * nx * n;
			frameVelY -= 2 * ny * n;
			particle.x = cx + ( 1 - time ) * frameVelX;
			particle.y = cy + ( 1 - time ) * frameVelY;
			var normalVel:Number = particle.velX * nx + particle.velY * ny;
			particle.velX -= (1 + bounce) * nx * normalVel;
			particle.velY -= (1 + bounce) * ny * normalVel;
			return true;
		}
	}
}
