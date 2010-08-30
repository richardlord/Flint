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
	import org.flintparticles.threeD.geom.Vector3D;
	import org.flintparticles.threeD.particles.Particle3D;
	import org.flintparticles.threeD.zones.Zone3D;	

	/**
	 * The Jet Action applies an acceleration to the particle only if it is in the specified zone. 
	 */

	public class Jet extends ActionBase
	{
		private var _acc:Vector3D;
		private var _zone:Zone3D;
		private var _invert:Boolean;
		private var _temp:Vector3D;
		
		/**
		 * The constructor creates a Jet action for use by 
		 * an emitter. To add a Jet to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param accelerationX The x coordinate of the acceleration to apply, in pixels 
		 * per second per second.
		 * @param accelerationY The y coordinate of the acceleration to apply, in pixels 
		 * per second per second.
		 * @param zone The zone in which to apply the acceleration.
		 * @param invertZone If false (the default) the acceleration is applied only to particles inside 
		 * the zone. If true the acceleration is applied only to particles outside the zone.
		 */
		public function Jet( acceleration:Vector3D = null, zone:Zone3D = null, invertZone:Boolean = false )
		{
			_temp = new Vector3D();
			this.acceleration = acceleration ? acceleration : Vector3D.ZERO;
			this.zone = zone;
			this.invertZone = invertZone;
		}
		
		/**
		 * The acceleration, in coordinate units per second per second.
		 */
		public function get acceleration():Vector3D
		{
			return _acc;
		}
		public function set acceleration( value:Vector3D ):void
		{
			_acc = value.clone();
		}
		
		/**
		 * The zone in which to apply the acceleration.
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
		 * If true, the zone is treated as the safe area and being ouside the zone
		 * results in the particle dying. Otherwise, being inside the zone causes the
		 * particle to die.
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
		 * The x coordinate of the acceleration, in coordinate units per second per second.
		 */
		public function get x():Number
		{
			return _acc.x;
		}
		public function set x( value:Number ):void
		{
			_acc.x = value;
		}
		
		/**
		 * The y coordinate of the acceleration, in coordinate units per second per second.
		 */
		public function get y():Number
		{
			return _acc.y;
		}
		public function set y( value:Number ):void
		{
			_acc.y = value;
		}
		
		/**
		 * The z coordinate of the acceleration, in coordinate units per second per second.
		 */
		public function get z():Number
		{
			return _acc.z;
		}
		public function set z( value:Number ):void
		{
			_acc.z = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var p:Particle3D = Particle3D( particle );
			if( _zone.contains( p.position ) )
			{
				if( !_invert )
				{
					p.velocity.incrementBy( _acc.multiply( time, _temp ) );
				}
			}
			else
			{
				if( _invert )
				{
					p.velocity.incrementBy( _acc.multiply( time, _temp ) );
				}
			}
		}
	}
}
