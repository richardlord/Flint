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
	 * The SpeedLimit action limits the particle's maximum speed to the specified
	 * speed. The behaviour can be switched to instead limit the minimum speed to
	 * the specified speed.
	 * 
	 * <p>This action has aa priority of -5, so that it executes after all accelerations 
	 * have occured.</p>
	 */

	public class SpeedLimit extends ActionBase
	{
		private var _limit:Number;
		private var _limitSq:Number;
		private var _isMinimum:Boolean;
		
		/**
		 * The constructor creates a SpeedLimit action for use by 
		 * an emitter. To add a SpeedLimit to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param speed The speed limit for the action in pixels per second.
		 * @param isMinimum If true, particles travelling slower than the speed limit
		 * are accelerated to the speed limit, otherwise particles travelling faster
		 * than the speed limit are decelerated to the speed limit.
		 */
		public function SpeedLimit( speed:Number = Number.MAX_VALUE, isMinimum:Boolean = false )
		{
			priority = -5;
			this.limit = speed;
			this.isMinimum = isMinimum;
		}
		
		/**
		 * The speed limit
		 */
		public function get limit():Number
		{
			return _limit;
		}
		public function set limit( value:Number ):void
		{
			_limit = value;
			_limitSq = value * value;
		}
		
		/**
		 * Whether the speed is a minimum (true) or maximum (false) speed.
		 */
		public function get isMinimum():Boolean
		{
			return _isMinimum;
		}
		public function set isMinimum( value:Boolean ):void
		{
			_isMinimum = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var p:Particle3D = Particle3D( particle );
			var speedSq:Number = p.velocity.lengthSquared;
			if ( ( _isMinimum && speedSq < _limitSq ) || ( !_isMinimum && speedSq > _limitSq ) )
			{
				var scale:Number = _limit / Math.sqrt( speedSq );
				p.velocity.scaleBy( scale );
			}
		}
	}
}
