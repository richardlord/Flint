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

package org.flintparticles.common.utils
{
	/**
	 * A FastWeightedArray performes the same purpose as a WeightedArray 
	 * but this array is optimized to select random items in a large array 
	 * much more rapidly. In improving the speed if the array, it is necessary
	 * to loose the functionality to remove items from the FastWeightedArray, so
	 * the original WeightedArray also still available.
	 * 
	 * <p>The FastWeightedArray is a collection of values that are weighted. When 
	 * a random value is required from the collection, the value returned
	 * is randomly selkected based on the weightings.</p>
	 * 
	 * <p>Due to the nature of a FastWeightedArray, there are no facilities
	 * to push, unshift or splice items into the array. All items are 
	 * added to the FastWeightedArray using the add method.</p>
	 */
	public class FastWeightedArray
	{
		private var _values:Array;
		private var _totalRatios:Number;
		
		/**
		 * Then constructor function is used to create a FastWeightedArray
		 */
		public function FastWeightedArray()
		{
			_values = new Array();
			_totalRatios = 0;
		}
		
		/**
		 * Adds a value to the FastWeightedArray.
		 * 
		 * @param value the value to add
		 * @param weight the weighting to place on the item
		 * @return the length of the FastWeightedArray
		 */
		public function add( value:*, ratio:Number ):uint
		{
			_totalRatios += ratio;
			_values.push( new Pair( _totalRatios, value ) );
			return _values.length;
		}
		
		/**
		 * Empties the FastWeightedArray. After calling this method the FastWeightedArray 
		 * contains no items.
		 */
		public function clear():void
		{
			_values.length = 0;
			_totalRatios = 0;
		}
		
		/**
		 * The number of items in the FastWeightedArray
		 */
		public function get length():uint
		{
			return _values.length;
		}
		
		/**
		 * The sum of the weights of all the values.
		 */
		public function get totalRatios():Number
		{
			return _totalRatios;
		}

		/**
		 * Returns a random value from the FastWeightedArray. The weighting of the values is
		 * used when selcting the random value, so items with a higher weighting are
		 * more likely to be seleted.
		 * 
		 * @return A randomly selected item from the array.
		 */
		public function getRandomValue():*
		{
			var position:Number = Math.random() * _totalRatios;
			var low:uint = 0;
			var mid:uint;
			var high:uint = _values.length;
			while( low < high )
			{
				mid = Math.floor( ( low + high ) * 0.5 );
				if( Pair( _values[ mid ] ).topWeight < position )
				{
					low = mid + 1;
				}
				else
				{
					high = mid;
				}
			}
			return Pair( _values[low] ).value;
		}
	}
}

class Pair
{
	internal var topWeight:Number;
	internal var value:*;
	
	public function Pair( topWeight:Number, value:* )
	{
		this.topWeight = topWeight;
		this.value = value;
	}
}