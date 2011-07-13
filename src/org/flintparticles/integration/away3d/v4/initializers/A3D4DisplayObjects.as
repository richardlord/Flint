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
	import away3d.entities.Sprite3D;
	import away3d.materials.AnimatedBitmapMaterial;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.MaterialBase;

	import org.flintparticles.common.initializers.ImageInitializerBase;
	import org.flintparticles.common.utils.WeightedArray;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * The A3D4DisplayObjects Initializer sets the DisplayObject to use to 
	 * draw the particle in a 3D scene. It is used with the Away3D renderer when
	 * particles should be represented by one of a number of display objects.
	 * 
	 * <p>The initializer creates an Away3D Sprite3D and a BitmapMaterial, with the display object
	 * as the image source for the material, for rendering the display 
	 * object in an Away3D scene.</p>
	 * 
	 * <p>This class includes an object pool for reusing objects when particles die.</p>
	 */
	public class A3D4DisplayObjects extends ImageInitializerBase
	{
		private var _displayObjects:WeightedArray;
		
		/**
		 * The constructor creates an A3D4DisplayObjects initializer for use by 
		 * an emitter. To add an A3D4DisplayObjects to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param displayObjects An array containing the DisplayObjects to use for 
		 * each particle created by the emitter.
		 * @param weights The weighting to apply to each DisplayObject. If no weighting
		 * values are passed, the DisplayObjects are used with equal probability.
		 * @param usePool Indicates whether particles should be reused when a particle dies.
		 * @param fillPool Indicates how many particles to create immediately in the pool, to
		 * avoid creating them when the particle effect is running.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function A3D4DisplayObjects( displayObjects:Array, weights:Array = null, usePool:Boolean = false, fillPool:uint = 0 )
		{
			super( usePool );
			_displayObjects = new WeightedArray();
			var len:int = displayObjects.length;
			var i:int;
			if( weights != null && weights.length == len )
			{
				for( i = 0; i < len; ++i )
				{
					addDisplayObject( displayObjects[i], weights[i] );
				}
			}
			else
			{
				for( i = 0; i < len; ++i )
				{
					addDisplayObject( displayObjects[i], 1 );
				}
			}
			if( fillPool > 0 )
			{
				this.fillPool( fillPool );
			}
		}
		
		public function addDisplayObject( displayObject:DisplayObject, weight:Number = 1 ):void
		{
			_displayObjects.add( displayObject, weight );
			if( _usePool )
			{
				clearPool();
			}
		}
		
		public function removeDisplayObject( displayObject:DisplayObject ):void
		{
			_displayObjects.remove( displayObject );
			if( _usePool )
			{
				clearPool();
			}
		}
		
		/**
		 * Used internally, this method creates an image object for displaying the particle 
		 * by creating a Sprite3D and using one of the display objects as its material.
		 */
		override public function createImage():Object
		{
			var displayObject:DisplayObject = _displayObjects.getRandomValue();
			var material:MaterialBase;
			if( displayObject is MovieClip )
			{
				material = new AnimatedBitmapMaterial( MovieClip( displayObject ), true, true );
			}
			else
			{
				var bounds:Rectangle = displayObject.getBounds( displayObject );
				var width:int = textureSize( bounds.width );
				var height:int = textureSize( bounds.height );
				var bitmapData:BitmapData = new BitmapData( width, height, true, 0x00FFFFFF );
				var matrix:Matrix = displayObject.transform.matrix.clone();
				matrix.translate( -bounds.left, -bounds.top );
				matrix.scale( width / bounds.width, height / bounds.height );
				bitmapData.draw( displayObject, matrix, displayObject.transform.colorTransform, null, null, true );
				material = new BitmapMaterial( bitmapData, true, true );
			}
			return new Sprite3D( material, displayObject.width, displayObject.height );
		}
		
		private function textureSize( value:Number ):int
		{
			var val:int = Math.ceil( value );
			var count:int = 0;
			while( val )
			{
				count++;
				val = val >>> 1;
			}
			return 1 << count + 1;
		}
	}
}
