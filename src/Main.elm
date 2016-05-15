module Main exposing (..)

import Array exposing (Array)
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Task
import Process
import Time exposing (Time, second, millisecond)
import Maybe
import Random

import Logo exposing (Colour(..))
import Sound exposing (Sound)
import Util

main : Program Never
main =
  Html.program {
    init = defaultState
    , view = renderModel
    , update = update
    , subscriptions = subscriptions }

type Msg
  = NewGame (Array Colour)
  | Next
  | Wait
  | Done
  | Click Colour
  | NextColour Colour
  | GameOver

type GameState
  = Play
  | WaitForInput


type alias Model =
  { sequence : Array Logo.Colour
  , lightIndex : Int -- The index in the array of the current light
  , light : Colour --The colour to highlight
  , state : GameState
  , sound : Sound
  , highscore : Int
  }

defaultState : (Model, Cmd Msg)
defaultState =
  ({ sequence = Array.empty
  , lightIndex = 0
  , light = Logo.None
  , state = Play
  , sound = Sound.initialSound
  , highscore = 0
  }
  , Random.generate NewGame (randomSequence 1))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = gameLoop msg model

gameLoop : Msg -> Model -> (Model, Cmd Msg)
gameLoop msg model =
  case msg of
    NewGame newSequence ->
      ({ model | sequence = newSequence, state = Play }
       , delay (second * 1) Next)
    Next ->
      let
        curLight = Maybe.withDefault Logo.None (Array.get model.lightIndex model.sequence)
        _ = Sound.playNote (lightToNote curLight) model.sound
      in
        ({ model | light = curLight, lightIndex = model.lightIndex + 1 }
        , delay (millisecond * 500) Wait)
    Wait ->
      if model.lightIndex < (Array.length model.sequence) then
        ({ model | light = Logo.None }, (delay (millisecond * 100) Next))
      else
        --Sequence has finished
        ({ model | light = Logo.None
         , state = WaitForInput
         , lightIndex = 0 }, Cmd.none)
    Click light ->
      if model.state == WaitForInput then
        let
          expectedColour = Maybe.withDefault Logo.None (Array.get model.lightIndex model.sequence)
          (newIndex, sound, cmd) = if expectedColour == light then
            guessedRight model light
          else
            guessedWrong
          _ = Sound.playNote sound model.sound
        in
          ({ model | light = light, lightIndex = newIndex }, delay (millisecond * 500) cmd)
      else
        (model, Cmd.none)
    NextColour colour ->
      --Add the new colour onto the sequence and start again from the beginning
      ({ model | sequence = Array.push colour model.sequence
      , lightIndex = 0
      , state = Play }
      , delay (second * 1) Next)
    Done ->
      --If the entire sequence was guessed correctly, then add another random
      --colour to the end and restart
      let
        sequenceComplete = model.lightIndex == Array.length model.sequence
        cmd = if sequenceComplete then
          Random.generate NextColour (Util.oneOf [Green, Yellow, Purple, Blue])
        else
          Cmd.none
        highscore = if sequenceComplete then
          Basics.max model.highscore (Array.length model.sequence)
        else
          model.highscore
      in
        ({ model | light = Logo.None, highscore = highscore }, cmd)
    GameOver ->
      ({ model | light = Logo.None }, Random.generate NewGame (randomSequence 1))

guessedRight : Model -> Colour -> (Int, Sound.Note, Msg)
guessedRight model light =
  (model.lightIndex + 1, lightToNote light, Done)

guessedWrong : (Int, Sound.Note, Msg)
guessedWrong =
  (0, Sound.Nope, GameOver)

delay : Time -> Msg -> Cmd Msg
delay t msg = Task.perform (always msg) (always msg) (Process.sleep t)

randomSequence : Int -> Random.Generator (Array Colour)
randomSequence length =
  Random.map Array.fromList (Random.list length (Util.oneOf [Green, Yellow, Purple, Blue]))

lightToNote : Colour -> Sound.Note
lightToNote light =
  case light of
    Purple -> Sound.G3
    Green -> Sound.C4
    Yellow -> Sound.E4
    Blue -> Sound.G4
    None -> Sound.C4

renderModel : Model -> Html Msg
renderModel model =
  div [mainpanel]
    [
    h1 [] [text "Simon Says"],
    p [] [text ("Highscore: " ++ (toString model.highscore))],
    div [svgpanel] [Html.map logoMsgToMainMsg (Logo.logo model.light)]
    ]

logoMsgToMainMsg : Logo.Msg -> Msg
logoMsgToMainMsg logoMsg =
  case logoMsg of
    Logo.Click colour -> Click colour

mainpanel : Html.Attribute Msg
mainpanel =
  style [
    ("margin-left","20%"),
    ("margin-right","20%"),
    ("margin-top","20px")
    ]

svgpanel : Html.Attribute Msg
svgpanel =
  style [
    ("width","500px"),
    ("height","500px")
    ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
