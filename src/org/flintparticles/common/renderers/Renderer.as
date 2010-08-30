/*
 * FLINT PARTICLE SYSTEM
 * .....................
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

package org.flintparticles.common.renderers 
{
	import org.flintparticles.common.emitters.Emitter;					

	/**
	 * The Renderer interface must be implemented by all renderers. A renderer 
	 * is a class that draws the particles that are managed by an emitter. A 
	 * renderer can display the contents of a number of emitters.
	 */
	public interface Renderer
	{
		/**
		 * Add an emitter to this renderer. The renderer should draw all the 
		 * particles that are being managed by the emitter.
		 * 
		 * @param emitter The emitter whose particles should be drawn by the 
		 * renderer
		 */
		function addEmitter( emitter : Emitter ) : void;

		/**
		 * Stop rendering particles that are managed by this emitter.
		 * 
		 * @param emitter The emitter whose particles should no longer be
		 * drawn by the renderer.
		 */
		function removeEmitter( emitter : Emitter ) : void;
	}
}
