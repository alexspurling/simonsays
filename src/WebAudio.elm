port module WebAudio exposing (..)

-- PORTS

port loadSound : String -> Cmd msg

port playSound : String -> Cmd msg
