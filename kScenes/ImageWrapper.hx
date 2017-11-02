package kScenes;
import kha.Image;
class ImageWrapper extends Wrapper {
    public var image: Image;
    public function new( image_: Image, ?x_: Float = 0., ?y_: Float = 0. ){
        image = image_;
        super( image.width, image.height, x_, y_ );
    }
    public function clone(): ImageWrapper {
        var imageWrapper = new ImageWrapper( image, x, y );
        imageWrapper.alpha = alpha;
        return imageWrapper;
    }
}