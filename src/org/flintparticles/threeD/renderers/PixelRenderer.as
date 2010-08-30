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

package org.flintparticles.threeD.renderers
{
	import org.flintparticles.threeD.geom.Point3D;
	import org.flintparticles.threeD.particles.Particle3D;
	
	import flash.geom.Rectangle;	

	/**
	 * The PixelRenderer is a native Flint 3D renderer that draws particles
	 * as single pixels on a Bitmap display object.
	 * 
	 * <p>The region of the projection plane drawn by this renderer must be 
	 * defined in the canvas property of the BitmapRenderer. Particles outside this 
	 * region are not drawn.</p>
	 * 
	 * <p>The PixelRenderer allows the use of BitmapFilters to modify the appearance
	 * of the bitmap. Every frame, under normal circumstances, the Bitmap used to
	 * display the particles is wiped clean before all the particles are redrawn.
	 * However, if one or more filters are added to the renderer, the filters are
	 * applied to the bitmap instead of wiping it clean. This enables various trail
	 * effects by using blur and other filters.</p>
	 * 
	 * <p>The PixelRenderer has mouse events disabled for itself and any 
	 * display objects in its display list. To enable mouse events for the renderer
	 * or its children set the mouseEnabled or mouseChildren properties to true.</p>
	 */
	public class PixelRenderer extends BitmapRenderer
	{
		/**
		 * The constructor creates a PixelRenderer. After creation it should be
		 * added to the display list of a DisplayObjectContainer to place it on 
		 * the stage.
		 * 
		 * <p>Emitter's should be added to the renderer using the renderer's
		 * addEmitter method. The renderer displays all the particles created
		 * by the emitter's that have been added to it.</p>
		 * 
		 * @param canvas The area within the renderer on which particles can be drawn.
		 * Particles outside this area will not be drawn.
		 * @param zSort Whether to sort the particles according to their
		 * z order when rendering them or not.
		 * 
		 * @see org.flintparticles.twoD.emitters.Emitter#renderer
		 */
		public function PixelRenderer( canvas:Rectangle, zSort:Boolean = false )
		{
			super( canvas, zSort );
		}
		
		/**
		 * This is the method that draws each particle. calculates the position
		 * of the particle in teh camera's viewport and draws the particle
		 * as a single pixel in that location.
		 * 
		 * @param particle The particle to draw on the bitmap.
		 */
		override protected function drawParticle( particle:Particle3D ):void
		{
			var pos:Point3D = particle.projectedPosition;
			if( pos.z < _camera.nearPlaneDistance || pos.z > _camera.farPlaneDistance )
			{
				return;
			}
			pos.project();
			_bitmap.bitmapData.setPixel32( Math.round( pos.x + _halfWidth ), Math.round( -pos.y + _halfHeight ), particle.color );
		}
	}
}