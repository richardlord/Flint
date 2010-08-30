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
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.emitters.Emitter;
	
	import flash.utils.getTimer;	

	/**
	 * The PerformanceAdjusted counter causes the emitter to emit particles 
	 * continuously at a steady rate. It then adjusts this rate downwards if 
	 * the frame rate is below a target frame rate, until it reaches an emission
	 * rate at which the system can maintain the target frame rate.
	 */
	public class PerformanceAdjusted implements Counter
	{
		private var _timeToNext:Number;
		private var _rateMin:Number;
		private var _rateMax:Number;
		private var _target:Number;
		private var _rate:Number;
		private var _times:Array;
		private var _timeToRateCheck:Number;
		private var _stop:Boolean;
		
		/**
		 * The constructor creates a PerformanceAdjusted counter for use by an 
		 * emitter. To add a PerformanceAdjusted counter to an emitter use the 
		 * emitter's counter property.
		 * 
		 * @param rateMin The minimum number of particles to emit per second. 
		 * The counter will never drop the rate below this value.
		 * @param rateMax The maximum number of particles to emit per second. 
		 * The counter will start at this rate and adjust downwards if the frame 
		 * rate is below the target.
		 * @param targetFrameRate The frame rate that the counter should aim for. 
		 * Always set this slightly below your actual frame rate since flash will 
		 * drop frames occasionally even when performance is fine. So, for example, 
		 * if your movie's frame rate is 30fps and you want to target this rate, 
		 * set the target rate to 26fps.
		 */
		public function PerformanceAdjusted( rateMin:Number = 0, rateMax:Number = 0, targetFrameRate:Number = 24 )
		{
			_stop = false;
			_rateMin = rateMin;
			_rate = _rateMax = rateMax;
			_target = targetFrameRate;
			_times = new Array();
			_timeToRateCheck = 0;
		}
		
		/**
		 * The minimum number of particles to emit per second. The counter
		 * will never drop the rate below this value.
		 */
		public function get rateMin():Number
		{
			return _rateMin;
		}
		public function set rateMin( value:Number ):void
		{
			_rateMin = value;
			_timeToRateCheck = 0;
		}
		
		/**
		 * The maximum number of particles to emit per second. the counter
		 * will start at this rate and adjust downwards if the frame rate is
		 * below the target frame rate.
		 */
		public function get rateMax():Number
		{
			return _rateMax;
		}
		public function set rateMax( value:Number ):void
		{
			_rate = _rateMax = value;
			_timeToRateCheck = 0;
		}
		
		/**
		 * The frame rate that the counter should aim for. Always set this 
		 * slightly below your actual frame rate since flash will drop frames 
		 * occasionally even when performance is fine. So, for example, if your 
		 * movie's frame rate is 30fps and you want to target this rate, set the 
		 * target rate to 26fps.
		 */
		public function get targetFrameRate():Number
		{
			return _target;
		}
		public function set targetFrameRate( value:Number ):void
		{
			_target = value;
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
		public function startEmitter( emitter:Emitter ):uint
		{
			newTimeToNext();
			return 0;
		}
		
		private function newTimeToNext():void
		{
			_timeToNext = 1 / _rate;
		}
		
		/**
		 * Uses the time and current rate to calculate how many particles the 
		 * emitter should emit now. Also monitors the frame rate and adjusts
		 * the emission rate down if the frame rate drops below the target.
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
		public function updateEmitter( emitter:Emitter, time:Number ):uint
		{
			if( _stop )
			{
				return 0;
			}
			
			if( _rate > _rateMin && ( _timeToRateCheck -= time ) <= 0 )
			{
				// adjust rate
				var t:Number;
				if ( _times.push( t = getTimer() ) > 9 )
				{
					var frameRate:Number = Math.round( 10000 / ( t - Number( _times.shift() ) ) );
					if( frameRate < _target )
					{
						_rate = Math.floor( ( _rate + _rateMin ) * 0.5 );
						_times.length = 0;
						
						if( !( _timeToRateCheck = Particle( emitter.particles[0] ).lifetime ) )
						{
							_timeToRateCheck = 2;
						}
					}
				}
			}
			
			var emitTime:Number = time;
			var count:uint = 0;
			emitTime -= _timeToNext;
			while ( emitTime >= 0 )
			{
				++count;
				newTimeToNext();
				emitTime -= _timeToNext;
			}
			_timeToNext = -emitTime;
			
			return count;
		}

		/**
		 * Indicates if the counter has emitted all its particles. For this counter
		 * this will always be false.
		 */
		public function get complete():Boolean
		{
			return false;
		}
	}
}