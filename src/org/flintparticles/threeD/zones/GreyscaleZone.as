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
	import org.flintparticles.common.utils.FastWeightedArray;
	import org.flintparticles.threeD.geom.Matrix3D;
	import org.flintparticles.threeD.geom.Point3D;
	import org.flintparticles.threeD.geom.Vector3D;
	
	import flash.display.BitmapData;
	import flash.geom.Point;	

	/**
	 * The Greyscale zone defines a shaped zone based on a BitmapData object.
	 * The zone contains all pixels in the bitmap that are not black, with a weighting
	 * such that lighter pixels are more likely to be selected than darker pixels
	 * when creating particles inside the zone.
	 */

	public class GreyscaleZone implements Zone3D 
	{
		private var _bitmapData : BitmapData;
		private var _corner : Point3D;
		private var _top : Vector3D;
		private var _scaledWidth : Vector3D;
		private var _left : Vector3D;
		private var _scaledHeight : Vector3D;
		private var _normal : Vector3D;
		private var _basis : Matrix3D;
		private var _distToOrigin:Number;
		private var _dirty:Boolean;
		private var _volume : Number;
		private var _validPoints : FastWeightedArray;
		
		/**
		 * The constructor creates a Greyscale zone. To avoid distorting the zone, the top
		 * and left vectors should be perpendicular and the same lengths as the width and
		 * height of the bitmap data object. Vectors that are not the same width and height
		 * as the bitmap data object will scale the zone and vectors that are not perpendicular
		 * will skew the zone.
		 * 
		 * @param bitmapData The bitmapData object that defines the zone.
		 * @param corner The position for the top left corner of the bitmap data for the zone.
		 * @param top The top side of the zone from the corner. The length of the vector 
		 * indicates how long the side is.
		 * @param left The left side of the zone from the corner. The length of the
		 * vector indicates how long the side is.
		 */
		public function GreyscaleZone( bitmapData : BitmapData = null, corner:Point3D = null, top:Vector3D = null, left:Vector3D = null )
		{
			_bitmapData = bitmapData;
			_corner = corner ? corner.clone() : new Point3D( 0, 0, 0 );
			_top = top ? top.clone() : new Vector3D( 1, 0, 0 );
			_left = left ? left.clone() : new Vector3D( 0, -1, 0 );
			if( _bitmapData )
			{
				_dirty = true;
				invalidate();
			}
		}
		
		/**
		 * The bitmapData object that defines the zone.
		 */
		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}
		public function set bitmapData( value : BitmapData ) : void
		{
			_bitmapData = value;
			invalidate();
		}

		/**
		 * The position for the top left corner of the bitmap data for the zone.
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
		 * The top side of the zone from the corner. The length of the vector 
		 * indicates how long the side is.
		 */
		public function get top() : Vector3D
		{
			return _top.clone();
		}

		public function set top( value : Vector3D ) : void
		{
			_top = value;
			_dirty = true;
		}

		/**
		 * The left side of the zone from the corner. The length of the
		 * vector indicates how long the side is.
		 */
		public function get left() : Vector3D
		{
			return _left.clone();
		}

		public function set left( value : Vector3D ) : void
		{
			_left = value;
			_dirty = true;
		}

		/**
		 * This method forces the zone to revaluate itself. It should be called whenever the 
		 * contents of the BitmapData object change. However, it is an intensive method and 
		 * calling it frequently will likely slow your code down.
		 */
		public function invalidate():void
		{
			_validPoints = new FastWeightedArray();
			for( var x : int = 0; x < _bitmapData.width ; ++x )
			{
				for( var y : int = 0; y < _bitmapData.height ; ++y )
				{
					var pixel : uint = _bitmapData.getPixel32( x, y );
					var grey : Number = 0.11 * ( pixel & 0xFF ) + 0.59 * ( ( pixel >>> 8 ) & 0xFF ) + 0.3 * ( ( pixel >>> 16 ) & 0xFF );
					if ( grey != 0 )
					{
						_validPoints.add( new Point( x, _bitmapData.height-y ), grey / 255 );
					}
				}
			}
			_volume = _top.crossProduct( _left ).length * _validPoints.totalRatios / ( _bitmapData.width * _bitmapData.height );
			_dirty = true;
		}

		private function init():void
		{
			_normal = _top.crossProduct( _left );
			_distToOrigin = _normal.dotProduct( _corner.toVector3D() );
			_scaledWidth = _top.multiply( 1 / _bitmapData.width );
			_scaledHeight = _left.multiply( 1 / _bitmapData.height );
			_basis = Matrix3D.newBasisTransform( _scaledWidth, _scaledHeight, _top.crossProduct( _left ).normalize() );
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
			
			var pixel : uint = _bitmapData.getPixel32( Math.round( q.x ), Math.round( _bitmapData.height-q.y ) );
			return ( pixel & 0xFFFFFF ) != 0;
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
			var point:Point =  Point( _validPoints.getRandomValue() ).clone();
			return _corner.add( _scaledWidth.multiply( point.x ).incrementBy( _scaledHeight.multiply( point.y ) ) );
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
			return _volume;
		}
	}
}