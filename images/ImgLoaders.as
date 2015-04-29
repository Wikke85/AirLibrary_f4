package images
{
	public final class ImgLoaders
	{
		public function ImgLoaders()
		{
		}
		
		[Embed('loader.swf')] public static const loader:Class;
		[Embed('loader_inverted.swf')] public static const loader_inverted:Class;
		
	}
}