package org.flintparticles.threeD.geom
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * Utility methods for working with the Matrix3D class.
	 */
	public class Matrix3DUtils
	{
		/**
		 * Creates a new Matrix3D for scaling.
		 * 
		 * @param scaleX The scale factor in the x direction
		 * @param scaleY The scale factor in the y direction
		 * @param scaleZ The scale factor in the z direction
		 * 
		 * @return The new matrix
		 */
		public static function newScale( scaleX:Number, scaleY:Number, scaleZ:Number ):Matrix3D
		{
			return new Matrix3D( Vector.<Number>( [ scaleX,0,0,0,0,scaleY,0,0,0,0,scaleZ,0,0,0,0,1 ] ) );
		}
		
		/**
		 * Creates a new Matrix3D for translation.
		 * 
		 * @param x The translation along the x axis.
		 * @param y The translation along the y axis.
		 * @param z The translation along the z axis.
		 * 
		 * @return The new matrix
		 */
		public static function newTranslate( x:Number, y:Number, z:Number ):Matrix3D
		{
			return new Matrix3D( Vector.<Number>( [ 1,0,0,0,0,1,0,0,0,0,1,0,x,y,z,1 ] ) );
		}
	
		/**
		 * Creates a new Matrix3D for rotation about an axis.
		 * 
		 * @param angle The angle in radians for the rotation
		 * @param axis The axis to rotate around
		 * @param pivotPoint The point the axis passes through. The default value is the origin.
		 * 
		 * @return The new matrix
		 */
		public static function newRotate( angle:Number, axis:Vector3D, pivotPoint:Vector3D = null ):Matrix3D
		{
			if ( angle == 0 )
			{
				return new Matrix3D();
			}
			const sin:Number = Math.sin( angle );
			const cos:Number = Math.cos( angle );
			const oneMinCos:Number = 1 - cos;
			var rotate:Matrix3D = new Matrix3D( Vector.<Number>( [
				cos + axis.x * axis.x * oneMinCos, axis.x * axis.y * oneMinCos + axis.z * sin, axis.x * axis.z  * oneMinCos - axis.y * sin, 0,
				axis.x * axis.y * oneMinCos - axis.z * sin, cos + axis.y * axis.y * oneMinCos, axis.y * axis.z * oneMinCos + axis.x * sin, 0,
				axis.x * axis.z  * oneMinCos + axis.y * sin, axis.y * axis.z * oneMinCos - axis.x * sin, cos + axis.z * axis.z * oneMinCos, 0,
				0, 0, 0, 1 ] ) );
			
			if( pivotPoint )
			{
				rotate.prependTranslation( -pivotPoint.x, -pivotPoint.y, -pivotPoint.z );
				rotate.appendTranslation( pivotPoint.x, pivotPoint.y, pivotPoint.z );
			}
			return rotate;
		}

		/**
		 * Creates a coordinate system transformation such that the vectors
		 * indicated are transformed to the x, y and z axes. The vectors need
		 * not be perpendicular, but they must form a basis for 3D space.
		 * 
		 * @param axisX The vector that is translated to ( 1, 0, 0 ) by the transform.
		 * @param axisY The vector that is translated to ( 0, 1, 0 ) by the transform.
		 * @param axisZ The vector that is translated to ( 0, 0, 1 ) by the transform.
		 */
		public static function newBasisTransform( axisX:Vector3D, axisY:Vector3D, axisZ:Vector3D ):Matrix3D
		{
			var m:Matrix3D = new Matrix3D( Vector.<Number>( [ 
				axisX.x, axisX.y, axisX.z, 0,
				axisY.x, axisY.y, axisY.z, 0,
				axisZ.x, axisZ.y, axisZ.z, 0,
				0, 0, 0, 1 ] ) );
			m.invert();
			return m;
		}
	}
}
