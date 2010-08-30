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

package org.flintparticles.common.emitters
{
	import org.flintparticles.common.actions.Action;
	import org.flintparticles.common.activities.Activity;
	import org.flintparticles.common.behaviours.BehaviourArrayUtils;
	import org.flintparticles.common.counters.Counter;
	import org.flintparticles.common.counters.ZeroCounter;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.common.events.UpdateEvent;
	import org.flintparticles.common.initializers.Initializer;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.particles.ParticleFactory;
	import org.flintparticles.common.utils.FrameUpdater;
	
	import flash.events.EventDispatcher;	

	/**
	 * Dispatched when a particle dies and is about to be removed from the system.
	 * As soon as the event has been handled the particle will be removed but at the
	 * time of the event it still exists so its properties (e.g. its location) can be
	 * read from it.
	 * 
	 * @eventType org.flintparticles.common.events.ParticleEvent.PARTICLE_DEAD
	 */
	[Event(name="particleDead", type="org.flintparticles.common.events.ParticleEvent")]

	/**
	 * Dispatched when a particle is created and has just been added to the emitter.
	 * 
	 * @eventType org.flintparticles.common.events.ParticleEvent.PARTICLE_CREATED
	 */
	[Event(name="particleCreated", type="org.flintparticles.common.events.ParticleEvent")]

	/**
	 * Dispatched when a pre-existing particle is added to the emitter.
	 * 
	 * @eventType org.flintparticles.common.events.ParticleEvent.PARTICLE_ADDED
	 */
	[Event(name="particleAdded", type="org.flintparticles.common.events.ParticleEvent")]

	/**
	 * Dispatched when an emitter attempts to update the particles' state but it 
	 * contains no particles. This event will be dispatched every time the update 
	 * occurs and there are no particles in the emitter. The update does not occur
	 * when the emitter has not yet been started, when the emitter is paused, and
	 * after the emitter has been stopped, so the event will not be dispatched 
	 * at these times.
	 * 
	 * <p>See the firework example for an example that uses this event.</p>
	 * 
	 * @see start();
	 * @see pause();
	 * @see stop();
	 * 
	 * @eventType org.flintparticles.common.events.EmitterEvent.EMITTER_EMPTY
	 */
	[Event(name="emitterEmpty", type="org.flintparticles.common.events.EmitterEvent")]

	/**
	 * Dispatched when the particle system has updated and the state of the particles
	 * has changed.
	 * 
	 * @eventType org.flintparticles.common.events.EmitterEvent.EMITTER_UPDATED
	 */
	[Event(name="emitterUpdated", type="org.flintparticles.common.events.EmitterEvent")]

	/**
	 * Dispatched when the counter for the particle system has finished its cycle and so
	 * the system will not emit any more particles unless the counter is changed or restarted.
	 * 
	 * @eventType org.flintparticles.common.events.EmitterEvent.COUNTER_COMPLETE
	 */
	[Event(name="counterComplete", type="org.flintparticles.common.events.EmitterEvent")]

	/**
	 * The Emitter class is the base class for the Emitter2D and Emitter3D classes.
	 * The emitter class contains the common behavioour used by these two concrete
	 * classes.
	 * 
	 * <p>An Emitter manages the creation and ongoing state of particles. It uses 
	 * a number of utility classes to customise its behaviour.</p>
	 * 
	 * <p>An emitter uses Initializers to customise the initial state of particles
	 * that it creates; their position, velocity, color etc. These are added to the 
	 * emitter using the addInitializer method.</p>
	 * 
	 * <p>An emitter uses Actions to customise the behaviour of particles that
	 * it creates; to apply gravity, drag, fade etc. These are added to the emitter 
	 * using the addAction method.</p>
	 * 
	 * <p>An emitter uses Activities to customise its own behaviour in an ongoing
	 * manner, to move it or rotate it for example.</p>
	 * 
	 * <p>An emitter uses a Counter to know when and how many particles to emit.</p>
	 * 
	 * <p>All timings in the emitter are based on actual time passed, 
	 * independent of the frame rate of the flash movie.</p>
	 * 
	 * <p>Most functionality is best added to an emitter using Actions,
	 * Initializers, Activities and Counters. This offers greater 
	 * flexibility to combine behaviours without needing to subclass 
	 * the Emitter classes.</p>
	 */

	public class Emitter extends EventDispatcher
	{
		/**
		 * @private
		 */
		protected var _particleFactory:ParticleFactory;
		
		/**
		 * @private
		 */
		protected var _initializers:Array;
		/**
		 * @private
		 */
		protected var _actions:Array;
		/**
		 * @private
		 */
		protected var _activities:Array;
		/**
		 * @private
		 */
		protected var _particles:Array;
		/**
		 * @private
		 */
		protected var _counter:Counter;

		/**
		 * @private
		 */
		protected var _useInternalTick:Boolean = true;
		/**
		 * @private
		 */
		protected var _fixedFrameTime:Number = 0;
		/**
		 * @private
		 */
		protected var _running:Boolean = false;
		/**
		 * @private
		 */
		protected var _started:Boolean = false;
		/**
		 * @private
		 */
		protected var _maximumFrameTime:Number = 0.1;
		/**
		 * Indicates if the emitter should dispatch a counterComplete event at the
		 * end of the next update cycle.
		 */
		protected var _dispatchCounterComplete:Boolean = false;

		/**
		 * The constructor creates an emitter.
		 * 
		 * @param useInternalTick Indicates whether the emitter should use its
		 * own tick event to update its state. The internal tick process is tied
		 * to the framerate and updates the particle system every frame.
		 */
		public function Emitter()
		{
			_particles = new Array();
			_actions = new Array();
			_initializers = new Array();
			_activities = new Array();
			_counter = new ZeroCounter();
		}

		/**
		 * The maximum duration for a single update frame, in seconds.
		 * 
		 * <p>Under some circumstances related to the Flash player (e.g. on MacOSX, when the 
		 * user right-clicks on the flash movie) the flash movie will freeze for a period. When the
		 * freeze ends, the current frame of the particle system will be calculated as the time since 
		 * the previous frame,  which encompases the duration of the freeze. This could cause the 
		 * system to generate a single frame update that compensates for a long period of time and 
		 * hence moves the particles an unexpected long distance in one go. The result is usually
		 * visually unacceptable and certainly unexpected.</p>
		 * 
		 * <p>This property sets a maximum duration for a frame such that any frames longer than 
		 * this duration are ignored. The default value is 0.5 seconds. Developers don't usually
		 * need to change this from the default value.</p>
		 */
		public function get maximumFrameTime() : Number
		{
			return _maximumFrameTime;
		}
		public function set maximumFrameTime( value : Number ) : void
		{
			_maximumFrameTime = value;
		}
		
		/**
		 * The array of all initializers being used by this emitter.
		 */
		public function get initializers():Array
		{
			return _initializers;
		}
		public function set initializers( value:Array ):void
		{
			var initializer:Initializer;
			for each( initializer in _initializers )
			{
				initializer.removedFromEmitter( this );
			}
			_initializers = value.slice();
			BehaviourArrayUtils.sortArray( _initializers );
			for each( initializer in value )
			{
				initializer.addedToEmitter( this );
			}
		}

		/**
		 * Adds an Initializer object to the Emitter. Initializers set the
		 * initial state of particles created by the emitter.
		 * 
		 * @param initializer The Initializer to add
		 * 
		 * @see removeInitializer()
		 * @see org.flintParticles.common.initializers.Initializer.getDefaultPriority()
		 */
		public function addInitializer( initializer:Initializer ):void
		{
			BehaviourArrayUtils.add( _initializers, initializer );
			initializer.addedToEmitter( this );
		}
		
		/**
		 * Removes an Initializer from the Emitter.
		 * 
		 * @param initializer The Initializer to remove
		 * 
		 * @see addInitializer()
		 */
		public function removeInitializer( initializer:Initializer ):void
		{
			if( BehaviourArrayUtils.remove( _initializers, initializer ) )
			{
				initializer.removedFromEmitter( this );
			}
		}
		
		/**
		 * Detects if the emitter is using a particular initializer or not.
		 * 
		 * @param initializer The initializer to look for.
		 * 
		 * @return true if the initializer is being used by the emitter, false 
		 * otherwise.
		 */
		public function hasInitializer( initializer:Initializer ):Boolean
		{
			return BehaviourArrayUtils.contains( _initializers, initializer );
		}
		
		/**
		 * Detects if the emitter is using an initializer of a particular class.
		 * 
		 * @param initializerClass The type of initializer to look for.
		 * 
		 * @return true if the emitter is using an instance of the class as an
		 * initializer, false otherwise.
		 */
		public function hasInitializerOfType( initializerClass:Class ):Boolean
		{
			return BehaviourArrayUtils.containsType( _initializers, initializerClass );
		}

		/**
		 * The array of all actions being used by this emitter.
		 */
		public function get actions():Array
		{
			return _actions;
		}
		public function set actions( value:Array ):void
		{
			var action:Action;
			for each( action in _actions )
			{
				action.removedFromEmitter( this );
			}
			_actions = value.slice();
			BehaviourArrayUtils.sortArray( _actions );
			for each( action in value )
			{
				action.addedToEmitter( this );
			}
		}

		/**
		 * Adds an Action to the Emitter. Actions set the behaviour of particles 
		 * created by the emitter.
		 * 
		 * @param action The Action to add
		 * 
		 * @see removeAction();
		 * @see org.flintParticles.common.actions.Action.getDefaultPriority()
		 */
		public function addAction( action:Action ):void
		{
			BehaviourArrayUtils.add( _actions, action );
			action.addedToEmitter( this );
		}
		
		/**
		 * Removes an Action from the Emitter.
		 * 
		 * @param action The Action to remove
		 * 
		 * @see addAction()
		 */
		public function removeAction( action:Action ):void
		{
			if( BehaviourArrayUtils.remove( _actions, action ) )
			{
				action.removedFromEmitter( this );
			}
		}
		
		/**
		 * Detects if the emitter is using a particular action or not.
		 * 
		 * @param action The action to look for.
		 * 
		 * @return true if the action is being used by the emitter, false 
		 * otherwise.
		 */
		public function hasAction( action:Action ):Boolean
		{
			return BehaviourArrayUtils.contains( _actions, action );
		}
		
		/**
		 * Detects if the emitter is using an action of a particular class.
		 * 
		 * @param actionClass The type of action to look for.
		 * 
		 * @return true if the emitter is using an instance of the class as an
		 * action, false otherwise.
		 */
		public function hasActionOfType( actionClass:Class ):Boolean
		{
			return BehaviourArrayUtils.containsType( _actions, actionClass );
		}

		/**
		 * The array of all actions being used by this emitter.
		 */
		public function get activities():Array
		{
			return _activities;
		}
		public function set activities( value:Array ):void
		{
			var activity:Activity;
			for each( activity in _activities )
			{
				activity.removedFromEmitter( this );
			}
			_activities = value.slice();
			BehaviourArrayUtils.sortArray( _activities );
			for each( activity in _activities )
			{
				activity.addedToEmitter( this );
			}
		}

		/**
		 * Adds an Activity to the Emitter. Activities set the behaviour
		 * of the Emitter.
		 * 
		 * @param activity The activity to add
		 * 
		 * @see removeActivity()
		 * @see org.flintParticles.common.activities.Activity.getDefaultPriority()
		 */
		public function addActivity( activity:Activity ):void
		{
			BehaviourArrayUtils.add( _activities, activity );
			activity.addedToEmitter( this );
		}
		
		/**
		 * Removes an Activity from the Emitter.
		 * 
		 * @param activity The Activity to remove
		 * 
		 * @see addActivity()
		 */
		public function removeActivity( activity:Activity ):void
		{
			if( BehaviourArrayUtils.remove( _activities, activity ) )
			{
				activity.removedFromEmitter( this );
			}
		}
		
		/**
		 * Detects if the emitter is using a particular activity or not.
		 * 
		 * @param activity The activity to look for.
		 * 
		 * @return true if the activity is being used by the emitter, false 
		 * otherwise.
		 */
		public function hasActivity( activity:Activity ):Boolean
		{
			return BehaviourArrayUtils.contains( _activities, activity );
		}
		
		/**
		 * Detects if the emitter is using an activity of a particular class.
		 * 
		 * @param activityClass The type of activity to look for.
		 * 
		 * @return true if the emitter is using an instance of the class as an
		 * activity, false otherwise.
		 */
		public function hasActivityOfType( activityClass:Class ):Boolean
		{
			return BehaviourArrayUtils.containsType( _activities, activityClass );
		}

		/**
		 * The Counter for the Emitter. The counter defines when and
		 * with what frequency the emitter emits particles.
		 */		
		public function get counter():Counter
		{
			return _counter;
		}
		public function set counter( value:Counter ):void
		{
			_counter = value;
			if( running )
			{
				_counter.startEmitter( this );
			}
		}
		
		/**
		 * Used by counters to tell the emitter to dispatch a counter complete event.
		 */
		public function dispatchCounterComplete():void
		{
			_dispatchCounterComplete = true;
		}
		
		/**
		 * Indicates whether the emitter should manage its own internal update
		 * tick. The internal update tick is tied to the frame rate and updates
		 * the particle system every frame.
		 * 
		 * <p>If users choose not to use the internal tick, they have to call
		 * the emitter's update method with the appropriate time parameter every
		 * time they want the emitter to update the particle system.</p>
		 */		
		public function get useInternalTick():Boolean
		{
			return _useInternalTick;
		}
		public function set useInternalTick( value:Boolean ):void
		{
			if( _useInternalTick != value )
			{
				_useInternalTick = value;
				if( _started )
				{
					if( _useInternalTick )
					{
						FrameUpdater.instance.addEventListener( UpdateEvent.UPDATE, updateEventListener, false, 0, true );
					}
					else
					{
						FrameUpdater.instance.removeEventListener( UpdateEvent.UPDATE, updateEventListener );
					}
				}
			}
		}
		
		/**
		 * Indicates a fixed time (in seconds) to use for every frame. Setting 
		 * this property causes the emitter to bypass its frame timing 
		 * functionality and use the given time for every frame. This enables
		 * the particle system to be frame based rather than time based.
		 * 
		 * <p>To return to time based animation, set this value to zero (the 
		 * default).</p>
		 * 
		 * <p>This feature only works if useInternalTick is true (the default).</p>
		 * 
		 * @see #useInternalTick
		 */		
		public function get fixedFrameTime():Number
		{
			return _fixedFrameTime;
		}
		public function set fixedFrameTime( value:Number ):void
		{
			_fixedFrameTime = value;
		}
		
		/**
		 * Indicates if the emitter is currently running.
		 */
		public function get running():Boolean
		{
			return _running;
		}
		
		/**
		 * This is the particle factory used by the emitter to create and dispose 
		 * of particles. The 2D and 3D libraries each have a default particle
		 * factory that is used by the Emitter2D and Emitter3D classes. Any custom 
		 * particle factory should implement the ParticleFactory interface.
		 * @see org.flintparticles.common.particles.ParticleFactory
		 */		
		public function get particleFactory():ParticleFactory
		{
			return _particleFactory;
		}
		public function set particleFactory( value:ParticleFactory ):void
		{
			_particleFactory = value;
		}
		
		/**
		 * The array of all particles created by this emitter.
		 */
		public function get particles():Array
		{
			return _particles;
		}
		public function set particles( value:Array ):void
		{
			killAllParticles();
			addExistingParticles( value, false );
		}

		/*
		 * Used internally to create a particle.
		 */
		protected function createParticle():Particle
		{
			var particle:Particle = _particleFactory.createParticle();
			var len:int = _initializers.length;
			initParticle( particle );
			for ( var i:int = 0; i < len; ++i )
			{
				Initializer( _initializers[i] ).initialize( this, particle );
			}
			_particles.push( particle );
			dispatchEvent( new ParticleEvent( ParticleEvent.PARTICLE_CREATED, particle ) );
			return particle;
		}
		
		/**
		 * Emitters do their own particle initialization here - usually involves 
		 * positioning and rotating the particle to match the position and rotation 
		 * of the emitter. This method is called before any initializers that are
		 * assigned to the emitter, so initializers can override any properties set 
		 * here.
		 * 
		 * <p>The implementation of this method in this base class does nothing.</p>
		 */
		protected function initParticle( particle:Particle ):void
		{
		}
		
		/**
		 * Adds existing particles to the emitter. This enables users to create 
		 * particles externally to the emitter and then pass the particles to the
		 * emitter for management.
		 * 
		 * @param particles An array of particles
		 * @param applyInitializers Indicates whether to apply the emitter's
		 * initializer behaviours to the particle (true) or not (false).
		 */
		public function addExistingParticles( particles:Array, applyInitializers:Boolean = false ):void
		{
			var len:int = particles.length;
			var i:int;
			if( applyInitializers )
			{
				var len2:int = _initializers.length;
				for ( var j:int = 0; j < len2; ++j )
				{
					for ( i = 0; i < len; ++i )
					{
						Initializer( _initializers[j] ).initialize( this, particles[i] );
					}
				}
			}
			for( i = 0; i < len; ++i )
			{
				_particles.push( particles[i] );
				dispatchEvent( new ParticleEvent( ParticleEvent.PARTICLE_ADDED, particles[i] ) );
			}
		}

		public function killAllParticles():void
		{
			var len:int = _particles.length;
			for ( var i:int = 0; i < len; ++i )
			{
				dispatchEvent( new ParticleEvent( ParticleEvent.PARTICLE_DEAD, _particles[i] ) );
				_particleFactory.disposeParticle( _particles[i] );
			}
			_particles.length = 0;
		}
		
		/**
		 * Starts the emitter. Until start is called, the emitter will not emit or 
		 * update any particles.
		 */
		public function start():void
		{
			if( _useInternalTick )
			{
				FrameUpdater.instance.addEventListener( UpdateEvent.UPDATE, updateEventListener, false, 0, true );
			}
			_started = true;
			_running = true;
			var len:int = _activities.length;
			for ( var i:int = 0; i < len; ++i )
			{
				Activity( _activities[i] ).initialize( this );
			}
			len = _counter.startEmitter( this );
			for ( i = 0; i < len; ++i )
			{
				createParticle();
			}
		}
		
		/**
		 * Update event listener used to fire the update function when using teh internal tick.
		 */
		private function updateEventListener( ev:UpdateEvent ):void
		{
			if( _fixedFrameTime )
			{
				update( _fixedFrameTime );
			}
			else
			{
				update( ev.time );
			}
		}
		
		/**
		 * Used to update the emitter. If using the internal tick, this method
		 * will be called every frame without any action by the user. If not
		 * using the internal tick, the user should call this method on a regular
		 * basis to update the particle system.
		 * 
		 * <p>The method asks the counter how many particles to create then creates 
		 * those particles. Then it calls sortParticles, applies the activities to 
		 * the emitter, applies the Actions to all the particles, removes all dead 
		 * particles, and finally dispatches an emitterUpdated event which tells 
		 * any renderers to redraw the particles.
		 * 
		 * @param time The duration, in seconds, to be applied in the update step.
		 * 
		 * @see sortParticles();
		 */
		public function update( time:Number ):void
		{
			if( !_running )
			{
				return;
			}
			if( time > _maximumFrameTime )
			{
				time = _maximumFrameTime;
			}
			var i:int;
			var particle:Particle;
			var len:int = _counter.updateEmitter( this, time );
			for( i = 0; i < len; ++i )
			{
				createParticle();
			}
			sortParticles();
			len = _activities.length;
			for ( i = 0; i < len; ++i )
			{
				Activity( _activities[i] ).update( this, time );
			}
			if ( _particles.length > 0 )
			{
				
				// update particle state
				len = _actions.length;
				var action:Action;
				var len2:int = _particles.length;
				
				for( var j:int = 0; j < len; ++j )
				{
					action = _actions[j];
					for ( i = 0; i < len2; ++i )
					{
						particle = _particles[i];
						action.update( this, particle, time );
					}
				}
				// remove dead particles
				for ( i = len2; i--; )
				{
					particle = _particles[i];
					if ( particle.isDead )
					{
						_particles.splice( i, 1 );
						dispatchEvent( new ParticleEvent( ParticleEvent.PARTICLE_DEAD, particle ) );
						if( particle.isDead )
						{
							_particleFactory.disposeParticle( particle );
						}
					}
				}
			}
			else 
			{
				dispatchEvent( new EmitterEvent( EmitterEvent.EMITTER_EMPTY ) );
			}
			dispatchEvent( new EmitterEvent( EmitterEvent.EMITTER_UPDATED ) );
			if( _dispatchCounterComplete )
			{
				_dispatchCounterComplete = false;
				dispatchEvent( new EmitterEvent( EmitterEvent.COUNTER_COMPLETE ) );
			}
		}
		
		/**
		 * Used to sort the particles as required. In this base class this method 
		 * does nothing.
		 */
		protected function sortParticles():void
		{
		}
		
		/**
		 * Pauses the emitter.
		 */
		public function pause():void
		{
			_running = false;
		}
		
		/**
		 * Resumes the emitter after a pause.
		 */
		public function resume():void
		{
			_running = true;
		}
		
		/**
		 * Stops the emitter, killing all current particles and returning them to the 
		 * particle factory for reuse.
		 */
		public function stop():void
		{
			if( _useInternalTick )
			{
				FrameUpdater.instance.removeEventListener( UpdateEvent.UPDATE, updateEventListener );
			}
			_started = false;
			_running = false;
			killAllParticles();
		}
		
		/**
		 * Makes the emitter skip forwards a period of time with a single update.
		 * Used when you want the emitter to look like it's been running for a while.
		 * 
		 * @param time The time, in seconds, to skip ahead.
		 * @param frameRate The frame rate for calculating the new positions. The
		 * emitter will calculate each frame over the time period to get the new state
		 * for the emitter and its particles. A higher frameRate will be more
		 * accurate but will take longer to calculate.
		 */
		public function runAhead( time:Number, frameRate:Number= 10 ):void
		{
			var maxTime:Number = _maximumFrameTime;
			var step:Number = 1 / frameRate;
			_maximumFrameTime = step;
			while ( time > 0 )
			{
				time -= step;
				update( step );
			}
			_maximumFrameTime = maxTime;
		}
	}
}