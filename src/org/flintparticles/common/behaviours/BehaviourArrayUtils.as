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

package org.flintparticles.common.behaviours
{
	/**
	 * A set of utility functions for use with arrays of Behaviours.
	 * 
	 * @see org.flintparticles.common.behaviours.Behaviour
	 */
	public class BehaviourArrayUtils 
	{
		/**
		 * Tests whether a behaviour is in the array.
		 */
		public static function contains( array:Array, item:Behaviour ):Boolean
		{
			return array.indexOf( item ) != -1;
		}
		
		public static function containsType( array:Array, type:Class ):Boolean
		{
			var len:uint = array.length;
			for( var i:uint = 0; i < len; ++i )
			{
				if( array[i] is type )
				{
					return true;
				}
			}
			return false;
		}

		public static function remove( array:Array, item:Behaviour ):Boolean
		{
			var index:int = array.indexOf( item );
			if( index != -1 )
			{
				array.splice( index, 1 );
				return true;
			}
			return false;
		}

		public static function add( array:Array, item:Behaviour ):uint
		{
			var len:uint = array.length;
			for( var i:uint = 0; i < len; ++i )
			{
				if( Behaviour( array[i] ).priority < item.priority )
				{
					break;
				}
			}
			array.splice( i, 0, item );
			return len + 1;
		}

		public static function removeAt( array:Array, index:uint ):Behaviour
		{
			var temp:Behaviour = array[index] as Behaviour;
			array.splice( index, 1 );
			return temp;
		}
		
		public static function clear( array:Array ):void
		{
			array.length = 0;
		}
		
		public static function sortArray( array:Array ):void
		{
			array.sortOn( "priority", Array.NUMERIC );
		}
	}
}
