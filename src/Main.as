package {
import com.agnither.game2048.Application;

[SWF (frameRate=60, width=1024, height=1024, backgroundColor=0)]
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
