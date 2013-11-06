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
import org.flintparticles.common.initializers.InitializerBase;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.twoD.particles.Particle2D;
import org.flintparticles.twoD.paths.LinearPath2D;
import org.flintparticles.twoD.zones.Zone2D;

/**
 * The LinearPath represents particle moving trajectory from one point to another with
 * constant speed.
 */
public class LinearPath extends InitializerBase {
    private var _start:Zone2D;
    private var _end:Zone2D;

    /**
     * The constructor creates a LinearPath.
     *
     * @param start zone where particle start it moving
     * @param end target particle zone
     */
    public function LinearPath(start:Zone2D, end:Zone2D) {
        super();
        _start = start;
        _end = end;
    }

    /**
     * Start zone
     */
    public function get start():Zone2D {
        return _start;
    }

    public function set start(value:Zone2D):void {
        _start = value;
    }

    /**
     * End zone
     */
    public function get end():Zone2D {
        return _end;
    }

    public function set end(value:Zone2D):void {
        _end = value;
    }

    /**
     * @inheritDoc
     */
    override public function initialize(emitter:Emitter, particle:Particle):void {
        var p:Particle2D = Particle2D(particle);
        var loc:Point = _start.getLocation();
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
        p.path = new LinearPath2D(loc, _end.getLocation());
    }
}
}
