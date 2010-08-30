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

package org.flintparticles.common.utils 
{
	import flash.display.DisplayObject;		

	public class DisplayObjectUtils 
	{
		/**
		 * Converts a rotation in the coordinate system of a display object 
		 * to a global rotation relative to the stage.
		 * 
		 * @param obj The display object
		 * @param rotation The rotation
		 * 
		 * @return The rotation relative to the stage's coordinate system.
		 */
		public static function localToGlobalRotation( obj:DisplayObject, rotation:Number ):Number
		{
			var rot:Number = rotation + obj.rotation;
			for( var current:DisplayObject = obj.parent; current && current != obj.stage; current = current.parent )
			{
				rot += current.rotation;
			}
			return rot;
		}

		/**
		 * Converts a global rotation in the coordinate system of the stage 
		 * to a local rotation in the coordinate system of a display object.
		 * 
		 * @param obj The display object
		 * @param rotation The rotation
		 * 
		 * @return The rotation relative to the display object's coordinate system.
		 */
		public static function globalToLocalRotation( obj:DisplayObject, rotation:Number ):Number
		{
			var rot:Number = rotation - obj.rotation;
			for( var current:DisplayObject = obj.parent; current && current != obj.stage; current = current.parent )
			{
				rot -= current.rotation;
			}
			return rot;
		}
	}
}
