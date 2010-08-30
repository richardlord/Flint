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

package org.flintparticles.common.actions
{
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;	

	/**
	 * The ActionBase class is the abstract base class for all particle actions
	 * in the Flint library. It implements the Action interface with a default
	 * priority of zero and empty methods for the rest of the interface.
	 * 
	 * <p>Instances of the ActionBase class should not be directly created because 
	 * the ActionBase class itself simply implements the Action interface with 
	 * default methods that do nothing.</p>
	 * 
	 * <p>Developers creating custom actions may either extend the ActionBase
	 * class or implement the Action interface directly. Classes that extend the 
	 * ActionBase class need only to implement their own functionality for the 
	 * methods they want to use, leaving other methods with their default empty
	 * implementations.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 */
	public class ActionBase implements Action
	{
		protected var _priority:int = 0;
		
		/**
		 * The constructor creates an ActionBase object. But you shouldn't use it 
		 * directly because the ActionBase class is abstract.
		 */
		public function ActionBase()
		{
		}
		
		/**
		 * Returns a default priority of 0 for this action. Derived classes 
		 * override this method if they want a different default priority.
		 * 
		 * @see org.flintparticles.common.actions.Action#getDefaultPriority()
		 */
		public function get priority():int
		{
			return _priority;
		}
		public function set priority( value:int ):void
		{
			_priority = value;
		}
		
		/**
		 * This method does nothing. Some derived classes override this method
		 * to perform actions when the action is added to an emitter.
		 * 
		 * @param emitter The Emitter that the Action was added to.
		 * 
		 * @see org.flintparticles.common.actions.Action#addedToEmitter()
		 */
		public function addedToEmitter( emitter:Emitter ):void
		{
		}
		
		/**
		 * This method does nothing. Some derived classes override this method
		 * to perform actions when the action is removed from the emitter.
		 * 
		 * @param emitter The Emitter that the Action was removed from.
		 * 
		 * @see org.flintparticles.common.actions.Action#removedFromEmitter()
		 */
		public function removedFromEmitter( emitter:Emitter ):void
		{
		}
		
		/**
		 * This method does nothing. All derived classes override this method
		 * to update each particle every frame.
		 * 
		 * @param emitter The Emitter that created the particle.
		 * @param particle The particle to be updated.
		 * @param time The duration of the frame - used for time based updates.
		 * 
		 * @see org.flintparticles.common.actions.Action#update()
		 */
		public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
		}
	}
}