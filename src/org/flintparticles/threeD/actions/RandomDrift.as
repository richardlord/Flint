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
	import org.flintparticles.threeD.particles.Particle3D;	

	/**
	 * The RandomDrift action moves the particle by a random small amount every frame,
	 * causing the particle to drift around.
	 */

	public class RandomDrift extends ActionBase
	{
		private var _driftX:Number;
		private var _driftY:Number;
		private var _driftZ:Number;
		
		/**
		 * The constructor creates a RandomDrift action for use by 
		 * an emitter. To add a RandomDrift to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param driftX The maximum amount of horizontal drift in pixels per second.
		 * @param driftY The maximum amount of vertical drift in pixels per second.
		 */
		public function RandomDrift( driftX:Number = 0, driftY:Number = 0, driftZ:Number = 0 )
		{
			this.driftX = driftX;
			this.driftY = driftY;
			this.driftZ = driftZ;
		}
		
		/**
		 * The maximum amount of horizontal drift in pixels per second.
		 */
		public function get driftX():Number
		{
			return _driftX / 2;
		}
		public function set driftX( value:Number ):void
		{
			_driftX = value * 2;
		}
		
		/**
		 * The maximum amount of vertical drift in pixels per second.
		 */
		public function get driftY():Number
		{
			return _driftY / 2;
		}
		public function set driftY( value:Number ):void
		{
			_driftY = value * 2;
		}
		
		/**
		 * The maximum amount of vertical drift in pixels per second.
		 */
		public function get driftZ():Number
		{
			return _driftZ / 2;
		}
		public function set driftZ( value:Number ):void
		{
			_driftZ = value * 2;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var p:Particle3D = Particle3D( particle );
			p.velocity.x += ( Math.random() - 0.5 ) * _driftX * time;
			p.velocity.y += ( Math.random() - 0.5 ) * _driftY * time;
			p.velocity.z += ( Math.random() - 0.5 ) * _driftZ * time;
		}
	}
}
