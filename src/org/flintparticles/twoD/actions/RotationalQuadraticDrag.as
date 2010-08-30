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
	 * The RotationalQuadraticDrag action applies drag to the particle to slow it 
	 * down when it's rotating. The drag force is proportional to the square of the 
	 * angular velocity of the particle. For other types of rotational drag see the 
	 * RotationalLinerDrag and RotationalFriction actions.
	 * 
	 * @see RotationalFriction
	 * @see RotationalLinearDrag
	 */

	public class RotationalQuadraticDrag extends ActionBase
	{
		private var _drag:Number;
		
		/**
		 * The constructor creates a RotationalQuadraticDrag action for use by 
		 * an emitter. To add a RotationalQuadraticDrag to all particles created 
		 * by an emitter, use the emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param drag The amount of drag. A higher number produces a stronger drag 
		 * force.
		 */
		public function RotationalQuadraticDrag( drag:Number = 0 )
		{
			this.drag = drag;
		}
		
		/**
		 * The amount of drag. A higher number produces a stronger drag force.
		 */
		public function get drag():Number
		{
			return _drag;
		}
		public function set drag( value:Number ):void
		{
			_drag = value;
		}
		
		/**
		 * Calculates the rotational drag on the particle and applies it for the 
		 * period of time indicated.
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
			if( p.angVelocity == 0 )
			{
				return;
			}
			var scale:Number = 1 - _drag * time * p.angVelocity / p.inertia;
			if( scale < 0 )
			{
				p.angVelocity = 0;
			}
			else
			{
				p.angVelocity *= scale;
			}
		}
	}
}
