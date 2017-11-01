package kScenes;
import kha.Font;
import kha.Color;
class TextWrapper extends Wrapper {
	public var content: String;
	public var font: Font;
	public var color: Color;
	public var size: Int;
	public var spacing: Float;
    public function new( 	content_: 	String
						, 	font_: 		Font
						, 	color_: 	Color
						,   size_: 		Int
						,   ?spacing_:   Float = -1.
						,   ?x_: Float = 0., ?y_: Float = 0. ){
        content = content_;
		font = font_;
		color = color_;
		size = size_;
		spacing = spacing_;
		var width_ = font.width( size, content );
		var height_ = font.height( size );
		super( width_, height_, x_, y_ );
    }
	public function clone(): TextWrapper {
		var textWrapper = new TextWrapper( content, font, color, size, x, y );
		textWrapper.alpha = alpha;
		return textWrapper;
	}
}