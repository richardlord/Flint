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

package org.flintparticles.threeD.emitters.mxml 
{
	import org.flintparticles.threeD.emitters.Emitter3D;
	
	import mx.core.IMXMLObject;	

	/**
	 * @inheritDoc
	 * 
	 * <p>This version of the emitter exposes additional properties to MXML and is intended for use 
	 * in MXML documents.</p>
	 */
	public class Emitter3D extends org.flintparticles.threeD.emitters.Emitter3D implements IMXMLObject 
	{
		public function Emitter3D()
		{
			super( );
		}
		
		/**
		 * Makes the emitter skip forwards a period of time at teh start. Use this property
		 * when you want the emitter to look like it's been running for a while.
		 */
		[Inspectable]
		public var runAheadTime:Number = 0;
		
		/**
		 * The frame=-rate to use when running the emitter ahead at the start.
		 * 
		 * @see #runAheadTime
		 */
		[Inspectable]
		public var runAheadFrameRate:Number = 10;
		
		/**
		 * Indicates if the emitter should start automatically or wait for the start methood to be called.
		 */
		[Inspectable]
		public var autoStart:Boolean = true;

		/**
		 * @private
		 */		
		public function initialized(document:Object, id:String):void
		{
			if( autoStart )
			{
				start();
			}
			if( runAheadTime )
			{
				runAhead( runAheadTime, runAheadFrameRate );
			}
		}
	}
}
