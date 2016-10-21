port module Main exposing (..)

import Html exposing (Html, div, text, br, button)
import Html.App as App
import Html.Events exposing (onClick)

import Debug exposing (log)

type alias Model =
  { default : Int
  }

type Msg =
  Increment

main : Program (Maybe Model)
main =
  App.programWithFlags
    { init = init
    , view = view
    , update = updateWithStorage
    , subscriptions = subscriptions
    }

port setStorage : Model -> Cmd msg

-- Copied verbatim from https://github.com/evancz/elm-todomvc/blob/master/Todo.elm
updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg model =
  let
    ( newModel, cmds ) =
      update msg model
  in
      ( newModel
      , Cmd.batch [ setStorage newModel, cmds ]
      )

model : Model
model =
  { default = 1 }

init : Maybe Model -> ( Model, Cmd Msg )
init savedModel =
  Maybe.withDefault model savedModel ! [ Cmd.none ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
      Increment ->
        ( { model | default = (model.default + 1) }
        , Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

view : Model -> Html Msg
view model =
  div []
    [ text ("default: " ++ (toString model.default))
    , br [][]
    , button [ onClick Increment ]
       [ text "Click Me" ]
    ]
