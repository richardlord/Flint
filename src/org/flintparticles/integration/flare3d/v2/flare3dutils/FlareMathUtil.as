package org.flintparticles.integration.flare3d.v2.flare3dutils
{
	import flash.geom.Vector3D;

	public class FlareMathUtil
	{
		private static const MathPI:Number = Math.PI;
		public function FlareMathUtil()
		{
		}
		public static function quaternion2euler(quarternion:FQuaternion):Vector3D
		{
			var result:Vector3D = new Vector3D();
			
			var test :Number = quarternion.x*quarternion.y + quarternion.z*quarternion.w;
			if (test > 0.499) { // singularity at north pole
				result.x = 2 * Math.atan2(quarternion.x,quarternion.w);
				result.y = Math.PI/2;
				result.z = 0;
				return result;
			}
			if (test < -0.499) { // singularity at south pole
				result.x = -2 * Math.atan2(quarternion.x,quarternion.w);
				result.y = - Math.PI/2;
				result.z = 0;
				return result;
			}
			
			var sqx	:Number = quarternion.x*quarternion.x;
			var sqy	:Number = quarternion.y*quarternion.y;
			var sqz	:Number = quarternion.z*quarternion.z;
			
			result.x = Math.atan2(2*quarternion.y*quarternion.w - 2*quarternion.x*quarternion.z , 1 - 2*sqy - 2*sqz);
			result.y = Math.asin(2*test);
			result.z = Math.atan2(2*quarternion.x*quarternion.w-2*quarternion.y*quarternion.z , 1 - 2*sqx - 2*sqz);
			
			return result;
		}
		
	}
}