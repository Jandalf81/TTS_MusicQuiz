function Songpack_loadFromURL(url)
    broadcastToAll(LANG_READINGSONGPACK_WAIT)

    WebRequest.get(url, function (webReturn)
            --log(webReturn.text)
            local json = JSON.decode(webReturn.text)
            songpack = json
        end)

    Wait.condition(Songpack_loadFromURL_Success, Songpack_loadFromURL_isReady, 10, Songpack_loadFromURL_Timeout)
end

function Songpack_loadFromURL_Success()
    broadcastToAll(LANG_READINGSONGPACK_SUCCESS)

    local LANG_READINGSONGPACK_WELCOME_repl
    LANG_READINGSONGPACK_WELCOME_repl = string.gsub(string.gsub(LANG_READINGSONGPACK_WELCOME, '<songpack>', songpack.name), '<creator>', songpack.creator)
    broadcastToAll(LANG_READINGSONGPACK_WELCOME_repl)
    -- log(songpack)
end

function Songpack_loadFromURL_isReady()
    if (songpack == nil) then
        return false
    else
        return true
    end
end

function Songpack_loadFromURL_Timeout()
    broadcastToAll(LANG_READINGSONGPACK_TIMEOUT)
end