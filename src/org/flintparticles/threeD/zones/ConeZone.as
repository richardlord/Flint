/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
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

package org.flintparticles.threeD.zones 
{
	import flash.geom.Vector3D;
	import org.flintparticles.threeD.geom.Vector3DUtils;	

	/**
	 * The ConeZone zone defines a zone that contains all the points inside a cone.
	 * The cone can be positioned anywhere in 3D space. The cone may, optionally,
	 * have its top removed, leaving a truncated base as the zone.
	 */

	public class ConeZone implements Zone3D 
	{
		private var _apex:Vector3D;
		private var _axis:Vector3D;
		private var _angle:Number;
		private var _minDist:Number;
		private var _maxDist:Number;
		private var _perp1:Vector3D;
		private var _perp2:Vector3D;
		private var _dirty:Boolean;
		
		/**
		 * The constructor creates a ConeZone 3D zone.
		 * 
		 * @param apex The point at the apex of the cone.
		 * @param axis A vector along the central axis of the cone from
		 * the apex and towards the base of the cone.
		 * @param angle The angle at the apex of the cone.
		 * @param height The height of the cone.
		 * @param truncatedHeight The height at which the top of the cone is removed, leaving 
		 * just the base from height to truncatedHeight. 
		 */
		public function ConeZone( apex:Vector3D = null, axis:Vector3D = null, angle:Number = 0, height:Number = 0, truncatedHeight:Number = 0 )
		{
			this.apex = apex ? apex : new Vector3D();
			this.axis = axis ? axis : Vector3D.Y_AXIS;
			this.angle = angle;
			this.truncatedHeight = truncatedHeight;
			this.height = height;
		}
		
		private function init():void
		{
			var axes:Array = Vector3DUtils.getPerpendiculars( _axis );
			_perp1 = axes[0];
			_perp2 = axes[1];
			_dirty = false;
		}

		private function radiusAtHeight( h:Number ):Number
		{
			return Math.tan( _angle / 2 ) * h;
		}

		/**
		 * The point at the apex of the cone.
		 */
		public function get apex() : Vector3D
		{
			return _apex.clone();
		}
		public function set apex( value : Vector3D ) : void
		{
			_apex = Vector3DUtils.clonePoint( value );
		}

		/**
		 * The central axis of the cone, from the apex towards the base.
		 */
		public function get axis() : Vector3D
		{
			return _axis.clone();
		}
		public function set axis( value : Vector3D ) : void
		{
			_axis = Vector3DUtils.cloneVector( value );
			_dirty = true;
		}
		
		/**
		 * The angle at the apex of the cone.
		 */
		public function get angle() : Number
		{
			return _angle;
		}
		public function set angle( value : Number ) : void
		{
			_angle = value;
		}
		
		/**
		 * The height of the cone.
		 */
		public function get height() : Number
		{
			return _maxDist;
		}
		public function set height( value : Number ) : void
		{
			_maxDist = value;
		}
		
		/**
		 * The height at which the top of the cone is removed, leaving 
		 * just the base from height to truncatedHeight.
		 */
		public function get truncatedHeight() : Number
		{
			return _minDist;
		}
		public function set truncatedHeight( value : Number ) : void
		{
			_minDist = value;
		}
		
		/**
		 * The contains method determines whether a point is inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @param p The location to test.
		 * @return true if the location is inside the zone, false if it is outside.
		 */
		public function contains( p:Vector3D ):Boolean
		{
			if( _dirty )
			{
				init();
			}

			var q:Vector3D = p.subtract( _apex );
			var d:Number = q.dotProduct( _axis );
			if( d < _minDist || d > _maxDist )
			{
				return false;
			}
			var dec:Vector3D = _axis.clone();
			dec.scaleBy( d );
			q.decrementBy( dec );
			var len:Number = q.lengthSquared;
			var r:Number = radiusAtHeight( d );
			return len <= r * r;
		}
		
		/**
		 * The getLocation method returns a random point inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getLocation():Vector3D
		{
			if( _dirty )
			{
				init();
			}

			var h:Number = Math.random();
			h = _minDist + ( 1 - h * h ) * ( _maxDist - _minDist );
			
			var r:Number = Math.random();
			r = ( 1 - r * r ) * radiusAtHeight( h );
			
			var a:Number = Math.random() * 2 * Math.PI;
			var p1:Vector3D = _perp1.clone();
			p1.scaleBy( r * Math.cos( a ) );
			var p2:Vector3D = _perp2.clone();
			p2.scaleBy( r * Math.sin( a ) );
			var ax:Vector3D = _axis.clone();
			ax.scaleBy( h );
			p1.incrementBy( p2 );
			p1.incrementBy( ax );
			return _apex.add( p1 );
		}
		
		/**
		 * The getArea method returns the size of the zone.
		 * This method is used by the MultiZone class. Usually, 
		 * it need not be called directly by the user.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getVolume():Number
		{
			var r1:Number = radiusAtHeight( _minDist );
			var r2:Number = radiusAtHeight( _maxDist );
			return ( _maxDist * r2 * r2 - _minDist * r1 * r1 ) * Math.PI / 3;
		}
	}
}
