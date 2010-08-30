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

package org.flintparticles.twoD.initializers 
{
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.initializers.InitializerBase;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.twoD.particles.Particle2D;	

	/**
	 * The RotateVelocity Initializer sets the angular velocity of the particle.
	 * It is usually combined with the Rotate action to rotate the particle
	 * using this angular velocity.
	 */

	public class RotateVelocity extends InitializerBase
	{
		private var _max:Number;
		private var _min:Number;

		/**
		 * The constructor creates a RotateVelocity initializer for use by 
		 * an emitter. To add a RotateVelocity to all particles created by an emitter, use the
		 * emitter's addInitializer method.
		 * 
		 * <p>The angularVelocity of particles initialized by this class
		 * will be a random value between the minimum and maximum
		 * values set. If no maximum value is set, the minimum value
		 * is used with no variation.</p>
		 * 
		 * @param minAngVelocity The minimum angularVelocity, in 
		 * radians per second, for the particle's angularVelocity.
		 * @param maxAngVelocity The maximum angularVelocity, in 
		 * radians per second, for the particle's angularVelocity.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function RotateVelocity( minAngVelocity:Number = 0, maxAngVelocity:Number = NaN )
		{
			this.minAngVelocity = minAngVelocity;
			this.maxAngVelocity = maxAngVelocity;
		}
		
		/**
		 * The minimum angular velocity value for particles initialised by 
		 * this initializer. Should be between 0 and 1.
		 */
		public function get minAngVelocity():Number
		{
			return _min;
		}
		public function set minAngVelocity( value:Number ):void
		{
			_min = value;
		}
		
		/**
		 * The maximum angular velocity value for particles initialised by 
		 * this initializer. Should be between 0 and 1.
		 */
		public function get maxAngVelocity():Number
		{
			return _max;
		}
		public function set maxAngVelocity( value:Number ):void
		{
			_max = value;
		}
		
		/**
		 * When reading, returns the average of minAngVelocity and maxAngVelocity.
		 * When writing this sets both maxAngVelocity and minAngVelocity to the 
		 * same angular velocity value.
		 */
		public function get angVelocity():Number
		{
			return _min == _max ? _min : ( _max + _min ) / 2;
		}
		public function set angVelocity( value:Number ):void
		{
			_max = _min = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			var p:Particle2D = Particle2D( particle );
			if( isNaN( _max ) )
			{
				p.angVelocity = _min;
			}
			else
			{
				p.angVelocity = _min + Math.random() * ( _max - _min );
			}
		}
	}
}
