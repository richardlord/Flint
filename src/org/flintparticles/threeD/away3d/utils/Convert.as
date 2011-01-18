/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord & Michael Ivanov
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

package org.flintparticles.threeD.away3d.utils 
{
	import away3d.core.math.Quaternion;

	import org.flintparticles.threeD.geom.Quaternion;

	/**
	 * This class contains static methods to convert between Away3D geometry 
	 * classes and Flint geometry classes.
	 */
	public class Convert 
	{
		/**
		 * Convert a Flint Quaternion object to an Away3D Quaternion object.
		 */
		public static function QuaternionToA3D( q:org.flintparticles.threeD.geom.Quaternion ):away3d.core.math.Quaternion
		{
			var r:away3d.core.math.Quaternion = new away3d.core.math.Quaternion();
			r.w = q.w;
			r.x = q.x;
			r.y = q.y;
			r.z = q.z;
			return r;
		}

		/**
		 * Convert an Away3D Quaternion object to a Flint Quaternion object.
		 */
		public static function QuaternionFromA3D( q:away3d.core.math.Quaternion ):org.flintparticles.threeD.geom.Quaternion
		{
			return new org.flintparticles.threeD.geom.Quaternion( q.w, q.x, q.y, q.z );
		}
	}
}
