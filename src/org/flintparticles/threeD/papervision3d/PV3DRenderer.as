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
	import org.flintparticles.common.utils.Maths;
	import org.flintparticles.threeD.papervision3d.utils.Convert;
	import org.flintparticles.threeD.particles.Particle3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.DisplayObjectContainer3D;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;	

	/**
	 * Renders the particles in a Papervision3D scene.
	 * 
	 * <p>To use this renderer, the particles' image properties should be 
	 * Papervision3D objects, renderable in a Papervision3D scene. This renderer
	 * doesn't update the scene, but copies each particle's properties
	 * to its image object so next time the Papervision3D scene is rendered the 
	 * image objects are drawn according to the state of the particle
	 * system.</p>
	 */
	public class PV3DRenderer extends RendererBase
	{
		private var _container:DisplayObjectContainer3D;
		
		/**
		 * The constructor creates an Papervision3D renderer for displaying the
		 * particles in a Papervision3D scene.
		 * 
		 * @param container A Papervision3D object container. The particle display
		 * objects are created inside this object container. This is usually
		 * a scene object, but it may be any DisplayObjectContainer3D.
		 */
		public function PV3DRenderer( container:DisplayObjectContainer3D )
		{
			super();
			_container = container;
		}
		
		/**
		 * This method copies the particle's state to the associated image object.
		 * 
		 * <p>This method is called internally by Flint and shouldn't need to be 
		 * called by the user.</p>
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
		override protected function addParticle( particle:Particle ):void
		{
			_container.addChild( DisplayObject3D( particle.image ) );
			renderParticle( particle as Particle3D );
		}
		
		protected function renderParticle( particle:Particle3D ):void
		{
			var o:DisplayObject3D = particle.image;
			o.x = particle.position.x;
			o.y = particle.position.y;
			o.z = particle.position.z;
			o.scaleX = o.scaleY = o.scaleZ = particle.scale;
			if( o is Plane && o.material is MovieMaterial )
			{
				MovieMaterial( o.material ).movie.transform.colorTransform = particle.colorTransform;
			}
			else
			{
				// this only works for some materials
				o.material.fillColor = particle.color & 0xFFFFFF;
				o.material.fillAlpha = particle.alpha;
				// rotation
				var r:Number3D = Convert.QuaternionToPV3D( particle.rotation ).toEuler();
				o.rotationX = Maths.asDegrees( r.x );
				o.rotationY = Maths.asDegrees( r.y );
				o.rotationZ = Maths.asDegrees( r.z );
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
		override protected function removeParticle( particle:Particle ):void
		{
			_container.removeChild( DisplayObject3D( particle.image ) );
		}
	}
}
