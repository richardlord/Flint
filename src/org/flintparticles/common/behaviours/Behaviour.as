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

package org.flintparticles.common.behaviours
{
	import org.flintparticles.common.emitters.Emitter;	
	
	/**
	 * The Behaviour interface is the base for the Action, Initializer and 
	 * Activity interfaces.
	 */
	public interface Behaviour
	{
		/**
		 * The priority property is used to order the execution of behaviours.
		 * 
		 * <p>The behaviours within the Flint library use 0 as the default priority. 
		 * Some behaviours that need to be called early have priorities of 10 or 20.
		 * Behaviours that need to be called late have priorities of -10 or -20.</p>
		 * 
		 * <p>For example, the move action has a priority of -20 because the movement
		 * should be performed last, after other actions have made changes
		 * to the particle's velocity.</p>
		 */
		function get priority():int;
		function set priority( value:int ):void;
		
		/**
		 * The addedToEmitter method is called by the emitter when the Behaviour is 
		 * added to it. It is an opportunity for a behaviour to do any initializing
		 * that is relative to the emitter. Only a few behaviours make use of this
		 * method. It is called by the emitter and need not be called by the user.
		 * 
		 * @param emitter The Emitter that the Behaviour was added to.
		 */
		function addedToEmitter( emitter:Emitter ):void;
		
		/**
		 * The removedFromEmitter method is called by the emitter when the Behaviour 
		 * is removed from it. It is an opportunity for a behaviour to do any finalizing
		 * that is relative to the emitter. Only a few behaviours make use of this
		 * method. It is called by the emitter and need not be called by the user.
		 * 
		 * @param emitter The Emitter that the Behaviour was removed from.
		 */
		function removedFromEmitter( emitter:Emitter ):void;
	}
}