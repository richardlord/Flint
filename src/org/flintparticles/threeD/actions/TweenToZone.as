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

package org.flintparticles.threeD.actions 
{
	import org.flintparticles.common.actions.ActionBase;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.threeD.geom.Point3D;
	import org.flintparticles.threeD.geom.Vector3D;
	import org.flintparticles.threeD.particles.Particle3D;
	import org.flintparticles.threeD.zones.Zone3D;

	[DefaultProperty("zone")]

	/**
	 * The TweenToZone action adjusts the particle's position between two
	 * locations as it ages. The start location is wherever the particle starts
	 * from, depending on the emitter and the initializers. The end position is
	 * a random point within the specified zone. The current position is relative 
	 * to the particle's energy,
	 * which changes as the particle ages in accordance with the energy easing
	 * function used. This action should be used in conjunction with the Age action.
	 */

	public class TweenToZone extends ActionBase
	{
		private var _zone:Zone3D;
		private var _temp:Vector3D;
		
		/**
		 * The constructor creates a TweenToZone action for use by an emitter. 
		 * To add a TweenToZone to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param zone The zone for the particle's position when its energy is 0.
		 */
		public function TweenToZone( zone:Zone3D = null )
		{
			_zone = zone;
		}
		
		/**
		 * The zone for the particle's position when its energy is 0.
		 */
		public function get zone():Zone3D
		{
			return _zone;
		}
		public function set zone( value:Zone3D ):void
		{
			_zone = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var p:Particle3D = Particle3D( particle );
			var data:TweenToZoneData;
			if( ! p.dictionary[this] )
			{
				var pt:Point3D = _zone.getLocation();
				data = new TweenToZoneData( p.position, pt );
				p.dictionary[this] = data;
			}
			else
			{
				data = p.dictionary[this];
			}
			
			data.end.add( data.diff.multiply( p.energy, _temp ), p.position );
		}
	}
}

import org.flintparticles.threeD.geom.Point3D;
import org.flintparticles.threeD.geom.Vector3D;

class TweenToZoneData
{
	public var diff:Vector3D;
	public var end:Point3D;
	
	public function TweenToZoneData( start:Point3D, end:Point3D )
	{
		this.diff = end.vectorTo( start );
		this.end = end.clone();
	}
}
