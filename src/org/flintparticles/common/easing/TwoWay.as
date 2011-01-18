/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2011
 * http://flintparticles.org/
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

package org.flintparticles.common.easing
{
	/**
	 * A set of easing equations that start and end at the end value and reach the start value 
	 * at the half-time point. They are designed for modifying the particle energy such that it 
	 * starts and ends at zero and peaks at half way through the particle's lifetime.
	 * 
	 * @see org.flintparticles.common.actions.Age
	 */
	public class TwoWay
	{
		/**
		 * Gives a linear increase and decrease in energy either side of the centre point.
		 */
		public static function linear( t : Number, b : Number, c : Number, d : Number ):Number
		{
			if( ( t = 2 * t / d ) <= 1 )
			{
				return ( 1 - t ) * c + b;
			}
			return ( t - 1 ) * c + b;
		}
		
		/**
		 * Energy increases and then decreases as if following the top half of a circle.
		 */
		public static function circular( t : Number, b : Number, c : Number, d : Number ):Number
		{
			t = 1 - (2 * t / d);
			return ( 1 - Math.sqrt( 1 - t * t ) ) * c + b;
		}
		
		/**
		 * Energy follows the first half of a sine wave.
		 */
		public static function sine( t : Number, b : Number, c : Number, d : Number ):Number
		{
			return ( 1 - Math.sin( Math.PI * t / d ) ) * c + b;
		}
		
		/**
		 * Eases towards the middle using a quadratic curve.
		 */
		public static function quadratic( t : Number, b : Number, c : Number, d : Number ):Number
		{
			t = 1 - (2 * t / d);
			return t * t * c + b;
		}
		
		/**
		 * Eases towards the middle using a cubic curve.
		 */
		public static function cubic( t : Number, b : Number, c : Number, d : Number ):Number
		{
			t = 1 - (2 * t / d);
			if( t < 0 ) t = -t;
			return t * t * t * c + b;
		}
		
		/**
		 * Eases towards the middle using a quartic curve.
		 */
		public static function quartic( t : Number, b : Number, c : Number, d : Number ):Number
		{
			t = 1 - (2 * t / d);
			return t * t * t * t * c + b;
		}
		
		/**
		 * Eases towards the middle using a quintic curve.
		 */
		public static function quintic( t : Number, b : Number, c : Number, d : Number ):Number
		{
			t = 1 - (2 * t / d);
			if( t < 0 ) t = -t;
			return t * t * t * t * t * c + b;
		}
	}
}
