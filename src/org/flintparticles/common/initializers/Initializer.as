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
	import org.flintparticles.common.behaviours.Behaviour;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;		

	/**
	 * The Initializer interface must be implemented by all particle initializers.
	 * 
	 * <p>An Initializer is a class that is used to set properties of a particle 
	 * when it is created. Initializers may, for example, set an initial velocity
	 * for a particle.</p>
	 * 
	 * <p>Initializers are directly associated with emitters and act on all
	 * particles created by that emitter. Initializers are applied to 
	 * all particles created by an emitter by using the emitter's addInitializer 
	 * method. Initializers are removed from the emitter by using the emitter's
	 * removeInitializer method.<p>
	 * 
	 * <p>The key method in the Initializer interface is the initiaize method.
	 * This is called for every particle and is where the initializer modifies 
	 * the particle's properties.</p>
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
	 * @see org.flintparticles.common.emitters.Emitter#removeInitializer()
	 */
	public interface Initializer extends Behaviour
	{
		/**
		 * The initialize method is used by the emitter to apply the initialization
		 * to every particle. It is the key feature of the initializers and is
		 * used to initialize the state of every particle. This method 
		 * is called within the emitter's createParticle met6hod for every particle 
		 * and need not be called by the user.
		 * 
		 * @param emitter The Emitter that created the particle.
		 * @param particle The particle to be initialized.
		 */
		function initialize( emitter:Emitter, particle:Particle ):void;
	}
}