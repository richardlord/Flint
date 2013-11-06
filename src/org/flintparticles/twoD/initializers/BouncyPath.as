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

package org.flintparticles.twoD.initializers {
import flash.geom.Point;

import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.twoD.particles.Particle2D;
import org.flintparticles.twoD.paths.BouncyPath2D;
import org.flintparticles.twoD.zones.Zone2D;

/**
 * The BouncyPath represents particle moving trajectory from one point to another with bounce
 * effect.
 */
public class BouncyPath extends LinearPath {
    private var _amplitude:Number;
    private var _bounces:Number;

    /**
     * The constructor creates a BouncyPath. Particle will bounce while moving. Each bounce will
     * have less height than previous.
     *
     * @param start zone where particle start it moving
     * @param end target particle zone
     * @param amplitude initial bounce amplitude
     * @param bounces number of jumps
     */
    public function BouncyPath(start:Zone2D, end:Zone2D, amplitude:Number, bounces:Number) {
        super(start, end);
        _amplitude = amplitude;
        _bounces = bounces;
    }

    /**
     * Amplitude height
     */
    public function get amplitude():Number {
        return _amplitude;
    }

    public function set amplitude(value:Number):void {
        _amplitude = value;
    }

    /**
     * Number of jumps
     */
    public function get bounces():Number {
        return _bounces;
    }

    public function set bounces(value:Number):void {
        _bounces = value;
    }

    /**
     * @inheritDoc
     */
    override public function initialize(emitter:Emitter, particle:Particle):void {
        var p:Particle2D = Particle2D(particle);
        var loc:Point = start.getLocation();
        if (p.rotation == 0) {
            p.x += loc.x;
            p.y += loc.y;
        }
        else {
            var sin:Number = Math.sin(p.rotation);
            var cos:Number = Math.cos(p.rotation);
            p.x += cos * loc.x - sin * loc.y;
            p.y += cos * loc.y + sin * loc.x;
        }
        p.previousX = p.x;
        p.previousY = p.y;
        p.path = new BouncyPath2D(loc, end.getLocation(), _amplitude, _bounces);
    }
}
}
