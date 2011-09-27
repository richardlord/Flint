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
 
package org.flintparticles.integration.alternativa3d
{
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.AnimSprite;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Sprite3D;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.TextureResource;

	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.renderers.RendererBase;
	import org.flintparticles.threeD.particles.Particle3D;

	import flash.display.BitmapData;
	import flash.geom.Vector3D;

	/**
	 * Renders the particles in an Alternativa3D scene.
	 * 
	 * <p>To use this renderer, the particles' image properties should be 
	 * Alternativa3D objects, renderable in an Alternativa3D scene. This renderer
	 * doesn't update the scene, but copies each particle's properties
	 * to its image object so next time the Alternativa3D scene is rendered the 
	 * image objects are drawn according to the state of the particle
	 * system.</p>
	 */
	public class Alt3DRenderer extends RendererBase
	{
		private var _container : Object3D;

		/**
		 * The constructor creates an Alternativa3D renderer for displaying the
		 * particles in an Alternativa3D scene.
		 * 
		 * @param container An Alternativa3D object container. The particle display
		 * objects are created inside this object container.
		 */
		public function Alt3DRenderer( container : Object3D )
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
		override protected function renderParticles( particles : Array ) : void
		{
			for each ( var p:Particle3D in particles )
			{
				renderParticle( p );
			}
		}

		protected function renderParticle( particle : Particle3D ) : void
		{
			if ( particle.image is Object3D )
			{
				var obj : Object3D = particle.image as Object3D;
				obj.x = particle.position.x;
				obj.y = particle.position.y;
				obj.z = particle.position.z;
				obj.scaleX = particle.scale;
				obj.scaleY = particle.scale;
				obj.scaleZ = particle.scale;
				
				var rotVector : Vector3D = particle.rotation.toAxisRotation();
				if ( obj is Mesh )
				{
					obj.rotationX = rotVector.x;
					obj.rotationY = rotVector.y;
					obj.rotationZ = rotVector.z;
					// Mesh( o ).matrix.appendRotation(Maths.asDegrees(rotVector.w),rotVector);////!!!!!test if it works ,if not create Vector3DUtils for ALT3D
					// mesh rendering
					var numSurfaces : int = Mesh( obj ).numSurfaces;
					for ( var i : int = 0; i < numSurfaces; ++i )
					{
						var material : Material = Mesh( obj ).getSurface( i ).material;
						if ( material )
						{
							if ( material["hasOwnProperty"]( "color" ) )
							{
								material["color"] = particle.color & 0xFFFFFF;
							}
							if ( material["hasOwnProperty"]( "alpha" ) )
							{
								material["alpha"] = particle.alpha;
							}
							Mesh( obj ).getSurface( i ).material = material.clone();
							// Mesh(obj).setMaterialToAllSurfaces(material);
						}
					}
				}
				else if ( obj is Sprite3D )
				{
					Sprite3D( obj ).rotation = rotVector.z;

					var spriteMaterial : Material = Sprite3D( obj ).material;
					// ////if the material is FillMaterial
					if ( spriteMaterial["hasOwnProperty"]( "color" ) )
					{
						spriteMaterial["color"] = particle.color & 0xFFFFFF;
					}
					if ( spriteMaterial["hasOwnProperty"]( "alpha" ) )
					{
						spriteMaterial["alpha"] = particle.alpha;
					}
					Sprite3D( obj ).material = spriteMaterial.clone();
					
					if ( obj is AnimSprite )
					{
						AnimSprite( obj ).frame++;
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
		override protected function addParticle( particle : Particle ) : void
		{
			if( particle.image is Object3D )
			{
				_container.addChild( Object3D( particle.image ) );
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
		override protected function removeParticle( particle : Particle ) : void
		{
			if( particle.image is Object3D )
			{
				_container.removeChild( Object3D( particle.image ) );
			}
		}
	}
}
