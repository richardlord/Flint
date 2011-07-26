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

package org.flintparticles.integration.flare3d.initializers
{
	import org.flintparticles.common.initializers.ImageClass;

	/**
	 * The F3DObjectClass initializer sets the class of the 3D Object to use to 
	 * draw the particle in a 3D scene. It is used with the Flare3D renderer when
	 * particles should be represented by a 3D object.
	 * 
	 * <p>This class is actually just a copy of the ImageClass initializer. It is included
	 * here to make it clear that this is one way to initialize a 3d particle's
	 * object for rendering in a Flare3D scene.</p>
	 * 
	 * <p>If you need to set properties of the object class that are not accessible through
	 * the object constructor, you should use the SetImageProperties initializer to set
	 * these additional properties.</p>
	 * 
	 * <p>In situations where all the particles are the same, or are one of a small number of
	 * objects, the other Flare3D initializers are usually more efficient
	 * because they use one set of geometry and material data for all the similar particles.
	 * This initializer creates new data for each particle.</p>
	 * 
	 * <p>This class is useful where a custom object class produces visually different
	 * objects every time it is used.</p>
	 * 
	 * <p>This class includes an object pool for reusing objects when particles die.</p>
	 * 
	 * @see org.flintparticles.integration.flare3d.initializers.F3DCloneObject
	 * @see org.flintparticles.integration.flare3d.initializers.F3DCloneObjects
	 * @see org.flintparticles.common.initializers.ImageClass
	 * @see org.flintparticles.common.initializers.SetImageProperties
	 */
	public class F3DObjectClass extends ImageClass
	{
		/**
		 * The constructor creates a F3DObjectClass initializer for use by 
		 * an emitter. To add a F3DObjectClass to all particles created by an emitter, use the
		 * emitter's addInitializer method.
		 * 
		 * @param objectClass The class to use when creating
		 * the particles' 3d object for rendering.
		 * @param parameters The parameters to pass to the constructor
		 * for the object class.
		 * @param usePool Indicates whether particles should be reused when a particle dies.
		 * @param fillPool Indicates how many particles to create immediately in the pool, to
		 * avoid creating them when the particle effect is running.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function F3DObjectClass( imageClass : Class = null, parameters : Array = null, usePool : Boolean = false, fillPool : uint = 0 )
		{
			super( imageClass, parameters, usePool, fillPool );
		}
	}
}
