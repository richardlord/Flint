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

package org.flintparticles.twoD.zones 
{
	import org.flintparticles.twoD.particles.Particle2D;

	import flash.geom.Point;

	/**
	 * The MutiZone zone defines a zone that combines other zones into one larger zone.
	 */

	public class MultiZone implements Zone2D 
	{
		private var _zones : Array;
		private var _areas : Array;
		private var _totalArea : Number;
		
		/**
		 * The constructor defines a MultiZone zone.
		 */
		public function MultiZone()
		{
			_zones = new Array();
			_areas = new Array();
			_totalArea = 0;
		}
		
		/**
		 * The addZone method is used to add a zone into this MultiZone object.
		 * 
		 * @param zone The zone you want to add.
		 */
		public function addZone( zone:Zone2D ):void
		{
			_zones.push( zone );
			var area:Number = zone.getArea();
			_areas.push( area );
			_totalArea += area;
		}
		
		/**
		 * The removeZone method is used to remove a zone from this MultiZone object.
		 * 
		 * @param zone The zone you want to add.
		 */
		public function removeZone( zone:Zone2D ):void
		{
			var len:int = _zones.length;
			for( var i:int = 0; i < len; ++i )
			{
				if( _zones[i] == zone )
				{
					_totalArea -= _areas[i];
					_areas.splice( i, 1 );
					_zones.splice( i, 1 );
					return;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function contains( x:Number, y:Number ):Boolean
		{
			var len:int = _zones.length;
			for( var i:int = 0; i < len; ++i )
			{
				if( Zone2D( _zones[i] ).contains( x, y ) )
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLocation():Point
		{
			var selectZone:Number = Math.random() * _totalArea;
			var len:int = _zones.length;
			for( var i:int = 0; i < len; ++i )
			{
				if( ( selectZone -= _areas[i] ) <= 0 )
				{
					return Zone2D( _zones[i] ).getLocation();
				}
			}
			if( _zones.length == 0 )
			{
				throw new Error( "Attempt to use a MultiZone object that contains no Zones" );
			}
			else
			{
				return Zone2D( _zones[0] ).getLocation();
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getArea():Number
		{
			return _totalArea;
		}
		
		/**
		 * @inheritDoc
		 */
		public function collideParticle( particle:Particle2D, bounce:Number = 1 ):Boolean
		{
			var collide:Boolean = false;
			for each( var zone:Zone2D in _zones )
			{
				collide = zone.collideParticle( particle, bounce ) || collide;
			}
			return collide;
		}
	}
}
