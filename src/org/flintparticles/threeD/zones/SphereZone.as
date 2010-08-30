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

package org.flintparticles.threeD.zones 
{
	import org.flintparticles.threeD.geom.Point3D;
	import org.flintparticles.threeD.geom.Vector3D;	

	/**
	 * The SphereZone zone defines a zone that contains all the points in a sphere.
	 * The sphere can be positioned anywhere in 3D space and may, optionally,
	 * be hollow in the middle.
	 */

	public class SphereZone implements Zone3D 
	{
		private var _center:Point3D;
		private var _innerRadius:Number;
		private var _innerRadiusSq:Number;
		private var _outerRadius:Number;
		private var _outerRadiusSq:Number;
		
		/**
		 * The constructor creates a SphereZone 3D zone.
		 * 
		 * @param center The point at the center of the sphere.
		 * @param outerRadius The outer radius of the sphere.
		 * @param innerRadius The inner radius of the sphere. This defines the hollow 
		 * center of the sphere. If set to zero, the sphere is solid throughout. 
		 */
		public function SphereZone( center:Point3D = null, outerRadius:Number = 0, innerRadius:Number = 0 )
		{
			_center = center ? center.clone() : new Point3D( 0, 0, 0 );
			_innerRadius = innerRadius;
			_innerRadiusSq = _innerRadius * _innerRadius;
			_outerRadius = outerRadius;
			_outerRadiusSq = _outerRadius * _outerRadius;
		}
		
		/**
		 * The point at the center of the sphere.
		 */
		public function get center() : Point3D
		{
			return _center.clone();
		}
		public function set center( value : Point3D ) : void
		{
			_center = value.clone();
		}

		/**
		 * The radius of the hollow center of the sphere.
		 */
		public function get innerRadius() : Number
		{
			return _innerRadius;
		}
		public function set innerRadius( value : Number ) : void
		{
			_innerRadius = value;
			_innerRadiusSq = _innerRadius * _innerRadius;
		}

		/**
		 * The outer radius of the sphere.
		 */
		public function get outerRadius() : Number
		{
			return _outerRadius;
		}
		public function set outerRadius( value : Number ) : void
		{
			_outerRadius = value;
			_outerRadiusSq = _outerRadius * _outerRadius;
		}

		/**
		 * The contains method determines whether a point is inside the sphere.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @param p The location to test.
		 * @return true if the location is inside the zone, false if it is outside.
		 */
		public function contains( p:Point3D ):Boolean
		{
			var distSq:Number = p.distanceSquared( _center );
			return distSq <= _outerRadiusSq && distSq >= _innerRadiusSq;
		}
		
		/**
		 * The getLocation method returns a random point inside the sphere.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @return A random point inside the zone.
		 */
		public function getLocation():Point3D
		{
			var rand:Vector3D;
			do
			{
				rand = new Vector3D( Math.random() - 0.5, Math.random() - 0.5, Math.random() - 0.5 );
			}
			while ( rand.x == 0 && rand.y == 0 && rand.z == 0 );
			rand.normalize();
			var d:Number = Math.random();
			d = _innerRadius + ( 1 - d * d ) * ( _outerRadius - _innerRadius );
			rand.scaleBy( d / rand.length );
			return _center.add( rand );
		}
		
		/**
		 * The getVolume method returns the volume of the sphere.
		 * This method is used by the MultiZone class. Usually, 
		 * it need not be called directly by the user.
		 * 
		 * @return the volume of the sphere.
		 */
		public function getVolume():Number
		{
			// treat as one pixel tall disc
			return ( _outerRadiusSq * _outerRadius - _innerRadiusSq * _innerRadius ) * Math.PI * 4 / 3;
		}
	}
}
