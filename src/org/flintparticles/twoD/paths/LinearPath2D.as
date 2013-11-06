/*
 * FLINT PARTICLE SYSTEM + EXTENSIONS
 * ..................................
 *
 * Author: Sergey Dvoynikov
 * Copyright (c) Sergey Dvoynikov 2013
 * http://oroborogames.net
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

package org.flintparticles.twoD.paths {
import flash.geom.Point;

/**
 * Linear path for 2D particles
 */
public class LinearPath2D implements Path2D {
    private var _start:Point;
    private var _delta:Point;

    /**
     * Creates path for linear particle trajectory
     * @param start
     * @param end
     */
    public function LinearPath2D(start:Point, end:Point) {
        _start = start;
        _delta = new Point(end.x - start.x, end.y - start.y);
    }

    /**
     * @inheritDoc
     */
    public function x(progress:Number):Number {
        return _start.x + progress * _delta.x;
    }

    /**
     * @inheritDoc
     */
    public function y(progress:Number):Number {
        return _start.y + progress * _delta.y;
    }
}
}
