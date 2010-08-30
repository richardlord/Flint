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

package org.flintparticles.threeD.papervision3d.initializers
{
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.initializers.InitializerBase;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.utils.construct;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.primitives.Plane;
	
	import flash.display.DisplayObject;	

	/**
	 * The PV3DDisplayObjectClass initializer sets the DisplayObject to use to 
	 * draw the particle in a 3D scene. It is used with the Papervision3D renderer when
	 * particles should be represented by a display object.
	 * 
	 * <p>The initializer creates an Papervision3D Plane object with the DisplayObject as its material
	 * for rendering the display object in an Papervision3D scene.</p>
	 */

	public class PV3DDisplayObjectClass extends InitializerBase
	{
		private var _imageClass:Class;
		private var _parameters:Array;
		
		/**
		 * The constructor creates an ImageClass initializer for use by 
		 * an emitter. To add an ImageClass to all particles created by an emitter, use the
		 * emitter's addInitializer method.
		 * 
		 * @param imageClass The class to use when creating
		 * the particles' DisplayObjects.
		 * @param parameters The parameters to pass to the constructor
		 * for the image class.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function PV3DDisplayObjectClass( imageClass:Class, ...parameters )
		{
			_imageClass = imageClass;
			_parameters = parameters;
		}
		
		/**
		 * The class to use when creating
		 * the particles' DisplayObjects.
		 */
		public function get imageClass():Class
		{
			return _imageClass;
		}
		public function set imageClass( value:Class ):void
		{
			_imageClass = value;
		}
		
		/**
		 * The parameters to pass to the constructor
		 * for the image class.
		 */
		public function get parameters():Array
		{
			return _parameters;
		}
		public function set parameters( value:Array ):void
		{
			_parameters = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:org.flintparticles.common.particles.Particle ):void
		{
			var clip:DisplayObject = construct( _imageClass, _parameters );
			var material:MovieMaterial = new MovieMaterial( clip, true, true, false, clip.getBounds( clip ) );
			particle.image = new Plane( material, clip.width, clip.height );
		}
	}
}
