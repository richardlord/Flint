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

package org.flintparticles.twoD.particles 
{
	import org.flintparticles.common.particles.ParticleFactory;
	import org.flintparticles.common.utils.DisplayObjectUtils;
	import org.flintparticles.common.utils.Maths;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;	

	public class Particle2DUtils 
	{
		/**
		 * Adds existing display objects as particles to the emitter. This allows you, for example, 
		 * to take an existing image and subject it to the actions of the emitter.
		 * 
		 * <p>This method moves all the display objects into the emitter's renderer,
		 * removing them from their current position within the display list. It will
		 * only work if a renderer has been defined for the emitter and the renderer has
		 * been added to the display list.</p>
		 * 
		 * @param renderer The display object whose coordinate system the display object's position
		 * is converted to. This is usually the renderer for the particle system created by the emitter.
		 * @param objects Each parameter is another display object for adding to the emitter.
		 * If you pass an array as the parameter, each item in the array should be another
		 * display object for adding to the emitter.
		 */
		public static function createParticles2DFromDisplayObjects( displayObjects:Array, renderer:DisplayObject = null, factory:ParticleFactory = null ):Array
		{
			var particles:Array = new Array();
			for( var i:Number = 0; i < displayObjects.length; ++i )
			{
				particles.push( createParticle2DFromDisplayObject( displayObjects[i], renderer, factory ) );
			}
			return particles;
		}
		
		/*
		 * Used internally to add an individual display object to the emitter
		 */
		public static function createParticle2DFromDisplayObject( obj:DisplayObject, renderer:DisplayObject = null, factory:ParticleFactory = null ):Particle2D
		{
			var particle:Particle2D;
			if( factory )
			{
				particle = Particle2D( factory.createParticle() );
			}
			else
			{
				particle = new Particle2D();
			}
			if ( obj.parent && renderer )
			{
				var p : Point = renderer.globalToLocal( obj.localToGlobal( new Point( 0, 0 ) ) );
				particle.x = p.x;
				particle.y = p.y;
				var r : Number = DisplayObjectUtils.globalToLocalRotation( renderer, DisplayObjectUtils.localToGlobalRotation( obj, 0 ) );
				particle.rotation = Maths.asRadians( r );
				obj.parent.removeChild( obj );
			}
			else
			{
				particle.x = obj.x;
				particle.y = obj.y;
				particle.rotation = Maths.asRadians( obj.rotation );
			}
			particle.image = obj;
			var rad:Number = ( obj.width + obj.height ) / 4;
			if( rad != 0 )
			{
				particle.collisionRadius = rad;
			}
			return particle;
		}

		public static function createPixelParticlesFromBitmapData( bitmapData:BitmapData, factory:ParticleFactory = null, offsetX:Number = 0, offsetY:Number = 0 ):Array
		{
			var particles:Array = new Array();
			var width:int = bitmapData.width;
			var height:int = bitmapData.height;
			var y:int;
			var x:int;
			var p:Particle2D;
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
							p = Particle2D( factory.createParticle() );
							p.x = x + offsetX;
							p.y = y + offsetY;
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
							p = new Particle2D();
							p.x = x + offsetX;
							p.y = y + offsetY;
							p.color = color;
							particles.push( p );
						}
					}
				}
			}
			return particles;
		}
		
		public static function createRectangleParticlesFromBitmapData( bitmapData:BitmapData, size:uint, factory:ParticleFactory = null, offsetX:Number = 0, offsetY:Number = 0 ):Array
		{
			var particles:Array = new Array();
			var width:int = bitmapData.width;
			var height:int = bitmapData.height;
			var y:int;
			var x:int;
			var halfSize:Number = size * 0.5;
			offsetX += halfSize;
			offsetY += halfSize;
			var p:Particle2D;
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
						p = Particle2D( factory.createParticle() );
						p.x = x + offsetX;
						p.y = y + offsetY;
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
						p = new Particle2D();
						p.x = x + offsetX;
						p.y = y + offsetY;
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
