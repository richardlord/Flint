/*
* FLINT PARTICLE SYSTEM
* .....................
* 
* Author: Richard Lord
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

package org.flintparticles.integration.flare3d.v2.initializers
{
	
	
	
	
	import flare.core.Mesh3D;
	import flare.core.Particle3D;
	import flare.core.ParticleEmiter3D;
	import flare.core.Pivot3D;
	import flare.materials.Material3D;
	import flare.materials.Shader3D;
	import flare.materials.filters.ColorFilter;
	import flare.materials.flsl.FLSLFilter;
	import flare.primitives.Sphere;
	
	import flash.display.BlendMode;
	import flash.net.getClassByAlias;
	import flash.utils.getQualifiedClassName;
	
	import mx.controls.Image;
	
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.initializers.ImageClass;
	import org.flintparticles.common.initializers.InitializerBase;
	import org.flintparticles.common.particles.Particle;
	
	/**
	 * The A3DObjectClass initializer sets the 3D Object to use to 
	 * draw the particle in a 3D scene. It is used with the Away3D renderer when
	 * particles should be represented by a 3D object.
	 */
	
	public class F3DObjectClass extends ImageClass
	{

		
		/**
		 * The constructor creates an A3DObjectClass initializer for use by 
		 * an emitter. To add an ImageClass to all particles created by an emitter, 
		 * use the emitter's addInitializer method.
		 * 
		 * @param imageClass The class to use when creating
		 * the particles' image object.
		 * @param parameters The parameters to pass to the constructor
		 * for the image class.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function F3DObjectClass( objectClass:Class = null, ...parameters )
		{
			this.imageClass = objectClass;
			this.parameters = parameters;
		}
	
	}
}
