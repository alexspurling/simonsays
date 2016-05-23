module Sound exposing (..)

import List
import Platform.Cmd exposing (batch)

import WebAudio exposing (..)


type Note = G3 | C4 | E4 | G4 | Nope

soundUrl : Note -> String
soundUrl note =
  case note of
    G3 -> "/sound/g3.wav"
    C4 -> "/sound/c4.wav"
    E4 -> "/sound/e4.wav"
    G4 -> "/sound/g4.wav"
    Nope -> "/sound/nope.wav"


initialiseSounds : Cmd msg
initialiseSounds =
  [G3, C4, E4, G4, Nope]
    |> List.map (WebAudio.loadSound << soundUrl)
    |> batch


playNote : Note -> Cmd msg
playNote note =
  note
    |> soundUrl
    |> WebAudio.playSound