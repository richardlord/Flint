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
	import org.flintparticles.threeD.geom.Vector3DUtils;

	import flash.geom.Vector3D;

	/**
	 * The LineZone zone defines a zone that contains all the points on a line.
	 */

	public class LineZone implements Zone3D 
	{
		private var _start:Vector3D;
		private var _end:Vector3D;
		private var _length:Vector3D;
		
		/**
		 * The constructor creates a LineZone 3D zone.
		 * 
		 * @param start The point at one end of the line.
		 * @param end The point at the other end of the line.
		 */
		public function LineZone( start:Vector3D = null, end:Vector3D = null )
		{
			this.start = start ? start : new Vector3D();
			this.end = end ? end : new Vector3D();
		}
		
		/**
		 * The point at one end of the line.
		 */
		public function get start() : Vector3D
		{
			return _start.clone();
		}
		public function set start( value : Vector3D ) : void
		{
			_start = Vector3DUtils.clonePoint( value );
			setLength();
		}

		/**
		 * The point at the other end of the line.
		 */
		public function get end() : Vector3D
		{
			return _end.clone();
		}
		public function set end( value : Vector3D ) : void
		{
			_end = Vector3DUtils.clonePoint( value );
			setLength();
		}

		private function setLength():void
		{
			if( _start && _end )
			{
				_length = _end.subtract( _start );
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
		public function contains( p:Vector3D ):Boolean
		{
			var vectorToPoint:Vector3D = p.subtract( _start );
			// is not on line through points if cross product is not zero
			if( ! vectorToPoint.crossProduct( _length ).lengthSquared < 0.00001 )
			{
				return false;
			}
			// is not between points if dot product of line to each point is the same sign
			return vectorToPoint.dotProduct( p.subtract( _end ) ) <= 0;
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
			var len:Vector3D = _length.clone();
			len.scaleBy( Math.random() );
			return _start.add( len );
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
