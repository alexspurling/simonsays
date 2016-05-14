module Sound exposing (..)

import WebAudio exposing (..)

type alias Sound =
  { g3 : MediaElementAudioSourceNode
  , c4 : MediaElementAudioSourceNode
  , e4 : MediaElementAudioSourceNode
  , g4 : MediaElementAudioSourceNode
  , nope : MediaElementAudioSourceNode }

type Note = G3 | C4 | E4 | G4 | Nope

initialSound : Sound
initialSound =
  let
    g3 = getMediaElement "/assets/g32.wav"
    c4 = getMediaElement "/assets/c42.wav"
    e4 = getMediaElement "/assets/e42.wav"
    g4 = getMediaElement "/assets/g42.wav"
    nope = getMediaElement "/assets/nope.wav"
  in
    { g3 = g3, c4 = c4, e4 = e4, g4 = g4, nope = nope }

playNote : Note -> Sound -> ()
playNote note sound =
  let
    _ = case note of
          G3 -> playMediaElement sound.g3
          C4 -> playMediaElement sound.c4
          E4 -> playMediaElement sound.e4
          G4 -> playMediaElement sound.g4
          Nope -> playMediaElement sound.nope
  in
    ()

getMediaElement : String -> MediaElementAudioSourceNode
getMediaElement soundFile =
  createHiddenMediaElementAudioSourceNode WebAudio.DefaultContext
    |> connectNodes (getDestinationNode DefaultContext) 0 0
    |> setMediaElementSource soundFile
