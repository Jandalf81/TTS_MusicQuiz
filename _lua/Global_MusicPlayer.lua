function MusicPlayer_play(song)
    MusicPlayer.setCurrentAudioclip({title = song.title, url = song.url})
    MusicPlayer.play()
end

function MusicPlayer_isPlaying()
    -- log('isPlaying: ' .. MusicPlayer.player_status)
    if (MusicPlayer.player_status ~= 'Play') then
        return false
    else
        return true
    end
end

function MusicPlayer_isStopped()
    -- log('isStopped: ' .. MusicPlayer.player_status)
    if (MusicPlayer.player_status ~= 'Pause') then
        return false
    else
        return true
    end
end

function MusicPlayer_announceSong(song)
    local LANG_MUSICPLAYER_ANNOUNCE_repl
    LANG_MUSICPLAYER_ANNOUNCE_repl = string.gsub(string.gsub(string.gsub(LANG_MUSICPLAYER_ANNOUNCE, '<track>', song.track), '<album>', song.album), '<artist>', song.artist)
    broadcastToAll(LANG_MUSICPLAYER_ANNOUNCE_repl)
end