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

package org.flintparticles.threeD.away3d.away4 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.core.math.Vector3DUtils;
	import away3d.entities.Mesh;
	import away3d.entities.Sprite3D;
	
	import flash.geom.Vector3D;
	
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.renderers.RendererBase;
	import org.flintparticles.common.utils.Maths;
	import org.flintparticles.threeD.away3d.utils.Convert;
	import org.flintparticles.threeD.particles.Particle3D;


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
	public class Away3D4Renderer extends RendererBase
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
		public function Away3D4Renderer( container:ObjectContainer3D )
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
			var o:* = particle.image;
			
			if( o is Object3D ) {
				Object3D( o ).x = particle.position.x;
				Object3D( o ).y = particle.position.y;
				Object3D( o ).z = particle.position.z;
				Object3D( o ).scaleX = Object3D( o ).scaleY = Object3D( o ).scaleZ = particle.scale;
				
				var rotation:flash.geom.Vector3D = away3d.core.math.Vector3DUtils.quaternion2euler( Convert.QuaternionToA3D( particle.rotation ) );
				Object3D( o ).rotationX = Maths.asDegrees( rotation.x );
				Object3D( o ).rotationY = Maths.asDegrees( rotation.y );
				Object3D( o ).rotationZ = Maths.asDegrees( rotation.z );
			
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
				
			}
			
			// display object rendering
		
			if( o is Sprite3D )
			{
				Sprite3D( o ).x = particle.position.x;
				Sprite3D( o ).y = particle.position.y;
				Sprite3D( o ).z = particle.position.z;
				/////changed/////
				Sprite3D( o ).scaleX = particle.scale;
				Sprite3D( o ).scaleY = particle.scale;
				Sprite3D( o ).scaleZ = particle.scale;
				
			if( Sprite3D( o ).material["hasOwnProperty"]( "color" ) )
					{
						Sprite3D( o ).material["color"] = particle.color & 0xFFFFFF;
					}
					if( Sprite3D( o ).material["hasOwnProperty"]( "alpha" ) )
					{
						Sprite3D( o ).material["alpha"] = particle.alpha;
					}
				//	trace(Sprite3D( o ).material["color"]);
				
			}
		
			// others
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
			if( particle.image is Object3D )
			{
				
				_container.addChild( Object3D( particle.image )as ObjectContainer3D );
				renderParticle( Particle3D( particle ) );
			}
			else if( particle.image is Sprite3D )
			{
				_container.addChild( Sprite3D( particle.image ) );
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
			if( particle.image is Mesh )
			{
				_container.removeChild( Mesh( particle.image ) );
		
				
		
				
				for(var i:int=0;i<Mesh( particle.image ).geometry.subGeometries.length;++i){
				Mesh( particle.image ).geometry.subGeometries[i].dispose();
				}
				Mesh( particle.image ).material.dispose(false);
				Mesh( particle.image ).dispose(false);
			
			
			}
			else if( particle.image is Sprite3D )
			{
				_container.removeChild( Sprite3D( particle.image ) );
				Sprite3D( particle.image ).material.dispose(false);
				Sprite3D( particle.image ).dispose(true);
			
			}
			particle.image =null;
		}
	}
}
