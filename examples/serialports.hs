import System.Hardware.Serialport.Probe
import Control.Monad

main :: IO ()
main = do
    ports <- probeSerialPorts
    forM_ ports $ \(dev, descr) ->
        putStrLn $ dev ++ ": " ++ descr
