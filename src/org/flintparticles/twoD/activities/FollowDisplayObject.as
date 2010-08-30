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

package org.flintparticles.twoD.activities
{
	import org.flintparticles.common.activities.ActivityBase;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.twoD.emitters.Emitter2D;

	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * The FollowDisplayObject activity causes the emitter to follow
	 * the position of a DisplayObject. The purpose is for the emitter
	 * to emit particles from the vicinity of the DisplayObject.
	 */
	public class FollowDisplayObject extends ActivityBase
	{
		private var _renderer:DisplayObject;
		private var _displayObject:DisplayObject;
		
		/**
		 * The constructor creates a FollowDisplayObject activity for use by 
		 * an emitter. To add a FollowDisplayObject to an emitter, use the
		 * emitter's addActvity method.
		 * 
		 * @param renderer The display object whose coordinate system the DisplayObject's position is 
		 * converted to. This is usually the renderer for the particle system created by the emitter.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addActivity()
		 */
		public function FollowDisplayObject( displayObject:DisplayObject = null, renderer:DisplayObject = null )
		{
			this.displayObject = displayObject;
			this.renderer = renderer;
		}
		
		/**
		 * The DisplayObject whose coordinate system the DisplayObject's position is converted to. This
		 * is usually the renderer for the particle system created by the emitter.
		 */
		public function get renderer():DisplayObject
		{
			return _renderer;
		}
		public function set renderer( value:DisplayObject ):void
		{
			_renderer = value;
		}
		
		/**
		 * The display object that the emitter follows.
		 */
		public function get displayObject():DisplayObject
		{
			return _displayObject;
		}
		public function set displayObject( value:DisplayObject ):void
		{
			_displayObject = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter : Emitter, time : Number ) : void
		{
			var e:Emitter2D = Emitter2D( emitter );
			var p:Point = new Point( 0, 0 );
			p = _displayObject.localToGlobal( p );
			p = _renderer.globalToLocal( p );
			e.x = p.x;
			e.y = p.y;
		}
	}
}
