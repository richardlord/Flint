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

package org.flintparticles.threeD.away3d 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Mesh;
	import away3d.core.base.Object3D;
	import away3d.core.math.Number3D;
	import away3d.sprites.MovieClipSprite;
	
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.renderers.RendererBase;
	import org.flintparticles.common.utils.Maths;
	import org.flintparticles.threeD.away3d.utils.Convert;
	import org.flintparticles.threeD.particles.Particle3D;	

	/**
	 * Renders the particles in an Away3D scene.
	 * 
	 * <p>To use this renderer, the particles' image properties should be 
	 * Away3D objects, renderable in an Away3D scene. This renderer
	 * doesn't update the scene, but copies each particle's properties
	 * to its image object so next time the Away3D scene is rendered the 
	 * image objects are drawn according to the state of the particle
	 * system.</p>
	 */
	public class Away3DRenderer extends RendererBase
	{
		private var _container:ObjectContainer3D;
		
		/**
		 * The constructor creates an Away3D renderer for displaying the
		 * particles in an Away3D scene.
		 * 
		 * @param container An Away3D object container. The particle display
		 * objects are created inside this object container. This is usually
		 * a scene object, but it may be any ObjectContainer3D.
		 */
		public function Away3DRenderer( container:ObjectContainer3D )
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

		protected function renderParticle( particle:Particle3D ):void
		{
			var o:Object3D = particle.image;
			o.x = particle.position.x;
			o.y = particle.position.y;
			o.z = particle.position.z;
			o.scaleX = o.scaleY = o.scaleZ = particle.scale;
			
			// rotation
			var r:Number3D = new Number3D();
			r.quaternion2euler( Convert.QuaternionToA3D( particle.rotation ) );
			o.rotationX = Maths.asDegrees( r.x );
			o.rotationY = Maths.asDegrees( r.y );
			o.rotationZ = Maths.asDegrees( r.z );
			
			// mesh rendering
			if( o is Mesh )
			{
				if( Mesh( o ).material["hasOwnProperty"]( "color" ) )
				{
					Mesh( o ).material["color"] = particle.color & 0xFFFFFF;
				}
				if( Mesh( o ).material["hasOwnProperty"]( "alpha" ) )
				{
					Mesh( o ).material["alpha"] = particle.alpha;
				}
			}
			
			// display object rendering
			else if( o is MovieClipSprite )
			{
				MovieClipSprite( o ).movieclip.transform.colorTransform = particle.colorTransform;
				MovieClipSprite( o ).scaling = particle.scale;
			}
			
			// others
			else
			{
				// can't do color transform
				// will try alpha - only works if objects have own canvas
				o.alpha = particle.alpha;
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
			_container.addChild( Object3D( particle.image ) );
			renderParticle( Particle3D( particle ) );
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
			_container.removeChild( Object3D( particle.image ) );
		}
	}
}
