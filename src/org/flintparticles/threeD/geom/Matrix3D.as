/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2010
 * http://flintparticles.org/
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

package org.flintparticles.threeD.geom
{
	/**
	 * <p>Matrix3D represents a 3D transformation matrix. It mimics some aspects of the 
	 * flash.geom.Matrix3D class embedded in the Flash Player version 10.</p>
	 * 
	 */
	public class Matrix3D 
	{
		/**
		 * A zero matrix.
		 */
		public static const ZERO:Matrix3D = new Matrix3D( [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] );
		
		/**
		 * An identity matrix.
		 */
		public static const IDENTITY:Matrix3D = new Matrix3D( [1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1] );
		
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
			return new Matrix3D( [scaleX,0,0,0,0,scaleY,0,0,0,0,scaleZ,0,0,0,0,1] );
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
			return new Matrix3D( [1,0,0,x,0,1,0,y,0,0,1,z,0,0,0,1] );
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
		public static function newRotate( angle:Number, axis:Vector3D, pivotPoint:Point3D = null ):Matrix3D
		{
			if ( angle == 0 )
			{
				return IDENTITY.clone();
			}
			const sin:Number = Math.sin( angle );
			const cos:Number = Math.cos( angle );
			const oneMinCos:Number = 1 - cos;
			var rotate:Matrix3D = new Matrix3D( [
				cos + axis.x * axis.x * oneMinCos, axis.x * axis.y * oneMinCos - axis.z * sin, axis.x * axis.z  * oneMinCos + axis.y * sin, 0,
				axis.x * axis.y * oneMinCos + axis.z * sin, cos + axis.y * axis.y * oneMinCos, axis.y * axis.z * oneMinCos - axis.x * sin, 0,
				axis.x * axis.z  * oneMinCos - axis.y * sin, axis.y * axis.z * oneMinCos + axis.x * sin,  cos + axis.z * axis.z * oneMinCos, 0,
				0, 0, 0, 1 ] );
			
			if( pivotPoint )
			{
				rotate.prependTranslate( -pivotPoint.x, -pivotPoint.y, -pivotPoint.z );
				rotate.appendTranslate( pivotPoint.x, pivotPoint.y, pivotPoint.z );
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
			var m:Matrix3D = new Matrix3D( [ axisX.x, axisY.x, axisZ.x, 0, 
											 axisX.y, axisY.y, axisZ.y, 0,
											 axisX.z, axisY.z, axisZ.z, 0,
											 0, 0, 0, 1 ] );
			m.invert();
			return m;
		}


		/**
		 * The value in row 1 column 1 of the matrix.
		 * 
		 * x 0 0 0
		 * 0 0 0 0
		 * 0 0 0 0
		 * 0 0 0 0
		 */
		public var n11:Number;

		/**
		 * The value in row 1 column 2 of the matrix.
		 * 
		 * 0 x 0 0
		 * 0 0 0 0
		 * 0 0 0 0
		 * 0 0 0 0
		 */
		public var n12:Number;

		/**
		 * The value in row 1 column 3 of the matrix.
		 * 
		 * 0 0 x 0
		 * 0 0 0 0
		 * 0 0 0 0
		 * 0 0 0 0
		 */
		public var n13:Number;

		/**
		 * The value in row 1 column 4 of the matrix.
		 * 
		 * 0 0 0 x
		 * 0 0 0 0
		 * 0 0 0 0
		 * 0 0 0 0
		 */
		public var n14:Number;

		/**
		 * The value in row 2 column 1 of the matrix.
		 * 
		 * 0 0 0 0
		 * x 0 0 0
		 * 0 0 0 0
		 * 0 0 0 0
		 */
		public var n21:Number;

		/**
		 * The value in row 2 column 2 of the matrix.
		 * 
		 * 0 0 0 0
		 * 0 x 0 0
		 * 0 0 0 0
		 * 0 0 0 0
		 */
		public var n22:Number;

		/**
		 * The value in row 2 column 3 of the matrix.
		 * 
		 * 0 0 0 0
		 * 0 0 x 0
		 * 0 0 0 0
		 * 0 0 0 0
		 */
		public var n23:Number;

		/**
		 * The value in row 2 column 4 of the matrix.
		 * 
		 * 0 0 0 0
		 * 0 0 0 x
		 * 0 0 0 0
		 * 0 0 0 0
		 */
		public var n24:Number;

		/**
		 * The value in row 3 column 1 of the matrix.
		 * 
		 * 0 0 0 0
		 * 0 0 0 0
		 * x 0 0 0
		 * 0 0 0 0
		 */
		public var n31:Number;

		/**
		 * The value in row 3 column 2 of the matrix.
		 * 
		 * 0 0 0 0
		 * 0 0 0 0
		 * 0 x 0 0
		 * 0 0 0 0
		 */
		public var n32:Number;

		/**
		 * The value in row 3 column 3 of the matrix.
		 * 
		 * 0 0 0 0
		 * 0 0 0 0
		 * 0 0 x 0
		 * 0 0 0 0
		 */
		public var n33:Number;

		/**
		 * The value in row 3 column 4 of the matrix.
		 * 
		 * 0 0 0 0
		 * 0 0 0 0
		 * 0 0 0 x
		 * 0 0 0 0
		 */
		public var n34:Number;

		/**
		 * The value in row 4 column 1 of the matrix.
		 * 
		 * 0 0 0 0
		 * 0 0 0 0
		 * 0 0 0 0
		 * x 0 0 0
		 */
		public var n41:Number;

		/**
		 * The value in row 4 column 2 of the matrix.
		 * 
		 * 0 0 0 0
		 * 0 0 0 0
		 * 0 0 0 0
		 * 0 x 0 0
		 */
		public var n42:Number;

		/**
		 * The value in row 4 column 3 of the matrix.
		 * 
		 * 0 0 0 0
		 * 0 0 0 0
		 * 0 0 0 0
		 * 0 0 x 0
		 */
		public var n43:Number;

		/**
		 * The value in row 4 column 4 of the matrix.
		 * 
		 * 0 0 0 0
		 * 0 0 0 0
		 * 0 0 0 0
		 * 0 0 0 x
		 */
		public var n44:Number;

		/**
		 * Creates a Matrix3D object from an array of numbers.
		 * 
		 * <p>The array may contain 12 or 16 numbers in row major form.
		 * If the array contains only 12 values, the values 0,0,0,1 are
		 * used to populate the last row of the matrix. If no array is passed
		 * in, an identity matrix is created.</p>
		 * 
		 * @param values The raw data to populate the matrix with.
		 */
		public function Matrix3D( values:Array = null )
		{
			if( values == null )
			{
				values = [1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];
			}
			if( values.length < 12 )
			{
				throw new Error( "The array initializer in the Matrix3 class must cointain 12 values" );
			}
			n11 = values[0];
			n12 = values[1];
			n13 = values[2];
			n14 = values[3];
			n21 = values[4];
			n22 = values[5];
			n23 = values[6];
			n24 = values[7];
			n31 = values[8];
			n32 = values[9];
			n33 = values[10];
			n34 = values[11];
			if( values.length < 16 )
			{
				n41 = 0;
				n42 = 0;
				n43 = 0;
				n44 = 1;
			}
			else
			{
				n41 = values[12];
				n42 = values[13];
				n43 = values[14];
				n44 = values[15];
			}
		}
				
		/**
		 * Copy another matrix into this one
		 * 
		 * @param m the matrix to copy
		 * 
		 * @return a reference to this matrix
		 */
		public function copy( m:Matrix3D ):Matrix3D
		{
			n11 = m.n11;
			n12 = m.n12;
			n13 = m.n13;
			n14 = m.n14;
			n21 = m.n21;
			n22 = m.n22;
			n23 = m.n23;
			n24 = m.n24;
			n31 = m.n31;
			n32 = m.n32;
			n33 = m.n33;
			n34 = m.n34;
			n41 = m.n41;
			n42 = m.n42;
			n43 = m.n43;
			n44 = m.n44;
			return this;
		}
		
		/**
		 * Make a duplicate of this matrix
		 * 
		 * @return The new matrix
		 */
		public function clone():Matrix3D
		{
			return new Matrix3D( rawData );
		}
		
		/**
		 * Compare another matrix with this one
		 * 
		 * @param m the matrix to compare with
		 * 
		 * @return true if the matrices are the same, false otherwise
		 */
		public function equals( m:Matrix3D ):Boolean
		{
			return m.n11 == n11 && m.n12 == n12 && m.n13 == n13 && m.n14 == n14
			&& m.n21 == n21 && m.n22 == n22 && m.n23 == n23 && m.n24 == n24
			&& m.n31 == n31 && m.n32 == n32 && m.n33 == n33 && m.n34 == n34
			&& m.n41 == n41 && m.n42 == n42 && m.n43 == n43 && m.n44 == n44;
		}

		/**
		 * Compare another matrix with this one
		 * 
		 * @param m the matrix to compare with
		 * @param e The small variation allowed between the values representing
		 * the matrices
		 * 
		 * @return true if the matrices are the within e of each other, false otherwise
		 */
		public function nearEquals( m:Matrix3D, e:Number ):Boolean
		{
			return Math.abs( m.n11 - n11 ) <= e
				&& Math.abs( m.n12 - n12 ) <= e
				&& Math.abs( m.n13 - n13 ) <= e
				&& Math.abs( m.n14 - n14 ) <= e
				&& Math.abs( m.n21 - n21 ) <= e
				&& Math.abs( m.n22 - n22 ) <= e
				&& Math.abs( m.n23 - n23 ) <= e
				&& Math.abs( m.n24 - n24 ) <= e
				&& Math.abs( m.n31 - n31 ) <= e
				&& Math.abs( m.n32 - n32 ) <= e
				&& Math.abs( m.n33 - n33 ) <= e
				&& Math.abs( m.n34 - n34 ) <= e
				&& Math.abs( m.n41 - n41 ) <= e
				&& Math.abs( m.n42 - n42 ) <= e
				&& Math.abs( m.n43 - n43 ) <= e
				&& Math.abs( m.n44 - n44 ) <= e;
		}

		/**
		 * Add another transformation matrix to this one, applying the new
		 * transformation after the transformations already in this matrix.
		 * 
		 * @param m The other transformation matrix
		 * 
		 * @return A reference to this matrix
		 */
		public function append( m:Matrix3D ):Matrix3D
		{
			const o11:Number = n11;
			const o12:Number = n12;
			const o13:Number = n13;
			const o14:Number = n14;
			const o21:Number = n21;
			const o22:Number = n22;
			const o23:Number = n23;
			const o24:Number = n24;
			const o31:Number = n31;
			const o32:Number = n32;
			const o33:Number = n33;
			const o34:Number = n34;
			const o41:Number = n41;
			const o42:Number = n42;
			const o43:Number = n43;
			const o44:Number = n44;
			
			n11 = m.n11 * o11 + m.n12 * o21 + m.n13 * o31 + m.n14 * o41;
			n12 = m.n11 * o12 + m.n12 * o22 + m.n13 * o32 + m.n14 * o42;
			n13 = m.n11 * o13 + m.n12 * o23 + m.n13 * o33 + m.n14 * o43;
			n14 = m.n11 * o14 + m.n12 * o24 + m.n13 * o34 + m.n14 * o44;
			n21 = m.n21 * o11 + m.n22 * o21 + m.n23 * o31 + m.n24 * o41;
			n22 = m.n21 * o12 + m.n22 * o22 + m.n23 * o32 + m.n24 * o42;
			n23 = m.n21 * o13 + m.n22 * o23 + m.n23 * o33 + m.n24 * o43;
			n24 = m.n21 * o14 + m.n22 * o24 + m.n23 * o34 + m.n24 * o44;
			n31 = m.n31 * o11 + m.n32 * o21 + m.n33 * o31 + m.n34 * o41;
			n32 = m.n31 * o12 + m.n32 * o22 + m.n33 * o32 + m.n34 * o42;
			n33 = m.n31 * o13 + m.n32 * o23 + m.n33 * o33 + m.n34 * o43;
			n34 = m.n31 * o14 + m.n32 * o24 + m.n33 * o34 + m.n34 * o44;
			n41 = m.n41 * o11 + m.n42 * o21 + m.n43 * o31 + m.n44 * o41;
			n42 = m.n41 * o12 + m.n42 * o22 + m.n43 * o32 + m.n44 * o42;
			n43 = m.n41 * o13 + m.n42 * o23 + m.n43 * o33 + m.n44 * o43;
			n44 = m.n41 * o14 + m.n42 * o24 + m.n43 * o34 + m.n44 * o44;
			
			return this;
		}

		/**
		 * Append a scale transformation to this matrix, applying the scale
		 * after the transformations already in this matrix.
		 * 
		 * @param scaleX The scaling factor in the x direction
		 * @param scaleY The scaling factor in the y direction
		 * @param scaleZ The scaling factor in the z direction
		 * 
		 * @return A reference to this matrix
		 */
		public function appendScale( scaleX:Number, scaleY:Number, scaleZ:Number ):Matrix3D
		{
			return append( newScale( scaleX, scaleY, scaleZ ) );
		}
		
		/**
		 * Append a translation transformation to this matrix, applying the 
		 * translation after the transformations already in this matrix.
		 * 
		 * @param x The translation along the x axis.
		 * @param y The translation along the y axis.
		 * @param z The translation along the z axis.
		 * 
		 * @return A reference to this matrix
		 */
		public function appendTranslate( x:Number, y:Number, z:Number ):Matrix3D
		{
			return append( newTranslate( x, y, z ) );
		}
	
		/**
		 * Append a rotation about an axis transformation to this matrix, applying the 
		 * rotation after the transformations already in this matrix.
		 * 
		 * @param angle The rotation angle in radians. If this is not set, the
		 * w coordinate of the axis is used as the angle.
		 * @param axis The vector to rotate around
		 * @param pivotPoint The point the axis passes through. The default value is the origin.
		 * 
		 * @return A reference to this matrix
		 */
		public function appendRotate( angle:Number, axis:Vector3D, pivotPoint:Point3D = null ):Matrix3D
		{
			if ( angle == 0 )
			{
				return this;
			}
			return append( newRotate( angle, axis, pivotPoint ) );
		}

		/**
		 * Append a coordinate system transformation such that the vectors
		 * indicated are transformed to the x, y and z axes. The vectors need
		 * not be perpendicular, but they must form a basis for 3D space.
		 * 
		 * @param axisX The vector that is translated to ( 1, 0, 0 ) by the transform.
		 * @param axisY The vector that is translated to ( 0, 1, 0 ) by the transform.
		 * @param axisZ The vector that is translated to ( 0, 0, 1 ) by the transform.
		 * 
		 * @return A reference to this matrix
		 */
		public function appendBasisTransform( axisX:Vector3D, axisY:Vector3D, axisZ:Vector3D ):Matrix3D
		{
			return append( newBasisTransform( axisX, axisY, axisZ ) );
		}

		/**
		 * Add another transformation matrix to this one, applying the new
		 * transformation before the transformations already in this matrix.
		 * 
		 * @param m The other transformation matrix
		 * 
		 * @return A reference to this matrix
		 */
		public function prepend( m:Matrix3D ):Matrix3D
		{
			const o11:Number = n11;
			const o12:Number = n12;
			const o13:Number = n13;
			const o14:Number = n14;
			const o21:Number = n21;
			const o22:Number = n22;
			const o23:Number = n23;
			const o24:Number = n24;
			const o31:Number = n31;
			const o32:Number = n32;
			const o33:Number = n33;
			const o34:Number = n34;
			const o41:Number = n41;
			const o42:Number = n42;
			const o43:Number = n43;
			const o44:Number = n44;
			
			n11 = o11 * m.n11 + o12 * m.n21 + o13 * m.n31 + o14 * m.n41;
			n12 = o11 * m.n12 + o12 * m.n22 + o13 * m.n32 + o14 * m.n42;
			n13 = o11 * m.n13 + o12 * m.n23 + o13 * m.n33 + o14 * m.n43;
			n14 = o11 * m.n14 + o12 * m.n24 + o13 * m.n34 + o14 * m.n44;
			n21 = o21 * m.n11 + o22 * m.n21 + o23 * m.n31 + o24 * m.n41;
			n22 = o21 * m.n12 + o22 * m.n22 + o23 * m.n32 + o24 * m.n42;
			n23 = o21 * m.n13 + o22 * m.n23 + o23 * m.n33 + o24 * m.n43;
			n24 = o21 * m.n14 + o22 * m.n24 + o23 * m.n34 + o24 * m.n44;
			n31 = o31 * m.n11 + o32 * m.n21 + o33 * m.n31 + o34 * m.n41;
			n32 = o31 * m.n12 + o32 * m.n22 + o33 * m.n32 + o34 * m.n42;
			n33 = o31 * m.n13 + o32 * m.n23 + o33 * m.n33 + o34 * m.n43;
			n34 = o31 * m.n14 + o32 * m.n24 + o33 * m.n34 + o34 * m.n44;
			n41 = o41 * m.n11 + o42 * m.n21 + o43 * m.n31 + o44 * m.n41;
			n42 = o41 * m.n12 + o42 * m.n22 + o43 * m.n32 + o44 * m.n42;
			n43 = o41 * m.n13 + o42 * m.n23 + o43 * m.n33 + o44 * m.n43;
			n44 = o41 * m.n14 + o42 * m.n24 + o43 * m.n34 + o44 * m.n44;
			
			return this;
		}

		/**
		 * Prepend a scale transformation to this matrix, applying the scale
		 * before the transformations already in this matrix.
		 * 
		 * @param scaleX The scaling factor in the x direction
		 * @param scaleY The scaling factor in the y direction
		 * @param scaleZ The scaling factor in the z direction
		 * 
		 * @return A reference to this matrix
		 */
		public function prependScale( scaleX:Number, scaleY:Number, scaleZ:Number ):Matrix3D
		{
			return prepend( newScale( scaleX, scaleY, scaleZ ) );
		}
		
		/**
		 * Prepend a translation transformation to this matrix, applying the 
		 * translation before the transformations already in this matrix.
		 * 
		 * @param x The translation along the x axis.
		 * @param y The translation along the y axis.
		 * @param z The translation along the z axis.
		 * 
		 * @return A reference to this matrix
		 */
		public function prependTranslate( x:Number, y:Number, z:Number ):Matrix3D
		{
			return prepend( newTranslate( x, y, z ) );
		}
	
		/**
		 * Prepend a rotation about an axis transformation to this matrix, applying the 
		 * rotation before the transformations already in this matrix.
		 * 
		 * @param angle The rotation angle in radians. If this is not set, the
		 * w coordinate of the axis is used as the angle.
		 * @param axis The vector to rotate around
		 * @param pivotPoint The point the axis passes through. The default value is the origin.
		 * 
		 * @return A reference to this matrix
		 */
		public function prependRotate( angle:Number, axis:Vector3D, pivotPoint:Point3D = null ):Matrix3D
		{
			if ( angle == 0 )
			{
				return this;
			}
			return prepend( newRotate( angle, axis, pivotPoint ) );
		}

		/**
		 * Prepend a coordinate system transformation such that the vectors
		 * indicated are transformed to the x, y and z axes. The vectors need
		 * not be perpendicular, but they must form a basis for 3D space.
		 * 
		 * @param axisX The vector that is translated to ( 1, 0, 0 ) by the transform.
		 * @param axisY The vector that is translated to ( 0, 1, 0 ) by the transform.
		 * @param axisZ The vector that is translated to ( 0, 0, 1 ) by the transform.
		 * 
		 * @return A reference to this matrix
		 */
		public function prependBasisTransform( axisX:Vector3D, axisY:Vector3D, axisZ:Vector3D ):Matrix3D
		{
			return prepend( newBasisTransform( axisX, axisY, axisZ ) );
		}

		/**
		 * The determinant of the matrix
		 */
		public function get determinant():Number
		{
			return ( n11 * n22 - n12 * n21 ) * ( n33 * n44 - n34 * n43 )
				 + ( n13 * n21 - n11 * n23 ) * ( n32 * n44 - n34 * n42 )
				 + ( n11 * n24 - n14 * n21 ) * ( n32 * n43 - n33 * n42 )
				 + ( n12 * n23 - n13 * n22 ) * ( n31 * n44 - n34 * n41 )
				 + ( n14 * n22 - n12 * n24 ) * ( n31 * n43 - n33 * n41 )
				 + ( n13 * n24 - n14 * n23 ) * ( n31 * n42 - n32 * n41 );
		}
		
		/**
		 * The inverse of this matrix, or null if no inverse exists
		 */
		public function get inverse():Matrix3D
		{
			return clone().invert();
		}
	
		/**
		 * Invert this matrix. If no inverse exists, the matrix is invalid and null
		 * is returned.
		 * 
		 * @return A reference to this matrix or null if no inverse exists
		 */
		public function invert():Matrix3D
		{
			var d:Number = determinant;
			if ( Math.abs( d ) < 0.0001 )
			{
				n11 = n12 = n13 = n14 = n21 = n22 = n23 = n24 = n31 = n32 = n33 = n34 = n41 = n42 = n43 = n44 = NaN;
				return null;
			}
			const det:Number = 1/d;
			const o11:Number = n11;
			const o12:Number = n12;
			const o13:Number = n13;
			const o14:Number = n14;
			const o21:Number = n21;
			const o22:Number = n22;
			const o23:Number = n23;
			const o24:Number = n24;
			const o31:Number = n31;
			const o32:Number = n32;
			const o33:Number = n33;
			const o34:Number = n34;
			const o41:Number = n41;
			const o42:Number = n42;
			const o43:Number = n43;
			const o44:Number = n44;
			
			n11 =   det * ( o22 * ( o33 * o44 - o43 * o34 ) - o32 * ( o23 * o44 - o43 * o24 ) + o42 * ( o23 * o34 - o33 * o24 ) ) ;
			n12 = - det * ( o12 * ( o33 * o44 - o43 * o34 ) - o32 * ( o13 * o44 - o43 * o14 ) + o42 * ( o13 * o34 - o33 * o14 ) ) ;
			n13 =   det * ( o12 * ( o23 * o44 - o43 * o24 ) - o22 * ( o13 * o44 - o43 * o14 ) + o42 * ( o13 * o24 - o23 * o14 ) ) ;
			n14 = - det * ( o12 * ( o23 * o34 - o33 * o24 ) - o22 * ( o13 * o34 - o33 * o14 ) + o32 * ( o13 * o24 - o23 * o14 ) ) ;
			n21 = - det * ( o21 * ( o33 * o44 - o43 * o34 ) - o31 * ( o23 * o44 - o43 * o24 ) + o41 * ( o23 * o34 - o33 * o24 ) ) ;
			n22 =   det * ( o11 * ( o33 * o44 - o43 * o34 ) - o31 * ( o13 * o44 - o43 * o14 ) + o41 * ( o13 * o34 - o33 * o14 ) ) ;
			n23 = - det * ( o11 * ( o23 * o44 - o43 * o24 ) - o21 * ( o13 * o44 - o43 * o14 ) + o41 * ( o13 * o24 - o23 * o14 ) ) ;
			n24 =   det * ( o11 * ( o23 * o34 - o33 * o24 ) - o21 * ( o13 * o34 - o33 * o14 ) + o31 * ( o13 * o24 - o23 * o14 ) ) ;
			n31 =   det * ( o21 * ( o32 * o44 - o42 * o34 ) - o31 * ( o22 * o44 - o42 * o24 ) + o41 * ( o22 * o34 - o32 * o24 ) ) ;
			n32 = - det * ( o11 * ( o32 * o44 - o42 * o34 ) - o31 * ( o12 * o44 - o42 * o14 ) + o41 * ( o12 * o34 - o32 * o14 ) ) ;
			n33 =   det * ( o11 * ( o22 * o44 - o42 * o24 ) - o21 * ( o12 * o44 - o42 * o14 ) + o41 * ( o12 * o24 - o22 * o14 ) ) ;
			n34 = - det * ( o11 * ( o22 * o34 - o32 * o24 ) - o21 * ( o12 * o34 - o32 * o14 ) + o31 * ( o12 * o24 - o22 * o14 ) ) ;
			n41 = - det * ( o21 * ( o32 * o43 - o42 * o33 ) - o31 * ( o22 * o43 - o42 * o23 ) + o41 * ( o22 * o33 - o32 * o23 ) ) ;
			n42 =   det * ( o11 * ( o32 * o43 - o42 * o33 ) - o31 * ( o12 * o43 - o42 * o13 ) + o41 * ( o12 * o33 - o32 * o13 ) ) ;
			n43 = - det * ( o11 * ( o22 * o43 - o42 * o23 ) - o21 * ( o12 * o43 - o42 * o13 ) + o41 * ( o12 * o23 - o22 * o13 ) ) ;
			n44 =   det * ( o11 * ( o22 * o33 - o32 * o23 ) - o21 * ( o12 * o33 - o32 * o13 ) + o31 * ( o12 * o23 - o22 * o13 ) ) ;

			return this;
		}
	
		/**
		 * Transform a Vector3D or Point3D using this matrix, returning a new, transformed vector.
		 * 
		 * @param v The vector to transform.
		 * 
		 * @return The result of the transformation.
		 */
		public function transform( v:Transformable3D, result:Transformable3D = null ):Transformable3D
		{
			if( result == null )
			{
				result = new (v.classType)();
			}
			result.x = n11 * v.x + n12 * v.y + n13 * v.z + n14 * v.w;
			result.y = n21 * v.x + n22 * v.y + n23 * v.z + n24 * v.w;
			result.z = n31 * v.x + n32 * v.y + n33 * v.z + n34 * v.w;
			result.w = n41 * v.x + n42 * v.y + n43 * v.z + n44 * v.w;
			return result;
		}

		/**
		 * Transform a Vector3D or Point3D using this matrix, storing the result in the original 
		 * vector.
		 * 
		 * @param v The vector to transform.
		 * 
		 * @return A reference to the original (now transformed) vector.
		 */
		public function transformSelf( v:Transformable3D ):Transformable3D
		{
			var x:Number = v.x;
			var y:Number = v.y;
			var z:Number = v.z;
			var w:Number = v.w;
			v.x = n11 * x + n12 * y + n13 * z + n14 * w;
			v.y = n21 * x + n22 * y + n23 * z + n24 * w;
			v.z = n31 * x + n32 * y + n33 * z + n34 * w;
			v.w = n41 * x + n42 * y + n43 * z + n44 * w;
			return v;
		}

		/**
		 * Transform an array of Vector3D or Point3D objects using this matrix. The 
		 * results are returned in a new array.
		 * 
		 * @param v the array of Vector3D or Point3D objects to transform.
		 * 
		 * @return An array containing the new transformed vectors.
		 */
		public function transformArray( vectors:Array ):Array
		{
			var transformedVectors:Array = new Array();
			for each( var vector:Transformable3D in vectors )
			{
				transformedVectors.push( transform( vector ) );
			}
			return transformedVectors;
		}
		
		/**
		 * Transform an array of Vector3D or Point3D objects using this matrix. The 
		 * original vectors are modified to contain the new, transformed values.
		 * 
		 * @param v the array of Vector3D or Point3D objects to transform.
		 * 
		 * @return The original array, which now contains the transformed vectors.
		 */
		public function transformArraySelf( vectors:Array ):Array
		{
			for each( var vector:Transformable3D in vectors )
			{
				transformSelf( vector );
			}
			return vectors;
		}

		/**
		 * The positionelements of the matrix. This is the last column of the
		 * matrix, containing values n14, n24, n34, n44.
		 */
		public function get position():Point3D
		{
			var p:Point3D = new Point3D( n14, n24, n34 );
			p.w = n44;
			return p;
		}
		public function set position( value:Point3D ):void
		{
			n14 = value.x;
			n24 = value.y;
			n34 = value.z;
			n44 = value.w;
		}
		
		/**
		 * An array containing the sixteen values in the matrix, in row-major form.
		 * 
		 * <p>[n11, n12, n13, n14, n21, n22, n23, n24, n31, n32, n33, n34, n41, n42, n43, n44]</p>
		 */
		public function get rawData():Array
		{
			return [n11, n12, n13, n14,
				 n21, n22, n23, n24,
				 n31, n32, n33, n34,
				 n41, n42, n43, n44];
		}
		public function set rawData( values:Array ):void
		{
			if( values.length < 12 )
			{
				throw new Error( "The raw data for the Matrix3D class must contain 12 or 16 values" );
			}
			n11 = values[0];
			n12 = values[1];
			n13 = values[2];
			n14 = values[3];
			n21 = values[4];
			n22 = values[5];
			n23 = values[6];
			n24 = values[7];
			n31 = values[8];
			n32 = values[9];
			n33 = values[10];
			n34 = values[11];
			if( values.length < 16 )
			{
				n41 = 0;
				n42 = 0;
				n43 = 0;
				n44 = 1;
			}
			else
			{
				n41 = values[12];
				n42 = values[13];
				n43 = values[14];
				n44 = values[15];
			}
		}
		
		public function toString():String
		{
			return rawData.toString();
		}
	}
}
