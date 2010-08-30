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

package org.flintparticles.twoD.initializers 
{
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.initializers.InitializerBase;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.twoD.particles.Particle2D;
	import org.flintparticles.twoD.zones.Zone2D;
	
	import flash.geom.Point;	

	[DefaultProperty("zone")]
	
	/**
	 * The ColorInit Initializer sets the velocity of the particle. It is
	 * usually combined with the Move action to move the particle
	 * using this velocity.
	 * 
	 * <p>The initial velocity is defined using a zone from the 
	 * org.flintparticles.twoD.zones package. The use of zones enables diverse 
	 * ranges of velocities. For example, to use a specific velocity,
	 * a Point zone can be used. To use a varied speed in a specific
	 * direction, a LineZone zone can be used. For a fixed speed in
	 * a varied direction, a Disc or DiscSector zone with identical
	 * inner and outer radius can be used. A Disc or DiscSector with
	 * different inner and outer radius produces a range of speeds
	 * in a range of directions.
	 */

	public class Velocity extends InitializerBase
	{
		private var _zone:Zone2D;

		/**
		 * The constructor creates a Velocity initializer for use by 
		 * an emitter. To add a Velocity to all particles created by an emitter, use the
		 * emitter's addInitializer method.
		 * 
		 * @param velocity The zone to use for creating the velocity.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function Velocity( zone:Zone2D = null )
		{
			this.zone = zone;
		}
		
		/**
		 * The zone.
		 */
		public function get zone():Zone2D
		{
			return _zone;
		}
		public function set zone( value:Zone2D ):void
		{
			_zone = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			var p:Particle2D = Particle2D( particle );
			var loc:Point = _zone.getLocation();
			if( p.rotation == 0 )
			{
				p.velX = loc.x;
				p.velY = loc.y;
			}
			else
			{
				var sin:Number = Math.sin( p.rotation );
				var cos:Number = Math.cos( p.rotation );
				p.velX = cos * loc.x - sin * loc.y;
				p.velY = cos * loc.y + sin * loc.x;
			}
		}
	}
}
