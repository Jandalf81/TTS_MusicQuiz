function Songpack_loadFromURL(url)
    broadcastToAll('Reading Songpack, please wait...')

    WebRequest.get(url, function (webReturn)
            --log(webReturn.text)
            local json = JSON.decode(webReturn.text)
            songpack = json
        end)

    Wait.condition(Songpack_loadFromURL_Success, Songpack_loadFromURL_isReady, 10, Songpack_loadFromURL_Timeout)
end

function Songpack_loadFromURL_Success()
    broadcastToAll('Songpack read successfully')
    broadcastToAll('Welcome to ' .. songpack.settings.name)
end

function Songpack_loadFromURL_isReady()
    if (songpack == nil) then
        return false
    else
        return true
    end
end

function Songpack_loadFromURL_Timeout()
    broadcastToAll('Reading Songpack timed out!')
end