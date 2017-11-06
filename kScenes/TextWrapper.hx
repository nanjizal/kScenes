package kScenes;
import kha.Font;
import kha.Color;
import kha.Image;
import kha.graphics2.Graphics;
class TextWrapper extends Wrapper {
    public var content: String;
    public var font: Font;
    public var color: Color;
    public var size: Int;
    public var spacing: Float;
    public var image: Image;
    public var useImage: Bool;
    public function new(     content_:     String
                        ,     font_:         Font
                        ,     color_:     Color
                        ,   size_:         Int
                        ,   ?spacing_:   Float = -1.
                        ,   ?x_: Float = 0., ?y_: Float = 0., useImage_: Bool = true ){
        content = content_;
        font = font_;
        color = color_;
        size = size_;
        spacing = spacing_;
        useImage = useImage_;
        var width_: Float;
        if( spacing == null ){
             width_ = font.width( size, content );
        } else {
            var dW = 0.;
            for( i in 0...content.length ) {
                dW += font.width( size, content.substr( i, 1 ) );
                dW += spacing;
            }
            width_ = dW - spacing;
        }
        var height_ = font.height( size );
        super( width_, height_, x_, y_ );
        if( useImage ) generateImage();
    }
    public function clone(): TextWrapper {
        var textWrapper = new TextWrapper( content, font, color, size, x, y );
        textWrapper.alpha = alpha;
        return textWrapper;
    }
    public function generateImage(){
        image    = Image.createRenderTarget( Math.ceil( width ), Math.ceil( height ), null, null, 4 );
        var g2  = image.g2;
        g2.begin();
        g2.clear(Color.fromValue(0x00000000));
        g2.font     = font;
        g2.fontSize = size;
        g2.color    = color;
        g2.opacity  = 1.0;
        if( spacing == null ){
            g2.drawString( content, 0, 0 );
        } else {
            var spacing = spacing;
            var size = size;
            var letter: String;
            var letterW: Float = 0.;
            var dW = 0.;
            var font = font;
            for( i in 0...content.length ) {
                letter = content.substr( i, 1 );
                dW += letterW;
                g2.drawString( letter, dW, 0 );
                if( letter == ' ' ){
                    letterW = font.width( size, letter );
                } else {
                    letterW = font.width( size, letter ) + spacing;
                }
            }
        }
        g2.end();
        useImage = true;
    }
    public function generateOnG2( g2: Graphics, ?dx: Float = 0., ?dy: Float = 0.){
        g2.font     = font;
        g2.fontSize = size;
        g2.color    = color;
        g2.opacity  = 1.0;
        if( spacing == null ){
            g2.drawString( content, dx, dy );
        } else {
            var spacing = spacing;
            var size = size;
            var letter: String;
            var letterW: Float = 0.;
            var dW = 0.;
            var font = font;
            for( i in 0...content.length ) {
                letter = content.substr( i, 1 );
                dW += letterW;
                g2.drawString( letter, dW + dx, dy );
                if( letter == ' ' ){
                    letterW = font.width( size, letter );
                } else {
                    letterW = font.width( size, letter ) + spacing;
                }
            }
        }
    }
    
}