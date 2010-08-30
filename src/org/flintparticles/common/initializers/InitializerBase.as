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

package org.flintparticles.common.initializers
{
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;	

	/**
	 * The InitializerBase class is the abstract base class for all particle 
	 * initializers in the Flint library. It implements the Initializer interface 
	 * with a default priority of zero and empty methods for the rest of the 
	 * interface.
	 * 
	 * <p>Instances of the InitializerBase class should not be directly created 
	 * because the InitializerBase class itself simply implements the Initializer
	 * interface with default methods that do nothing.</p>
	 * 
	 * <p>Developers creating custom initializers may either extend the 
	 * InitializerBase class or implement the Initializer interface directly. 
	 * Classes that extend the InitializerBase class need only to implement their 
	 * own functionality for the methods they want to use, leaving other methods 
	 * with their default empty implementations.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
	 */
	public class InitializerBase implements Initializer
	{
		protected var _priority:int = 0;

		/**
		 * The constructor creates an Initializer object. But you shouldn't use 
		 * it directly because the InitializerBase class is abstract.
		 */
		public function InitializerBase()
		{
		}
		
		/**
		 * Returns a default priority of 0 for this action. Derived classes 
		 * overrid ethis method if they want a different default priority.
		 * 
		 * @see org.flintparticles.common.initializers.Initializer#getDefaultPriority()
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
		 * to perform actions when the initializer is added to an emitter.
		 * 
		 * @see org.flintparticles.common.initializers.Initializer#addedToEmitter()
		 */
		public function addedToEmitter( emitter:Emitter ):void
		{
		}
		
		/**
		 * This method does nothing. Some derived classes override this method
		 * to perform actions when the initializer is removed from the emitter.
		 * 
		 * @see org.flintparticles.common.initializers.Initializer#removedFromEmitter()
		 */
		public function removedFromEmitter( emitter:Emitter ):void
		{
		}
		
		/**
		 * This method does nothing. All derived classes override this method
		 * to initialize each particle created by the emitter.
		 * 
		 * @see org.flintparticles.common.initializers.Initializer#initialize()
		 */
		public function initialize( emitter:Emitter, particle:Particle ):void
		{
		}
	}
}