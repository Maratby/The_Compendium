local suits = {
	"Spades",
	"Hearts",
	"Clubs",
	"Diamonds"
}
---Canio Deck's alterations to the Deck
local compend_backapply = Back.apply_to_run
function Back:apply_to_run()
    if Compendium_Deck_Check() == "b_comp_caniodeck" or Compendium_Deck_Check() == "b_comp_tribdeck" then
        G.E_MANAGER:add_event(Event({
            func = function()
                for index, value in pairs(G.playing_cards) do
                    if not value:is_face() and value:get_id() <= 4 then
						if value:get_id() == 2 then
							SMODS.change_base(value, nil, "Jack")
						elseif value:get_id() == 3 then
							SMODS.change_base(value, nil, "Queen")
						elseif value:get_id() == 4 then
							SMODS.change_base(value, nil, "King")
						end
                    end
                end
                return true
            end
        }))
    end
	if Compendium_Deck_Check() == "b_comp_yorickdeck" then
        G.E_MANAGER:add_event(Event({
			blocking = false,
            func = function()
				local _suit = pseudorandom_element(suits, pseudoseed("woohoo"))
                for index, value in pairs(G.playing_cards) do
                    if value:is_suit(_suit) then
						value:set_seal("Purple")
                    end
                end
                return true
            end
        }))
    end
    return compend_backapply(self)
end

SMODS.Back {
	name = "001-CANIO",
	key = "caniodeck",
	pos = { x = 0, y = 0 },
	unlocked = true,
	discovered = true,
	config = { joker = "j_caino", display = "Canio" },
	atlas = "CompendiumDecks",
	loc_vars = function(self)
		return { vars = { self.config.display} }
	end,
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				Compendium_Cardmaker(false, true, self.config.joker)
				Compendium_Cardmaker(false, false, "j_trading")
				return true
			end
		}))
	end
}

SMODS.Back {
	name = "002-TRIBOULET",
	key = "tribdeck",
	pos = { x = 1, y = 0 },
	unlocked = true,
	discovered = true,
	config = { joker = "j_triboulet", display = "Triboulet" },
	atlas = "CompendiumDecks",
	loc_vars = function(self)
		return { vars = { self.config.display} }
	end,
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				Compendium_Cardmaker(false, true, self.config.joker)
				Compendium_Cardmaker(false, false, "j_sock_and_buskin")
				return true
			end
		}))
	end
}

SMODS.Back {
	name = "003-YORICK",
	key = "yorickdeck",
	pos = { x = 2, y = 0 },
	unlocked = true,
	discovered = true,
	config = { joker = "j_yorick", display = "Yorick" },
	atlas = "CompendiumDecks",
	loc_vars = function(self)
		return { vars = { self.config.display} }
	end,
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				Compendium_Cardmaker(false, true, self.config.joker)
				ease_discard(2)
				G.GAME.round_resets.discards = G.GAME.round_resets.discards + 2
				G.hand.config.highlighted_limit = G.hand.config.highlighted_limit + 1
				return true
			end
		}))
	end
}

SMODS.Back {
	name = "004-CHICOT",
	key = "chicotdeck",
	pos = { x = 3, y = 0 },
	unlocked = true,
	discovered = true,
	config = { joker = "j_chicot", display = "Chicot" },
	atlas = "CompendiumDecks",
	loc_vars = function(self)
		return { vars = { self.config.display} }
	end,
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				Compendium_Cardmaker("e_negative", true, self.config.joker)
				Compendium_Cardmaker("e_negative", true, self.config.joker)
				compend_redeem_voucher("v_directors_cut", 0)
				ease_ante(-1)
				return true
			end
		}))
	end
}

SMODS.Back {
	name = "005-PERKEO",
	key = "perkeodeck",
	pos = { x = 4, y = 0 },
	unlocked = true,
	discovered = true,
	config = { joker = "j_perkeo", display = "Perkeo" },
	atlas = "CompendiumDecks",
	loc_vars = function(self)
		return { vars = { self.config.display} }
	end,
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				Compendium_Cardmaker(false, true, self.config.joker)
				compend_redeem_voucher("v_crystal_ball", 0)
				G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
				return true
			end
		}))
	end,
	calculate = function(self, back, context)
		if context.end_of_round and not context.individual and not context.repetition and G.GAME.blind.boss and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
			print("splash")
			if #G.consumeables.cards + G.GAME.consumeable_buffer < (G.consumeables.config.card_limit - 1) then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 2
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0.0,
					func = (function()
						local s_card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil,
							'perkdeck yay')
						s_card:add_to_deck()
						G.consumeables:emplace(s_card)
						local s_card2 = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil,
							'perkdeck yay')
						s_card2:add_to_deck()
						G.consumeables:emplace(s_card2)
						return true
					end)
				}))
				return {
					message = localize('k_plus_spectral'),
					colour = G.C.SECONDARY_SET.Spectral,
					card = G.deck
				}
			elseif #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0.0,
					func = (function()
						local s_card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil,
							'perkdeck yay')
						s_card:add_to_deck()
						G.consumeables:emplace(s_card)
						G.GAME.consumeable_buffer = 0
						return true
					end)
				}))
				return {
					message = localize('k_plus_spectral'),
					colour = G.C.SECONDARY_SET.Spectral,
					card = G.deck
				}
			end
		end
	end
}