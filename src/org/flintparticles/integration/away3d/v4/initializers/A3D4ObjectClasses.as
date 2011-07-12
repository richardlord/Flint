/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord & Michael Ivanov
 * Copyright (c) Richard Lord 2008-2011
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

package org.flintparticles.integration.away3d.v4.initializers
{
	import org.flintparticles.common.initializers.ImageClasses;

	/**
	 * The A3D4ObjectClasses Initializer sets the class of the 3D Object to use 
	 * to draw the particle in a 3D scene. It selects one of multiple object 
	 * classes that are passed to it. It is used with the Away3D 4 renderer when
	 * particles should be represented by a 3D object.
	 * 
	 * <p>This class is actually just a copy of the ImageClasses initializer. It is included
	 * here to make it clear that this is one way to initialize a 3d particle's
	 * object for rendering in an Away 3d scene.</p>
	 * 
	 * <p>If you need to set properties of the object class that are not accessible through
	 * the object constructor, you should use the SetImageProperties initializer to set
	 * these additional properties.</p>
	 * 
	 * <p>In situations where all the particles are the same, or are one of a small number of
	 * objects, the A3D4CloneObject and A3D4CloneObjects initializers are more efficient
	 * because they use one set of geometry and material data for all the similar particles.
	 * This initializer creates new data for each particle.</p>
	 * 
	 * <p>This class is useful where a custom object class produces visually different
	 * objects every time it is used.</p>
	 * 
	 * <p>This class includes an object pool for reusing objects when particles die.</p>
	 * 
	 * @see org.flintparticles.integration.away3d.v4.initializers.A3D4CloneObject
	 * @see org.flintparticles.integration.away3d.v4.initializers.A3D4CloneObjects
	 * @see org.flintparticles.common.Initializers.SetImageProperties
	 */
	public class A3D4ObjectClasses extends ImageClasses
	{
		/**
		 * The constructor creates an A3D4ObjectClasses initializer for use by 
		 * an emitter. To add an A3D4ObjectClasses to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param objects An array containing the classes to use for each particle 
		 * created by the emitter. Each item in the array may be a class or an array 
		 * containing a class and a number of parameters to pass to the constructor.
		 * @param weights The weighting to apply to each object class. If no weighting
		 * values are passed, the objects are used with equal probability.
		 * @param usePool Indicates whether particles should be reused when a particle dies.
		 * @param fillPool Indicates how many particles to create immediately in the pool, to
		 * avoid creating them when the particle effect is running.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function A3D4ObjectClasses( objects:Array, weights:Array = null, usePool:Boolean = false, fillPool:uint = 0 )
		{
			super( objects, weights, usePool, fillPool );
		}
	}
}