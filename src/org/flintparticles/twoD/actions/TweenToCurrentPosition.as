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

package org.flintparticles.twoD.actions
{
	import org.flintparticles.common.actions.ActionBase;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.initializers.Initializer;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.twoD.particles.Particle2D;
	import org.flintparticles.twoD.zones.Zone2D;

	import flash.geom.Point;

	[DefaultProperty("zone")]

	/**
	 * The TweenToCurrentPosition action adjusts the particle's position between two
	 * locations as it ages. The start location is a random point within the specified
	 * zone, and the end location is the particle's position when it is created or added 
	 * to the emitter. The current position is relative to the particle's energy,
	 * which changes as the particle ages in accordance with the energy easing
	 * function used. This action should be used in conjunction with the Age action.
	 */

	public class TweenToCurrentPosition extends ActionBase implements Initializer
	{
		private var _zone : Zone2D;

		/**
		 * The constructor creates a TweenToCurrentPosition action for use by an emitter. 
		 * To add a TweenToCurrentPosition to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param zone The zone for the particle's position when its energy is 0.
		 */
		public function TweenToCurrentPosition( zone : Zone2D = null )
		{
			_zone = zone;
			priority = -10;
		}

		/**
		 * The zone for the particle's position when its energy is 0.
		 */
		public function get zone() : Zone2D
		{
			return _zone;
		}

		public function set zone( value : Zone2D ) : void
		{
			_zone = value;
		}

		/**
		 * 
		 */
		override public function addedToEmitter( emitter : Emitter ) : void
		{
			if ( !emitter.hasInitializer( this ) )
			{
				emitter.addInitializer( this );
			}
		}

		override public function removedFromEmitter( emitter : Emitter ) : void
		{
			emitter.removeInitializer( this );
		}

		/**
		 * 
		 */
		public function initialize( emitter : Emitter, particle : Particle ) : void
		{
			var p : Particle2D = Particle2D( particle );
			var pt : Point = _zone.getLocation();
			var data : TweenToPositionData = new TweenToPositionData( pt.x, pt.y, p.x, p.y );
			p.dictionary[this] = data;
		}

		/**
		 * Calculates the current position of the particle based on it's energy.
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
		override public function update( emitter : Emitter, particle : Particle, time : Number ) : void
		{
			var p : Particle2D = Particle2D( particle );
			if ( !p.dictionary[this] )
			{
				initialize( emitter, particle );
			}
			var data : TweenToPositionData = p.dictionary[this];
			p.x = data.endX + data.diffX * p.energy;
			p.y = data.endY + data.diffY * p.energy;
		}
	}
}

class TweenToPositionData
{
	public var diffX : Number;
	public var diffY : Number;
	public var endX : Number;
	public var endY : Number;

	public function TweenToPositionData( startX : Number, startY : Number, endX : Number, endY : Number )
	{
		this.diffX = startX - endX;
		this.diffY = startY - endY;
		this.endX = endX;
		this.endY = endY;
	}
}
