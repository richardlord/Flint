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

package org.flintparticles.integration.away3d.v4
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.core.math.Vector3DUtils;

	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.renderers.RendererBase;
	import org.flintparticles.common.utils.Maths;
	import org.flintparticles.integration.away3d.v4.utils.Convert;
	import org.flintparticles.threeD.particles.Particle3D;

	import flash.geom.Vector3D;

	/**
	 * Renders the particles in an Away3D4 scene.
	 * 
	 * <p>To use this renderer, the particles' image properties should be 
	 * Away3D v4(Molehill API based) objects, renderable in an Away3D scene. This renderer
	 * doesn't update the scene, but copies each particle's properties
	 * to its image object so next time the Away3D scene is rendered the 
	 * image objects are drawn according to the state of the particle
	 * system.</p>
	 */
	public class A3D4Renderer extends RendererBase
	{
		private var _container:ObjectContainer3D;
		
		/**
		 * The constructor creates an Away3D renderer for displaying the
		 * particles in an Away3D scene.
		 * 
		 * @param container An Away3D object container. The particle display
		 * objects are created inside this object container.
		 */
		///Added by Michael--second param defines recycling mode
		private var _recycleParticles:Boolean=false;
		public function A3D4Renderer( container:ObjectContainer3D ,recycleParticles:Boolean=false)
		{
			super();
			_container = container;
			_recycleParticles=recycleParticles;
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
			// N.B. Sprite3D is a subclass of Object3D so we don't need to treat it as a special case
			if( particle.image is Object3D )
			{
				var obj:Object3D = particle.image as Object3D;
				
				obj.x = particle.position.x;
				obj.y = particle.position.y;
				obj.z = particle.position.z;
				obj.scaleX = obj.scaleY = obj.scaleZ = particle.scale;
				
				var rotation:flash.geom.Vector3D = away3d.core.math.Vector3DUtils.quaternion2euler( Convert.QuaternionToA3D( particle.rotation ) );
				obj.rotationX = Maths.asDegrees( rotation.x );
				obj.rotationY = Maths.asDegrees( rotation.y );
				obj.rotationZ = Maths.asDegrees( rotation.z );
				
				if( obj.hasOwnProperty("material") )
				{
					var material:Object = obj["material"];
					if( material.hasOwnProperty( "colorTransform" ) )
					{
						material["colorTransform"] = particle.colorTransform;
					}
					else
					{
						if( material.hasOwnProperty( "color" ) )
						{
							material["color"] = particle.color & 0xFFFFFF;
						}
						if( material.hasOwnProperty( "alpha" ) )
						{
							material["alpha"] = particle.alpha;
						}
					}
				}
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
			
			if( particle.image is ObjectContainer3D )
			{
				_container.addChild( ObjectContainer3D( particle.image ) );
				renderParticle( Particle3D( particle ) );
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
			// We can't clean up the 3d object here because the particle may not be dead.
			// We need to handle disposal elsewhere
			if( particle.image is ObjectContainer3D )
			{
				_container.removeChild( ObjectContainer3D( particle.image ) );
			}
		}
	}
}
