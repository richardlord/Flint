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

package org.flintparticles.threeD.particles 
{
	import org.flintparticles.common.particles.ParticleFactory;
	import org.flintparticles.threeD.geom.Point3D;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;	

	public class Particle3DUtils 
	{
		public static function createPixelParticlesFromBitmapData( bitmapData:BitmapData, factory:ParticleFactory = null, offset:Point3D = null ):Array
		{
			if( offset == null )
			{
				offset = Point3D.ZERO;
			}
			var particles:Array = new Array();
			var width:int = bitmapData.width;
			var height:int = bitmapData.height;
			var y:int;
			var x:int;
			var p:Particle3D;
			var color:uint;
			if( factory )
			{
				for( y = 0; y < height; ++y )
				{
					for( x = 0; x < width; ++x )
					{
						color = bitmapData.getPixel32( x, y );
						if( color >>> 24 > 0 )
						{
							p = Particle3D( factory.createParticle() );
							p.position = new Point3D( x + offset.x, y + offset.y, offset.z );
							p.color = color;
							particles.push( p );
						}
					}
				}
			}
			else
			{
				for( y = 0; y < height; ++y )
				{
					for( x = 0; x < width; ++x )
					{
						color = bitmapData.getPixel32( x, y );
						if( color >>> 24 > 0 )
						{
							p = new Particle3D();
							p.position = new Point3D( x + offset.x, y + offset.y, offset.z );
							p.color = color;
							particles.push( p );
						}
					}
				}
			}
			return particles;
		}
		
		public static function createRectangleParticlesFromBitmapData( bitmapData:BitmapData, size:uint, factory:ParticleFactory = null, offset:Point3D = null ):Array
		{
			if( offset == null )
			{
				offset = Point3D.ZERO;
			}
			var particles:Array = new Array();
			var width:int = bitmapData.width;
			var height:int = bitmapData.height;
			var y:int;
			var x:int;
			var halfSize:Number = size * 0.5;
			offset.x += halfSize;
			offset.y -= halfSize;
			var p:Particle3D;
			var b:BitmapData;
			var m:Bitmap;
			var s:Sprite;
			var zero:Point = new Point( 0, 0 );
			if( factory )
			{
				for( y = 0; y < height; y += size )
				{
					for( x = 0; x < width; x += size )
					{
						p = Particle3D( factory.createParticle() );
						p.position = new Point3D( x + offset.x, -y + offset.y, offset.z );
						b = new BitmapData( size, size, true, 0 );
						b.copyPixels( bitmapData, new Rectangle( x, y, size, size ), zero );
						m = new Bitmap( b );
						m.x = -halfSize;
						m.y = -halfSize;
						s = new Sprite();
						s.addChild( m );
						p.image = s;
						p.collisionRadius = halfSize;
						particles.push( p );
					}
				}
			}
			else
			{
				for( y = 0; y < height; ++y )
				{
					for( x = 0; x < width; ++x )
					{
						p = new Particle3D();
						p.position = new Point3D( x + offset.x, -y + offset.y, offset.z );
						b = new BitmapData( size, size, true, 0 );
						b.copyPixels( bitmapData, new Rectangle( x, y, size, size ), zero );
						m = new Bitmap( b );
						m.x = -halfSize;
						m.y = -halfSize;
						s = new Sprite();
						s.addChild( m );
						p.image = s;
						p.collisionRadius = halfSize;
						particles.push( p );
					}
				}
			}
			return particles;
		}
	}
}
