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
	 * Geom3D is the abstract base class for a vector or a point in three-dimensional 
	 * cartesian coordinate space.
	 * 
	 * <p>An object in the Geom3D class actually has four coordinates. The standard
	 * x, y, and z coordinates are used as normal for defining a location or a
	 * vector in 3D space. The forth coordinate (w) is used to distinguish between
	 * points and vectors, and to automate the variation under transformations.</p>
	 */
	internal class Transformable3D
	{
		/**
		 * The x coordinate of the point or vector.
		 */
		public var x:Number;
		
		/**
		 * The y coordinate of the point or vector.
		 */
		public var y:Number;
		
		/**
		 * The z coordinate of the point or vector.
		 */
		public var z:Number;
		
		/**
		 * The w coordinate of the point or vector.
		 * 
		 * <p>A vector will always have a w coordinate of zero, while a point will always
		 * have a w coordinate which is not zero. A point's w coordinate is usually, but 
		 * not always, 1.</p>
		 * 
		 * <p>This has a number of beneficial side effects, including</p>
		 * 
		 * <ul>
		 * <li>Adding a point and a vector produces a point. Adding two vectors produces 
		 * a vector. Points can't be added together.</li>
		 * <li>Subtracting a vector from a point produces a point. Subtracting a vector 
		 * from a vector produces a vector. Subtracting a point from a point produces
		 * the vector from one point to the other. A point can't be subtracted from 
		 * a vector.</li>
		 * <li>Matrix transformations on vectors don't apply the translation elements.
		 * Matrix transformations on points do apply the translation elements.</li>
		 * <li>In 3D graphics, when a point is transformed to canera space, the w coordinate 
		 * represents the projection transform for projectinbg the point onto the 
		 * projecction surface.</li>
		 * </ul>
		 */
		internal var w:Number;
		
		/**
		 * Constructor
		 *
		 * @param x the x coordinate of the point or vector
		 * @param y the y coordinate of the point or vector
		 * @param z the z coordinate of the point or vector
		 * @param w the w coordinate of the point or vector
		 */
		public function Transformable3D( x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 0 )
		{
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = w;
		}
		
		/**
		 * Returns the actual type of the object - Point3D or Vector3D. Used by some 
		 * matrix operations.
		 */
		internal function get classType():Class
		{
			return Transformable3D;
		}
	}
}
