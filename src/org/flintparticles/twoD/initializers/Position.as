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
	 * The Position Initializer sets the initial location of the particle.
	 * 
	 * <p>The class uses zones to place the particle. A zone defines a region
	 * in relation to the emitter and the particle is placed at a random point within
	 * that region. For precise placement, the Point zone defines a single
	 * point at which all particles will be placed. Various zones (and the
	 * Zones interface for use when implementing custom zones) are defined
	 * in the org.flintparticles.twoD.zones package.</p>
	 */
	public class Position extends InitializerBase
	{
		private var _zone : Zone2D;

		/**
		 * The constructor creates a Position initializer for use by 
		 * an emitter. To add a Position to all particles created by an emitter, use the
		 * emitter's addInitializer method.
		 * 
		 * @param zone The zone to place all particles in.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function Position( zone : Zone2D = null )
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
		override public function initialize( emitter : Emitter, particle : Particle ) : void
		{
			var p:Particle2D = Particle2D( particle );
			var loc:Point = _zone.getLocation();
			if( p.rotation == 0 )
			{
				p.x += loc.x;
				p.y += loc.y;
			}
			else
			{
				var sin:Number = Math.sin( p.rotation );
				var cos:Number = Math.cos( p.rotation );
				p.x += cos * loc.x - sin * loc.y;
				p.y += cos * loc.y + sin * loc.x;
			}
			p.previousX = p.x;
			p.previousY = p.y;
		}
	}
}
