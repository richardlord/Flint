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

package org.flintparticles.common.events
{
	import flash.events.Event;	

	/**
	 * The class for emitter related events dispatched by classes in the Flint project.
	 */
	public class EmitterEvent extends Event
	{
		/**
		 * The event dispatched by an emitter when it currently has no particles
		 * to display.
		 */
		public static var EMITTER_EMPTY:String = "emitterEmpty";
		
		/**
		 * The event dispatched by an emitter when it has updated all its particles
		 * and is ready for them to be rendered. Renderers usually listen for
		 * this event to know when to redraw the particles.
		 */
		public static var EMITTER_UPDATED:String = "emitterUpdated";

		/**
		 * The event dispatched by an emitter when it's counter has completed it's full 
		 * lifecycle and will not emit any further particles.
		 */
		public static var COUNTER_COMPLETE:String = "counterComplete";
		
		/**
		 * The constructor creates a EmitterEvent object.
		 * 
		 * @param type The type of the event, accessible as Event.type.
		 * @param bubbles Determines whether the Event object participates 
		 * in the bubbling stage of the event flow. The default value is false.
		 * @param cancelable Determines whether the Event object can be 
		 * canceled. The default values is false.
		 */
		public function EmitterEvent( type : String, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super(type, bubbles, cancelable);
		}
	}
}