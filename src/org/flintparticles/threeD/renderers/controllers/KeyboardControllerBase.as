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
	import org.flintparticles.common.events.UpdateEvent;
	import org.flintparticles.common.utils.FrameUpdater;
	import org.flintparticles.threeD.renderers.Camera;

	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

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
	public class KeyboardControllerBase implements CameraController
	{
		protected var _stage:DisplayObject;
		protected var _camera:Camera;
		protected var _running:Boolean = false;
		protected var _useInternalTick:Boolean = true;
		protected var _maximumFrameTime:Number = 0.5;
		protected var _fixedFrameTime:Number = 0;
		
		protected var wDown:Boolean = false;
		protected var aDown:Boolean = false;
		protected var sDown:Boolean = false;
		protected var dDown:Boolean = false;
		protected var leftDown:Boolean = false;
		protected var rightDown:Boolean = false;
		protected var upDown:Boolean = false;
		protected var downDown:Boolean = false;
		protected var pgUpDown:Boolean = false;
		protected var pgDownDown:Boolean = false;
		
		[Inspectable]
		public var autoStart:Boolean = true;

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
		public function KeyboardControllerBase()
		{
		}
		
		/**
		 * The maximum duration for a single update frame, in seconds.
		 * 
		 * <p>Under some circumstances related to the Flash player (e.g. on MacOSX, when the 
		 * user right-clicks on the flash movie) the flash movie will freeze for a period. When the
		 * freeze ends, the current frame of the particle system will be calculated as the time since 
		 * the previous frame,  which encompases the duration of the freeze. This could cause the 
		 * system to generate a single frame update that compensates for a long period of time and 
		 * hence moves the particles an unexpected long distance in one go. The result is usually
		 * visually unacceptable and certainly unexpected.</p>
		 * 
		 * <p>This property sets a maximum duration for a frame such that any frames longer than 
		 * this duration are ignored. The default value is 0.5 seconds. Developers don't usually
		 * need to change this from the default value.</p>
		 */
		public function get maximumFrameTime() : Number
		{
			return _maximumFrameTime;
		}
		public function set maximumFrameTime( value : Number ) : void
		{
			_maximumFrameTime = value;
		}
		
		/**
		 * Indicates a fixed time (in seconds) to use for every frame. Setting 
		 * this property causes the controller to bypass its frame timing 
		 * functionality and use the given time for every frame. This enables
		 * the particle system to be frame based rather than time based.
		 * 
		 * <p>To return to time based animation, set this value to zero (the 
		 * default).</p>
		 * 
		 * <p>This feature only works if useInternalTick is true (the default).</p>
		 * 
		 * @see #useInternalTick
		 */		
		public function get fixedFrameTime():Number
		{
			return _fixedFrameTime;
		}
		public function set fixedFrameTime( value:Number ):void
		{
			_fixedFrameTime = value;
		}

		/**
		 * Indicates whether the controller should manage its own internal update
		 * tick. The internal update tick is tied to the frame rate and updates
		 * the particle system every frame.
		 * 
		 * <p>If users choose not to use the internal tick, they have to call
		 * the controller's update method with the appropriate time parameter every
		 * time they want the controller to update the camera.</p>
		 */		
		public function get useInternalTick():Boolean
		{
			return _useInternalTick;
		}
		public function set useInternalTick( value:Boolean ):void
		{
			if( _useInternalTick != value )
			{
				_useInternalTick = value;
				if( _running )
				{
					if( _useInternalTick )
					{
						FrameUpdater.instance.addEventListener( UpdateEvent.UPDATE, updateEventListener, false, 0, true );
					}
					else
					{
						FrameUpdater.instance.removeEventListener( UpdateEvent.UPDATE, updateEventListener );
					}
				}
			}
		}
		
		/**
		 * The camera to control with this controller.
		 */
		public function get camera():Camera
		{
			return _camera;
		}
		public function set camera( value:Camera ):void
		{
			_camera = value;
		}
		
		/**
		 * The stage - used for listening to keyboard events
		 */
		public function get stage():DisplayObject
		{
			return _stage;
		}
		public function set stage( value:DisplayObject ):void
		{
			if( _stage )
			{
				_stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDown );
				_stage.removeEventListener( KeyboardEvent.KEY_UP, keyUp );
			}
			_stage = value;
			_stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDown, false, 0, true );
			_stage.addEventListener( KeyboardEvent.KEY_UP, keyUp, false, 0, true );
		}
		
		private function keyDown( ev:KeyboardEvent ):void
		{
			switch( ev.keyCode )
			{
				case Keyboard.UP:
					upDown = true;
					break;
				case Keyboard.DOWN:
					downDown = true;
					break;
				case Keyboard.LEFT:
					leftDown = true;
					break;
				case Keyboard.RIGHT:
					rightDown = true;
					break;
				case 87:
					wDown = true;
					break;
				case 65:
					aDown = true;
					break;
				case 83:
					sDown = true;
					break;
				case 68:
					dDown = true;
					break;
				case 33:
					pgUpDown = true;
					break;
				case 34:
					pgDownDown = true;
					break;
			}
		}
		
		private function keyUp( ev:KeyboardEvent ):void
		{
			switch( ev.keyCode )
			{
				case Keyboard.UP:
					upDown = false;
					break;
				case Keyboard.DOWN:
					downDown = false;
					break;
				case Keyboard.LEFT:
					leftDown = false;
					break;
				case Keyboard.RIGHT:
					rightDown = false;
					break;
				case 87:
					wDown = false;
					break;
				case 65:
					aDown = false;
					break;
				case 83:
					sDown = false;
					break;
				case 68:
					dDown = false;
					break;
				case 33:
					pgUpDown = false;
					break;
				case 34:
					pgDownDown = false;
					break;
			}
		}
		
		/**
		 * Update event listener used to fire the update function when using teh internal tick.
		 */
		private function updateEventListener( ev:UpdateEvent ):void
		{
			if( _fixedFrameTime )
			{
				update( _fixedFrameTime );
			}
			else
			{
				update( ev.time );
			}
		}
		
		public function update( time:Number ):void
		{
			if( !_running || time > _maximumFrameTime )
			{
				return;
			}
			updateCamera( time );
		}
		
		protected function updateCamera( time:Number ):void
		{
			
		}
		
		/**
		 * Starts the controller.
		 */
		public function start():void
		{
			if( _useInternalTick )
			{
				FrameUpdater.instance.addEventListener( UpdateEvent.UPDATE, updateEventListener, false, 0, true );
			}
			_running = true;
		}
		

		
		/**
		 * Stops the controller.
		 */
		public function stop():void
		{
			if( _useInternalTick )
			{
				FrameUpdater.instance.removeEventListener( UpdateEvent.UPDATE, updateEventListener );
			}
			_running = false;
		}
	}
}
