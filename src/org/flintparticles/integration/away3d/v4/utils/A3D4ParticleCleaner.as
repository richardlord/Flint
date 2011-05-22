/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord & Michael Ivanov
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

package org.flintparticles.integration.away3d.v4.utils
{
	import away3d.core.base.Object3D;
	import away3d.entities.Sprite3D;
	import away3d.materials.MaterialBase;

	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.events.ParticleEvent;
	
	/**
	 * Away3D 4 objects and materials should be disposed of, by calling their dispose method, 
	 * when they are no longer required. This class will call the dispose method on the 
	 * image object of particles when they die. To use it, create an instance of the class
	 * and add any Emitters to it that use Away3D 4 objects. All particles on that emitter
	 * will be cleaned up when they die.
	 */
	public class A3D4ParticleCleaner
	{
		/**
		 * The method that does the cleaning.
		 * 
		 * @param event The particleDead event containing a reference to the particleto clean up.
		 */
		protected function cleanParticle( event:ParticleEvent ):void
		{
			if( event.particle.isDead && event.particle.image && event.particle.image is Object3D )
			{
				//dispose often throws errors. I'm sure the A3D team will sort it out before release
				try
				{
					var obj:Object3D = Object3D( event.particle.image );
					// A deep disposal on the object3d should dispose of the material.
					// But Sprite3D doesn't do this, so we test for it here and manually dispose of the material
					if( obj is Sprite3D && Sprite3D(obj).material is MaterialBase )
					{
						var material:MaterialBase = MaterialBase( Sprite3D(obj).material );
						material.dispose( true );
					}
					obj.dispose( true );
				}
				catch(e:Error)
				{
					// do nothing
				}
			}
		}
		
		/**
		 * Add an emitter to have it's particles' Away3D objects disposed when the particles die.
		 * 
		 * @param emitter The emitter
		 */
		public function addEmitter( emitter:Emitter ):void
		{
			emitter.addEventListener( ParticleEvent.PARTICLE_DEAD, cleanParticle, false, -10, true );
		}
		
		/**
		 * Remove an emitter to stop disposing it's particles' Away3D objects when the particles die.
		 * 
		 * @param emitter The emitter
		 */
		public function removeEmitter( emitter:Emitter ):void
		{
			emitter.removeEventListener( ParticleEvent.PARTICLE_DEAD, cleanParticle );
		}
	}
}
