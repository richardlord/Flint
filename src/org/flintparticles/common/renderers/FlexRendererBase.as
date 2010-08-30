/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2010
 * http://flintparticles.org/
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

package org.flintparticles.common.renderers 
{
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.renderers.Renderer;
	
	import mx.core.UIComponent;
	
	import flash.events.Event;	

	/**
	 * The base class used by all the Flex compatible renderers. This class manages
	 * various aspects of the rendering process.
	 * 
	 * <p>The class will add every emitter it should renderer to it's internal
	 * collection of emitters. It will listen for the appropriate events on the 
	 * emitter and will then call the protected methods addParticle, removeParticle
	 * and renderParticles at the appropriate times. Many derived classes need 
	 * only implement these three methods to manage the rendering of the particles.</p>
	 */
	public class FlexRendererBase extends UIComponent implements Renderer 
	{
		/**
		 * @private
		 * 
		 * We retain assigned emitters in this array merely so the reference exists and they are not
		 * garbage collected. This ensures the expected behaviour is achieved - an emitter that exists
		 * on a renderer is not garbage collected, an emitter that does not exist on a renderer may be 
		 * garbage collected if no other references exist.
		 */
		protected var _emitters:Array;
		
		/**
		 * The constructor creates a FlexRendererBase class.
		 */
		public function FlexRendererBase()
		{
			super();
			_emitters = new Array();
			mouseEnabled = false;
			mouseChildren = false;
			addEventListener( Event.ADDED_TO_STAGE, addedToStage, false, 0, true );
		}
		
		/**
		 * Adds the emitter to the renderer. When an emitter is added, the renderer
		 * invalidates its display so the renderParticles method will be called
		 * on the next render event in the frame update.
		 * 
		 * @param emitter The emitter that is added to the renderer.
		 */
		public function addEmitter( emitter : Emitter ) : void
		{
			_emitters.push( emitter );
			if( stage )
			{
				stage.invalidate();
			}
			emitter.addEventListener( EmitterEvent.EMITTER_UPDATED, emitterUpdated, false, 0, true );
			emitter.addEventListener( ParticleEvent.PARTICLE_CREATED, particleAdded, false, 0, true );
			emitter.addEventListener( ParticleEvent.PARTICLE_ADDED, particleAdded, false, 0, true );
			emitter.addEventListener( ParticleEvent.PARTICLE_DEAD, particleRemoved, false, 0, true );
			for each( var p:Particle in emitter.particles )
			{
				addParticle( p );
			}
			if( _emitters.length == 1 )
			{
				addEventListener( Event.RENDER, updateParticles, false, 0, true );
			}
		}

		/**
		 * Removes the emitter from the renderer. When an emitter is removed, the renderer
		 * invalidates its display so the renderParticles method will be called
		 * on the next render event in the frame update.
		 * 
		 * @param emitter The emitter that is removed from the renderer.
		 */
		public function removeEmitter( emitter : Emitter ) : void
		{
			for( var i:int = 0; i < _emitters.length; ++i )
			{
				if( _emitters[i] == emitter )
				{
					_emitters.splice( i, 1 );
					emitter.removeEventListener( EmitterEvent.EMITTER_UPDATED, emitterUpdated );
					emitter.removeEventListener( ParticleEvent.PARTICLE_CREATED, particleAdded );
					emitter.removeEventListener( ParticleEvent.PARTICLE_ADDED, particleAdded );
					emitter.removeEventListener( ParticleEvent.PARTICLE_DEAD, particleRemoved );
					for each( var p:Particle in emitter.particles )
					{
						removeParticle( p );
					}
					if( _emitters.length == 0 )
					{
						removeEventListener( Event.RENDER, updateParticles );
						renderParticles( [] );
					}
					else if( stage )
					{
						stage.invalidate();
					}
					return;
				}
			}
		}
		
		private function addedToStage( ev:Event ):void
		{
			if( stage )
			{
				stage.invalidate();
			}
		}
		
		private function particleAdded( ev:ParticleEvent ):void
		{
			addParticle( ev.particle );
			if( stage )
			{
				stage.invalidate();
			}
		}
		
		private function particleRemoved( ev:ParticleEvent ):void
		{
			removeParticle( ev.particle );
			if( stage )
			{
				stage.invalidate();
			}
		}

		protected function emitterUpdated( ev:EmitterEvent ):void
		{
			if( stage )
			{
				stage.invalidate();
			}
		}
		
		protected function updateParticles( ev:Event ) : void
		{
			var particles:Array = new Array();
			for( var i:int = 0; i < _emitters.length; ++i )
			{
				particles = particles.concat( Emitter( _emitters[i] ).particles );
			}
			renderParticles( particles );
		}
		
		
		
		/**
		 * The addParticle method is called when a particle is added to one of
		 * the emitters that is being rendered by this renderer.
		 * 
		 * @param particle The particle.
		 */
		protected function addParticle( particle:Particle ):void
		{
		}
		
		/**
		 * The removeParticle method is called when a particle is removed from one
		 * of the emitters that is being rendered by this renderer.
		 * 
		 * @param particle The particle.
		 */
		protected function removeParticle( particle:Particle ):void
		{
		}
		
		/**
		 * The renderParticles method is called during the render phase of 
		 * each frame if the state of one of the emitters being rendered
		 * by this renderer has changed.
		 * 
		 * @param particles The particles being managed by all the emitters
		 * being rendered by this renderer. The particles are in no particular
		 * order.
		 */
		protected function renderParticles( particles:Array ):void
		{
		}

		/**
		 * The array of all emitters being rendered by this renderer. This is exposed
		 * to enable setting of the emitters in mxml files. It is not intended to be used
		 * from Actionscript code.
		 */
		public function get emitters():Array
		{
			return _emitters;
		}
		public function set emitters( value:Array ):void
		{
			var e:Emitter;
			for each( e in _emitters )
			{
				removeEmitter( e );
			}
			for each( e in value )
			{
				addEmitter( e );
			}
		}
		
		/**
		 * private
		 */
		override protected function measure():void
		{
			super.measure();
	
			measuredWidth=200;
			measuredMinWidth=0;
			measuredHeight=200;
			measuredMinHeight=0;
		}
	}
}
