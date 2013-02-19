package com.halcyon.util.utilities 
{
	/**
	 * ...
	 * @author JCC
	 */
	public class MathUtils 
	{
		
		public static function round(val:Number):int 
		{
			return int(val +0.5);
		}
		
		public static function min(val1:*, val2:*):*
		{
			return (val1 > val2)?val2:val1;
		}

		public static function max(val1:*, val2:*):*
		{
			return (val1 < val2)?val2:val1;
		}
		
	}

}