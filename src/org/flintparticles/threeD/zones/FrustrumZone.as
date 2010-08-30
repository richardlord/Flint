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

package org.flintparticles.threeD.zones 
{
	import org.flintparticles.threeD.geom.Point3D;
	import org.flintparticles.threeD.renderers.Camera;
	
	import flash.geom.Rectangle;	

	/**
	 * The FrustrumZone zone defines a zone in the shape of a camera frustrum. The
	 * frustrum is the area of space visible using the camera. Everything in the
	 * camera's field of view is inside the frustrum and everything outside the
	 * camera's field of view is outside the frustrum.
	 * 
	 * <p>When using this zone, it is possible to adjust the view rect used when
	 * calculating the frustrum so that the frustrum is slightly larger (or smaller)
	 * than the camera's actual view frustrum.</p>
	 */

	public class FrustrumZone implements Zone3D 
	{
		private var _camera:Camera;
		private var _viewRect:Rectangle;
		
		/**
		 * The constructor creates a FrustrumZone zone.
		 * 
		 * @param camera The flint camera whose frustrum should be used.
		 * @param viewRect The rectangle describing the size and position
		 * of the viewing window. The camera points at position 0,0 in
		 * this rectangle, so a normal frustrum would have the form
		 * new Rectangle( -w/2, -h/2, w, h ). If using a BitmapRenderer,
		 * you could use the renderer's canvas as the viewRect, but you
		 * may want a slightly larger rectangle if this zone is used for
		 * removing particles via a DeathZone action.
		 */
		public function FrustrumZone( camera:Camera = null, viewRect:Rectangle = null )
		{
			_camera = camera;
			_viewRect = viewRect;
		}
				
		/**
		 * The flint camera whose frustrum should be used.
		 */
		public function get camera() : Camera
		{
			return _camera;
		}
		public function set camera( value : Camera ) : void
		{
			_camera = value;
		}
		
		/**
		 * The rectangle describing the size and position
		 * of the viewing window. The camera points at position 0,0 in
		 * this rectangle, so a normal frustrum would have the form
		 * new Rectangle( -w/2, -h/2, w, h ). If using a BitmapRenderer,
		 * you could use the renderer's canvas as the viewRect, but you
		 * may want a slightly larger rectangle if this zone is used for
		 * removing particles via a DeathZone action to allow for the
		 * size of the particles.
		 */
		public function get viewRect() : Rectangle
		{
			return _viewRect;
		}
		public function set viewRect( value : Rectangle ) : void
		{
			_viewRect = value;
		}

		/**
		 * The contains method determines whether a point is inside the box.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @param x The x coordinate of the location to test for.
		 * @param y The y coordinate of the location to test for.
		 * @return true if point is inside the zone, false if it is outside.
		 */
		public function contains( p:Point3D ):Boolean
		{
			var pos:Point3D = _camera.transform.transform( p ) as Point3D;
			if( pos.z < _camera.nearPlaneDistance || pos.z > _camera.farPlaneDistance )
			{
				return false;
			}
			pos.project();
			if( pos.x < _viewRect.left || pos.x > _viewRect.right
				|| pos.y < _viewRect.top || pos.y > _viewRect.bottom )
			{
				return false;
			}
			return true;
		}
		
		/**
		 * The getLocation method returns a random point inside the box.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getLocation():Point3D
		{
			var z:Number = ( Math.random() * ( _camera.farPlaneDistance - _camera.nearPlaneDistance ) ) + _camera.nearPlaneDistance;
			var scale:Number = z / _camera.projectionDistance;
			var x:Number = ( ( Math.random() * _viewRect.width ) + _viewRect.left ) * scale;
			var y:Number = ( ( Math.random() * _viewRect.height ) + _viewRect.top ) * scale;
			var p:Point3D = new Point3D( x, y, z );
			_camera.spaceTransform.inverse.transformSelf( p );
			return p;
		}
		
		/**
		 * The getArea method returns the volume of the box.
		 * This method is used by the MultiZone class. Usually, 
		 * it need not be called directly by the user.
		 * 
		 * @return the volume of the box.
		 */
		public function getVolume():Number
		{
			var proj:Number = _viewRect.width * _viewRect.height;
			var front:Number = proj * _camera.nearPlaneDistance * _camera.nearPlaneDistance * _camera.nearPlaneDistance / ( _camera.projectionDistance * _camera.projectionDistance );
			var back:Number = proj * _camera.farPlaneDistance * _camera.farPlaneDistance * _camera.farPlaneDistance / ( _camera.projectionDistance * _camera.projectionDistance );
			return ( back - front ) / 3;
		}
	}
}
