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
	
	import flash.display.DisplayObject;	

	[DefaultProperty("image")]
	
	/**
	 * The SharedImage Initializer sets the DisplayObject to use to draw
	 * the particle. It is used with the BitmapRenderer. When using the
	 * DisplayObjectRenderer the ImageClass Initializer must be used.
	 * 
	 * With the BitmapRenderer, the DisplayObject is copied into the bitmap
	 * using the particle's property to place the image correctly. So
	 * many particles can share the same DisplayObject because it is
	 * only indirectly used to display the particle.
	 */

	public class SharedImage extends InitializerBase
	{
		private var _image:DisplayObject;
		
		/**
		 * The constructor creates a SharedImage initializer for use by 
		 * an emitter. To add a SharedImage to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param image The DisplayObject to use for each particle created by the emitter.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function SharedImage( image:DisplayObject = null )
		{
			_image = image;
		}
		
		/**
		 * The DisplayObject to use for each particle created by the emitter.
		 */
		public function get image():DisplayObject
		{
			return _image;
		}
		public function set image( value:DisplayObject ):void
		{
			_image = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			particle.image = _image;
		}
	}
}
