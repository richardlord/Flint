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

package org.flintparticles.common.displayObjects 
{
	import flash.display.Shape;
	import flash.geom.Point;	

	/**
	 * The Star class is a DisplayObject that is the shape of a five point star. 
	 * The registration point of this display object is in the middle of the star.
	 */

	public class Star extends Shape 
	{
		private var _radius:Number;
		private var _color:uint;
		
		/**
		 * The constructor creates a Star with the specified radius.
		 * 
		 * @param radius The radius, in pixels, of the Star.
		 * @param color The color of the Star
		 * @param bm The blendMode for the Star
		 */
		public function Star( radius:Number, color:uint = 0xFFFFFF, bm:String = "normal" )
		{
			_radius = radius;
			_color = color;
			draw();
			blendMode = bm;
		}
		
		private function draw():void
		{
			graphics.clear();
			var point:Point;
			var rotStep:Number = Math.PI / 5;
			var innerRadius:Number = _radius * Math.cos( rotStep * 2 );
			var halfPi:Number = Math.PI * 0.5;
			
			graphics.beginFill( _color );
			graphics.moveTo( 0, -_radius );
			point = Point.polar( innerRadius, rotStep - halfPi );
			graphics.lineTo( point.x, point.y );
			point = Point.polar( _radius, 2 * rotStep - halfPi );
			graphics.lineTo( point.x, point.y );
			point = Point.polar( innerRadius, 3 * rotStep - halfPi );
			graphics.lineTo( point.x, point.y );
			point = Point.polar( _radius, 4 * rotStep - halfPi );
			graphics.lineTo( point.x, point.y );
			point = Point.polar( innerRadius, 5 * rotStep - halfPi );
			graphics.lineTo( point.x, point.y );
			point = Point.polar( _radius, 6 * rotStep - halfPi );
			graphics.lineTo( point.x, point.y );
			point = Point.polar( innerRadius, 7 * rotStep - halfPi );
			graphics.lineTo( point.x, point.y );
			point = Point.polar( _radius, 8 * rotStep - halfPi );
			graphics.lineTo( point.x, point.y );
			point = Point.polar( innerRadius, 9 * rotStep - halfPi );
			graphics.lineTo( point.x, point.y );
			graphics.lineTo( 0, -_radius );
			graphics.endFill();
		}
		
		public function get radius():Number
		{
			return _radius;
		}
		public function set radius( value:Number ):void
		{
			_radius = value;
			draw();
		}
		
		public function get color():uint
		{
			return _color;
		}
		public function set color( value:uint ):void
		{
			_color = value;
			draw();
		}
	}
}
