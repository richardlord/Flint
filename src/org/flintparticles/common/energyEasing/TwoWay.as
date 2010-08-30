/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2010
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

package org.flintparticles.common.energyEasing
{
	/**
	 * A set of easing equations for modifying the particle energy such that it starts
	 * and ends at zero and peaks at one half way through the particle's lifetime.
	 * 
	 * @see org.flintparticles.common.actions.Age
	 */
	public class TwoWay
	{
		/**
		 * Gives a linear increase and decrease in energy either side of the centre point.
		 */
		public static function linear( age:Number, lifetime:Number ):Number
		{
			if( ( age = 2 * age / lifetime ) <= 1 )
			{
				return age;
			}
			return 2 - age;
		}
		
		/**
		 * Energy increases and then decreases as if following the top half of a circle.
		 */
		public static function circular( age:Number, lifetime:Number ):Number
		{
			age = 1 - (2 * age / lifetime);
			return Math.sqrt( 1 - age * age );
		}
		
		/**
		 * Energy follows the first half of a sine wave.
		 */
		public static function sine( age:Number, lifetime:Number ):Number
		{
			return Math.sin( Math.PI * age / lifetime );
		}
		
		/**
		 * Eases towards the middle using a quadratic curve.
		 */
		public static function quadratic( age:Number, lifetime:Number ):Number
		{
			age = 1 - (2 * age / lifetime);
			return -( age * age - 1 );
		}
		
		/**
		 * Eases towards the middle using a cubic curve.
		 */
		public static function cubic( age:Number, lifetime:Number ):Number
		{
			age = 1 - (2 * age / lifetime);
			if( age < 0 ) age = -age;
			return -( age * age * age - 1 );
		}
		
		/**
		 * Eases towards the middle using a quartic curve.
		 */
		public static function quartic( age:Number, lifetime:Number ):Number
		{
			age = 1 - (2 * age / lifetime);
			return -( age * age * age * age - 1 );
		}
		
		/**
		 * Eases towards the middle using a quintic curve.
		 */
		public static function quintic( age:Number, lifetime:Number ):Number
		{
			age = 1 - (2 * age / lifetime);
			if( age < 0 ) age = -age;
			return -( age * age * age * age * age - 1 );
		}
	}
}
