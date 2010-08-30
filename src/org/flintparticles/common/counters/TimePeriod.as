
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

package org.flintparticles.common.counters
{
	import org.flintparticles.common.easing.Linear;
	import org.flintparticles.common.emitters.Emitter;	

	/**
	 * The TimePeriod counter causes the emitter to emit particles for a period of 
	 * time and then stop. The rate of emission over that period can be modified 
	 * using easing equations that conform to the interface defined in Robert 
	 * Penner's easing equations. An update to these equations is included in the 
	 * org.flintparticles.common.easing package.
	 * 
	 * @see org.flintparticles.common.easing
	 */
	public class TimePeriod implements Counter
	{
		private var _particles : uint;
		private var _duration : Number;
		private var _particlesPassed : uint;
		private var _timePassed : Number;
		private var _easing : Function;
		private var _stop : Boolean = false;

		/**
		 * The constructor creates a TimePeriod counter for use by an emitter. To
		 * add a TimePeriod counter to an emitter use the emitter's counter property.
		 * 
		 * @param numParticles The number of particles to emit over the full duration
		 * of the time period
		 * @param duration The duration of the time period. After this time is up the
		 * emitter will not release any more particles.
		 * @param easing An easing function used to distribute the emission of the
		 * particles over the time period. If no easing function is passed a simple
		 * linear distribution is used in which particles are emitted at a constant 
		 * rate over the time period.
		 * 
		 * @see org.flintparticles.common.emitter.Emitter.counter
		 */
		public function TimePeriod( numParticles : uint = 0, duration : Number = 0, easing : Function = null )
		{
			_particles = numParticles;
			_duration = duration;
			if ( easing == null )
			{
				_easing = Linear.easeNone;
			}
			else
			{
				_easing = easing;
			}
		}

		/**
		 * The number of particles to emit over the full duration
		 * of the time period.
		 */
		public function get numParticles():uint
		{
			return _particles;
		}
		public function set numParticles( value:uint ):void
		{
			_particles = value;
		}
		
		/**
		 * The duration of the time period. After this time is up the
		 * emitter will not release any more particles.
		 */
		public function get duration():Number
		{
			return _duration;
		}
		public function set duration( value:Number ):void
		{
			_duration = value;
		}
		
		/**
		 * An easing function used to distribute the emission of the
		 * particles over the time period.
		 */
		public function get easing():Function
		{
			return _easing;
		}
		public function set easing( value:Function ):void
		{
			_easing = value;
		}
		
		/**
		 * Initilizes the counter. Returns 0 to indicate that the emitter should 
		 * emit no particles when it starts.
		 * 
		 * <p>This method is called within the emitter's start method 
		 * and need not be called by the user.</p>
		 * 
		 * @param emitter The emitter.
		 * @return 0
		 * 
		 * @see org.flintparticles.common.counters.Counter#startEmitter()
		 */
		public function startEmitter( emitter:Emitter ) : uint
		{
			_particlesPassed = 0;
			_timePassed = 0;
			return 0;
		}

		/**
		 * Uses the time, timePeriod and easing function to calculate how many
		 * particles the emitter should emit now.
		 * 
		 * <p>This method is called within the emitter's update loop and need not
		 * be called by the user.</p>
		 * 
		 * @param emitter The emitter.
		 * @param time The time, in seconds, since the previous call to this method.
		 * @return the number of particles the emitter should create.
		 * 
		 * @see org.flintparticles.common.counters.Counter#updateEmitter()
		 */
		public function updateEmitter( emitter:Emitter, time : Number ) : uint
		{
			if( _stop || _timePassed >= _duration )
			{
				return 0;
			}
			
			_timePassed += time;
			
			if( _timePassed >= _duration )
			{
				emitter.dispatchCounterComplete();
				var newParticles:uint = _particles - _particlesPassed;
				_particlesPassed = _particles;
				return newParticles;
			}
			
			var oldParticles:uint = _particlesPassed;
			_particlesPassed = Math.round( _easing( _timePassed, 0, _particles, _duration ) );
			return _particlesPassed - oldParticles;
		}

		/**
		 * Stops the emitter from emitting particles
		 */
		public function stop():void
		{
			_stop = true;
		}
		
		/**
		 * Resumes the emitter after a stop
		 */
		public function resume():void
		{
			_stop = false;
		}

		/**
		 * Indicates if the counter has emitted all its particles.
		 */
		public function get complete():Boolean
		{
			return _particlesPassed == _particles;
		}
	}
}