package kScenes.actors.advanced;
import kha.*;
import kScenes.actors.*;
class LabelGroup extends Picture{
    var arrTx: Array<Label>;
    public function new( arrTx_: Array<Label> ){
        arrTx = arrTx_;
        // calculate image size
        var left      =  10000000.;
        var top       =  10000000.;
        var right     = -10000000.;
        var bottom    = -10000000.;
        for( txW in arrTx ){
            var x0 = txW.ex;
            var y0 = txW.ey;
            var r0 = x0 + txW.width;
            var b0 = y0 + txW.height;
            if( x0 < left )     left = x0;
            if( y0 < top )      top = y0;
            if( r0 > right )    right = r0;
            if( b0 > bottom )   bottom = b0;
        }
        var wid     = Math.ceil( right - left );
        var hi      = Math.ceil( bottom - top ); 
        var image_  = Image.createRenderTarget( Math.ceil( wid ), Math.ceil( hi ), null, null, 4 );
        var g2      = image_.g2;
        g2.begin();
        g2.clear(Color.fromValue( 0x00000000 ));
        for( txW in arrTx ) txW.generateOnG2( g2, txW.ex - left, txW.ey - top );
        g2.end();
        super( image_, left, top );
    }
}