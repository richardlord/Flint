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

package org.flintparticles.integration.away3d.v4.initializers
{
	import away3d.entities.Mesh;
	import away3d.entities.Sprite3D;
	import away3d.primitives.Cube;
	import away3d.primitives.Plane;
	import away3d.primitives.Sphere;
	
	import flash.utils.getQualifiedClassName;
	
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.initializers.InitializerBase;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.utils.WeightedArray;

	/**
	 * The ImageClass Initializer sets the DisplayObject to use to draw
	 * the particle. It is used with the DisplayObjectRenderer. When using the
	 * BitmapRenderer it is more efficient to use the SharedImage Initializer.
	 */

	public class A3D4ObjectClasses extends InitializerBase
	{
		private var _images:WeightedArray;
		
		/**
		 * The constructor creates a ImageClasses initializer for use by 
		 * an emitter. To add a ImageClasses to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param images An array containing the classes to use for 
		 * each particle created by the emitter.
		 * @param weights The weighting to apply to each displayObject. If no weighting
		 * values are passed, the images are used with equal probability.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function A3D4ObjectClasses( images:Array, parameters:Array = null, weights:Array = null )
		{
			_images = new WeightedArray;
			if( parameters == null )
			{
				parameters = [];
			}
			var len:int = images.length;
			var i:int;
			if( weights != null && weights.length == len )
			{
				for( i = 0; i < len; ++i )
				{
					if( parameters[i] )
					{
						addImage( images[i], parameters[i], weights[i] );
					}
					else
					{
						addImage( images[i], null, weights[i] );
					}
				}
			}
			else
			{
				for( i = 0; i < len; ++i )
				{
					if( parameters[i] )
					{
						addImage( images[i], parameters[i], 1 );
					}
					else
					{
						addImage( images[i], null, 1 );
					}
				}
			}
		}
		
		public function addImage( image:Class, parameters:Object = null, weight:Number = 1 ):void
		{
			_images.add( new Pair( image, parameters ), weight );
		}
		
		public function removeImage( image:* ):void
		{
			_images.remove( image );
		}

		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			var img:Pair = _images.getRandomValue();

			// copy the parameters object because the class will modify the object it's sent
			var p:Object = new Object();
			for( var name:String in img.parameters )
			{
				p[name] = img.parameters[name];
			}
			var imgClass:Class = img.image as Class;
			if(getQualifiedClassName(imgClass)=="away3d.entities::Sprite3D"){
				
				particle.image = new imgClass(null,0,0);
				initSprite3DProperties(particle.image,p);
			}else{
				particle.image = new imgClass();
				//particle.image = new imgClass( p );
				///common to all
				Mesh(particle.image).material=p["material"]==null?null:p["material"];
				Mesh(particle.image)["segmentsH"]=p["segmentsH"]==null?6:p["segmentsH"];
				Mesh(particle.image)["segmentsW"]=p["segmentsW"]==null?6:p["segmentsW"];
				///cube setup////
				if(getQualifiedClassName(imgClass)=="away3d.primitives::Cube"){
					initCubeProperties(particle.image,p);
				}
				////plane setup///
				if(getQualifiedClassName(imgClass)=="away3d.primitives::Plane"){
					initPlaneProperties(particle.image,p);
				}
				///sphere setup///
				if(getQualifiedClassName(imgClass)=="away3d.primitives::Sphere"){
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
class Pair
{
	internal var image:Class;
	internal var parameters:Object;
	
	public function Pair( image:Class, parameters:Object )
	{
		this.image = image;
		this.parameters = parameters;
	}
}