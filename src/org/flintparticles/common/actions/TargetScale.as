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
	import org.flintparticles.common.actions.ActionBase;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;	

	/**
	 * The TargetScale action adjusts the scale of the particle towards a 
	 * target scale. On every update the scale of the particle moves a 
	 * little closer to the target scale. The rate at which particles approach
	 * the target is controlled by the rate property.
	 */
	public class TargetScale extends ActionBase
	{
		private var _scale:Number;
		private var _rate:Number;
		
		/**
		 * The constructor creates a TargetScale action for use by an emitter. 
		 * To add a TargetScale to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param targetScale The target scale for the particle. 1 is normal size.
		 * @param rate Adjusts how quickly the particle reaches the target scale.
		 * Larger numbers cause it to approach the target scale more quickly.
		 */
		public function TargetScale( targetScale:Number= 1, rate:Number = 0.1 )
		{
			_scale = targetScale;
			_rate = rate;
		}
		
		/**
		 * The target scale for the particle. 1 is normal size.
		 */
		public function get targetScale():Number
		{
			return _scale;
		}
		public function set targetScale( value:Number ):void
		{
			_scale = value;
		}
		
		/**
		 * Adjusts how quickly the particle reaches the target scale.
		 * Larger numbers cause it to approach the target scale more quickly.
		 */
		public function get rate():Number
		{
			return _rate;
		}
		public function set rate( value:Number ):void
		{
			_rate = value;
		}
		
		/**
		 * Adjusts the scale of the particle based on its current scale, the target 
		 * scale and the time elapsed.
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
			particle.scale += ( _scale - particle.scale ) * _rate * time;
		}
	}
}
