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
	import org.flintparticles.threeD.particles.Particle3D;
	import org.flintparticles.threeD.zones.Zone3D;	

	[DefaultProperty("zone")]

	/**
	 * The DeathZone action marks the particle as dead if it is inside
	 * a specific zone.
	 * 
	 * This action has a priority of -20, so that it executes after 
	 * all movement has occured.
	 */

	public class DeathZone extends ActionBase
	{
		private var _zone:Zone3D;
		private var _invertZone:Boolean;
		
		/**
		 * The constructor creates a DeathZone action for use by an emitter. 
		 * To add a DeathZone to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * @see org.flintparticles.threeD.zones
		 * 
		 * @param zone The zone to use. Any item from the 
		 * org.flintparticles.threeD.zones package can be used.
		 * @param zoneIsSafe If true, the zone is treated as the safe area
		 * and particles outside the zone are killed. If false, particles
		 * inside the zone are killed.
		 */
		public function DeathZone( zone:Zone3D = null, zoneIsSafe:Boolean = false )
		{
			priority = -20;
			this.zone = zone;
			this.zoneIsSafe = zoneIsSafe;
		}
		
		/**
		 * The zone.
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
		 * If true, the zone is treated as the safe area and particles ouside the 
		 * zone are killed. If false, particles inside the zone are killed.
		 */
		public function get zoneIsSafe():Boolean
		{
			return _invertZone;
		}
		public function set zoneIsSafe( value:Boolean ):void
		{
			_invertZone = value;
		}

		/**
		 * Checks whether the particle is inside the zone and kills it if it is
		 * in the DeathZone region.
		 * 
		 * <p>This method is called by the emitter and need not be called by the 
		 * user.</p>
		 * 
		 * @param emitter The Emitter that created the particle.
		 * @param particle The particle to be updated.
		 * @param time The duration of the frame - used for time based updates.
		 * 
		 * @see org.flintparticles.common.actions.Action#update()
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var p:Particle3D = Particle3D( particle );
			var inside:Boolean = _zone.contains( p.position );
			if ( _invertZone )
			{
				inside = !inside;
			}
			if ( inside )
			{
				p.isDead = true;
			}
		}
	}
}
