module Sound exposing (..)

import List
import Platform.Cmd exposing (batch)

import WebAudio exposing (..)


type Note = G3 | C4 | E4 | G4 | Nope

soundUrl : Note -> String
soundUrl note =
  case note of
    G3 -> "/assets/g3.wav"
    C4 -> "/assets/c4.wav"
    E4 -> "/assets/e4.wav"
    G4 -> "/assets/g4.wav"
    Nope -> "/assets/nope.wav"

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