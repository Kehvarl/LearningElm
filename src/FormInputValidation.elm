module Main exposing (Model, init, main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



--MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



--MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    }


init : Model
init =
    Model "" "" ""



--UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }



--VIEW`


view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name Name
        , viewInput "password" "Password" model.password Password
        , viewInput "password" "Re-Enter PAssword" model.passwordAgain PasswordAgain
        , viewValidation model
        ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


viewValidation : Model -> Html msg
viewValidation model =
    let
        ( messagecolor, message ) =
            validation model
    in
    div [ style "color" messagecolor ] [ text message ]


validation : Model -> ( String, String )
validation model =
    let
        password =
            model.password

        passwordAgain =
            model.passwordAgain
    in
    if not (password == passwordAgain) then
        ( "red", "Passwords do not match!" )

    else if String.length password < 8 then
        ( "red", "Password must be at least 8 characters" )

    else if not (validationMixedCase password) then
        ( "red", "Passwords must contain both upper and lower-case letters" )

    else if not (String.any Char.isDigit password) then
        ( "red", "Passwords must contain at least one number" )

    else
        ( "green", "OK" )


validationMixedCase : String -> Bool
validationMixedCase password =
    String.any Char.isUpper password && String.any Char.isLower password
