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
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.twoD.particles.Particle2D;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;	

	/**
	 * The BitmapLineRenderer draws particles as continuous lines on a Bitmap display object.
	 * This is useful for effects like hair and grass.
	 * 
	 * <p>The BitmapLineRenderer uses the color and alpha of the particle
	 * for the color of the current line segment, and uses the scale of
	 * the particle for the line width.</p>
	 * 
	 * <b>The region of the particle system covered by this bitmap object must be defined
	 * in the canvas property of the BitmapLineRenderer. Particles outside this region
	 * are not drawn.
	 * 
	 * <p>The BitmapLineRenderer allows the use of BitmapFilters to modify the appearance
	 * of the bitmap.</p>
	 * 
	 * @see org.flintparticles.twoD.renderers.FullStagePixelRenderer
	 * @see org.flintparticles.common.emitters.Emitter#runAhead()
	 */
	public class BitmapLineRenderer extends BitmapRenderer
	{
		private var _shape:Shape;
		/**
		 * The constructor creates a PixelRenderer. After creation it should be
		 * added to the display list of a DisplayObjectContainer to place it on 
		 * the stage and should be applied to an Emitter using the Emitter's
		 * renderer property.
		 */
		public function BitmapLineRenderer( canvas:Rectangle= null, smoothing:Boolean = false )
		{
			super( canvas, smoothing );
			_clearBetweenFrames = false;
			_shape = new Shape();
		}
		
		/**
		 * Used internally to draw the particles.
		 */
		override protected function drawParticle( particle:Particle2D ):void
		{
			_shape.graphics.clear();
			_shape.graphics.lineStyle( particle.scale, particle.color & 0xFFFFFF, particle.color >>> 24 );
			_shape.graphics.moveTo( particle.previousX, particle.previousY );
			_shape.graphics.lineTo( particle.x, particle.y );
			_bitmapData.draw( _shape );
		}

		override protected function emitterUpdated( ev:EmitterEvent ):void
		{
			renderParticles( Emitter( ev.target ).particles );
		}
		override protected function updateParticles( ev:Event ):void
		{
		}
	}
}