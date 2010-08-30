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
	 * This function is used to construct an object from the class and an array of parameters.
	 * 
	 * @param type The class to construct.
	 * @param parameters An array of up to ten parameters to pass to the constructor.
	 */
	public function construct( type:Class, parameters:Array ):*
	{
		switch( parameters.length )
		{
			case 0:
				return new type();
			case 1:
				return new type( parameters[0] );
			case 2:
				return new type( parameters[0], parameters[1] );
			case 3:
				return new type( parameters[0], parameters[1], parameters[2] );
			case 4:
				return new type( parameters[0], parameters[1], parameters[2], parameters[3] );
			case 5:
				return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4] );
			case 6:
				return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5] );
			case 7:
				return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6] );
			case 8:
				return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7] );
			case 9:
				return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8] );
			case 10:
				return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9] );
			default:
				return null;
		}
	}
}
