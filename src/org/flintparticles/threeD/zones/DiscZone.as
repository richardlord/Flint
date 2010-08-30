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
	import org.flintparticles.threeD.geom.Vector3DUtils;	

	/**
	 * The DiscZone zone defines a zone that contains all the points on a disc.
	 * The disc can be positioned anywhere in 3D space. The disc may, optionally,
	 * have a hole in the middle.
	 */

	public class DiscZone implements Zone3D 
	{
		private var _center:Point3D;
		private var _normal:Vector3D;
		private var _innerRadius:Number;
		private var _innerRadiusSq:Number;
		private var _outerRadius:Number;
		private var _outerRadiusSq:Number;
		private var _distToOrigin:Number;
		private var _planeAxis1:Vector3D;
		private var _planeAxis2:Vector3D;
		private var _dirty:Boolean;

		private static const TWOPI:Number = Math.PI * 2;
		
		/**
		 * The constructor creates a DiscZone 3D zone.
		 * 
		 * @param centre The point at the center of the disc.
		 * @param normal A vector normal to the disc.
		 * @param outerRadius The outer radius of the disc.
		 * @param innerRadius The inner radius of the disc. This defines the hole 
		 * in the center of the disc. If set to zero, there is no hole. 
		 */
		public function DiscZone( center:Point3D = null, normal:Vector3D = null, outerRadius:Number = 0, innerRadius:Number = 0 )
		{
			_center = center ? center.clone() : new Point3D( 0, 0, 0 );
			_normal = normal ? normal.unit() : new Vector3D( 0, 0, 1 );
			_innerRadius = innerRadius;
			_innerRadiusSq = _innerRadius * _innerRadius;
			_outerRadius = outerRadius;
			_outerRadiusSq = _outerRadius * _outerRadius;
			_dirty = true;
		}
		
		private function init():void
		{
			_distToOrigin = _normal.dotProduct( center.toVector3D() );
			var axes:Array = Vector3DUtils.getPerpendiculars( normal );
			_planeAxis1 = axes[0];
			_planeAxis2 = axes[1];
			_dirty = false;
		}
		
		/**
		 * The point at the center of the disc.
		 */
		public function get center() : Point3D
		{
			return _center.clone();
		}
		public function set center( value : Point3D ) : void
		{
			_center = value.clone();
			_dirty = true;
		}

		/**
		 * The vector normal to the disc. When setting the vector, the vector is
		 * normalized. So, when reading the vector this will be a normalized version
		 * of the vector that is set.
		 */
		public function get normal() : Vector3D
		{
			return _normal.clone();
		}
		public function set normal( value : Vector3D ) : void
		{
			_normal = value.unit();
			_dirty = true;
		}

		/**
		 * The inner radius of the disc.
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
		 * The outer radius of the disc.
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
		 * The contains method determines whether a point is inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @param p The location to test.
		 * @return true if the location is inside the zone, false if it is outside.
		 */
		public function contains( p:Point3D ):Boolean
		{
			if( _dirty )
			{
				init();
			}
			// is not in plane if dist to origin along normal is different
			var dist:Number = _normal.dotProduct( p.toVector3D() );
			if( Math.abs( dist - _distToOrigin ) > 0.1 ) // test for close, not exact
			{
				return false;
			}
			// test distance to center
			var distToCenter:Number = center.distance( p );
			if( distToCenter <= _outerRadiusSq && distToCenter >= _innerRadiusSq )
			{
				return true;
			}
			return false;
		}
		
		/**
		 * The getLocation method returns a random point inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getLocation():Point3D
		{
			if( _dirty )
			{
				init();
			}
			var rand:Number = Math.random();
			var radius:Number = _innerRadius + (1 - rand * rand ) * ( _outerRadius - _innerRadius );
			var angle:Number = Math.random() * TWOPI;
			return _center.add( _planeAxis1.multiply( radius * Math.cos( angle ) ).incrementBy( _planeAxis2.multiply( radius * Math.sin( angle ) ) ) );
		}
		
		/**
		 * The getArea method returns the size of the zone.
		 * This method is used by the MultiZone class. Usually, 
		 * it need not be called directly by the user.
		 * 
		 * @return The surface area of the disc.
		 */
		public function getVolume():Number
		{
			// treat as one pixel tall disc
			return ( _outerRadius * _outerRadius - _innerRadius * _innerRadius ) * Math.PI;
		}
	}
}
