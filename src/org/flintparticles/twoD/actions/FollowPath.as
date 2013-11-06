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

package org.flintparticles.twoD.actions {
import org.flintparticles.common.actions.ActionBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.twoD.particles.Particle2D;
import org.flintparticles.twoD.paths.Path2D;

/**
 * The FollowPath action moves the particle along its path
 */
public class FollowPath extends ActionBase {

    /**
     * Constructor creates new FollowPath action
     */
    public function FollowPath() {

    }

    /**
     * Calculates position of the particle over the
     * period of time indicated.
     *
     * <p>This method is called by the emitter and need not be called by the
     * user.</p>
     *
     * @param emitter The Emitter that created the particle.
     * @param particle The particle to be updated.
     * @param time The duration of the frame - used for time based updates.
     *
     * @see org.flintparticles.common.actions.Action#update()
     */
    override public function update(emitter:Emitter, particle:Particle, time:Number):void {
        var p2d:Particle2D = particle as Particle2D;

        if (p2d) {
            var path2D:Path2D = p2d.path as Path2D;
            p2d.x = p2d.previousX + path2D.x(1 - p2d.energy);
            p2d.y = p2d.previousY + path2D.y(1 - p2d.energy);
        }
    }
}
}
