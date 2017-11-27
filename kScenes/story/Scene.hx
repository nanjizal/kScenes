package kScenes.story;
import kScenes.actors.*;
import kha.graphics2.Graphics;
import kha.Framebuffer;
import kha.Canvas;
import kha.math.*;
import kha.Color;
import kha.Image;
class Scene {
    var backRectangles:         Array<Rectangle>     = new Array<Rectangle>();
    var images:                 Array<Picture>       = new Array<Picture>();
    var frontRectangles:        Array<Rectangle>     = new Array<Rectangle>();
    var texts:                  Array<Label>         = new Array<Label>();
    public var hitWraps:        Array<Actor>         = new Array<Actor>();
    var imageTotal:             Int = 0;
    var textTotal:              Int = 0;
    var backRectangleTotal:     Int = 0;
    var frontRectangleTotal:    Int = 0;
    public var sceneName:       String;
    public function new( sceneName_: String ){
        sceneName = sceneName_;
    }
    public function renderToImage(): Image {
        var left      =  10000000.;
        var top       =  10000000.;
        var right     = -10000000.;
        var bottom    = -10000000.;
        for( rect in backRectangles ) {
            var x0 = rect.ex;
            var y0 = rect.ey;
            var r0 = x0 + rect.width;
            var b0 = y0 + rect.height;
            if( x0 < left )     left = x0;
            if( y0 < top )      top = y0;
            if( r0 > right )    right = r0;
            if( b0 > bottom )   bottom = b0;
        }
        for( img in images ) {
            var x0 = img.ex;
            var y0 = img.ey;
            var r0 = x0 + img.width;
            var b0 = y0 + img.height;
            if( x0 < left )     left = x0;
            if( y0 < top )      top = y0;
            if( r0 > right )    right = r0;
            if( b0 > bottom )   bottom = b0;
        }
        for( tx in texts ) {
            var x0 = tx.ex;
            var y0 = tx.ey;
            var r0 = x0 + tx.width;
            var b0 = y0 + tx.height;
            if( x0 < left )     left = x0;
            if( y0 < top )      top = y0;
            if( r0 > right )    right = r0;
            if( b0 > bottom )   bottom = b0;
        }
        for( rect in frontRectangles ){
            var x0 = rect.ex;
            var y0 = rect.ey;
            var r0 = x0 + rect.width;
            var b0 = y0 + rect.height;
            if( x0 < left )     left = x0;
            if( y0 < top )      top = y0;
            if( r0 > right )    right = r0;
            if( b0 > bottom )   bottom = b0;
        }
        var wid     = Math.ceil( right );
        var hi      = Math.ceil( bottom ); 
        var image_  = Image.createRenderTarget( Math.ceil( wid ), Math.ceil( hi ), null, null, 4 );
        var g2      = image_.g2;
        g2.begin();
        g2.clear(Color.fromValue( 0x00000000 ));
        render( image_ );
        g2.end();
        return image_;
    }
    public function addBackRectangle( item: Rectangle ){
        backRectangles[ backRectangles.length ] = item;
        backRectangleTotal++;
    }
    public function addImage( item: Picture ){
        images[ images.length ] = item;
        imageTotal++;
    }
    public function addFrontRectangle( item: Rectangle ){
        frontRectangles[ frontRectangles.length ] = item;
        frontRectangleTotal++;
    }
    public function addText( item: Label ){
        texts[ texts.length ] = item;
        textTotal++;
    }
    public function addHit( item: Actor ){
        hitWraps[ hitWraps.length ] = item;
    }
    public function hide( ?delay: Float = 0. ){
        for( rect in backRectangles ) rect.hide( delay );
        for( img in images ) img.hide( delay );
        for( tx in texts ) tx.hide( delay );
        for( rect in frontRectangles ) rect.hide( delay );
    }
    public function show( ?delay: Float = 0. ){
        for( rect in backRectangles ) rect.show( delay );
        for( img in images ) img.show( delay );
        for( tx in texts ) tx.show( delay );
        for( rect in frontRectangles ) rect.show( delay );
    }
    public function checkHit( x: Float, y: Float ): Int {
        if( texts.length == 0 ) return -1;
        if( texts[ 0 ].alpha != 1. ) return -1; // need to rework tweens and use onFinish
        for( i in 0...hitWraps.length ){ 
            var item = hitWraps[ i ];
            if( item.hitable ) if( item.hitTest( x, y ) ) return i;
        }
        return -1;
    }
    public function render( canvas: Canvas){
        var g2 = canvas.g2;
        var l: Int;
        l = backRectangleTotal;
        for( i in 0...l ){
            var rect = backRectangles[ i ];
            if( rect != null ){
                if( rect.hasMatrix ) g2.transformation = rect.matrix;
                g2.opacity = rect.alpha;
                if( rect.colorFill != null ) {
                    g2.color = rect.colorFill;
                    g2.fillRect( rect.x, rect.y, rect.width, rect.height );
                }
                if( rect.colorLine != null ){
                    g2.color = rect.colorLine;
                    g2.drawRect( rect.x, rect.y, rect.width, rect.height, rect.strength );
                }
                g2.opacity = 1.;
                if( rect.hasMatrix ) g2.transformation = FastMatrix3.identity();
            }
        }
        g2.color = Color.White;
        l = imageTotal;
        for( i in 0...l ){
            var img = images[ i ];
            if( img != null ){
                if( img.hasMatrix ) g2.transformation = img.matrix;
                g2.opacity = img.alpha;
                g2.drawImage( img.image, img.x, img.y );
                g2.opacity = 1.;
                if( img.hasMatrix ) g2.transformation = img.matrix;
            }
        }
        l = frontRectangleTotal;
        for( i in 0...l ){
            var rect = frontRectangles[ i ];
            if( rect != null ){
                if( rect.hasMatrix ) g2.transformation = rect.matrix;
                g2.opacity = rect.alpha;
                if( rect.colorFill != null ) {
                    g2.color = rect.colorFill;
                    g2.fillRect( rect.x, rect.y, rect.width, rect.height );
                }
                if( rect.colorLine != null ){
                    g2.color = rect.colorLine;
                    g2.drawRect( rect.x, rect.y, rect.width, rect.height, rect.strength );
                }
                g2.opacity = 1.;
                if( rect.hasMatrix ) g2.transformation = rect.matrix;
            }
        }
        g2.color = Color.White;
        // text pre-rendered you need to call text.generateImage(); if you change text.
        l = textTotal;
        for( i in 0...l ){
            var img = texts[ i ];
            if( img != null ){
                if( !img.useImage || img.image == null ) { 
                    renderText( g2, img );
                } else {
                    if( img.hasMatrix ) g2.transformation = img.matrix;
                    g2.opacity = img.alpha;
                    g2.drawImage( img.image, img.x, img.y );
                    g2.opacity = 1.;
                    if( img.hasMatrix ) g2.transformation = FastMatrix3.identity();
                }
            }
        }
        g2.color = Color.White;
    }
    function renderText( g2: Graphics, tx: Label ){
        if( tx != null ){
            if( tx.hasMatrix ){
                g2.transformation = tx.matrix;
            }
            g2.font = tx.font;
            g2.fontSize = tx.size;
            g2.color = tx.color;
            g2.opacity = tx.alpha;
            if( tx.spacing == null ){
                g2.drawString( tx.content, tx.x, tx.y );
            } else {
                var spacing = tx.spacing;
                var size = tx.size;
                var letter: String;
                var letterW: Float = 0.;
                var dW = 0.;
                var font = tx.font;
                for( i in 0...tx.content.length ) {
                    letter = tx.content.substr( i, 1 );
                    dW += letterW;
                    g2.drawString( letter, tx.x + dW, tx.y );
                    if( letter == ' ' ){
                        letterW = font.width( size, letter );
                    } else {
                        letterW = font.width( size, letter ) + spacing;
                    }
                }
            }
            g2.opacity = 1.;
            if( tx.hasMatrix ){
                g2.transformation = FastMatrix3.identity();
            }
        }
    }
}