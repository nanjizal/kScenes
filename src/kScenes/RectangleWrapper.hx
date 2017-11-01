package kScenes;
import kha.Image;
class RectangleWrapper extends Wrapper {
    public function new( width_: Float, height_: Float, ?x_: Float = 0., ?y_: Float = 0. ){
		super( width_, height_, x_, y_ );
    }
	public function clone(): RectangleWrapper {
		var rectangleWrapper = new RectangleWrapper( width, height, x, y );
		rectangleWrapper.alpha = alpha;
		return rectangleWrapper;
	}
}