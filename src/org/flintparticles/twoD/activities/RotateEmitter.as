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

package org.flintparticles.twoD.activities
{
	import org.flintparticles.common.activities.ActivityBase;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.twoD.emitters.Emitter2D;	

	/**
	 * The RotateEmitter activity rotates the emitter at a constant rate.
	 */
	public class RotateEmitter extends ActivityBase
	{
		private var _angularVelocity:Number;
		
		/**
		 * The constructor creates a RotateEmitter activity for use by 
		 * an emitter. To add a RotateEmitter to an emitter, use the
		 * emitter's addActvity method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addActivity()
		 * 
		 * @para angularVelocity The angular velocity for the emitter in 
		 * radians per second.
		 */
		public function RotateEmitter( angularVelocity:Number = 0 )
		{
			this.angularVelocity = angularVelocity;
		}
		
		/**
		 * The angular velocity for the emitter in 
		 * radians per second.
		 */
		public function get angularVelocity():Number
		{
			return _angularVelocity;
		}
		public function set angularVelocity( value:Number ):void
		{
			_angularVelocity = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter : Emitter, time : Number ) : void
		{
			var e:Emitter2D = Emitter2D( emitter );
			e.rotRadians += _angularVelocity * time;
		}
	}
}