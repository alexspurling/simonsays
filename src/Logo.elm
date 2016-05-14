module Logo exposing (..)

import Array exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (..)
import Html exposing (Html)

type Highlight
  = None
  | HGreen
  | HYellow
  | HPurple
  | HBlue

type alias ColourString = String

type Msg = Click Highlight | NewGame (Array Highlight) | Next | Wait

yellow : Highlight -> ColourString
yellow highlight = if highlight == HYellow then "#ffc229" else "#F0AD00"
green : Highlight -> ColourString
green highlight = if highlight == HGreen then "#8cfe2f" else "#7FD13B"
blue : Highlight -> ColourString
blue highlight = if highlight == HBlue then "#38d4ff" else "#60B5CC"
purple : Highlight -> ColourString
purple highlight = if highlight == HPurple then "#3b3b97" else "#5A6378"


yellowEdge : Highlight -> Svg.Attribute Msg
yellowEdge highlight = (if highlight == HYellow then "stroke:#ffc229;stroke-width:2" else "") |> Svg.Attributes.style
greenEdge : Highlight -> Svg.Attribute Msg
greenEdge highlight = (if highlight == HGreen then "stroke:#8cfe2f;stroke-width:2" else "") |> Svg.Attributes.style
blueEdge : Highlight -> Svg.Attribute Msg
blueEdge highlight = (if highlight == HBlue then "stroke:#38d4ff;stroke-width:2" else "") |> Svg.Attributes.style
purpleEdge : Highlight -> Svg.Attribute Msg
purpleEdge highlight = (if highlight == HPurple then "stroke:#3b3b97;stroke-width:2" else "") |> Svg.Attributes.style

logo : Highlight -> Html Msg
logo highlight =
  let
    colourYellow = yellow highlight
    colourGreen = green highlight
    colourBlue = blue highlight
    colourPurple = purple highlight
    edgeYellow = yellowEdge highlight
    edgeGreen = greenEdge highlight
    edgeBlue = blueEdge highlight
    edgePurple = purpleEdge highlight
  in
    svg [ version "1.1", x "0", y "0", viewBox "0 0 323.141 322.95" ]
      [ polygon [ edgeYellow, fill colourYellow, onClick (Click HYellow), points "161.649,152.782 231.514,82.916 91.783,82.916" ] []
      , polygon [ edgeGreen, fill colourGreen, onClick (Click HGreen), points "8.867,0 79.241,70.375 232.213,70.375 161.838,0" ] []
      , rect
          [ edgeGreen, fill colourGreen, onClick (Click HGreen)
          , x "192.99", y "107.392", width "107.676", height "108.167"
          , transform "matrix(0.7071 0.7071 -0.7071 0.7071 186.4727 -127.2386)"
          ]
          []
      , polygon [ edgeBlue, fill colourBlue, onClick (Click HBlue), points "323.298,143.724 323.298,0 179.573,0" ] []
      , polygon [ edgePurple, fill colourPurple, onClick (Click HPurple), points "152.781,161.649 0,8.868 0,314.432" ] []
      , polygon [ edgeYellow, fill colourYellow, onClick (Click HYellow), points "255.522,246.655 323.298,314.432 323.298,178.879" ] []
      , polygon [ edgeBlue, fill colourBlue, onClick (Click HBlue), points "161.649,170.517 8.869,323.298 314.43,323.298" ] []
      ]
