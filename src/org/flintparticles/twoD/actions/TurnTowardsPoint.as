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

package org.flintparticles.twoD.actions 
{
	import org.flintparticles.common.actions.ActionBase;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.twoD.particles.Particle2D;	

	/**
	 * The TurnTowardsPoint action causes the particle to constantly adjust its 
	 * direction so that it travels towards a particular point.
	 */

	public class TurnTowardsPoint extends ActionBase
	{
		private var _x:Number;
		private var _y:Number;
		private var _power:Number;
		
		/**
		 * The constructor creates a TurnTowardsPoint action for use by an emitter. 
		 * To add a TurnTowardsPoint to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param power The strength of the turn action. Higher values produce a sharper turn.
		 * @param x The x coordinate of the point towards which the particle turns.
		 * @param y The y coordinate of the point towards which the particle turns.
		 */
		public function TurnTowardsPoint( x:Number = 0, y:Number = 0, power:Number = 0 )
		{
			this.power = power;
			this.x = x;
			this.y = y;
		}
		
		/**
		 * The strength of the turn action. Higher values produce a sharper turn.
		 */
		public function get power():Number
		{
			return _power;
		}
		public function set power( value:Number ):void
		{
			_power = value;
		}
		
		/**
		 * The x coordinate of the point that the particle turns towards.
		 */
		public function get x():Number
		{
			return _x;
		}
		public function set x( value:Number ):void
		{
			_x = value;
		}
		
		/**
		 * The y coordinate of the point that the particle turns towards.
		 */
		public function get y():Number
		{
			return _y;
		}
		public function set y( value:Number ):void
		{
			_y = value;
		}
		
		/**
		 * Calculates the direction to the focus point and turns the particle towards 
		 * this direction.
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
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var p:Particle2D = Particle2D( particle );
			var velLength:Number = Math.sqrt( p.velX * p.velX + p.velY * p.velY );
			var dx:Number = p.velX / velLength;
			var dy:Number = p.velY / velLength;
			var acc:Number = power * time;
			var targetX:Number = _x - p.x;
			var targetY:Number = _y - p.y;
			var len:Number = Math.sqrt( targetX * targetX + targetY * targetY );
			if( len == 0 )
			{
				return;
			}
			targetX /= len;
			targetY /= len;
			var dot:Number = targetX * dx + targetY * dy;
			var perpX:Number = targetX - dx * dot;
			var perpY:Number = targetY - dy * dot;
			var factor:Number = acc / Math.sqrt( perpX * perpX + perpY * perpY );
			p.velX += perpX * factor;
			p.velY += perpY * factor;
			factor = velLength / Math.sqrt( p.velX * p.velX + p.velY * p.velY );
			p.velX *= factor;
			p.velY *= factor;
		}
	}
}
