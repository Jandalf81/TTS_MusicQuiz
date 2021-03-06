function loadLangStrings()
    local bbOk = '[00FF00]'
    local bbWarning = '[FFFF00]'
    local bbError = '[FF0000]'
    local bbHighlight = '[AAAA00]'

    LANG_MEMORY_POOLTOOSMALL =
        '{en}Pool has only <poolentries> songs, please create a smaller field' ..
        '{de}Der Pool hat nur <poolentries> Songs, bitte erstelle ein kleineres Feld'
    LANG_MEMORY_HIT =  
        '{en}' .. bbOk .. 'Hit[-]' ..
        '{de}' .. bbOk .. 'Treffer[-]'
    LANG_MEMORY_MISS = 
        '{en}' .. bbError .. 'Miss[-]' ..
        '{de}' .. bbError .. 'Daneben[-]'

    LANG_READINGSONGPACK_WAIT = 
        '{en}' .. bbWarning .. 'Reading Songpack, please wait...[-]' ..
        '{de}' .. bbWarning .. 'Lese Songpack ein, bitte warten...[-]'
    LANG_READINGSONGPACK_SUCCESS = 
        '{en}' .. bbOk .. 'Songpack read successfully[-]' ..
        '{de}' .. bbOk .. 'Songpack erfolgreich eingelesen[-]'
    LANG_READINGSONGPACK_WELCOME = 
        '{en}Welcome to \'' .. bbHighlight .. '<songpack>[-]\' by ' .. bbHighlight .. '<creator>[-]' ..
        '{de}Willkommen zu \'' .. bbHighlight .. '<songpack>[-]\' von ' .. bbHighlight .. '<creator>[-]'
    LANG_READINGSONGPACK_TIMEOUT = 
        '{en}' .. bbError .. 'Reading Songpack timed out![-]' ..
        '{de}' .. bbError .. 'Lesen des Songpacks dauerte zu lange![-]'

    LANG_MUSICPLAYER_ANNOUNCE =
        '{en}That was ' .. bbHighlight .. '<track>[-] by ' .. bbHighlight .. '<artist>[-] from the album ' .. bbHighlight .. '<album>[-]' ..
        '{de}Das war ' .. bbHighlight .. '<track>[-] von ' .. bbHighlight .. '<artist>[-] aus dem Album ' .. bbHighlight .. '<album>[-]'
end