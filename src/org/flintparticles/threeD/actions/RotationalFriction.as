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
	import org.flintparticles.threeD.geom.Vector3D;
	import org.flintparticles.threeD.particles.Particle3D;	

	/**
	 * The RotationalFriction action applies friction to the particle's rotational movement
	 * to slow it down when it's rotating. The frictional force is constant, irrespective 
	 * of how fast the particle is rotating. For forces proportional to the particle's 
	 * angular velocity, use one of the rotational drag effects -
	 * RotationalLinearDrag and RotationalQuadraticDrag.
	 */

	public class RotationalFriction extends ActionBase
	{
		private var _friction:Number;
		
		/**
		 * The constructor creates a RotationalFriction action for use by 
		 * an emitter. To add a RotationalFriction to all particles created by an emitter, 
		 * use the emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param friction The amount of friction. A higher number produces a stronger frictional force.
		 */
		public function RotationalFriction( friction:Number = 0 )
		{
			this.friction = friction;
		}
		
		/**
		 * The amount of friction. A higher number produces a stronger frictional force.
		 */
		public function get friction():Number
		{
			return _friction;
		}
		public function set friction( value:Number ):void
		{
			_friction = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var p:Particle3D = Particle3D( particle );
			if( p.angVelocity.equals( Vector3D.ZERO ) )
			{
				return;
			}
			var scale:Number = 1 - ( _friction * time ) / ( p.angVelocity.length * p.inertia );
			if( scale < 0 )
			{
				p.angVelocity.reset( 0, 0, 0 );
			}
			else
			{
				p.angVelocity.scaleBy( scale );
			}
		}
	}
}
