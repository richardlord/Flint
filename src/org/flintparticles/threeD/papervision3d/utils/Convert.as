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

package org.flintparticles.threeD.papervision3d.utils 
{
	import org.flintparticles.threeD.geom.Matrix3D;
	import org.flintparticles.threeD.geom.Point3D;
	import org.flintparticles.threeD.geom.Quaternion;
	import org.flintparticles.threeD.geom.Vector3D;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Quaternion;	

	/**
	 * This class contains static methods to convert between Papervision3D geometry 
	 * classes and Flint geometry classes.
	 */
	public class Convert 
	{
		/**
		 * Convert a Flint Vector3D object to an Papervision3D Number3D object.
		 */
		public static function Vector3DToPV3D( v:Vector3D ):Number3D
		{
			return new Number3D( v.x, v.y, v.z );
		}

		/**
		 * Convert an Papervision3D Number3D object to a Flint Vector3D object.
		 */
		public static function Vector3DFromPV3D( v:Number3D ):Vector3D
		{
			return new Vector3D( v.x, v.y, v.z );
		}

		/**
		 * Convert a Flint Vector3D object to an Papervision3D Number3D object.
		 */
		public static function Point3DToPV3D( v:Point3D ):Number3D
		{
			return new Number3D( v.x, v.y, v.z );
		}

		/**
		 * Convert an Papervision3D Number3D object to a Flint Vector3D object.
		 */
		public static function Point3DFromPV3D( v:Number3D ):Point3D
		{
			return new Point3D( v.x, v.y, v.z );
		}

		/**
		 * Convert a Flint Matrix3D object to an Papervision3D Matrix3D object.
		 */
		public static function Matrix3DToPV3D( m:org.flintparticles.threeD.geom.Matrix3D ):org.papervision3d.core.math.Matrix3D
		{
			return new org.papervision3d.core.math.Matrix3D( m.rawData );
		}

		/**
		 * Convert an Papervision3D Matrix3D object to a Flint Matrix3D object.
		 */
		public static function Matrix3DFromPV3D( m:org.papervision3d.core.math.Matrix3D ):org.flintparticles.threeD.geom.Matrix3D
		{
			return new org.flintparticles.threeD.geom.Matrix3D(
				[ m.n11, m.n12, m.n13, m.n14, m.n21, m.n22, m.n23, m.n24, m.n31, m.n32, m.n33, m.n34, m.n41, m.n42, m.n43, m.n44 ]
			);
		}
		
		/**
		 * Convert a Flint Quaternion object to an Papervision3D Quaternion object.
		 */
		public static function QuaternionToPV3D( q:org.flintparticles.threeD.geom.Quaternion ):org.papervision3d.core.math.Quaternion
		{
			return new org.papervision3d.core.math.Quaternion( q.x, q.y, q.z, q.w );
		}

		/**
		 * Convert an Papervision3D Quaternion object to a Flint Quaternion object.
		 */
		public static function QuaternionFromPV3D( q:org.papervision3d.core.math.Quaternion ):org.flintparticles.threeD.geom.Quaternion
		{
			return new org.flintparticles.threeD.geom.Quaternion( q.w, q.x, q.y, q.z );
		}
	}
}
