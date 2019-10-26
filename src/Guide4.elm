module Main exposing (main)

import Browser
import Html exposing (Html, pre, text)
import Http
import Json.Decode as Json



--MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



--MODEL


type Model
    = Failure String
    | Loading
    | Success String


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , Http.get
        { url = "https://www.markuslaire.com/ajax/TimeNowUTC.php"
        , expect = Http.expectString GotText
        }
    )



--UPDATE


type Msg
    = GotText (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( Success fullText, Cmd.none )

                Err err ->
                    ( Failure (errorToString err), Cmd.none )


errorToString : Http.Error -> String
errorToString err =
    case err of
        Http.Timeout ->
            "Timeout exceeded"

        Http.NetworkError ->
            "Network error"

        Http.BadUrl url ->
            "Malformed url: " ++ url

        _ ->
            "Other"



--subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



--view


view : Model -> Html Msg
view model =
    case model of
        Failure errText ->
            text ("I was unable to load your book. " ++ errText)

        Loading ->
            text "loading"

        Success fullText ->
            pre [] [ text fullText ]
