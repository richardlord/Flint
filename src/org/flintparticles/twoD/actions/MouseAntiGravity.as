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
	 * The MouseAntiGravity action applies a force on the particle to push it 
	 * away from the mouse. The force applied is inversely proportional to the 
	 * square of the distance from the particle to the mouse. MouseAntiGravity is
	 * identical to MouseGravity with a negative power.
	 * 
	 * @see MouseGravity
	 */

	public class MouseAntiGravity extends MouseGravity
	{
		/**
		 * The constructor creates a MouseAntiGravity action for use by an emitter.
		 * To add a MouseAntiGravity to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param power The strength of the anti-gravity force - larger numbers produce a 
		 * stronger force.
		 * @param renderer The display object whose coordinate system the mouse 
		 * position is converted to. This is usually the renderer for the particle 
		 * system created by the emitter.
		 * @param epsilon The minimum distance for which gravity is calculated. 
		 * Particles closer than this distance experience a gravity force as if 
		 * they were this distance away. This stops the gravity effect blowing up 
		 * as distances get small.
		 */
		public function MouseAntiGravity( power:Number = 0, renderer:DisplayObject = null, epsilon:Number = 1 )
		{
			super( power, renderer, epsilon );
		}
		
		/**
		 * The strength of the anti-gravity force.
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
