*** Settings ***
Library           SeleniumLibrary
Library           String
Library           Collections

*** Variables ***
${SleepTime}      3    # sleep time in seconds
${name}           ${EMPTY}
${movie}          The Shawshank Redemption
@{names}
${genere}         ${EMPTY}
${action}         Action

*** Test Cases ***
TestCase1
    Open Browser    https://www.imdb.com/    Chrome
    sleep    ${SleepTime}
    input text    name=q    The Shawshank Redemption
    sleep    ${SleepTime}
    Click Button    id=suggestion-search-button
    sleep    ${SleepTime}
    ${names}=    Get WebElements    class:ipc-metadata-list-summary-item__t
    Element Text Should Be    ${names}[0]    ${movie}
    FOR    ${name}    IN    @{names}
        Element Should Contain    ${name}    ${movie}    ignore_case=True‏
    END
    sleep    ${SleepTime}
    Close Browser

TestCase2
    Open Browser    https://www.imdb.com/    Chrome
    sleep    ${SleepTime}
    Click Element    xpath=//*[@id="imdbHeader-navDrawerOpen"]
    sleep    ${SleepTime}
    Click Element    xpath=//*[@id="imdbHeader"]/div[2]/aside/div/div[2]/div/div[1]/span/div/div/ul/a[2]/span
    sleep    ${SleepTime}
    ${names}=    Get WebElements    class:titleColumn
    Element Should Contain    ${names}[0]    ${movie}
    ${ListSize}=    get Length    ${names}
    Should Be Equal    ${ListSize}    ${250}
    sleep    ${SleepTime}
    Close Browser

TestCase3
    Open Browser    https://www.imdb.com/    Chrome
    sleep    ${SleepTime}
    Click Element    class:ipc-btn__text
    sleep    ${SleepTime}
    Click Element    id=iconContext-find-in-page
    Click Element    xpath=//*[@id="main"]/div[2]/div[1]/a
    Click Element    xpath=//*[@id="genres-1"]
    input Text    xpath=//*[@id="main"]/div[3]/div[2]/input[1]    2010
    input Text    xpath=//*[@id="main"]/div[3]/div[2]/input[2]    2020
    sleep    ${SleepTime}
    Click Element    xpath=//*[@id="title_type-1"]
    sleep    ${SleepTime}
    Click Button    xpath=//*[@id="main"]/p[3]/button
    sleep    ${SleepTime}
    Click Element    xpath=//*[@id="main"]/div/div[2]/a[3]
    sleep    ${SleepTime}
    ${Arrofyears}=    Get WebElements    css:html.scriptsOn body#styleguide-v2.fixed div#wrapper div#root.redesign div#pagecontent.pagecontent div#content-2-wide.redesign div#main div.article div.lister.list.detail.sub-list div.lister-list div.lister-item.mode-advanced div.lister-item-content h3.lister-item-header span.lister-item-year.text-muted.unbold
    FOR    ${year}    IN    @{Arrofyears}
        ${templist}=    Split String    ${year.text}    ${space}
        ${length}=    get length    ${templist}
        ${length}=    evaluate    ${length}-1
        ${lastelement}=    evaluate    ${templist}[${length}]
        Should Be True    ${lastelement}>=2010
        Should Be True    ${lastelement}<=2020
    END
    ${Arrofratings}=    Get WebElements    css:html.scriptsOn body#styleguide-v2.fixed div#wrapper div#root.redesign div#pagecontent.pagecontent div#content-2-wide.redesign div#main div.article div.lister.list.detail.sub-list div.lister-list div.lister-item.mode-advanced div.lister-item-content div.ratings-bar div.inline-block.ratings-imdb-rating strong
    ${OriginalRatings}    Create List
    FOR    ${rate}    IN    @{Arrofratings}
        ${RateInnum}=    get text    ${rate}
        ${RateInnum}=    convert to Number    ${RateInnum}
        Append To List    ${OriginalRatings}    ${RateInnum}
    END
    ${ASCratings}=    Copy List    ${OriginalRatings}
    Sort List    ${ASCratings}
    reverse list    ${ASCratings}
    Lists Should Be Equal    ${ASCratings}    ${OriginalRatings}
    ${Arrofgenres}=    Get WebElements    class=genre
    FOR    ${genere}    IN    @{Arrofgenres}
        Element Should Contain    ${genere}    ${action}    ignore_case=True
    END
    sleep    ${SleepTime}
    Close Browser
