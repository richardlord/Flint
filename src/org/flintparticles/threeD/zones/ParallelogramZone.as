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
	import org.flintparticles.threeD.geom.Matrix3D;
	import org.flintparticles.threeD.geom.Point3D;
	import org.flintparticles.threeD.geom.Vector3D;	

	/**
	 * The PrallelogramZone zone defines a four sided zone n which opposite sides are parallel.
	 * If the two side vectors are perpendicular to each other, then the zone is rectangular.
	 */
	public class ParallelogramZone implements Zone3D 
	{
		private var _corner : Point3D;
		private var _side1 : Vector3D;
		private var _side2 : Vector3D;
		private var _normal : Vector3D;
		private var _basis : Matrix3D;
		private var _distToOrigin:Number;
		private var _dirty:Boolean;
		
		/**
		 * The constructor creates a PrallelogramZone zone.
		 * 
		 * @param corner A corner of the zone.
		 * @param side1 One side of the zone from the corner. The length of the vector 
		 * indicates how long the side is.
		 * @param side2 The other side of the zone from the corner. The length of the
		 * vector indicates how long the side is.
		 */
		public function ParallelogramZone( corner:Point3D = null, side1:Vector3D = null, side2:Vector3D = null )
		{
			_corner = corner ? corner.clone() : new Point3D( 0, 0, 0 );
			_side1 = side1 ? side1.clone() : new Vector3D( 1, 0, 0 );
			_side2 = side2 ? side2.clone() : new Vector3D( 0, -1, 0 );
			_dirty = true;
		}
		
		/**
		 * A corner of the zone.
		 */
		public function get corner() : Point3D
		{
			return _corner.clone();
		}

		public function set corner( value : Point3D ) : void
		{
			_corner = value.clone();
		}

		/**
		 * One side of the zone from the corner. The length of the vector 
		 * indicates how long the side is.
		 */
		public function get side1() : Vector3D
		{
			return _side1.clone();
		}

		public function set side1( value : Vector3D ) : void
		{
			_side1 = value;
			_dirty = true;
		}

		/**
		 * The other side of the zone from the corner. The length of the
		 * vector indicates how long the side is.
		 */
		public function get side2() : Vector3D
		{
			return _side2.clone();
		}

		public function set side2( value : Vector3D ) : void
		{
			_side2 = value;
			_dirty = true;
		}

		private function init():void
		{
			_normal = _side1.crossProduct( _side2 );
			_distToOrigin = _normal.dotProduct( _corner.toVector3D() );
			_basis = Matrix3D.newBasisTransform( _side1, _side2, _side1.crossProduct( _side2 ).normalize() );
			_basis.prependTranslate( -_corner.x, -_corner.y, -_corner.z );
			_dirty = false;
		}

		/**
		 * The contains method determines whether a point is inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @param x The x coordinate of the location to test for.
		 * @param y The y coordinate of the location to test for.
		 * @return true if point is inside the zone, false if it is outside.
		 */
		public function contains( p:Point3D ):Boolean
		{
			if( _dirty )
			{
				init();
			}
			var dist:Number = _normal.dotProduct( p.toVector3D() );
			if( Math.abs( dist - _distToOrigin ) > 0.1 ) // test for close, not exact
			{
				return false;
			}
			var q:Point3D = p.clone();
			_basis.transformSelf( q );
			return q.x >= 0 && q.x <= 1 && q.y >= 0 && q.y <= 1;
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
			return _corner.add( _side1.multiply( Math.random() ).incrementBy( _side2.multiply( Math.random() ) ) );
		}
		
		/**
		 * The getVolume method returns the size of the zone.
		 * This method is used by the MultiZone class. Usually, 
		 * it need not be called directly by the user.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getVolume():Number
		{
			return _side1.crossProduct( _side2 ).length;
		}
	}
}
