/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord & Michael Ivanov
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
	import away3d.core.math.Quaternion;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
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
		public static function Vector3DToA3D( v:org.flintparticles.threeD.geom.Vector3D ):flash.geom.Vector3D
		{
			return new flash.geom.Vector3D( v.x, v.y, v.z );
		}

		/**
		 * Convert an Away3D Number3D object to a Flint Vector3D object.
		 */
		public static function Vector3DFromA3D( v:flash.geom.Vector3D ):org.flintparticles.threeD.geom.Vector3D
		{
			return new org.flintparticles.threeD.geom.Vector3D( v.x, v.y, v.z );
		}

		/**
		 * Convert a Flint Point3D object to an Away3D Number3D object.
		 */
		public static function Point3DToA3D( v:Point3D ):flash.geom.Vector3D
		{
			return new flash.geom.Vector3D( v.x, v.y, v.z );
		}

		/**
		 * Convert an Away3D Number3D object to a Flint Point3D object.
		 */
		public static function Point3DFromA3D( v:flash.geom.Vector3D ):Point3D
		{
			return new Point3D( v.x, v.y, v.z );
		}

		/**
		 * Convert a Flint Matrix3D object to an Away3D Matrix3D object.
		 */
		public static function Matrix3DToA3D( m:org.flintparticles.threeD.geom.Matrix3D ):flash.geom.Matrix3D
		{
			var n:flash.geom.Matrix3D=new flash.geom.Matrix3D();
			// TODO: check that columns and raws match between the matrices
			n.rawData = new Vector.<Number>(
				m.rawData[0], m.rawData[4], m.rawData[8], m.rawData[12],
				m.rawData[1], m.rawData[5], m.rawData[9], m.rawData[13],
				m.rawData[2], m.rawData[6], m.rawData[10], m.rawData[14],
				m.rawData[3], m.rawData[7], m.rawData[11], m.rawData[15]
			);
			return n;
		}

		/**
		 * Convert an Away3D Matrix3D object to a Flint Matrix3D object.
		 */
		public static function Matrix3DFromA3D( m:flash.geom.Matrix3D ):org.flintparticles.threeD.geom.Matrix3D
		{
			// TODO: check that columns and raws match between the matrices
			return new org.flintparticles.threeD.geom.Matrix3D( [
				m.rawData[0], m.rawData[4], m.rawData[8], m.rawData[12],
				m.rawData[1], m.rawData[5], m.rawData[9], m.rawData[13],
				m.rawData[2], m.rawData[6], m.rawData[10], m.rawData[14],
				m.rawData[3], m.rawData[7], m.rawData[11], m.rawData[15]
			] );
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
