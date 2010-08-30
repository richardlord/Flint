/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2010
 * http://flintparticles.org/
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

package org.flintparticles.threeD.geom
{
	/**
	 * Point3D represents a point in three-dimensional cartesian 
	 * coordinate space.
	 */
	public class Point3D extends Transformable3D
	{
		/**
		 * A zero point.
		 */
		public static const ZERO:Point3D = new Point3D( 0, 0, 0 );

		/**
		 * Constructor
		 *
		 * @param x the x coordinate of the point
		 * @param y the y coordinate of the point
		 * @param z the z coordinate of the point
		 */
		public function Point3D( x:Number = 0, y:Number = 0, z:Number = 0 )
		{
			super( x, y, z, 1 );
		}
		
		/**
		 * Assigns new coordinates to this point
		 * 
		 * @param x The new x coordinate
		 * @param y The new y coordinate
		 * @param z The new z coordinate
		 * 
		 * @return a reference to this Point3D object
		 */
		public function reset( x:Number = 0, y:Number = 0, z:Number = 0 ):Point3D
		{
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = 1;
			return this;
		}
		
		/**
		 * Copies another point into this one.
		 * 
		 * @param p The point to copy
		 * 
		 * @return a reference to this point
		 */
		public function assign( p:Point3D ):Point3D
		{
			x = p.x;
			y = p.y;
			z = p.z;
			w = p.w;
			return this;
		}
		
		/**
		 * Makes a copy of this point.
		 * 
		 * @param result The point to hold the copy of this point. If
		 * no point is passed, a new point is created.
		 * 
		 * @return A copy of this point
		 */
		public function clone( result:Point3D = null ):Point3D
		{
			if( result == null )
			{
				result = new Point3D();
			}
			result.x = x;
			result.y = y;
			result.z = z;
			result.w = w;
			return result;
		}

		/**
		 * @inheritDoc
		 */
		override internal function get classType():Class
		{
			return Point3D;
		}
		
		/**
		 * Adds a vector to this point, translating this point according to the vector, 
		 * and returns the result.
		 * 
		 * @param v the vector to add
		 * @param result The point to hold the result of the addition. If
		 * no point is passed, a new point is created.
		 * 
		 * @return the result of the addition
		 */
		public function add( v:Vector3D, result:Point3D = null ):Point3D
		{
			if( result == null )
			{
				result = new Point3D();
			}
			result.x = x + v.x;
			result.y = y + v.y;
			result.z = z + v.z;
			return result;
		}
		
		/**
		 * Subtract a vector from this point, returning the result.
		 * 
		 * @param v The vector to subtract
		 * @param result The point to hold the result of the subtraction. If
		 * no point is passed, a new point is created.
		 * 
		 * @return The result of the subtraction
		 */		
		public function subtract( v:Vector3D, result:Point3D = null ):Point3D
		{
			if( result == null )
			{
				result = new Point3D();
			}
			result.x = x - v.x;
			result.y = y - v.y;
			result.z = z - v.z;
			return result;
		}

		/**
		 * Create the vector from this point to another point.
		 * 
		 * @param v The other point
		 * @param result The vector to hold the result. If
		 * no vector is passed, a new vector is created.
		 * 
		 * @return The result of the subtraction
		 */		
		public function vectorTo( p:Point3D, result:Vector3D = null ):Vector3D
		{
			if( result == null )
			{
				result = new Vector3D();
			}
			result.x = p.x - x;
			result.y = p.y - y;
			result.z = p.z - z;
			return result;
		}

		/**
		 * Multiply this point by a number, returning the result.
		 * 
		 * @param s The number to multiply by
		 * @param result The point to hold the result of the multiply. If
		 * no point is passed, a new point is created.
		 * 
		 * @return The result of the multiplication
		 */
		public function multiply( s:Number, result:Point3D = null ):Point3D
		{
			if( result == null )
			{
				result = new Point3D();
			}
			result.x = x * s;
			result.y = y * s;
			result.z = z * s;
			return result;
		}
		
		/**
		 * Divide this point by a number, returning the result.
		 * 
		 * @param s The number to divide by
		 * @param result The point to hold the result of the divide. If
		 * no point is passed, a new point is created.
		 * 
		 * @return The result of the division
		 */
		public function divide( s:Number, result:Point3D = null ):Point3D
		{
			if( result == null )
			{
				result = new Point3D();
			}
			var d:Number = 1 / s;
			result.x = x * d;
			result.y = y * d;
			result.z = z * d;
			return result;
		}
		
		/**
		 * Add a vector to this point.
		 * 
		 * @param v The vector to add
		 * 
		 * @return A reference to this point.
		 */
		public function incrementBy( v:Vector3D ):Point3D
		{
			x += v.x;
			y += v.y;
			z += v.z;
			return this;
		}

		/**
		 * Subtract a vector from this point.
		 * 
		 * @param v The vector to subtract
		 * 
		 * @return A reference to this point.
		 */
		public function decrementBy( v:Vector3D ):Point3D
		{
			x -= v.x;
			y -= v.y;
			z -= v.z;
			return this;
		}

		/**
		 * Multiply this point by a number.
		 * 
		 * @param s The number to multiply by
		 * 
		 * @return A reference to this point.
		 */
		public function scaleBy( s:Number ):Point3D
		{
			x *= s;
			y *= s;
			z *= s;
			return this;
		}
		
		/**
		 * Divide this point by a number.
		 * 
		 * @param s The number to divide by
		 * 
		 * @return A reference to this point.
		 */
		public function divideBy( s:Number ):Point3D
		{
			var d:Number = 1 / s;
			x *= d;
			y *= d;
			z *= d;
			return this;
		}
		
		/**
		 * Compare this point to another.
		 * 
		 * @param p The point to compare with
		 * 
		 * @return true if the points have the same coordinates, false otherwise
		 */
		public function equals( p:Point3D ):Boolean
		{
			return x == p.x && y == p.y && z == p.z;
		}

		/**
		 * Compare this point to another.
		 * 
		 * @param p The point to compare with
		 * @param e The distance allowed between the points.
		 * 
		 * @return true if the points are within distance e of each other, false otherwise
		 */
		public function nearTo( p:Point3D, e:Number ):Boolean
		{
			return distanceSquared( p ) <= e * e;
		}
		
		/**
		 * Calculates the distance between two points.
		 * 
		 * @param p the other point.
		 *
		 * @return the distance between the points.
		 */
		public function distance( p:Point3D ):Number
		{
			var dx:Number = x - p.x;
			var dy:Number = y - p.y;
			var dz:Number = z - p.z;
			return Math.sqrt( dx * dx + dy * dy + dz * dz );
		}
		
		/**
		 * Calculates the square of the distance between two points. This is faster than 
		 * calculating the actual distance.
		 * 
		 * @param p the other point.
		 *
		 * @return the square of the distance between the points.
		 */
		public function distanceSquared( p:Point3D ):Number
		{
			var dx:Number = x - p.x;
			var dy:Number = y - p.y;
			var dz:Number = z - p.z;
			return ( dx * dx + dy * dy + dz * dz );
		}
		
		/**
		 * Divide all the coordinates in this popoint by the w coordinate, 
		 * producing a point with a w coordinate of 1.
		 * 
		 * @return The projection of this point to a point with a w coordinate 
		 * of 1.
		 */
		public function project():Point3D
		{
			var d:Number = 1 / w;
			x *= d;
			y *= d;
			z *= d;
			w = 1;
			return this;
		}
		
		public function toVector3D( v:Vector3D = null ):Vector3D
		{
			if( v == null )
			{
				v = new Vector3D();
			}
			v.x = x;
			v.y = y;
			v.z = z;
			return v;
		}
		
		/**
		 * Get a string representation of this point
		 * 
		 * @return a string representation of this point
		 */
		public function toString():String
		{
			return "[Point3D] (x=" + x + ", y=" + y + ", z=" + z + ", w=" + w + ")";
		}
	}
}
