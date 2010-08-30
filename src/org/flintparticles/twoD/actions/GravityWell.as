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
	 * The GravityWell action applies a force on the particle to draw it towards
	 * a single point. The force applied is inversely proportional to the square
	 * of the distance from the particle to the point, in accordance with Newton's
	 * law of gravity.
	 * 
	 * <p>This simulates the effect of gravity over large distances (as between
	 * planets, for example). To simulate the effect of gravity at the surface
	 * of the eacrth, use an Acceleration action with the direction of force 
	 * downwards.</p>
	 * 
	 * @see Acceleration
	 */

	public class GravityWell extends ActionBase
	{
		private var _x:Number;
		private var _y:Number;
		private var _power:Number;
		private var _epsilonSq:Number;
		private var _gravityConst:Number = 10000; // just scales the power to a more reasonable number
		
		private var lp:Particle2D;
		private var lx:Number;
		private var ly:Number;
		private var ldSq:Number;
		private var ld:Number;
		private var lfactor:Number;
		
		/**
		 * The constructor creates a GravityWell action for use by an emitter.
		 * To add a GravityWell to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param power The strength of the gravity force - larger numbers produce a 
		 * stronger force.
		 * @param x The x coordinate of the point towards which the force draws 
		 * the particles.
		 * @param y The y coordinate of the point towards which the force draws 
		 * the particles.
		 * @param epsilon The minimum distance for which gravity is calculated. 
		 * Particles closer than this distance experience a gravity force as if 
		 * they were this distance away. This stops the gravity effect blowing 
		 * up as distances get small. For realistic gravity effects you will want 
		 * a small epsilon ( ~1 ), but for stable visual effects a larger
		 * epsilon (~100) is often better.
		 */
		public function GravityWell( power:Number = 0, x:Number = 0, y:Number = 0, epsilon:Number = 100 )
		{
			this.power = power;
			this.x = x;
			this.y = y;
			this.epsilon = epsilon;
		}
		
		/**
		 * The strength of the gravity force - larger numbers produce a 
		 * stronger force.
		 */
		public function get power():Number
		{
			return _power / _gravityConst;
		}
		public function set power( value:Number ):void
		{
			_power = value * _gravityConst;
		}
		
		/**
		 * The x coordinate of the point towards which the force draws 
		 * the particles.
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
		 * The y coordinate of the point towards which the force draws 
		 * the particles.
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
		 * The minimum distance for which the gravity force is calculated. 
		 * Particles closer than this distance experience the gravity as if
		 * they were this distance away. This stops the gravity effect blowing 
		 * up as distances get small.  For realistic gravity effects you will want 
		 * a small epsilon ( ~1 ), but for stable visual effects a larger
		 * epsilon (~100) is often better.
		 */
		public function get epsilon():Number
		{
			return Math.sqrt( _epsilonSq );
		}
		public function set epsilon( value:Number ):void
		{
			_epsilonSq = value * value;
		}
		
		/**
		 * Calculates the gravity force on the particle and applies it for
		 * the period of time indicated.
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
			if( particle.mass == 0 )
			{
				return;
			}
			lp = Particle2D( particle );
			lx = _x - lp.x;
			ly = _y - lp.y;
			ldSq = lx * lx + ly * ly;
			if( ldSq == 0 )
			{
				return;
			}
			ld = Math.sqrt( ldSq );
			if( ldSq < _epsilonSq ) ldSq = _epsilonSq;
			lfactor = ( _power * time ) / ( ldSq * ld );
			lp.velX += lx * lfactor;
			lp.velY += ly * lfactor;
		}
	}
}
