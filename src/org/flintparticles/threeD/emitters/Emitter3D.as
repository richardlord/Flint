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

package org.flintparticles.threeD.emitters
{
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.particles.ParticleFactory;
	import org.flintparticles.threeD.geom.Quaternion;
	import org.flintparticles.threeD.particles.Particle3D;
	import org.flintparticles.threeD.particles.ParticleCreator3D;

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	/**
	 * The Emitter3D class defines an emitter that exists in 3D space. It is the
	 * main emitter for using Flint in a 3D coordinate system.
	 * 
	 * <p>This emitter is not constrained to any particular 3D rendering
	 * environment. The emitter manages the creation and updating of each
	 * particle's state but does not do any rendering of the particles.
	 * The rendering is handled by a renderer. Renderer's could be created 
	 * for drawing an emitter's particles on any 3D drawing environment.</p>
	 * 
	 * <p>This emitter adds 3D specific features to the base emitter class.</p>
	 */

	public class Emitter3D extends Emitter
	{
		/**
		 * @private
		 * 
		 * default factory to manage the creation, reuse and destruction of particles
		 */
		protected static var _creator:ParticleCreator3D = new ParticleCreator3D();
		
		/**
		 * The default particle factory used to manage the creation, reuse and destruction of particles.
		 */
		public static function get defaultParticleFactory():ParticleFactory
		{
			return _creator;
		}
		
		/**
		 * @private
		 */
		protected var _position:Vector3D;
		/**
		 * @private
		 */
		protected var _rotation:Quaternion;
		/**
		 * @private
		 */
		protected var _rotationTransform:Matrix3D;
		private var _rotTransformRotation:Quaternion;
		
		/**
		 * Identifies whether the particles should be arranged
		 * into a spacially sorted array - this speeds up proximity
		 * testing for those actions that need it.
		 */
		public var spaceSort:Boolean = false;
		
		/**
		 * The constructor creates an emitter 3D.
		 */
		public function Emitter3D()
		{
			super();
			_particleFactory = _creator;
			_position = new Vector3D( 0, 0, 0, 1 );
			_rotation = Quaternion.IDENTITY.clone();
			_rotationTransform = new Matrix3D();
			_rotTransformRotation = Quaternion.IDENTITY.clone();
		}

		/**
		 * Indicates the position of the Emitter instance relative to 
		 * the local coordinate system of the Renderer.
		 */
		public function get position():Vector3D
		{
			return _position;
		}
		public function set position( value:Vector3D ):void
		{
			_position = value;
			_position.w = 1;
		}
		/**
		 * Indicates the rotation of the Emitter instance relative to 
		 * the local coordinate system of the Renderer.
		 */
		public function get rotation():Quaternion
		{
			return _rotation;
		}
		public function set rotation( value:Quaternion ):void
		{
			_rotation = value;
		}
		
		/**
		 * Indicates the rotation of the Emitter instance relative to 
		 * the local coordinate system of the Renderer, as a matrix
		 * transformation.
		 */
		public function get rotationTransform():Matrix3D
		{
			if( !_rotTransformRotation.equals( _rotation ) )
			{
				_rotationTransform = _rotation.toMatrixTransformation();
				_rotTransformRotation = _rotation.clone();
			}
			return _rotationTransform;
		}
		
		/*
		 * Used internally to initialize a particle based on the state of the
		 * emitter. This function sets the particle's position and rotation to 
		 * match the position and rotation of the emitter. After setting this
		 * default state, the initializer actions will be applied to the particle.
		 * 
		 * @param particle The particle to initialize.
		 */
		override protected function initParticle( particle:Particle ):void
		{
			var p:Particle3D = Particle3D( particle );
			p.position.x = _position.x;
			p.position.y = _position.y;
			p.position.z = _position.z;
			p.rotation.w = _rotation.w;
			p.rotation.x = _rotation.x;
			p.rotation.y = _rotation.y;
			p.rotation.z = _rotation.z;
		}
		
		/**
		 * If the spaceSort property is true, this method creates the spaceSortedX
		 * array.
		 * 
		 * @param time The duration, in seconds, of the current frame.
		 */
		override protected function sortParticles():void
		{
			if( spaceSort )
			{
				_particles.sort( sortOnX );
				var len:int = _particles.length;
				for( var i:int = 0; i < len; ++i )
				{
					Particle3D( _particles[ i ] ).sortID = i;
				}
			}
		}
		
		private function sortOnX( p1:Particle3D, p2:Particle3D ):int
		{
			return p1.position.x - p2.position.x;
		}
	}
}