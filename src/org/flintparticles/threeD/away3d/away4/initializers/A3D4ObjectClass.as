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

package org.flintparticles.threeD.away3d.away4.initializers
{
	
	
	import away3d.entities.Mesh;
	import away3d.entities.Sprite3D;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Plane;
	import away3d.primitives.Sphere;
	
	import flash.utils.getQualifiedClassName;
	
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.initializers.InitializerBase;
	import org.flintparticles.common.particles.Particle;

	/**
	 * The A3D4ObjectClass initializer sets the 3D Object to use to 
	 * draw the particle in a 3D scene. It is used with the Away3D 4 renderer when
	 * particles should be represented by a 3D object.
	 */

	public class A3D4ObjectClass extends InitializerBase
	{
		private var _imageClass:Class;
		private var _parameters:Object;
		
		/**
		 * The constructor creates an A3D4ObjectClass initializer for use by 
		 * an emitter. To add an ImageClass to all particles created by an emitter, 
		 * use the emitter's addInitializer method.
		 * 
		 * @param imageClass The class to use when creating
		 * the particles' image object.
		 * @param parameters The parameters to pass to the constructor
		 * for the image class.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function A3D4ObjectClass( imageClass:Class, parameters:Object )
		{
			_imageClass = imageClass;
			_parameters = parameters;
		}
		
		/**
		 * The class to use when creating
		 * the particles' DisplayObjects.
		 */
		public function get imageClass():Class
		{
			return _imageClass;
		}
		public function set imageClass( value:Class ):void
		{
			_imageClass = value;
		}
		
		/**
		 * The parameters to pass to the constructor
		 * for the image class.
		 */
		public function get parameters():Object
		{
			return _parameters;
		}
		public function set parameters( value:Object ):void
		{
			_parameters = value;
		}
		
		/**
		 * @inheritDoc
		 */
	
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			// copy the parameters object because the class will modify the object it's sent
			var p:Object = new Object();
			for( var name:String in _parameters )
			{
				p[name] = _parameters[name];
			}
		
			//new Sprite3D(material,width,height,rotation,align,scaling,distanceScaling)
			if(getQualifiedClassName(_imageClass)=="away3d.entities::Sprite3D"){
				
				particle.image = new _imageClass(null,0,0);
				initSprite3DProperties(particle.image,p);
		
			}else{
                
		
				
				particle.image = new _imageClass(  );
				///common to all
				Mesh(particle.image).material=p["material"]==null?null:p["material"];
				Mesh(particle.image)["segmentsH"]=p["segmentsH"]==null?6:p["segmentsH"];
				Mesh(particle.image)["segmentsW"]=p["segmentsW"]==null?6:p["segmentsW"];
				///cube setup////
				if(getQualifiedClassName(_imageClass)=="away3d.primitives::Cube"){
					initCubeProperties(particle.image,p);
				}
				////plane setup///
				if(getQualifiedClassName(_imageClass)=="away3d.primitives::Plane"){
					initPlaneProperties(particle.image,p);
				}
				///sphere setup///
				if(getQualifiedClassName(_imageClass)=="away3d.primitives::Sphere"){
					initSphereProperties(particle.image,p);
				}

		
				
			
				
			}
			
			
		
			
		}
		protected function initCubeProperties(cube:Cube,p:Object):void{
			///cube specific
			cube["width"]=p["width"]==null?100:p["width"];
			cube["height"]=p["height"]==null?100:p["height"];
			cube["depth"]=p["depth"]==null?100:p["depth"];
			cube["segmentsD"]=p["segmentsD"]==null?6:p["segmentsD"];
			cube["tile6"]=p["tile6"]==null?true:p["tile6"];
				
			
		}
		protected function initPlaneProperties(plane:Plane,p:Object):void{
			
			plane["width"]=p["width"]==null?100:p["width"];
			plane["height"]=p["height"]==null?100:p["height"];
			plane["yUp"]=p["yUp"]==null?true:p["yUp"];
		}
		protected function initSphereProperties(sphere:Sphere,p:Object):void{
		
			sphere["radius"]=p["radius"]==null?10:p["radius"];
			sphere["yUp"]=p["yUp"]==null?true:p["yUp"];
		}
		protected function initSprite3DProperties(sprite:Sprite3D,p:Object):void{
			sprite.material=p["material"]==null?null:p["material"];
			sprite.width=p["width"]==null?10:p["width"];
			sprite.height=p["height"]==null?10:p["height"];
			///
			sprite.rotationX=p["rotationX"]==null?0:p["rotationX"];
			sprite.rotationY=p["rotationY"]==null?0:p["rotationY"];
			sprite.rotationZ=p["rotationZ"]==null?0:p["rotationZ"];
			///
			sprite.scaleX=p["scaleX"]==null?1:p["scaleX"];
			sprite.scaleY=p["scaleY"]==null?1:p["scaleY"];
			sprite.scaleZ=p["scaleZ"]==null?1:p["scaleZ"];
		}
	}
}
