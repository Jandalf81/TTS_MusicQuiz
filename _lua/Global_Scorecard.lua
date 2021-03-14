-- prepares a XML structure to show the scorecard (basically the first line only)
function Scorecard_create()
    -- create the XML table, add a first row and a very first cell
    xmlTableScorecard = {
        {
            tag = 'TableLayout',
            attributes = {
                id = 'Scorecard',
                width = 600,
                autoCalculateHeight = true,
                color = 'rgba(0, 0, 0, 0.7)',
                rectAlignment = 'UpperLeft',
                allowDragging = true,
                restrictDraggingToParentBounds = true,
                returnToOriginalPositionWhenReleased = false,
                interactable = true,
                active = true,
            },
            children = {
                {
                    tag = 'Row',
                    attributes = {
                        preferredHeight = 20
                    },
                    children = {
                        {
                            tag = 'Cell',
                            attributes = {},
                            children = {
                                tag = 'Text',
                                value = 'Runde',
                                attributes = {
                                    fontSize = 16,
                                    color = 'White'
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    -- add another cell on the first row for each player
    local playerList = Player.getPlayers()
    for _, p in ipairs(playerList) do
        if (p.seated == true and p.color ~= 'Black') then
            table.insert(
                xmlTableScorecard[1].children[1].children,
                {
                    tag = 'Cell',
                    attributes = {},
                    children = {
                        tag = 'Text',
                        value = p.steam_name,
                        attributes = {
                            fontSize = 16,
                            color = p.color
                        }
                    }
                }
            )
        end
    end

    Global.UI.setXmlTable(xmlTableScorecard)
end


-- adds a new line to the scorecard to show the point in that round
function Scorecard_nextRound(gametype)
    round = round + 1

    -- add a new row to the XML table with a very first cell
    table.insert(
        xmlTableScorecard[1].children,
        {
            tag = 'Row',
            attributes = {
                preferredHeight = 20
            },
            children = {
                {
                    tag = 'Cell',
                    attributes = {},
                    children = {
                        tag = 'Text',
                        value = round .. ': ' .. gametype,
                        attributes = {
                            fontSize = 16,
                            color = 'White'
                        }
                    }
                }
            }
        }
    )

    -- add new cells on the new row for each player, give each Text a unique ID
    local playerList = Player.getPlayers()
    for _, p in ipairs(playerList) do
        if (p.seated == true and p.color ~= 'Black') then
            table.insert(
                xmlTableScorecard[1].children[round + 1].children,
                {
                    tag = 'Cell',
                    attributes = {},
                    children = {
                        tag = 'Text',
                        value = 0,
                        attributes = {
                            id = 'score_' .. p.color .. '_' .. round,
                            fontSize = 16,
                            color = 'White'
                        }
                    }
                }
            )
        end
    end

    log(xmlTableScorecard)

    Global.UI.setXmlTable(xmlTableScorecard)
end

function Scorecard_update(color, increment)
    local currentValue =  Global.UI.getValue('score_' .. color .. '_' .. round)
    
    Global.UI.setValue('score_' .. color .. '_' .. round, currentValue + increment)
end