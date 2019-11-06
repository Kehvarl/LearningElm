port module StoredDuck exposing (..)

import Browser
import Html exposing (Attribute, Html, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (keyCode, on, onClick, onInput)
import Json.Decode as Json



--MAIN


main =
    Browser.document
        { init = init
        , update = updateWithStorage
        , view = \model -> { title = "Elm • Duck", body = [ view model ] }
        , subscriptions = \_ -> Sub.none
        }


port setStorage : Model -> Cmd msg



--MODEL


type alias Model =
    { question : String
    , content : List String
    }


init : Maybe Model -> ( Model, Cmd Msg )
init maybeModel =
    ( Maybe.withDefault { question = "", content = [] } maybeModel
    , Cmd.none
    )



--UPDATE


type Msg
    = Change String
    | Submit


updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg model =
    let
        ( newModel, cmds ) =
            update msg model
    in
    ( newModel
    , Cmd.batch [ setStorage newModel, cmds ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newQuestion ->
            ( { model | question = newQuestion }
            , Cmd.none
            )

        Submit ->
            ( { model | content = model.content ++ [ model.question ], question = "" }
            , Cmd.none
            )



--VIEW


view : Model -> Html Msg
view model =
    div []
        [ input
            [ placeholder "Quack?"
            , value model.question
            , onEnter Submit
            , onInput Change
            ]
            []
        , Html.button [ onClick Submit ] [ text "Quack!" ]
        , Html.ul [] <| List.map (\c -> Html.li [] [ text c ]) model.content
        ]


onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg

            else
                Json.fail "not ENTER"
    in
    on "keydown" (Json.andThen isEnter keyCode)
