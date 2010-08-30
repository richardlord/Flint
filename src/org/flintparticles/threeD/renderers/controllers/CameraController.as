package org.flintparticles.threeD.renderers.controllers
{
	import org.flintparticles.threeD.renderers.Camera;
	
	public interface CameraController
	{
		function get camera():Camera;
		function set camera( value:Camera ):void;
	}
}