sendInfoMessage("Initializing Pawlatro...", "Pawlatro")

-------------------
---
--- ATLASES
---
-------------------


--- Base Jokers
SMODS.Atlas{
    key = "PawlatroJokers",
    path = "PawlatroJokers.png",
    px = 71,
    py = 95
}

--- Done by Botswanaiguana on FurryCorner
SMODS.Atlas{
    key = "IguanaJokers",
    path = "IguanaJokers.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "IguanaTarot",
    path = "IguanaTarot.png",
    px = 63,
    py = 93
}


-------------------
---
--- JOKERS
---
-------------------


SMODS.Joker{
    key = "Furoker",
    atlas = "PawlatroJokers",
    pos = {x = 0, y = 0},
    loc_txt = {
        name = "Furoker",
        text = {
            "{C:chips}+#1#{} Chips"
        }
    },
    rarity = 1,
    cost = 2,
    config = { extra = { chips = 50 }},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                card = card,
                chip_mod = card.ability.extra.chips,
                message = "+" .. card.ability.extra.chips,
                colour = G.C.CHIPS
            }
        end
    end
}

SMODS.Joker{
    key = "beachtoy",
    atlas = "PawlatroJokers",
    pos = {x = 2, y = 0},
    loc_txt = {
        name = "Beachtoy",
        text = {
            "{C:attention}+#1#{} Hand size every round,",
            "{C:green}#2# in #3#{} chance of self destroying",
            "{C:inactive}(Currently {C:attention}+#4#{C:inactive})"
        }
    },
    rarity = 1,
    cost = 5,
    config = { extra = { hand_size_gain = 1, odds = 12 , hand_size = 1 } }, 
    loc_vars = function(self, info_queue, card) 
        return { vars = { card.ability.extra.hand_size_gain, (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.hand_size} }
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size)
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
            if pseudorandom("beachtoy") < G.GAME.probabilities.normal / card.ability.extra.odds then
                -- This part plays the animation.
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("tarot1")
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        -- This part destroys the card.
                        G.E_MANAGER:add_event(Event({
                            trigger = "after",
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end
                        }))
                    return true
                    end
                }))
            else
                G.hand:change_size(card.ability.extra.hand_size_gain)
                card.ability.extra.hand_size = card.ability.extra.hand_size + card.ability.extra.hand_size_gain
            return {
                message = "Upgraded!",
                message = "Safe!",
                card = card
            }
            end
        end
    end
}

SMODS.Joker{
    key = "pooltoy",
    atlas = "PawlatroJokers",
    pos = {x = 3, y = 0},
    loc_txt = {
        name = "Pooltoy",
        text = {
            "{C:blue}+#1#{} Joker slot every round,",
            "{C:green}#2# in #3#{} chance of self destroying",
            "{C:inactive}(Currently {C:blue}+#4#{C:inactive})"
        }
    },
    rarity = 1,
    cost = 5,
    config = { extra = { joker_slots_gain = 1, odds = 12 , joker_slots = 1 } }, 
    loc_vars = function(self, info_queue, card) 
        return { vars = { card.ability.extra.joker_slots_gain, (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.joker_slots} }
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.joker_slots
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
            if pseudorandom("beachtoy") < G.GAME.probabilities.normal / card.ability.extra.odds then
                -- This part plays the animation.
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("tarot1")
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        -- This part destroys the card.
                        G.E_MANAGER:add_event(Event({
                            trigger = "after",
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end
                        }))
                    return true
                    end
                }))
            else
                G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.joker_slots_gain
                card.ability.extra.joker_slots = card.ability.extra.joker_slots + card.ability.extra.joker_slots_gain
            return {
                message = "Upgraded!",
                card = card
            }
            end
        end
    end
}

SMODS.Joker{
    key = "suspiciouslywealthyjoker",
    atlas = "PawlatroJokers",
    pos = {x = 5, y = 0},
    loc_txt = {
        name = "Suspiciously wealthy joker",
        text = {
            "Earn {C:money}$#1#{} for",
            "every bought joker",
            "{C:red}Self-destroys{} if",
            "a joker is sold"
        }
    },
    rarity = 1,
    cost = 5,
    config = { extra = { money = 3 } }, 
    loc_vars = function(self, info_queue, card) 
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.buying_card and context.card.ability.set == "Joker" then
            ease_dollars(card.ability.extra.money)
            card_eval_status_text(
                context.blueprint_card or card,
                "extra",
                nil,
                nil,
                nil,
                {message = "$" .. card.ability.extra.money, colour = G.C.MONEY, delay = 0.6}
            )
        end

        if context.selling_card and context.card.ability.set == "Joker" then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.6,
                blockable = false,
                func = function()
                    G.jokers:remove_card(card)
                    card:remove()
                    card = nil
                    return true;
                end
            }))
        end
    end
}

SMODS.Joker{
    key = "popufur",
    atlas = "PawlatroJokers",
    pos = {x = 4, y = 0},
    loc_txt = {
        name = "Popufur",
        text = {
            "{C:chips}+#1#{} Chips"
        }
    },
    rarity = 1,
    cost = 5,
    config = { extra = { chips = 200 } }, 
    loc_vars = function(self, info_queue, card) 
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                card = card,
                chip_mod = card.ability.extra.chips,
                message = "+" .. card.ability.extra.chips,
                colour = G.C.CHIPS
            }
        end
    end
}

SMODS.Joker{
    key = "protogen",
    atlas = "IguanaJokers",
    pos = {x = 0, y = 0},
    loc_txt = {
        name = "Protogen",
        text = {
            "{X:mult,C:white}X#1#{} Mult if the first and last",
            "played cards are the same suit"
        }
    },
    rarity = 1,
    cost = 5,
    config = { extra = { Xmult = 3 } }, 
    loc_vars = function(self, info_queue, card) 
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local playedHandSize = 0

            for i = 1, #G.play.cards do
                playedHandSize = playedHandSize + 1
            end

            if G.play.cards[1].base.suit == G.play.cards[playedHandSize].base.suit then
                return {
                    card = card,
                    Xmult_mod = card.ability.extra.Xmult,
                    message = "X" .. card.ability.extra.Xmult,
                    colour = G.C.MULT
                }
            end
        end
    end
}

SMODS.Joker{
    key = "paw",
    atlas = "IguanaJokers",
    pos = {x = 1, y = 0},
    loc_txt = {
        name = "Paw",
        text = {
            "{C:attention}Discarding{} a single enchanted card",
            "draws {C:green}#1#{} cards from your deck"
        }
    },
    rarity = 1,
    cost = 5,
    config = { extra = { cards = 3 } }, 
    loc_vars = function(self, info_queue, card) 
        return { vars = { card.ability.extra.cards } }
    end,
    calculate = function(self, card, context)
        if (context.discard) and (context.other_card == context.full_hand[#context.full_hand]) then
            local discardedCards = 0

            for k, v in ipairs(context.full_hand) do
                discardedCards = discardedCards + 1 
            end

            if (discardedCards == 1) and (context.full_hand[1].ability.set == "Enhanced") then
                card_eval_status_text(
                    context.blueprint_card or card,
                    "extra",
                    nil,
                    nil,
                    nil,
                    {message = "Draw!", colour = G.C.GREEN, delay = 0.6}
                )
                G.FUNCS.draw_from_deck_to_hand(3)   
            end
        end
    end
}


-------------------
---
--- CONSUMABLES
---
-------------------


SMODS.Consumable {
    set = 'Planet',
    key = 'Cerberus',
    config = { hand_type = 'paw_yiff'},
    pos = {x = 0, y = 0 },
    atlas = 'IguanaTarot',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_planet_q'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    process_loc_text = function(self)
        --use another planet's loc txt instead
        local target_text = G.localization.descriptions[self.set]['c_mercury'].text
        SMODS.Consumable.process_loc_text(self)
        G.localization.descriptions[self.set][self.key].text = target_text
    end,
    generate_ui = 0,
    loc_txt = {
        ['en-us'] = {
            name = 'Cerberus'
        }
    }
}


-------------------
---
--- HANDS
---
-------------------


SMODS.PokerHand {
    key = 'yiff',
    chips = 50,
    mult = 5,
    l_chips = 15,
    l_mult = 2,
    example = {
        { 'H_9', false },
        { 'S_7', false },
        { 'C_6', true },
        { 'H_2', true },
        { 'D_A', true },
    },
    loc_txt = {
        name = 'Iffy',
        description = {
            '4 cards that share the numbers',
            'of monosodium glutamate (e621)',
        }
    },

    evaluate = function(parts, hand)
        local count = 0
        local scoring_cards = {}

        for i = 1, #hand do 
            if count <= 3 then
                if (hand[i]:get_id() == 14) or (hand[i]:get_id() == 6) or (hand[i]:get_id() == 2) then
                    table.insert(scoring_cards, hand[i])
                    count = count + 1
                end
            end
        end

        if count == 3 then 
            return { scoring_cards }
        end
    end
}

-- Debug function for dumping tables on console
-- Thank you hookenz on stack overflow
dump = function(o) 
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
           if type(k) ~= 'number' then k = '"'..k..'"' end
           s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end