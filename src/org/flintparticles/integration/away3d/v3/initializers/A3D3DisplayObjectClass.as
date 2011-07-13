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

package org.flintparticles.integration.away3d.v3.initializers
{
	import away3d.sprites.MovieClipSprite;
	
	import org.flintparticles.common.initializers.ImageInitializerBase;
	import org.flintparticles.common.utils.construct;

	/**
	 * The A3D3DisplayObjectClass initializer sets the DisplayObject to use to 
	 * draw the particle in a 3D scene. It is used with the Away3D renderer when
	 * particles should be represented by a display object.
	 * 
	 * <p>The initializer creates an Away3D MovieClipSprite, with the display object
	 * as the image source (the movieClip property), for rendering the display 
	 * object in an Away3D scene.</p>
	 * 
	 * <p>This class includes an object pool for reusing objects when particles die.</p>
	 */
	public class A3D3DisplayObjectClass extends ImageInitializerBase
	{
		private var _imageClass:Class;
		private var _parameters:Array;
		
		/**
		 * The constructor creates an A3D3DisplayObjectClass initializer for use by 
		 * an emitter. To add an A3D3DisplayObjectClass to all particles created by an emitter, use the
		 * emitter's addInitializer method.
		 * 
		 * @param imageClass The class to use when creating
		 * the particles' DisplayObjects.
		 * @param parameters The parameters to pass to the constructor
		 * for the image class.
		 * @param usePool Indicates whether particles should be reused when a particle dies.
		 * @param fillPool Indicates how many particles to create immediately in the pool, to
		 * avoid creating them when the particle effect is running.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function A3D3DisplayObjectClass( imageClass:Class, parameters:Array = null, usePool:Boolean = false, fillPool:uint = 0 )
		{
			super( usePool );
			_imageClass = imageClass;
			_parameters = parameters ? parameters : [];
			if( fillPool > 0 )
			{
				this.fillPool( fillPool );
			}
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
			if( _usePool )
			{
				clearPool();
			}
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
			if( _usePool )
			{
				clearPool();
			}
		}
		
		/**
		 * Used internally, this method creates an image object for displaying the particle 
		 * by creating a MovieClipSprite and using the given DisplayObject as its movie clip source.
		 */
		override public function createImage():Object
		{
			return new MovieClipSprite( construct( _imageClass, _parameters ) ,"none", 1, true );
			
		}
	}
}
