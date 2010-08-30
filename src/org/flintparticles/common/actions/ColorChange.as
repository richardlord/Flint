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

package org.flintparticles.common.actions 
{
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.utils.interpolateColors;	

	/**
	 * The ColorChange action alters the color of the particle as it ages.
	 * It uses the particle's energy level to decide what colour to display.
	 * 
	 * <p>Usually a particle's energy changes from 1 to 0 over its lifetime, but
	 * this can be altered via the easing function set within the age action.</p>
	 * 
	 * <p>This action should be used in conjunction with the Age action.</p>
	 * 
	 * @see org.flintparticles.common.actions.Action
	 * @see org.flintparticles.common.actions.Age
	 */

	public class ColorChange extends ActionBase
	{
		private var _startColor:uint;
		private var _endColor:uint;
		
		/**
		 * The constructor creates a ColorChange action for use by an emitter. 
		 * To add a ColorChange to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param startColor The 32bit (ARGB) color of the particle when its
		 * energy is 1 - usually at the beginning of its life.
		 * @param endColor The 32bit (ARGB) color of the particle when its 
		 * energy is 0 - usually at the end of its life.
		 */
		public function ColorChange( startColor:uint = 0xFFFFFF, endColor:uint = 0xFFFFFF )
		{
			_startColor = startColor;
			_endColor = endColor;
		}
		
		/**
		 * The color of the particle when its energy is 1.
		 */
		public function get startColor():uint
		{
			return _startColor;
		}
		public function set startColor( value:uint ):void
		{
			_startColor = value;
		}
		
		/**
		 * The color of the particle when its energy is zero.
		 */
		public function get endColor():uint
		{
			return _endColor;
		}
		public function set endColor( value:uint ):void
		{
			_endColor = value;
		}

		/**
		 * Sets the color of the particle based on the colors and the particle's 
		 * energy level.
		 * 
		 * <p>This method is called by the emitter and need not be called by the 
		 * user</p>
		 * 
		 * @param emitter The Emitter that created the particle.
		 * @param particle The particle to be updated.
		 * @param time The duration of the frame - used for time based updates.
		 * 
		 * @see org.flintparticles.common.actions.Action#update()
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			particle.color = interpolateColors( _startColor, _endColor, particle.energy );
		}
	}
}
