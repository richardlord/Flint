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

package org.flintparticles.threeD.away3d.utils 
{
	import away3d.core.math.MatrixAway3D;
	import away3d.core.math.Number3D;
	import away3d.core.math.Quaternion;
	
	import org.flintparticles.threeD.geom.Matrix3D;
	import org.flintparticles.threeD.geom.Point3D;
	import org.flintparticles.threeD.geom.Quaternion;
	import org.flintparticles.threeD.geom.Vector3D;

	/**
	 * This class contains static methods to convert between Away3D geometry 
	 * classes and Flint geometry classes.
	 */
	public class Convert 
	{
		/**
		 * Convert a Flint Vector3D object to an Away3D Number3D object.
		 */
		public static function Vector3DToA3D( v:Vector3D ):Number3D
		{
			return new Number3D( v.x, v.y, v.z );
		}

		/**
		 * Convert an Away3D Number3D object to a Flint Vector3D object.
		 */
		public static function Vector3DFromA3D( v:Number3D ):Vector3D
		{
			return new Vector3D( v.x, v.y, v.z );
		}

		/**
		 * Convert a Flint Point3D object to an Away3D Number3D object.
		 */
		public static function Point3DToA3D( v:Point3D ):Number3D
		{
			return new Number3D( v.x, v.y, v.z );
		}

		/**
		 * Convert an Away3D Number3D object to a Flint Point3D object.
		 */
		public static function Point3DFromA3D( v:Number3D ):Point3D
		{
			return new Point3D( v.x, v.y, v.z );
		}

		/**
		 * Convert a Flint Matrix3D object to an Away3D Matrix3D object.
		 */
		public static function Matrix3DToA3D( m:Matrix3D ):MatrixAway3D
		{
			var n:MatrixAway3D = new MatrixAway3D();
			n.array2matrix( m.rawData, false, 1 );
			return n;
		}

		/**
		 * Convert an Away3D Matrix3D object to a Flint Matrix3D object.
		 */
		public static function Matrix3DFromA3D( m:MatrixAway3D ):Matrix3D
		{
			return new Matrix3D(
				[ m.sxx, m.sxy, m.sxz, m.tx, m.syx, m.syy, m.syz, m.ty, m.szx, m.szy, m.szz, m.tz, m.swx, m.swy, m.swz, m.tw ]
			);
		}
		
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
