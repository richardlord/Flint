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
	 * The LineZone zone defines a zone that contains all the points on a line.
	 */

	public class LineZone implements Zone3D 
	{
		private var _start:Point3D;
		private var _end:Point3D;
		private var _length:Vector3D;
		
		/**
		 * The constructor creates a LineZone 3D zone.
		 * 
		 * @param start The point at one end of the line.
		 * @param end The point at the other end of the line.
		 */
		public function LineZone( start:Point3D = null, end:Point3D = null )
		{
			_start = start ? start.clone() : new Point3D( 0, 0, 0 );
			_end = end ? end.clone() : new Point3D( 0, 0, 0 );
			setLength();
		}
		
		/**
		 * The point at one end of the line.
		 */
		public function get start() : Point3D
		{
			return _start;
		}
		public function set start( value : Point3D ) : void
		{
			_start = value.clone();
			setLength();
		}

		/**
		 * The point at the other end of the line.
		 */
		public function get end() : Point3D
		{
			return _end;
		}
		public function set end( value : Point3D ) : void
		{
			_end = value.clone();
			setLength();
		}

		private function setLength():void
		{
			if( _start && _end )
			{
				_length = _start.vectorTo( _end );
			}
		}

		/**
		 * The contains method determines whether a point is inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @param p The location to test for.
		 * @return true if point is inside the zone, false if it is outside.
		 */
		public function contains( p:Point3D ):Boolean
		{
			// is not on line through points if cross product is not zero
			if( ! _start.vectorTo( p ).crossProduct( _length ).lengthSquared < 0.00001 )
			{
				return false;
			}
			// is not between points if dot product of line to each point is the same sign
			return _start.vectorTo( p ).dotProduct( _end.vectorTo( p ) ) <= 0;
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
			return _start.add( _length.multiply( Math.random() ) );
		}
		
		/**
		 * The getArea method returns the size of the zone.
		 * This method is used by the MultiZone class. Usually, 
		 * it need not be called directly by the user.
		 * 
		 * @return The length of the line.
		 */
		public function getVolume():Number
		{
			// treat as one pixel tall rectangle
			return _length.length;
		}
	}
}
