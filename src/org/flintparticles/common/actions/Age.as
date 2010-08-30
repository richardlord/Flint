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
	import org.flintparticles.common.energyEasing.Linear;
	import org.flintparticles.common.particles.Particle;	

	/**
	 * The Age action operates in conjunction with the Lifetime 
	 * initializer. The Lifetime initializer sets the lifetime for
	 * the particle. The Age action then ages the particle over time,
	 * altering its energy to reflect its age. This energy can then
	 * be used by actions like Fade and ColorChange to alter the
	 * appearence of the particle as it ages.
	 * 
	 * <p>The aging process need not be linear. This action can use
	 * a function that modifies the aging process, to ease in or out or 
	 * to alter the aging in other ways.</p>
	 * 
	 * <p>When the particle's lifetime is over, this action marks it 
	 * as dead.</p>
	 * 
	 * <p>When adjusting the energy this action can use any of the
	 * easing functions in the org.flintparticles.common.energy package
	 * along with any custom easing functions that have the same interface.</p>
	 * 
	 * @see org.flintparticles.common.actions.Action
	 * @see org.flintparticles.common.initializers.Lifetime
	 * @see org.flintparticles.common.energy
	 */
	public class Age extends ActionBase
	{
		private var _easing:Function;
		
		/**
		 * The constructor creates an Age action for use by an emitter. 
		 * To add an Age to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @param easing an easing function to use to modify the 
		 * energy curve over the lifetime of the particle. The default
		 * null produces a linear response with no easing.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 */
		public function Age( easing:Function = null )
		{
			if ( easing == null )
			{
				_easing = Linear.easeNone;
			}
			else
			{
				_easing = easing;
			}
		}
		
		/**
		 * The easing function used to modify the energy over the 
		 * lifetime of the particle.
		 */
		public function get easing():Function
		{
			return _easing;
		}
		public function set easing( value:Function ):void
		{
			_easing = value;
		}
		
		/**
		 * Sets the energy of the particle based on its age and the easing function.
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
			particle.age += time;
			if( particle.age >= particle.lifetime )
			{
				particle.energy = 0;
				particle.isDead = true;
			}
			else
			{
				particle.energy = _easing( particle.age, particle.lifetime );
			}
		}
	}
}
