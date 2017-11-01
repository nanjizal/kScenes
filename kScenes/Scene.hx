package kScenes;
import kScenes.ImageWrapper;
import kScenes.TextWrapper;
import kha.graphics2.Graphics;
import kha.math.*;
import kha.Color;
class Scene {
	var backRectangles: 		Array<RectangleWrapper> = new Array<RectangleWrapper>();
	var images: 				Array<ImageWrapper> 	= new Array<ImageWrapper>();
	var frontRectangles: 		Array<RectangleWrapper> = new Array<RectangleWrapper>();
	var texts: 					Array<TextWrapper> 		= new Array<TextWrapper>();
	var imageTotal: 			Int = 0;
	var textTotal: 				Int = 0;
	var backRectangleTotal: 	Int = 0;
	var frontRectangleTotal: 	Int = 0;
	var sceneName: 				String;
	public function new( sceneName_: String ){
		sceneName = sceneName_;
	}
	public function addBackRectangle( item: RectangleWrapper ){
		backRectangles[ backRectangles.length ] = item;
		backRectangleTotal++;
	}
	public function addImage( item: ImageWrapper ){
		images[ images.length ] = item;
		imageTotal++;
	}
	public function addFrontRectangle( item: RectangleWrapper ){
		frontRectangles[ frontRectangles.length ] = item;
		frontRectangleTotal++;
	}
	public function addText( item: TextWrapper ){
		texts[ texts.length ] = item;
		textTotal++;
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
	public function render( g2: Graphics ){
		var l: Int;
		l = backRectangleTotal;
		for( i in 0...l ){
			var rect = backRectangles[ i ];
			if( rect != null ){
				if( rect.hasMatrix ){
					g2.transformation = rect.matrix;
				}
				g2.opacity = rect.alpha;
                g2.drawRect( rect.x, rect.y, rect.width, rect.height );
                g2.opacity = 1.;
				if( rect.hasMatrix ){
					g2.transformation = FastMatrix3.identity();
				}
			}
		}
		l = imageTotal;
        for( i in 0...l ){
            var img = images[ i ];
            if( img != null ){
				if( img.hasMatrix ){
					g2.transformation = img.matrix;
				}
                g2.opacity = img.alpha;
                g2.drawImage( img.image, img.x, img.y );
                g2.opacity = 1.;
				if( img.hasMatrix ){
					g2.transformation = FastMatrix3.identity();
				}
            }
        }
		l = frontRectangleTotal;
		for( i in 0...l ){
			var rect = frontRectangles[ i ];
			if( rect != null ){
				if( rect.hasMatrix ){
					g2.transformation = rect.matrix;
				}
				g2.opacity = rect.alpha;
                g2.drawRect( rect.x, rect.y, rect.width, rect.height );
                g2.opacity = 1.;
				if( rect.hasMatrix ){
					g2.transformation = FastMatrix3.identity();
				}
			}
		}
		l = textTotal;
		for( i in 0...l ){
			var tx = texts[ i ];
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
		g2.color = Color.White;
	}
}