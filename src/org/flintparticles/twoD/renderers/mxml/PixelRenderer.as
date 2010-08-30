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

package org.flintparticles.twoD.renderers.mxml
{
	import org.flintparticles.twoD.particles.Particle2D;
	
	import flash.geom.Rectangle;	

	/**
	 * The PixelRenderer draws particles as single pixels on a Bitmap display object. The
	 * region of the particle system covered by this bitmap object is defined by the width
	 * and height of the renderer. Particles outside this region are not drawn.
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
	 * 
	 * <p>This version of the PixelRenderer is a UIComponent and is intended for
	 * use in MXML documents.</p>
	 */
	public class PixelRenderer extends BitmapRenderer
	{
		/**
		 * The constructor creates a PixelRenderer. After creation it should be
		 * added to the display list of a DisplayObjectContainer to place it on 
		 * the stage and should be applied to an Emitter using the Emitter's
		 * renderer property.
		 */
		public function PixelRenderer( canvas:Rectangle = null )
		{
			super( canvas );
		}
		
		/**
		 * Used internally to draw the particles.
		 */
		override protected function drawParticle( particle:Particle2D ):void
		{
			_bitmapData.setPixel32( Math.round( particle.x - _canvas.x ), Math.round( particle.y - _canvas.y ), particle.color );
		}
	}
}