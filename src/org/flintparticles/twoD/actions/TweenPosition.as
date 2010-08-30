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

	/**
	 * The TweenPosition action adjusts the particle's position between two
	 * locations as it ages. The position is relative to the particle's energy,
	 * which changes as the particle ages in accordance with the energy easing
	 * function used. This action should be used in conjunction with the Age action.
	 */

	public class TweenPosition extends ActionBase
	{
		private var _diffX:Number = 0;
		private var _endX:Number = 0;
		private var _diffY:Number = 0;
		private var _endY:Number = 0;
		
		/**
		 * The constructor creates a TweenPosition action for use by an emitter. 
		 * To add a TweenPosition to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param startX The x value for the particle's position when its energy is 1.
		 * @param startY The y value for the particle's position when its energy is 1.
		 * @param endX The x value of the particle's position when its energy is 0.
		 * @param endY The y value of the particle's position when its energy is 0.
		 */
		public function TweenPosition( startX:Number = 0, startY:Number = 0, endX:Number = 0, endY:Number = 0 )
		{
			this.startX = startX;
			this.endX = endX;
			this.startY = startY;
			this.endY = endY;
		}
		
		/**
		 * The x position for the particle's position when its energy is 1.
		 */
		public function get startX():Number
		{
			return _endX + _diffX;
		}
		public function set startX( value:Number ):void
		{
			_diffX = value - _endX;
		}
		
		/**
		 * The X value for the particle's position when its energy is 0.
		 */
		public function get endX():Number
		{
			return _endX;
		}
		public function set endX( value:Number ):void
		{
			_diffX = _endX + _diffX - value;
			_endX = value;
		}
		
		/**
		 * The y position for the particle's position when its energy is 1.
		 */
		public function get startY():Number
		{
			return _endY + _diffY;
		}
		public function set startY( value:Number ):void
		{
			_diffY = value - _endY;
		}
		
		/**
		 * The y value for the particle's position when its energy is 0.
		 */
		public function get endY():Number
		{
			return _endY;
		}
		public function set endY( value:Number ):void
		{
			_diffY = _endY + _diffY - value;
			_endY = value;
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
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var p:Particle2D = Particle2D( particle );
			p.x = _endX + _diffX * p.energy;
			p.y = _endY + _diffY * p.energy;
		}
	}
}
