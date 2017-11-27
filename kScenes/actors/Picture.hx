package kScenes.actors;
import kha.Image;
import kha.graphics4.DepthStencilFormat;  
import kha.graphics4.TextureFormat;
class Picture extends Actor {
    public var image: Image;
    public static function fromDimensions( width: Float, height: Float, ?x_: Float = 0., ?y_: Float = 0. ): Picture {
        var image_ = Image.createRenderTarget( Math.ceil( width ), Math.ceil( height ), TextureFormat.RGBA32, DepthStencilFormat.DepthOnly, 4 );
        //var image_ = Image.createRenderTarget( Math.ceil( width ), Math.ceil( height ), null, null, 4 );
        return new Picture( image_, x_, y_ );
    }
    public function new( image_: Image, ?x_: Float = 0., ?y_: Float = 0. ){
        image = image_;
        super( image.width, image.height, x_, y_ );
    }
}