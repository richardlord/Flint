/*
 * FLINT PARTICLE SYSTEM
 * .....................
 *
 * Author: Xor (Adrian Stutz) for Nothing GmbH
 * Copyright (c) Richard Lord 2008-2011
 * http://flintparticles.org
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

    /**
     * The Ring class is a DisplayObject with a circle shape that contains a hole. 
     * The registration point of this diaplay object is in the center of the Ring.
     */

    public class Ring extends Shape
    {
        private var _outerRadius:Number;
        private var _innerRadius:Number;
        private var _color:uint;

        /**
         * The constructor creates a Ring with the specified inner and outer radius.
         * @param inner Inner radius of the ring
         * @param outer Outer radius of the ring
         * @param color Color of the ring
         * @param bm    Blend mode of the ring
         */
        public function Ring( inner:Number = 1, outer:Number = 2, color:uint = 0xFFFFFF, bm:String = "normal" )
        {
            _outerRadius = outer;
            _innerRadius = inner;
            _color = color;
            draw();
            blendMode = bm;
        }

        private function draw():void
        {
            graphics.clear();
            graphics.beginFill( _color );
            graphics.drawCircle( 0, 0, _outerRadius );
            graphics.drawCircle( 0, 0, _innerRadius );
            graphics.endFill();
        }

        public function get outerRadius():Number
        {
            return _outerRadius;
        }
        public function set outerRadius( value:Number ):void
        {
            _outerRadius = value;
            draw();
        }

        public function get innerRadius():Number
        {
            return _innerRadius;
        }
        public function set innerRadius( value:Number ):void
        {
            _innerRadius = value;
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
