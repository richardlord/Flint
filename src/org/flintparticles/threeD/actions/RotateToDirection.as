/*
 * FLINT PARTICLE SYSTEM
 * http://org.flintparticles.twoD.org/
 * ..........................
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

package org.flintparticles.threeD.actions 
{
	import org.flintparticles.common.actions.ActionBase;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.threeD.geom.Quaternion;
	import org.flintparticles.threeD.geom.Vector3DUtils;
	import org.flintparticles.threeD.particles.Particle3D;

	import flash.geom.Vector3D;

	/**
	 * The RotateToDirection action updates the rotation of the particle 
	 * so that it always points in the direction it is traveling.
	 */

	public class RotateToDirection extends ActionBase
	{
		private var _axis:Vector3D;
		private var _temp:Vector3D;
		private var _target:Vector3D;
		
		/**
		 * The constructor creates a RotateToDirection action for use by 
		 * an emitter. To add a RotateToDirection to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 */
		public function RotateToDirection()
		{
			_axis = Vector3DUtils.getVector( 0, 0, 0 );
			_temp = Vector3DUtils.getVector( 0, 0, 0 );
			_target = Vector3DUtils.getVector( 0, 0, 0 );
		}

		/**
		 * @inheritDoc
		 */
		override public function update( emitter : Emitter, particle : Particle, time : Number ) : void
		{
			var p : Particle3D = Particle3D( particle );
			if ( p.velocity.equals( Vector3DUtils.ZERO_VECTOR ) )
			{
				return;
			}
			Vector3DUtils.assignVector( _target, p.velocity );
			_target.normalize();
			if( _target.equals( p.faceAxis ) )
			{
				p.rotation.assign( Quaternion.IDENTITY );
				return;
			}
			Vector3DUtils.assignVector( _temp, p.faceAxis );
			_temp.negate();
			if( _target.equals( _temp ) )
			{
				var v:Vector3D = Vector3DUtils.getPerpendicular( p.faceAxis );
				p.rotation.reset( 0, v.x, v.y, v.z );
				return;
			}
			_axis = _target.crossProduct( p.faceAxis );
			var angle:Number = Math.acos( p.faceAxis.dotProduct( _target ) );
			p.rotation.setFromAxisRotation( _axis, angle );
		}
	}
}
