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

	/**
	 * The MutiZone zone defines a zone that combines other zones into one larger zone.
	 */

	public class MultiZone implements Zone3D 
	{
		private var _zones : Array;
		private var _volumes : Array;
		private var _totalVolume : Number;
		
		/**
		 * The constructor defines a MultiZone zone.
		 */
		public function MultiZone()
		{
			_zones = new Array();
			_volumes = new Array();
			_totalVolume = 0;
		}
		
		/**
		 * The addZone method is used to add a zone into this MultiZone object.
		 * 
		 * @param zone The zone you want to add.
		 */
		public function addZone( zone:Zone3D ):void
		{
			_zones.push( zone );
			var volume:Number = zone.getVolume();
			_volumes.push( volume );
			_totalVolume += volume;
		}
		
		/**
		 * The removeZone method is used to remove a zone from this MultiZone object.
		 * 
		 * @param zone The zone you want to remove.
		 */
		public function removeZone( zone:Zone3D ):void
		{
			var len:int = _zones.length;
			for( var i:int = 0; i < len; ++i )
			{
				if( _zones[i] == zone )
				{
					_totalVolume -= _volumes[i];
					_volumes.splice( i, 1 );
					_zones.splice( i, 1 );
					return;
				}
			}
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
			var len:int = _zones.length;
			for( var i:int = 0; i < len; ++i )
			{
				if( Zone3D( _zones[i] ).contains( p ) )
				{
					return true;
				}
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
			var selectZone:Number = Math.random() * _totalVolume;
			var len:int = _zones.length;
			for( var i:int = 0; i < len; ++i )
			{
				if( ( selectZone -= _volumes[i] ) <= 0 )
				{
					return Zone3D( _zones[i] ).getLocation();
				}
			}
			if( _zones.length == 0 )
			{
				throw new Error( "Attempt to use a MultiZone object that contains no Zones" );
			}
			else
			{
				return Zone3D( _zones[0] ).getLocation();
			}
			return null;
		}
		
		/**
		 * The getArea method returns the size of the zone.
		 * This method is used by the MultiZone class. Usually, 
		 * it need not be called directly by the user.
		 * 
		 * @return The volume of all the zones combined.
		 */
		public function getVolume():Number
		{
			return _totalVolume;
		}
	}
}
