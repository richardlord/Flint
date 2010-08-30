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
	 * The CylinderZone zone defines a zone that contains all the points in a 
	 * cylinder. The cylinder can be positioned anywhere in 3D space and may,
	 * optionally, have a hole running down the centre of it.
	 */

	public class CylinderZone implements Zone3D 
	{
		private var _center:Point3D;
		private var _axis:Vector3D;
		private var _innerRadius:Number;
		private var _innerRadiusSq:Number;
		private var _outerRadius:Number;
		private var _outerRadiusSq:Number;
		private var _length:Number;
		private var _perp1:Vector3D;
		private var _perp2:Vector3D;
		private var _dirty:Boolean;
		
		/**
		 * The constructor creates a CylinderZone 3D zone.
		 * 
		 * @param center The point at the center of one end of the cylinder.
		 * @param axis A vector along the central axis of the cylinder from
		 * the center and towards the other end of the cylinder.
		 * @param length The length of the cylinder.
		 * @param outerRadius The outer radius of the cylinder.
		 * @param innerRadius The inner radius of the cylinder. This defines the 
		 * hole in the center of the cylinder that runs the length of the cylinder.
		 * If this is set to zero, there is no hole. 
		 */
		public function CylinderZone( center:Point3D = null, axis:Vector3D = null, length:Number = 0, outerRadius:Number = 0, innerRadius:Number = 0 )
		{
			_center = center ? center.clone() : new Point3D( 0, 0, 0 );
			_axis = axis ? axis.unit() : new Vector3D( 0, 1, 0 );
			_innerRadius = innerRadius;
			_innerRadiusSq = innerRadius * innerRadius;
			_outerRadius = outerRadius;
			_outerRadiusSq = outerRadius * outerRadius;
			_length = length;
			_dirty = true;
		}
		
		private function init():void
		{
			var axes:Array = Vector3DUtils.getPerpendiculars( _axis );
			_perp1 = axes[0];
			_perp2 = axes[1];
			_dirty = false;
		}
		
		/**
		 * The point at the center of one end of the cylinder.
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
		 * The central axis of the cylinder, from the center point towards the other end.
		 */
		public function get axis() : Vector3D
		{
			return _axis.clone();
		}
		public function set axis( value : Vector3D ) : void
		{
			_axis = value.clone();
			_dirty = true;
		}
		
		/**
		 * The length of the cylinder.
		 */
		public function get length() : Number
		{
			return _length;
		}
		public function set length( value : Number ) : void
		{
			_length = value;
		}
		
		/**
		 * The outer radius of the cylinder.
		 */
		public function get outerRadius() : Number
		{
			return _outerRadius;
		}
		public function set outerRadius( value : Number ) : void
		{
			_outerRadius = value;
		}
		
		/**
		 * The inner radius of the cylinder. This defines the 
		 * hole in the center of the cylinder that runs the length of the cylinder.
		 * If this is set to zero, there is no hole.
		 */
		public function get innerRadius() : Number
		{
			return _innerRadius;
		}
		public function set innerRadius( value : Number ) : void
		{
			_innerRadius = value;
		}
		
		/**
		 * The contains method determines whether a point is inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @param p The location to test.
		 * @return true if the location is inside the cylinder, false if it is outside.
		 */
		public function contains( p:Point3D ):Boolean
		{
			if( _dirty )
			{
				init();
			}

			var q:Vector3D = _center.vectorTo( p );
			var d:Number = q.dotProduct( _axis );
			if( d < 0 || d > _length )
			{
				return false;
			}
			q.decrementBy( _axis.multiply( d ) );
			var len:Number = q.lengthSquared;
			return len >= _innerRadiusSq && len <= _outerRadiusSq;
		}
		
		/**
		 * The getLocation method returns a random point inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @return a random point inside the cylinder.
		 */
		public function getLocation():Point3D
		{
			if( _dirty )
			{
				init();
			}

			var l:Number = Math.random() * _length;
			
			var r:Number = Math.random();
			r = _innerRadius + ( 1 - r * r ) * ( _outerRadius - _innerRadius );
			
			var a:Number = Math.random() * 2 * Math.PI;
			var p:Vector3D = _perp1.multiply( r * Math.cos( a ) );
			p.incrementBy( _perp2.multiply( r * Math.sin( a ) ) );
			p.incrementBy( _axis.multiply( l ) );
			return _center.add( p );
		}
		
		/**
		 * The getArea method returns the size of the zone.
		 * This method is used by the MultiZone class. Usually, 
		 * it need not be called directly by the user.
		 * 
		 * @return The volume of the cylinder
		 */
		public function getVolume():Number
		{
			return ( _outerRadiusSq - _innerRadiusSq ) * _length * Math.PI;
		}
	}
}
