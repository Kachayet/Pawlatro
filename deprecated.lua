SMODS.PokerHand {
    key = 'royalyiff',
    chips = 120,
    mult = 9,
    l_chips = 40,
    l_mult = 4,
    example = {
        { 'H_A', true },
        { 'S_T', false },
        { 'D_8', false },
        { 'H_6', true },
        { 'H_2', true },
    },
    loc_txt = {
        name = 'Royal Yiff',
        description = {
            '4 cards that share the numbers of',
            'E621 (monosodium glutamate) with',
            'the same suit'
        }
    },
    evaluate = function(parts, hand)
        --- This is messy but if it works, it works
        local countHearts = 0
        local countDiamonds = 0
        local countSpades = 0
        local countClubs = 0

        local scoringHeartCards = {}
        local scoringDiamondCards = {}
        local scoringSpadeCards = {}
        local scoringClubCards = {}

        for i = 1, #hand do 
            if (countHearts <= 3) or (countDiamonds <= 3) or (countSpades <= 3) or (countClubs <= 3) then

                if (hand[i]:is_suit('Hearts')) then
                    if (hand[i]:get_id() == 14) or (hand[i]:get_id() == 6) or (hand[i]:get_id() == 2) then
                        table.insert(scoringHeartCards, hand[i])
                        countHearts = countHearts + 1
                    end
                end

                if (hand[i]:is_suit('Diamonds')) then
                    if (hand[i]:get_id() == 14) or (hand[i]:get_id() == 6) or (hand[i]:get_id() == 2) then
                        table.insert(scoringDiamondCards, hand[i])
                        countDiamonds = countDiamonds + 1
                    end
                end

                if (hand[i]:is_suit('Spades')) then
                    if (hand[i]:get_id() == 14) or (hand[i]:get_id() == 6) or (hand[i]:get_id() == 2) then
                        table.insert(scoringSpadeCards, hand[i])
                        countSpades = countSpades + 1
                    end
                end

                if (hand[i]:is_suit('Clubs')) then
                    if (hand[i]:get_id() == 14) or (hand[i]:get_id() == 6) or (hand[i]:get_id() == 2) then
                        table.insert(scoringClubCards, hand[i])
                        countClubs = countClubs + 1
                    end
                end

            end
        end

        if (countHearts == 3) then
            return { scoringHeartCards }
        end
        
        if (countDiamonds == 3) then 
            return { scoringDiamondCards }
        end 
        
        if (countSpades == 3) then
            return { scoringSpadeCards }
        end 
        
        if (countClubs == 3) then 
            return { scoringClubCards }
        end
    end
}