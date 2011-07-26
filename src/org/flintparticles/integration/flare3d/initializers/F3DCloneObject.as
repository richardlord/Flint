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
	import flare.core.Pivot3D;

	import org.flintparticles.common.initializers.ImageInitializerBase;

	/**
	 * The F3DCloneObject Initializer sets the object to use to draw
	 * the particle. It calls the clone method of the object to create 
	 * an instance for each particle.
	 * 
	 * <p>This class includes an object pool for reusing objects when particles die.</p>
	 */
	public class F3DCloneObject extends ImageInitializerBase
	{
		private var _object:Pivot3D;
		
		/**
		 * The constructor creates an F3DCloneObject initializer for use by 
		 * an emitter. To add an F3DCloneObject to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param object The Object3D to clone for each particle created by the emitter.
		 * @param usePool Indicates whether particles should be reused when a particle dies.
		 * @param fillPool Indicates how many particles to create immediately in the pool, to
		 * avoid creating them when the particle effect is running.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function F3DCloneObject( object:Pivot3D = null, usePool:Boolean = false, fillPool:uint = 0 )
		{
			super( usePool );
			_object = object;
			if( fillPool > 0 )
			{
				this.fillPool( fillPool );
			}
		}
		
		/**
		 * The Object3D to clone for each particle created by the emitter.
		 */
		public function get object():Pivot3D
		{
			return _object;
		}
		public function set object( value:Pivot3D ):void
		{
			_object = value;
			if( _usePool )
			{
				clearPool();
			}
		}
		
		/**
		 * Used internally, this method creates an image object for displaying the particle 
		 * by cloning the original Object3D.
		 */
		override public function createImage():Object
		{
			return _object.clone();
		}
	}
}
