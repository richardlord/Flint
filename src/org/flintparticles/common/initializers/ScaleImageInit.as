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

package org.flintparticles.common.initializers 
{
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;	

	/**
	 * The ScaleImageInit Initializer adjusts the size of the particles image.
	 * 
	 * <p>If you also want to adjust the mass and collision radius of the particle, use
	 * the ScaleAllInit initializer.</p>
	 * 
	 * @see org.flintparticles.twoD.initializers.ScaleAllInit
	 * @see org.flintparticles.threeD.initializers.ScaleAllInit
	 */

	public class ScaleImageInit extends InitializerBase
	{
		private var _min:Number;
		private var _max:Number;
		
		/**
		 * The constructor creates a ScaleImageInit initializer for use by 
		 * an emitter. To add a ScaleImageInit to all particles created by an emitter, use the
		 * emitter's addInitializer method.
		 * 
		 * <p>The scale factor of particles initialized by this class
		 * will be a random value between the minimum and maximum
		 * values set. If no maximum value is set, the minimum value
		 * is used with no variation.</p>
		 * 
		 * @param minScale the minimum scale factor for particles
		 * initialized by the instance.
		 * @param maxScale the maximum scale factor for particles
		 * initialized by the instance.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer().
		 */
		public function ScaleImageInit( minScale:Number = 1, maxScale:Number = NaN )
		{
			_min = minScale;
			if( isNaN( maxScale ) )
			{
				_max = _min;
			}
			else
			{
				_max = maxScale;
			}
		}
		
		/**
		 * The minimum scale value for particles initialised by 
		 * this initializer. Should be between 0 and 1.
		 */
		public function get minScale():Number
		{
			return _min;
		}
		public function set minScale( value:Number ):void
		{
			_min = value;
		}
		
		/**
		 * The maximum scale value for particles initialised by 
		 * this initializer. Should be between 0 and 1.
		 */
		public function get maxScale():Number
		{
			return _max;
		}
		public function set maxScale( value:Number ):void
		{
			_max = value;
		}
		
		/**
		 * When reading, returns the average of minScale and maxScale.
		 * When writing this sets both maxScale and minScale to the 
		 * same scale value.
		 */
		public function get scale():Number
		{
			return _min == _max ? _min : ( _max + _min ) / 2;
		}
		public function set scale( value:Number ):void
		{
			_max = _min = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			if( _max == _min )
			{
				particle.scale = _min;
			}
			else
			{
				particle.scale = _min + Math.random() * ( _max - _min );
			}
		}
	}
}
