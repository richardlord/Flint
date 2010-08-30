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

package org.flintparticles.threeD.actions 
{
	import org.flintparticles.common.actions.ActionBase;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.threeD.geom.Quaternion;
	import org.flintparticles.threeD.particles.Particle3D;	

	/**
	 * The Rotate action updates the rotation of the particle based on its angular velocity.
	 * It uses a Euler integrator to calculate the new rotation, hence the name.
	 * 
	 * <p>This action has a priority of -10, so that it executes after other actions.</p>
	 */

	public class Rotate extends ActionBase
	{
		/*
		 * Temporary variables created as class members to avoid creating new objects all the time
		 */
		private var q:Quaternion;
		
		/**
		 * The constructor creates a Rotate action for use by 
		 * an emitter. To add a Rotate to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 */
		public function Rotate()
		{
			priority = -10;
			q = new Quaternion();
		}

		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var p:Particle3D = Particle3D( particle );
			q.w = 0;
			q.x = p.angVelocity.x * 0.5;
			q.y = p.angVelocity.y * 0.5;
			q.z = p.angVelocity.z * 0.5;
			q.postMultiplyBy( p.rotation );
			p.rotation.incrementBy( q.scaleBy( time ) ).normalize();
		}
	}
}
