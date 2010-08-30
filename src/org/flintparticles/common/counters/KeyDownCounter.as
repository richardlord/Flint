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

package org.flintparticles.common.counters
{
	import org.flintparticles.common.emitters.Emitter;
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;	

	/**
	 * The KeyDownCounter Counter modifies another counter to only emit particles when a specific key
	 * is being pressed.
	 */
	public class KeyDownCounter implements Counter
	{
		private var _counter:Counter;
		private var _keyCode:uint;
		private var _isDown:Boolean;
		private var _stop:Boolean;
		private var _stage:Stage;
		
		/**
		 * The constructor creates a ZonedAction action for use by 
		 * an emitter. To add a ZonedAction to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param counter The counter to use when the key is down.
		 * @param keyCode The key code of the key that controls the counter.
		 * @param stage A reference to the stage.
		 */
		public function KeyDownCounter( counter:Counter = null, keyCode:uint = 0, stage:Stage = null )
		{
			_stop = false;
			_counter = counter;
			_keyCode = keyCode;
			_isDown = false;
			_stage = stage;
			createListeners();
		}
		
		private function createListeners():void
		{
			if( stage )
			{
				stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true );
				stage.addEventListener( KeyboardEvent.KEY_UP, keyUpListener, false, 0, true );
			}
		}
		
		private function keyDownListener( ev:KeyboardEvent ):void
		{
			if( ev.keyCode == _keyCode )
			{
				_isDown = true;
			}
		}
		private function keyUpListener( ev:KeyboardEvent ):void
		{
			if( ev.keyCode == _keyCode )
			{
				_isDown = false;
			}
		}

		/**
		 * The counter to use when the key is down.
		 */
		public function get counter():Counter
		{
			return _counter;
		}
		public function set counter( value:Counter ):void
		{
			_counter = value;
		}
		
		/**
		 * The key code of the key that controls the counter.
		 */
		public function get keyCode():uint
		{
			return _keyCode;
		}
		public function set keyCode( value:uint ):void
		{
			_keyCode = value;
		}
		
		/**
		 * A reference to the stage
		 */
		public function get stage():Stage
		{
			return _stage;
		}
		public function set stage( value:Stage ):void
		{
			_stage = value;
			createListeners();
		}
		
		public function startEmitter( emitter:Emitter ):uint
		{
			if( _isDown && !_stop )
			{
				return _counter.startEmitter( emitter );
			}
			_counter.startEmitter( emitter );
			return 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateEmitter( emitter:Emitter, time:Number ):uint
		{
			if( _isDown && !_stop )
			{
				return _counter.updateEmitter( emitter, time );
			}
			return 0;
		}
		
		/**
		 * Stops the emitter from emitting particles
		 */
		public function stop():void
		{
			_stop = true;
		}
		
		/**
		 * Resumes the emitter after a stop
		 */
		public function resume():void
		{
			_stop = false;
		}
		

		/**
		 * Indicates if the counter has emitted all its particles.
		 */
		public function get complete():Boolean
		{
			return _counter.complete;
		}
	}
}