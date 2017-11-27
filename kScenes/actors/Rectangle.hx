package kScenes.actors;
import kha.Image;
import kha.Color;
class Rectangle extends Actor {
    public var colorLine: Color = 0;
    public var colorFill: Color = 0;
    public var strength:  Float = 0.;
    public function new(    width_:     Float,      height_:     Float
                        ,   colorLine_: Color,      colorFill_:  Color
                        ,   strength_:  Float
                        ,   ?x_:        Float = 0., ?y_:         Float = 0. ){
        colorLine = colorLine_;
        colorFill = colorFill_;
        strength  = strength_;
        super( width_, height_, x_, y_ );
    }
}