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

package org.flintparticles.threeD.papervision3d 
{
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.renderers.RendererBase;
	import org.flintparticles.threeD.particles.Particle3D;
	import org.papervision3d.core.geom.Particles;
	import org.papervision3d.core.geom.renderables.Particle;	

	/**
	 * Renders the particles in a Papervision3D Particles object.
	 * 
	 * <p>To use this renderer, the particles' image properties should be 
	 * Papervision3D particles, renderable in a Papervision3D Particles object.
	 * This renderer doesn't update the scene, but copies each particle's 
	 * properties to its image object so next time the Papervision3D scene is 
	 * rendered the image objects are drawn according to the state of the particle
	 * system.</p>
	 */
	public class PV3DParticleRenderer extends RendererBase
	{
		private var _container:Particles;
		
		/**
		 * The constructor creates an Papervision3D particle renderer for displaying the
		 * particles in a Papervision3D Particles object.
		 * 
		 * @param container A Papervision3D Particles object. The particle display
		 * objects are created inside this Particles object.
		 */
		public function PV3DParticleRenderer( container:Particles )
		{
			super();
			_container = container;
		}
		
		/**
		 * This method copies the particle's state to the associated image object.
		 * 
		 * <p>This method is called internally by Flint and shouldn't need to be called
		 * by the user.</p>
		 * 
		 * @param particles The particles to be rendered.
		 */
		override protected function renderParticles( particles:Array ):void
		{
			for each( var p:Particle3D in particles )
			{
				renderParticle( p );
			}
		}
		
		/**
		 * This method is called when a particle is added to an emitter -
		 * usually because the emitter has just created the particle. The
		 * method adds the particle's image to the container's display list.
		 * It is called internally by Flint and need not be called by the user.
		 * 
		 * @param particle The particle being added to the emitter.
		 */
		override protected function addParticle( particle:org.flintparticles.common.particles.Particle ):void
		{
			_container.addParticle( org.papervision3d.core.geom.renderables.Particle( particle.image ) );
			renderParticle( particle as Particle3D );
		}
		
		protected function renderParticle( particle:Particle3D ):void
		{
			var o:org.papervision3d.core.geom.renderables.Particle = particle.image;
			o.x = particle.position.x;
			o.y = particle.position.y;
			o.z = particle.position.z;
			if( particle.dictionary["pv3dBaseSize"] )
			{
				o.size = particle.scale * particle.dictionary["pv3dBaseSize"];
			}
			else
			{
				o.size = particle.scale;
			}
			// TODO: rotation
			
			if( o.material )
			{
				// this only works for some materials
				o.material.fillColor = particle.color & 0xFFFFFF;
				o.material.fillAlpha = particle.alpha;
			}
		}
		
		/**
		 * This method is called when a particle is removed from an emitter -
		 * usually because the particle is dying. The method removes the 
		 * particle's image from the container's display list. It is called 
		 * internally by Flint and need not be called by the user.
		 * 
		 * @param particle The particle being removed from the emitter.
		 */
		override protected function removeParticle( particle:org.flintparticles.common.particles.Particle ):void
		{
			_container.removeParticle( org.papervision3d.core.geom.renderables.Particle( particle.image ) );
		}
	}
}
