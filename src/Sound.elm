module Sound exposing (..)

import WebAudio exposing (..)

type alias Sound =
  { oscillator : OscillatorNode
  , gain : GainNode }

initialSound : Sound
initialSound =
  let
    destinationNode = (getDestinationNode DefaultContext)
    gain = createGainNode DefaultContext
    oscillator = createOscillatorNode DefaultContext Sine
    _ = connectNodes gain 0 0 oscillator
    _ = connectNodes destinationNode 0 0 gain

    _ = setValue 0 gain.gain
    _ = startOscillator 0 oscillator

    -- currentTime = getCurrentTime DefaultContext
    -- _ = setValue freq oscillator3.frequency
    -- -- _ = setValue 0 gain2.gain
    -- _ = setValueAtTime 0 currentTime gain2.gain
    -- _ = linearRampToValue 1 (currentTime + 0.01) gain2.gain
    -- _ = linearRampToValue 0 (currentTime + 1) gain2.gain
    -- _ = setValueAtTime 1 (currentTime + 0.1) gain2.gain
    -- _ = setValueAtTime 0 (currentTime + 0.1) gain2.gain
    -- _ = setTargetAtTime 1 (currentTime + 0) 0.05 gain2.gain
    -- _ = setTargetAtTime 0 (currentTime + 1) 0.05 gain.gain
    -- _ = setTargetAtTime 1 (currentTime + 2) 0.05 gain.gain
    -- _ = stopOscillator (currentTime + 1.2) oscillator
  in
    { oscillator = oscillator, gain = gain }

playNote : Float -> Sound -> Float
playNote freq sound =
  let
    -- _ = setValue 0 sound.gain.gain
    _ = setValue freq sound.oscillator.frequency
    currentTime = getCurrentTime DefaultContext
    _ = Debug.log "Playing sound at freq and time " (freq, currentTime)
    -- _ = setValue 1 sound.gain.gain
    -- _ = linearRampToValue 1 (currentTime + 0.1) sound.gain.gain
    _ = setTargetAtTime 1 (currentTime + 0.15) 0.001 sound.gain.gain
    _ = setTargetAtTime 0 (currentTime + 0.5) 0.05 sound.gain.gain
  in
    freq
