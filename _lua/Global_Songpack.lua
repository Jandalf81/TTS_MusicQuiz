function loadSongpackFromURL(url)
    broadcastToAll('Reading Songpack, please wait...')

    WebRequest.get(url, function (webReturn)
            log(webReturn.text)
            local json = JSON.decode(webReturn.text)
            songpack = json
        end)

    Wait.condition(loadSongpackFromURL_Success, loadSongpackFromURL_isReady, 10, loadSongpackFromURL_Timeout)
end

function loadSongpackFromURL_Success()
    broadcastToAll('Songpack read successfully')
    broadcastToAll('Welcome to ' .. songpack.settings.name)
    log(songpack)
end

function loadSongpackFromURL_isReady()
    if (songpack == nil) then
        return false
    else
        return true
    end
end

function loadSongpackFromURL_Timeout()
    broadcastToAll('Reading Songpack timed out!')
end