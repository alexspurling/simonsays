module Logo exposing (..)

import Array exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (..)
import Html exposing (Html)

type Colour
  = None
  | Green
  | Yellow
  | Purple
  | Blue

type alias ColourString = String

type Msg = Click Colour | NewGame (Array Colour) | Next | Wait

yellow : Colour -> ColourString
yellow light = if light == Yellow then "#ffc229" else "#F0AD00"
green : Colour -> ColourString
green light = if light == Green then "#8cfe2f" else "#7FD13B"
blue : Colour -> ColourString
blue light = if light == Blue then "#38d4ff" else "#60B5CC"
purple : Colour -> ColourString
purple light = if light == Purple then "#3b3b97" else "#5A6378"


yellowEdge : Colour -> Svg.Attribute Msg
yellowEdge light = (if light == Yellow then "stroke:#ffc229;stroke-width:2" else "") |> Svg.Attributes.style
greenEdge : Colour -> Svg.Attribute Msg
greenEdge light = (if light == Green then "stroke:#8cfe2f;stroke-width:2" else "") |> Svg.Attributes.style
blueEdge : Colour -> Svg.Attribute Msg
blueEdge light = (if light == Blue then "stroke:#38d4ff;stroke-width:2" else "") |> Svg.Attributes.style
purpleEdge : Colour -> Svg.Attribute Msg
purpleEdge light = (if light == Purple then "stroke:#3b3b97;stroke-width:2" else "") |> Svg.Attributes.style

logo : Colour -> Html Msg
logo light =
  svg [ version "1.1", x "0", y "0", viewBox "0 0 323.141 322.95" ]
    [ polygon [ (yellowEdge light), fill (yellow light), onClick (Click Yellow), points "161.649,152.782 231.514,82.916 91.783,82.916" ] []
    , polygon [ (greenEdge light), fill (green light), onClick (Click Green), points "8.867,0 79.241,70.375 232.213,70.375 161.838,0" ] []
    , rect
        [ (greenEdge light), fill (green light), onClick (Click Green)
        , x "192.99", y "107.392", width "107.676", height "108.167"
        , transform "matrix(0.7071 0.7071 -0.7071 0.7071 186.4727 -127.2386)"
        ]
        []
    , polygon [ (blueEdge light), fill (blue light), onClick (Click Blue), points "323.298,143.724 323.298,0 179.573,0" ] []
    , polygon [ (purpleEdge light), fill (purple light), onClick (Click Purple), points "152.781,161.649 0,8.868 0,314.432" ] []
    , polygon [ (yellowEdge light), fill (yellow light), onClick (Click Yellow), points "255.522,246.655 323.298,314.432 323.298,178.879" ] []
    , polygon [ (blueEdge light), fill (blue light), onClick (Click Blue), points "161.649,170.517 8.869,323.298 314.43,323.298" ] []
    ]
