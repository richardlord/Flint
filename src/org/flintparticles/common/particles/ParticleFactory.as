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

package org.flintparticles.common.particles 
{
	/**
	 * The ParticleFactory interface defines the interface for any factory class used by emitters to 
	 * create, reuse and dispose of particles. To speed up the particle system, a ParticleFactory will
	 * usually maintain a pool of dead particles and reuse them when a new particle is needed, rather 
	 * than creating a whole new particle. The default ParticleFactory used by the Emitter is an 
	 * instance of the appropriate ParticleCreator class.
	 * 
	 * @see org.flintparticles.twoD.particles.ParticleCreator2D
	 * @see org.flintparticles.threeD.particles.ParticleCreator3D
	 */

	public interface ParticleFactory 
	{
		/**
		 * To obtain a new Particle object. If using a pool of particles the particle factory will usually return 
		 * a particle from the pool and only creates a new particle if the pool is empty.
		 * 
		 * @return a Particle object.
		 */
		function createParticle():Particle;
		
		/**
		 * Indicates a particle is no longer required. If using a pool of particles the particle factory will 
		 * return the particle to the pool for reuse later.
		 * 
		 * @param particle The particle to return for reuse.
		 */
		function disposeParticle( particle:Particle ):void;

		/**
		 * Clear all cached particles from the factory
		 */
		function clearAllParticles():void;
	}
}
