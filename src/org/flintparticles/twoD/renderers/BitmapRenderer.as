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

package org.flintparticles.twoD.renderers
{
	import org.flintparticles.common.renderers.SpriteRendererBase;
	import org.flintparticles.twoD.particles.Particle2D;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;	

	/**
	 * The BitmapRenderer draws particles onto a single Bitmap display object. The
	 * region of the particle system covered by this bitmap object must be defined
	 * in the canvas property of the BitmapRenderer. Particles outside this region
	 * are not drawn.
	 * 
	 * <p>The image to be used for each particle is the particle's image property.
	 * This is a DisplayObject, but this DisplayObject is not used directly. Instead
	 * it is copied into the bitmap with the various properties of the particle 
	 * applied. Consequently each particle may be represented by the same 
	 * DisplayObject instance and the SharedImage initializer can be used with this 
	 * renderer.</p>
	 * 
	 * <p>The BitmapRenderer allows the use of BitmapFilters to modify the appearance
	 * of the bitmap. Every frame, under normal circumstances, the Bitmap used to
	 * display the particles is wiped clean before all the particles are redrawn.
	 * However, if one or more filters are added to the renderer, the filters are
	 * applied to the bitmap instead of wiping it clean. This enables various trail
	 * effects by using blur and other filters. You can also disable the clearing
	 * of the particles by setting the clearBetweenFrames property to false.</p>
	 * 
	 * <p>The BitmapRenderer has mouse events disabled for itself and any 
	 * display objects in its display list. To enable mouse events for the renderer
	 * or its children set the mouseEnabled or mouseChildren properties to true.</p>
	 */
	public class BitmapRenderer extends SpriteRendererBase
	{
		protected static var ZERO_POINT:Point = new Point( 0, 0 );
		
		/**
		 * @private
		 */
		protected var _bitmap:Bitmap;
		
		protected var _bitmapData:BitmapData;
		/**
		 * @private
		 */
		protected var _preFilters:Array;
		/**
		 * @private
		 */
		protected var _postFilters:Array;
		/**
		 * @private
		 */
		protected var _colorMap:Array;
		/**
		 * @private
		 */
		protected var _smoothing:Boolean;
		/**
		 * @private
		 */
		protected var _canvas:Rectangle;
		/**
		 * @private
		 */
		protected var _clearBetweenFrames:Boolean;

		/**
		 * The constructor creates a BitmapRenderer. After creation it should be
		 * added to the display list of a DisplayObjectContainer to place it on 
		 * the stage and should be applied to an Emitter using the Emitter's
		 * renderer property.
		 * 
		 * @param canvas The area within the renderer on which particles can be drawn.
		 * Particles outside this area will not be drawn.
		 * @param smoothing Whether to use smoothing when scaling the Bitmap and, if the
		 * particles are represented by bitmaps, when drawing the particles.
		 * Smoothing removes pixelation when images are scaled and rotated, but it
		 * takes longer so it may slow down your particle system.
		 * 
		 * @see org.flintparticles.twoD.emitters.Emitter#renderer
		 */
		public function BitmapRenderer( canvas:Rectangle, smoothing:Boolean = false )
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
			_smoothing = smoothing;
			_preFilters = new Array();
			_postFilters = new Array();
			_canvas = canvas;
			createBitmap();
			_clearBetweenFrames = true;
		}
		
		/**
		 * The addFilter method adds a BitmapFilter to the renderer. These filters
		 * are applied each frame, before or after the new particle positions are 
		 * drawn, instead of wiping the display clear. Use of a blur filter, for 
		 * example, will produce a trail behind each particle as the previous images
		 * blur and fade more each frame.
		 * 
		 * @param filter The filter to apply
		 * @param postRender If false, the filter is applied before drawing the particles
		 * in their new positions. If true the filter is applied after drawing the particles.
		 */
		public function addFilter( filter:BitmapFilter, postRender:Boolean = false ):void
		{
			if( postRender )
			{
				_postFilters.push( filter );
			}
			else
			{
				_preFilters.push( filter );
			}
		}
		
		/**
		 * Removes a BitmapFilter object from the Renderer.
		 * 
		 * @param filter The BitmapFilter to remove
		 * 
		 * @see addFilter()
		 */
		public function removeFilter( filter:BitmapFilter ):void
		{
			for( var i:int = 0; i < _preFilters.length; ++i )
			{
				if( _preFilters[i] == filter )
				{
					_preFilters.splice( i, 1 );
					return;
				}
			}
			for( i = 0; i < _postFilters.length; ++i )
			{
				if( _postFilters[i] == filter )
				{
					_postFilters.splice( i, 1 );
					return;
				}
			}
		}
		
		/**
		 * The array of all filters being applied before rendering.
		 */
		public function get preFilters():Array
		{
			return _preFilters.slice();
		}
		public function set preFilters( value:Array ):void
		{
			var filter:BitmapFilter;
			for each( filter in _preFilters )
			{
				removeFilter( filter );
			}
			for each( filter in value )
			{
				addFilter( filter, false );
			}
		}

		/**
		 * The array of all filters being applied before rendering.
		 */
		public function get postFilters():Array
		{
			return _postFilters.slice();
		}
		public function set postFilters( value:Array ):void
		{
			var filter:BitmapFilter;
			for each( filter in _postFilters )
			{
				removeFilter( filter );
			}
			for each( filter in value )
			{
				addFilter( filter, true );
			}
		}

		/**
		 * Sets a palette map for the renderer. See the paletteMap method in flash's BitmapData object for
		 * information about how palette maps work. The palette map will be applied to the full canvas of the 
		 * renderer after all filters have been applied and the particles have been drawn.
		 */
		public function setPaletteMap( red : Array = null , green : Array = null , blue : Array = null, alpha : Array = null ) : void
		{
			_colorMap = new Array(4);
			_colorMap[0] = alpha;
			_colorMap[1] = red;
			_colorMap[2] = green;
			_colorMap[3] = blue;
		}
		/**
		 * Clears any palette map that has been set for the renderer.
		 */
		public function clearPaletteMap() : void
		{
			_colorMap = null;
		}
		
		/**
		 * Create the Bitmap and BitmapData objects
		 */
		protected function createBitmap():void
		{
			if( !_canvas )
			{
				return;
			}
			if( _bitmap && _bitmapData )
			{
				_bitmapData.dispose();
				_bitmapData = null;
			}
			if( _bitmap )
			{
				removeChild( _bitmap );
				_bitmap = null;
			}
			_bitmap = new Bitmap( null, "auto", _smoothing);
			_bitmapData = new BitmapData( Math.ceil( _canvas.width ), Math.ceil( _canvas.height ), true, 0 );
			_bitmap.bitmapData = _bitmapData;
			addChild( _bitmap );
			_bitmap.x = _canvas.x;
			_bitmap.y = _canvas.y;
		}
		
		/**
		 * The canvas is the area within the renderer on which particles can be drawn.
		 * Particles outside this area will not be drawn.
		 */
		public function get canvas():Rectangle
		{
			return _canvas;
		}
		public function set canvas( value:Rectangle ):void
		{
			_canvas = value;
			createBitmap();
		}
		
		/**
		 * Controls whether the display is cleared between each render frame.
		 * If you use pre-render filters, this value is ignored and the display is
		 * not cleared. If you use no filters or only post-render filters, this value 
		 * governs whether the screen is cleared.
		 * 
		 * <p>For BitmapRenderer and PixelRenderer, this value defaults to true.
		 * For BitmapLineRenderer it defaults to false.</p>
		 */
		public function get clearBetweenFrames():Boolean
		{
			return _clearBetweenFrames;
		}
		public function set clearBetweenFrames( value:Boolean ):void
		{
			_clearBetweenFrames = value;
		}
		
		public function get smoothing():Boolean
		{
			return _smoothing;
		}
		public function set smoothing( value:Boolean ):void
		{
			_smoothing = value;
			if( _bitmap )
			{
				_bitmap.smoothing = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function renderParticles( particles:Array ):void
		{
			if( !_bitmap )
			{
				return;
			}
			var i:int;
			var len:int;
			_bitmapData.lock();
			len = _preFilters.length;
			for( i = 0; i < len; ++i )
			{
				_bitmapData.applyFilter( _bitmapData, _bitmapData.rect, BitmapRenderer.ZERO_POINT, _preFilters[i] );
			}
			if( _clearBetweenFrames && len == 0 )
			{
				_bitmapData.fillRect( _bitmap.bitmapData.rect, 0 );
			}
			len = particles.length;
			if ( len )
			{
				for( i = len; i--; ) // draw new particles first so they are behind old particles
				{
					drawParticle( particles[i] );
				}
			}
			len = _postFilters.length;
			for( i = 0; i < len; ++i )
			{
				_bitmapData.applyFilter( _bitmapData, _bitmapData.rect, BitmapRenderer.ZERO_POINT, _postFilters[i] );
			}
			if( _colorMap )
			{
				_bitmapData.paletteMap( _bitmapData, _bitmapData.rect, ZERO_POINT, _colorMap[1] , _colorMap[2] , _colorMap[3] , _colorMap[0] );
			}
			_bitmapData.unlock();
		}
		
		/**
		 * Used internally here and in derived classes to alter the manner of 
		 * the particle rendering.
		 * 
		 * @param particle The particle to draw on the bitmap.
		 */
		protected function drawParticle( particle:Particle2D ):void
		{
			var matrix:Matrix;
			matrix = particle.matrixTransform;
			matrix.translate( -_canvas.x, -_canvas.y );
			_bitmapData.draw( particle.image, matrix, particle.colorTransform, DisplayObject( particle.image ).blendMode, null, _smoothing );
		}
		
		/**
		 * The bitmap data of the renderer.
		 */
		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}
	}
}