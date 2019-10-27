module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random



--MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



--MODEL


type Face
    = One
    | Two
    | Three
    | Four
    | Five
    | Six


type alias Model =
    { dieFace : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 1
    , Cmd.none
    )



--UPDATE


type Msg
    = Roll
    | NewFace Int


roll : Random.Generator Int
roll =
    Random.weighted
        ( 10, 1 )
        [ ( 10, 2 )
        , ( 10, 3 )
        , ( 10, 4 )
        , ( 20, 5 )
        , ( 40, 6 )
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Random.generate NewFace roll
            )

        NewFace newFace ->
            ( Model newFace
            , Cmd.none
            )



--subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



--VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text (String.fromInt model.dieFace) ]
        , button [ onClick Roll ] [ text "Roll" ]
        ]


fromFace : Face -> String
fromFace face =
    case face of
        One ->
            "1"

        Two ->
            "2"

        Three ->
            "3"

        Four ->
            "4"

        Five ->
            "5"

        Six ->
            "6"
