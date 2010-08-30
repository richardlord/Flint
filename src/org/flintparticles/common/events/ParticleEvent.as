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

package org.flintparticles.common.events
{
	import org.flintparticles.common.particles.Particle;
	
	import flash.events.Event;	

	/**
	 * The class for particle related events dispatched by classes in the Flint project.
	 */
	public class ParticleEvent extends Event
	{
		/**
		 * The event dispatched by an emitter when a particle is created.
		 */
		public static var PARTICLE_CREATED:String = "particleCreated";
		
		/**
		 * The event dispatched by an emitter when a particle dies.
		 */
		public static var PARTICLE_DEAD:String = "particleDead";
		
		/**
		 * The event dispatched by an emitter when a pre-existing particle is added to it.
		 */
		public static var PARTICLE_ADDED:String = "particleAdded";

		/**
		 * The event dispatched by an emitter when a particle collides with another particle.
		 */
		public static var PARTICLES_COLLISION:String = "particlesCollision";
		
		/**
		 * The event dispatched by an emitter when a particle collides with a zone.
		 */
		public static var ZONE_COLLISION:String = "zoneCollision";
		
		/**
		 * The event dispatched by an emitter when a particle collides with another particle.
		 */
		public static var BOUNDING_BOX_COLLISION:String = "boundingBoxCollision";
		
		/**
		 * The particle to which the event relates.
		 */
		public var particle:Particle;
		
		/**
		 * The other object involved in the event. This may be null.
		 */
		public var otherObject:*;
		
		/**
		 * The constructor creates a ParticleEvent object.
		 * 
		 * @param type The type of the event, accessible as Event.type.
		 * @param particle The particle to which teh event relates.
		 * @param bubbles Determines whether the Event object participates 
		 * in the bubbling stage of the event flow. The default value is false.
		 * @param cancelable Determines whether the Event object can be 
		 * canceled. The default values is false.
		 */
		public function ParticleEvent( type : String, particle:Particle = null, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super(type, bubbles, cancelable);
			this.particle = particle;
		}

		/**
		 * Creates a copy of this event.
		 * 
		 * @return The copy of this event.
		 */
		override public function clone():Event
		{
			var e:ParticleEvent = new ParticleEvent( type, particle, bubbles, cancelable );
			e.otherObject = otherObject;
			return e;
		}
	}
}