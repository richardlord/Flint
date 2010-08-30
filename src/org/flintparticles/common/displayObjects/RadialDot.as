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
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;	

	/**
	 * The RadialDot class is a DisplayObject that is a circle shape with a gradient 
	 * fill that fades to transparency at the edge of the dot. The registration point
	 * of this diaplay object is in the center of the Dot.
	 */

	public class RadialDot extends Shape 
	{
		private var _radius:Number;
		private var _color:uint;
		
		/**
		 * The constructor creates a RadialDot with the  specified radius.
		 * 
		 * @param radius The radius, in pixels, of the RadialDot.
		 * @param color The color of the RadialDot
		 * @param bm The blendMode of the RadialDot
		 */
		public function RadialDot( radius:Number = 1, color:uint = 0xFFFFFF, bm:String = "normal" )
		{
			_radius = radius;
			_color = color;
			draw();
			blendMode = bm;
		}
		
		private function draw():void
		{
			graphics.clear();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox( _radius * 2, _radius * 2, 0, -_radius, -_radius );
			graphics.beginGradientFill( GradientType.RADIAL, [_color,_color], [1,0], [0,255], matrix );
			graphics.drawCircle( 0, 0, _radius );
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
