package {
import com.agnither.game2048.Application;

[SWF (frameRate=60, width=800, height=800, backgroundColor=0xFFFFFF)]
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
