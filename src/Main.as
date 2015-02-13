package {
import com.agnither.game2048.Application;

[SWF (frameRate=60, width=500, height=500, backgroundColor=0)]
public class Main extends StarlingMainBase {

    public function Main() {
        super(Application);
    }

    override protected function initialize():void {
        super.initialize();

        showStats = true;
    }
}
}
