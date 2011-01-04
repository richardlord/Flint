package org.flintparticles.threeD.renderers.controllers
{
	import org.flintparticles.threeD.renderers.Camera;
	
	/**
	 * The interface for classes that manage the camera state based on key presses or other inputs.
	 */
	public interface CameraController
	{
		function get camera():Camera;
		function set camera( value:Camera ):void;
	}
}