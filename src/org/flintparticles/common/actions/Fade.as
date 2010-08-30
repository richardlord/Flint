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

	/**
	 * The Fade action adjusts the particle's alpha as it ages.
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

	public class Fade extends ActionBase
	{
		private var _diffAlpha:Number;
		private var _endAlpha:Number;
		
		/**
		 * The constructor creates a Fade action for use by 
		 * an emitter. To add a Fade to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * <p>This action has a priority of -5, so that the Fade executes after 
		 * color changes.</p>
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param startAlpha The alpha value for the particle when its energy
		 * is 1 - usually at the start of its lifetime. The value should be 
		 * between 0 and 1.
		 * @param endAlpha The alpha value of the particle when its energy
		 * is 0 - usually at the end of its lifetime. The value should be 
		 * between 0 and 1.
		 */
		public function Fade( startAlpha:Number = 1, endAlpha:Number = 0 )
		{
			priority = -5;
			_diffAlpha = startAlpha - endAlpha;
			_endAlpha = endAlpha;
		}
		
		/**
		 * The alpha value for the particle when its energy is 1.
		 * The value should be between 0 and 1.
		 */
		public function get startAlpha():Number
		{
			return _endAlpha + _diffAlpha;
		}
		public function set startAlpha( value:Number ):void
		{
			_diffAlpha = value - _endAlpha;
		}
		
		/**
		 * The alpha value for the particle when its energy is 0.
		 * The value should be between 0 and 1.
		 */
		public function get endAlpha():Number
		{
			return _endAlpha;
		}
		public function set endAlpha( value:Number ):void
		{
			_diffAlpha = _endAlpha + _diffAlpha - value;
			_endAlpha = value;
		}
		
		/**
		 * Sets the transparency of the particle based on the values defined
		 * and the particle's energy level.
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
			var alpha:Number = _endAlpha + _diffAlpha * particle.energy;
			particle.color = ( particle.color & 0xFFFFFF ) | ( Math.round( alpha * 255 ) << 24 );
		}
	}
}
