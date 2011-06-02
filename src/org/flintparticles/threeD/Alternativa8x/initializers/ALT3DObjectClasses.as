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

package org.flintparticles.threeD.Alternativa8x.initializers
{
	
	
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.objects.Sprite3D;
	
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
	
	public class ALT3DObjectClasses extends InitializerBase
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
		public function ALT3DObjectClasses( images:Array, parameters:Array = null, weights:Array = null )
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
		private var _particle:Particle;
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			_particle=particle
			var img:Pair = _images.getRandomValue();
			
			// copy the parameters object because the class will modify the object it's sent
			var p:Object = new Object();
			for( var name:String in img.parameters )
			{
				p[name] = img.parameters[name];
			}
			var imgClass:Class = img.image as Class;
			if(getObjectType(imgClass)=="Sprite3D"){
				
				
				initSpriteProperties(imgClass,p);
			}
			
			if(getObjectType(imgClass)=="Box"){
				initBoxProperties(imgClass,p);
			}
			
			if(getObjectType(imgClass)=="GeoSphere"){
				initSphereProperties(imgClass,p);
			}
			
			if(getObjectType(imgClass)=="AnimSprite"){
				initAnimSpriteProperties(imgClass,p);
			}
			
			Object3D(particle.image).scaleX=p["scaleX"]==null?1:p["scaleX"];
			Object3D(particle.image).scaleY=p["scaleY"]==null?1:p["scaleY"];
			Object3D(particle.image).scaleZ=p["scaleZ"]==null?1:p["scaleZ"];
			
		}
		
		
		protected function initSpriteProperties(imgClass:Class,p:Object):void{
			_particle.image = new imgClass(0,0,null);
			Sprite3D(_particle.image).width=p["width"]==null?10:p["width"];
			Sprite3D(_particle.image).height=p["height"]==null?10:p["height"];
			Sprite3D(_particle.image).rotation=p["rotation"]==null?0:p["rotation"];
			Sprite3D(_particle.image)["material"]=p["material"]==null?null:p["material"];
		}
		protected function initBoxProperties(imgClass:Class,p:Object):void{
			
			_particle.image=new imgClass(
				p["width"]==null?100:p["width"],
				p["length"]==null?100:p["length"],
				p["height"]==null?100:p["height"],
				p["widthSegments"]==null?1:p["widthSegments"],
				p["lengthSegments"]==null?1:p["lengthSegments"],
				p["heightSegments"]==null?1:p["heightSegments"],
				p["reverse"]==null?false:p["reverse"],
				p["material"]==null?null:p["material"]
			);
		}
		protected function initSphereProperties(imgClass:Class,p:Object):void{
			_particle.image = new imgClass(
				p["radius"]==null?100:p["radius"],	
				p["segments"]==null?2:p["segments"],
				p["reverse"]==null?false:p["reverse"],
				p["material"]==null?null:p["material"]
			);
		}
		protected function initAnimSpriteProperties(imgClass:Class,p:Object):void{
			
			_particle.image = new imgClass(
				p["width"]==null?100:p["width"],	
				p["height"]==null?100:p["height"],
				p["materials"]==null?null:p["materials"],
				p["loop"]==null?false:p["loop"],
				p["frame"]==null?0:p["frame"]
			);
		}
		private function getObjectType(value:*):String{
			var str:String="";
			switch (getQualifiedClassName(value)){
				case "alternativa.engine3d.primitives::GeoSphere":
					str="GeoSphere";
					break;
				case "alternativa.engine3d.primitives::Box":
					str="Box";
					break;
				case "alternativa.engine3d.objects::Sprite3D":
					str="Sprite3D";
					break;
				case "alternativa.engine3d.objects::AnimSprite":
					str="AnimSprite";
					break;
				
			}
			return str;
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