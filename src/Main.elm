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

import Logo exposing (Colour(..), Msg(..))
import Sound exposing (Sound)
import Util

main : Program Never
main =
  Html.program {
    init = defaultState
    , view = renderModel
    , update = update
    , subscriptions = subscriptions }

type GameState
  = Start
  | Colour
  | Pause
  | WaitForInput


type alias Model =
  { sequence : Array Logo.Colour
  , lightIndex : Int -- The index in the array of the current light
  , state : GameState
  , sound : Sound
  }

defaultState : (Model, Cmd Msg)
defaultState =
  ({ sequence = Array.empty
  , lightIndex = 0
  , state = Start
  , sound = Sound.initialSound
  }
  , Random.generate NewGame (randomSequence 5))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = gameLoop msg model

gameLoop : Msg -> Model -> (Model, Cmd Msg)
gameLoop msg model =
  case msg of
    NewGame newSequence ->
      ({ model | sequence = newSequence }
       , delay (second * 1) Next)
    Next ->
      let
        currentHightlight = Maybe.withDefault Logo.None (Array.get model.lightIndex model.sequence)
        _ = Sound.playNote (lightToNote currentHightlight) model.sound
      in
        ({ model | state = Colour } --Colour the current colour for 1 second
        , delay (millisecond * 500) Wait)
    Wait ->
      let --Move to the next index, trigger the next colour or just wait if at the end
        lightIndex = model.lightIndex + 1
        lightFinished = lightIndex < (Array.length model.sequence)
        cmd = if lightFinished
          then (delay (millisecond * 100) Next)
          else Cmd.none
        newState = if lightFinished then WaitForInput else Pause
      in
        ({ model |
          lightIndex = lightIndex,
          state = newState }, cmd)
    Click light ->
      let
        _ = Sound.playNote (lightToNote light) model.sound
      in
        (model, Cmd.none)

delay : Time -> Msg -> Cmd Msg
delay t msg = Task.perform (always msg) (always msg) (Process.sleep t)

randomSequence : Int -> Random.Generator (Array Colour)
randomSequence length =
  Random.map Array.fromList (Random.list length (Util.oneOf [Green, Yellow, Purple, Blue]))

lightToNote light =
  case light of
    Purple -> Sound.G3
    Green -> Sound.C4
    Yellow -> Sound.E4
    Blue -> Sound.G4
    _ -> Sound.C4

renderModel : Model -> Html Msg
renderModel model =
  let
    currentHighlight =
      if model.state == Colour then
        Maybe.withDefault Logo.None (Array.get model.lightIndex model.sequence)
      else
        Logo.None
  in
    renderBoard currentHighlight


renderBoard : Colour -> Html Msg
renderBoard light =
  div [mainpanel]
    [
    h1 [] [text "Simon Says"],
    div [svgpanel] [Logo.logo light]
    ]

mainpanel : Html.Attribute Msg
mainpanel =
  style [
    ("margin-left","20%"),
    ("margin-right","20%"),
    ("margin-top","40px")
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
