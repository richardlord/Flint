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

package org.flintparticles.integration.flare3d.v2
{
	
	
	import away3d.entities.Mesh;
	
	import flare.Flare3D;
	import flare.core.Mesh3D;
	import flare.core.Particle3D;
	import flare.core.Pivot3D;
	import flare.materials.Material3D;
	import flare.materials.Shader3D;
	import flare.materials.filters.ColorFilter;
	import flare.materials.filters.TextureFilter;
	import flare.materials.flsl.FLSLFilter;
	import flare.primitives.Sphere;
	import flare.utils.MeshUtils3D;
	
	import flash.display.Shader;
	import flash.geom.Vector3D;
	
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.renderers.RendererBase;
	import org.flintparticles.common.utils.Maths;
	import org.flintparticles.integration.flare3d.v2.flare3dutils.FConvert;
	import org.flintparticles.integration.flare3d.v2.flare3dutils.FlareMathUtil;
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
	public class F3DRenderer extends RendererBase
	{
		private var _container:Pivot3D;
		
		/**
		 * The constructor creates an Away3D renderer for displaying the
		 * particles in an Away3D scene.
		 * 
		 * @param container An Away3D object container. The particle display
		 * objects are created inside this object container. This is usually
		 * a scene object, but it may be any ObjectContainer3D.
		 */
		//////using currently Pivot3D as container
		public function F3DRenderer( container:Pivot3D )
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
			for each( var p:			org.flintparticles.threeD.particles.Particle3D in particles )
			{
				renderParticle( p );
			}
		}
		
		protected function renderParticle( particle:org.flintparticles.threeD.particles.Particle3D ):void
		{
			var o:* = particle.image;

			if( o is Mesh3D )
			{
				Mesh3D( o ).x = particle.position.x;
				Mesh3D( o ).y = particle.position.y;
				Mesh3D( o ).z = particle.position.z;
				Mesh3D( o ).setScale(particle.scale,particle.scale,particle.scale);
				//Object3D( o ).scaleX = Object3D( o ).scaleY = Object3D( o ).scaleZ = particle.scale;
				
				//	var rotation:flash.geom.Vector3D = away3d.core.math.Vector3DUtils.quaternion2euler( Convert.QuaternionToA3D( particle.rotation ) );
				var rotation:Vector3D=FlareMathUtil.quaternion2euler(FConvert.QuaternionToF3D(particle.rotation));
				Mesh3D(o).setRotation(
					Maths.asDegrees( rotation.x ),
					Maths.asDegrees( rotation.y ),
					Maths.asDegrees( rotation.z )
				);

				
				//----------------materials access----------------/////////
				var matLength:uint=Mesh3D(o).materials.length;
				for(var i:int=0;i<matLength;++i){
					var material:Material3D=Mesh3D(o).materials[i];
					if(material is Shader3D){
						
						var numLayers:uint=Shader3D(material).filters.length;
						for(var v:int=0;v<numLayers;++v){
							var currentLayer:FLSLFilter=Shader3D(material).filters[v];
							//var shader:Shader3D;
							if(currentLayer["hasOwnProperty"]( "color" ))
							{

								var pcolor:uint=particle.color ;//& 0xFFFFFF;
								
								
								var r:Number =( ( pcolor >>> 16 ) & 255 ) / 255; ///(hex & 0xff0000) >> 16;
								var 	g:Number =  ( ( pcolor >>> 8 ) & 255 ) / 255;
								var 		b:Number =  ( ( pcolor ) & 255 ) / 255;
								var a:Number =  ( ( pcolor >>> 24 ) & 255 ) / 255;
								ColorFilter(currentLayer).r=r;
								ColorFilter(currentLayer).g=g;
								ColorFilter(currentLayer).b=b;
								ColorFilter(currentLayer).a=a;
	
							}
							////wait till Flare has clone ,currently need to create a new material each time and also clone the bitmapdata
							////otherwise it gets disposed
							if(currentLayer is TextureFilter)///currentLayer["hasOwnProperty"]( "alpha" )
							{
								
							}
							
						}
						//	Mesh3D(o).materials[i]=material.clone();
						
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
			if( particle.image is Mesh3D )
			{
				//	_container.addChild( Object3D( particle.image ) );
				_container.addChild(particle.image);
				
			}
			renderParticle(org.flintparticles.threeD.particles.Particle3D( particle ) );
			///TODO for billboards
			/*else if( particle.image is Sprite3D )
			{
			_container.addSprite( Sprite3D( particle.image ) );
			renderParticle( Particle3D( particle ) );
			}*/
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
			if( particle.image is Mesh3D)
			{
			
				_container.removeChild(particle.image);
			
			}

		}
	}
}
