/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2011
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

package org.flintparticles.common.initializers
{
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.common.particles.Particle;

	/**
	 * The ImageInitializerBase is the base class for image initializers.
	 * It adds the option to pool the images for reuse after a particle dies 
	 * and to fill the pool with a set of images in advance.
	 */
	public class ImageInitializerBase extends InitializerBase
	{
		protected var _usePool:Boolean;
		protected var _pool:Array;
		protected var _emitters:Array;
		
		/**
		 * The constructor is usually called by the constructor of the class that extends this.
		 * 
		 * @param usePool Whether the images should be pooled for reuse when a particle dies
		 * @param fillPool How many images to create immediately for reuse as particles need them
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function ImageInitializerBase( usePool:Boolean = false, fillPool:uint = 0 )
		{
			_usePool = usePool;
			_emitters = new Array();
			if( _usePool )
			{
				clearPool();
				if( fillPool )
				{
					this.fillPool( fillPool );
				}
			}
		}
		
		/**
		 * Clears the image pool, forcing all particles to be created anew.
		 */
		public function clearPool():void
		{
			_pool = new Array();
		}
		
		/**
		 * When added to an emitter, the initializer will start listening for dead particles
		 * so their images may be pooled. The initializer will only pool images that it created.
		 */
		override public function addedToEmitter( emitter:Emitter ) : void
		{
			_emitters.push( emitter );
			if( _usePool )
			{
				emitter.addEventListener( ParticleEvent.PARTICLE_DEAD, particleDying, false, -1000, true );
			}
		}
		
		private function particleDying( event : ParticleEvent ) : void
		{
			if( event.particle.isDead && event.particle.dictionary[this] )
			{
				_pool.push( event.particle.image );
				delete event.particle.dictionary[this];
			}
		}
		
		/**
		 * When removed from an emitter, the initializer will stop listening for dead particles from that emitter.
		 */
		override public function removedFromEmitter( emitter:Emitter ) : void
		{
			emitter.removeEventListener( ParticleEvent.PARTICLE_DEAD, particleDying );
			var index:int = _emitters.indexOf( emitter );
			if( index != -1 )
			{
				_emitters.splice( index, 1 );
			}
		}
		
		/**
		 * Fills the pool with a given number of particles.
		 * 
		 * @param count The number of particles to create.
		 */
		public function fillPool( count:uint ) : void
		{
			if( !_usePool )
			{
				return;
			}
			if( _pool.length > 0 )
			{
				_pool = new Array( count );
			}
			for( var i:int = 0; i < count; ++i )
			{
				_pool[i] = createImage();
			}
		}
		
		/**
		 * Whether the images should be pooled for reuse when a particle dies
		 */
		public function get usePool():Boolean
		{
			return _usePool;
		}
		public function set usePool( value:Boolean ) : void
		{
			if( _usePool != value )
			{
				_usePool = value;
				var emitter:Emitter;
				if( _usePool )
				{
					for each( emitter in _emitters )
					{
						emitter.addEventListener( ParticleEvent.PARTICLE_DEAD, particleDying, false, -1000, true );
					}
				}
				else
				{
					for each( emitter in _emitters )
					{
						emitter.removeEventListener( ParticleEvent.PARTICLE_DEAD, particleDying );
					}
				}
			}
		}
		
		/**
		 * The method to create an image for a particle. This should be overridden in the class that extends this one.
		 */
		public function createImage() : Object
		{
			throw new Error( "Image initializer must override the createImage method." );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			if( _usePool )
			{
				if( _pool.length > 0 )
				{
					particle.image = _pool.shift();
				}
				else
				{
					particle.image = createImage();
				}
				particle.dictionary[this] = true;
			}
			else
			{
				particle.image = createImage();
			}
		}
	}
}
