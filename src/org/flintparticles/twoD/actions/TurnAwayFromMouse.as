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
	import flash.display.DisplayObject;		

	/**
	 * The TurnAwayFromMouse action causes the particle to constantly adjust its 
	 * direction so that it travels away from the mouse pointer.
	 */

	public class TurnAwayFromMouse extends TurnTowardsMouse
	{
		/**
		 * The constructor creates a TurnAwayFromMouse action for use by an emitter. 
		 * To add a TurnAwayFromMouse to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param power The strength of the turn action. Higher values produce a sharper turn.
		 * @param renderer The display object whose coordinate system the mouse position is 
		 * converted to. This is usually the renderer for the particle system created by the emitter.
		 */
		public function TurnAwayFromMouse( power:Number = 0, renderer:DisplayObject = null )
		{
			super( -power, renderer );
		}
		
		/**
		 * The strength of the turn action. Higher values produce a sharper turn.
		 */
		override public function get power():Number
		{
			return -super.power;
		}
		override public function set power( value:Number ):void
		{
			super.power = -value;
		}
	}
}
