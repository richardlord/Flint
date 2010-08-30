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

package org.flintparticles.twoD.actions 
{
	import org.flintparticles.common.actions.ActionBase;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.twoD.particles.Particle2D;
	import org.flintparticles.twoD.zones.Zone2D;	

	/**
	 * The Jet Action applies an acceleration to particles only if they are in 
	 * the specified zone. 
	 */

	public class Jet extends ActionBase
	{
		private var _x:Number;
		private var _y:Number;
		private var _zone:Zone2D;
		private var _invert:Boolean;
		
		/**
		 * The constructor creates a Jet action for use by an emitter. 
		 * To add a Jet to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param accelerationX The x component of the acceleration to apply, in 
		 * pixels per second per second.
		 * @param accelerationY The y component of the acceleration to apply, in 
		 * pixels per second per second.
		 * @param zone The zone in which to apply the acceleration.
		 * @param invertZone If false (the default) the acceleration is applied 
		 * only to particles inside the zone. If true the acceleration is applied 
		 * only to particles outside the zone.
		 */
		public function Jet( accelerationX:Number = 0, accelerationY:Number = 0, zone:Zone2D = null, invertZone:Boolean = false )
		{
			this.x = accelerationX;
			this.y = accelerationY;
			this.zone = zone;
			this.invertZone = invertZone;
		}
		
		/**
		 * The x component of the acceleration to apply, in 
		 * pixels per second per second.
		 */
		public function get x():Number
		{
			return _x;
		}
		public function set x( value:Number ):void
		{
			_x = value;
		}
		
		/**
		 * The y component of the acceleration to apply, in 
		 * pixels per second per second.
		 */
		public function get y():Number
		{
			return _y;
		}
		public function set y( value:Number ):void
		{
			_y = value;
		}
		
		/**
		 * The zone in which to apply the acceleration.
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
		 * If false (the default) the acceleration is applied 
		 * only to particles inside the zone. If true the acceleration is applied 
		 * only to particles outside the zone.
		 */
		public function get invertZone():Boolean
		{
			return _invert;
		}
		public function set invertZone( value:Boolean ):void
		{
			_invert = value;
		}
		
		/**
		 * Checks if the particle is inside the zone and, if so, applies the 
		 * acceleration to the particle for the period of time indicated.
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
			var p:Particle2D = Particle2D( particle );
			if( _zone.contains( p.x, p.y ) )
			{
				if( !_invert )
				{
					p.velX += _x * time;
					p.velY += _y * time;
				}
			}
			else
			{
				if( _invert )
				{
					p.velX += _x * time;
					p.velY += _y * time;
				}
			}
		}
	}
}
