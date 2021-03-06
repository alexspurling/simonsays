module Main exposing (..)

import Array exposing (Array)
import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Task
import Process
import Time exposing (Time, second, millisecond)
import Maybe
import Random
import Platform.Cmd exposing (batch)

import Logo exposing (Colour(..))
import Sound
import Util

main : Program Never
main =
  Html.App.program {
    init = initialState
    , view = renderModel
    , update = update
    , subscriptions = subscriptions }

type Msg
  = NewGame (Array Colour)
  | Next
  | Wait
  | Done Int
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
  , highscore : Int
  }

initialState : (Model, Cmd Msg)
initialState =
  ({ sequence = Array.empty
  , lightIndex = 0
  , light = Logo.None
  , state = Play
  , highscore = 0
  }
  , batch [Sound.initialiseSounds, (Random.generate NewGame (randomSequence 1))])

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
        sound = Sound.playNote (lightToNote curLight)
      in
        ({ model | light = curLight, lightIndex = model.lightIndex + 1 }
        , batch [sound, delay (millisecond * 500) Wait])
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

          guessedRight model light =
            (model.lightIndex + 1, lightToNote light, Done (model.lightIndex + 1))

          guessedWrong =
            (0, Sound.Nope, GameOver)

          (newIndex, note, cmd) = if expectedColour == light then
              guessedRight model light
            else
              guessedWrong
          sound = Sound.playNote note
        in
          ({ model | light = light, lightIndex = newIndex }
          , batch [sound, delay (millisecond * 500) cmd])
      else
        (model, Cmd.none)
    NextColour colour ->
      --Add the new colour onto the sequence and start again from the beginning
      ({ model | sequence = Array.push colour model.sequence
      , lightIndex = 0
      , state = Play }
      , delay (second * 1) Next)
    Done prevLightIndex ->
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

        --Only update the light colour if the model hasn't moved on
        --to the next index already
        light = if prevLightIndex >= model.lightIndex then
            Logo.None
          else
            model.light
      in
        ({ model | light = light, highscore = highscore }, cmd)
    GameOver ->
      ({ model | light = Logo.None }, Random.generate NewGame (randomSequence 1))


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
    div [svgpanel] [Html.App.map logoMsgToMainMsg (Logo.logo model.light)]
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
