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

package org.flintparticles.threeD.renderers.controllers 
{
	import flash.display.DisplayObject;
	
	import org.flintparticles.threeD.renderers.Camera;	

	/**
	 * Sets keyboard input to make a renderer's camera orbit around a point in response to 
	 * keyboard input.
	 * 
	 * <p>After assigning a camera to an instance of this class, the camera responds to the
	 * following keyboard input</p>
	 * 
	 * <ul>
	 * <li>W or Up arrow keys - track towards the target.</li>
	 * <li>S or Down arrow keys - track away from the target.</li>
	 * <li>A or Left arrow keys - orbit left around the target.</li>
	 * <li>D or Right arrow keys - orbit right around the target.</li>
	 * </ul>
	 */
	public class OrbitCamera extends KeyboardControllerBase
	{
		private var _rotationRate:Number;
		private var _trackRate:Number;
		
		/**
		 * The constructor creates an OrbitCamera controller.
		 * 
		 * @param stage The display object on which to listen for keyboard input. This should usually
		 * be a reference to the stage.
		 * @param camera The camera to control with this controller.
		 * @param rotationRate The rate at which to rotate the camera when the appropriate keys are 
		 * pressed, in radians per second.
		 * @param trackRate The rate at which to track the camera when the appropriate keys are 
		 * pressed, in units per second.
		 * @param useInternalTick Indicates whether the camera controller should use its
		 * own tick event to update its state. The internal tick process is tied
		 * to the framerate and updates the camera every frame.
		 */
		public function OrbitCamera( stage:DisplayObject = null, camera:Camera = null, rotationRate:Number = 1, trackRate:Number = 100, useInternalTick:Boolean = true )
		{
			if( camera )
			{
				this.camera = camera;
			}
			if( stage )
			{
				this.stage = stage;
			}
			this.rotationRate = rotationRate;
			this.trackRate = trackRate;
			this.useInternalTick = useInternalTick;
		}
		
		/**
		 * The rate at which to rotate the camera when the appropriate keys are 
		 * pressed, in radians per second.
		 */
		public function get rotationRate():Number
		{
			return _rotationRate;
		}
		public function set rotationRate( value:Number ):void
		{
			_rotationRate = value;
		}
		
		/**
		 * The rate at which to track the camera when the appropriate keys are 
		 * pressed, in units per second.
		 */
		public function get trackRate():Number
		{
			return _trackRate;
		}
		public function set trackRate( value:Number ):void
		{
			_trackRate = value;
		}

		override protected function updateCamera( time:Number ):void
		{
			if( upDown || wDown )
			{
				camera.dolly( _trackRate * time );
			}
			if( downDown || sDown )
			{
				camera.dolly( -_trackRate * time );
			}
			if( leftDown || aDown )
			{
				camera.orbit( -_rotationRate * time );
			}
			if( rightDown || dDown )
			{
				camera.orbit( _rotationRate * time );
			}
		}
	}
}
