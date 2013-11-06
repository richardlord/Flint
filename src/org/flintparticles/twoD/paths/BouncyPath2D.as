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
 * Bounce path for 2D particles
 */
public class BouncyPath2D extends LinearPath2D {
    private var _amplitude:Number;
    private var _bounces:Number;

    /**
     * Path constructor
     * @param start initial position
     * @param end target position
     * @param amplitude bounce amplitude
     * @param bounces number of jumps
     */
    public function BouncyPath2D(start:Point, end:Point, amplitude:Number, bounces:Number) {
        super(start, end);
        _amplitude = amplitude;
        _bounces = bounces;
    }

    /**
     * Path amplitude
     */
    public function get amplitude():Number {
        return _amplitude;
    }

    public function set amplitude(value:Number):void {
        _amplitude = value;
    }

    /**
     * Path jumps amount
     */
    public function get bounces():int {
        return _bounces;
    }

    public function set bounces(value:int):void {
        _bounces = value;
    }

    /**
     * @inheritDoc
     */
    override public function y(progress:Number):Number {
        return super.y(progress) -
                Math.abs(Math.sin(progress * Math.PI * _bounces)) * (1-progress) * _amplitude;
    }
}
}
