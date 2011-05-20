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

package org.flintparticles.integration.away3d.v3.initializers
{
	import away3d.sprites.Sprite3D;
	
	import flash.utils.getQualifiedClassName;
	
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.initializers.InitializerBase;
	import org.flintparticles.common.particles.Particle;

	/**
	 * The A3DObjectClass initializer sets the 3D Object to use to 
	 * draw the particle in a 3D scene. It is used with the Away3D renderer when
	 * particles should be represented by a 3D object.
	 */

	public class A3DObjectClass extends InitializerBase
	{
		private var _imageClass:Class;
		private var _parameters:Object;
		
		/**
		 * The constructor creates an A3DObjectClass initializer for use by 
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
		public function A3DObjectClass( imageClass:Class, parameters:Object = null )
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
			if(getQualifiedClassName(_imageClass)=="away3d.sprites::Sprite3D"){
				
				particle.image = new _imageClass();
				Sprite3D(particle.image).material=p["material"]==null?null:p["material"];
				Sprite3D(particle.image).width=p["width"]==null?10:p["width"];
				Sprite3D(particle.image).height=p["height"]==null?10:p["height"];
				Sprite3D(particle.image).rotation=p["rotation"]==null?0:p["rotation"];
				Sprite3D(particle.image).align=p["align"]==null?"center":p["align"];
				Sprite3D(particle.image).scaling=p["scaling"]==null?1:p["scaling"];
				Sprite3D(particle.image).distanceScaling=p["distanceScaling"]==null?true:p["distanceScaling"];
			}else{
				particle.image = new _imageClass( p );
			}
			
			
		
			
		}
	}
}
