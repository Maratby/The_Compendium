------------MOD CODE -------------------------

--- Every played card counts in scoring

Compendium = {}
Compendium_Mod = SMODS.current_mod
Compendium_Config = Compendium_Mod.config

---enabling deck calculate
SMODS.current_mod.optional_features = function()
    return {
        cardareas = { deck = true },
    }
end

SMODS.Atlas {
	key = "CompendiumDecks",
	path = "Decks.png",
	px = 71,
	py = 95,
}

---enter an edition in _edition to set edition, enter true or false in eternal to set eternal
function Compendium_Cardmaker(_edition, eternal, _key)
	local _card = SMODS.create_card({
		area = G.jokers,
		key = _key
	})
	if _edition == "e_negative" or _edition == "negative" then
		_card:set_edition({ negative = true }, nil)
		_card.edition.negative = true
	end
	if eternal then
		_card.ability.eternal = true
	end
	_card:add_to_deck()
	G.jokers:emplace(_card)
	return _card
end

---Deck key finder
function Compendium_Deck_Check()
	if Galdur and Galdur.config.use and Galdur.run_setup.choices.deck then
		return Galdur.run_setup.choices.deck.effect.center.key
	elseif G.GAME.viewed_back then
		return G.GAME.viewed_back.effect.center.key
	elseif G.GAME.selected_back then
		return G.GAME.selected_back.effect.center.key
	end
	return "b_red"
end

SMODS.load_file("items/VanillaDecks.lua")()

---hook for playing more than 6 cards at a time
local canplayref = G.FUNCS.can_play
G.FUNCS.can_play = function(e)
	canplayref(e) ---complete function hook
	if #G.hand.highlighted <= G.hand.config.highlighted_limit then
		if #G.hand.highlighted > 5 then
			e.config.colour = G.C.BLUE
			e.config.button = 'play_cards_from_highlighted'
		end
	end
end

---function for spawning vouchers
function compend_redeem_voucher(local_voucher, _delay)
	local voucher_card = SMODS.create_card({ area = G.play, key = local_voucher })
	voucher_card:start_materialize()
	voucher_card.cost = 0
	G.play:emplace(voucher_card)
	delay(0.3)
	voucher_card:redeem()
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = _delay or 0.8,
		func = function()
			voucher_card:start_dissolve()
			return true
		end
	}))
end

if Compendium_Config.ModDecks then
	---SMODS.load_file("items/ModdedDecks.lua")()
end

---Config UI

Compendium_Mod.config_tab = function()
	return {
		n = G.UIT.ROOT,
		config = { align = "m", r = 0.1, padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 6 },
		nodes = {
			{ n = G.UIT.R, config = { align = "cl", padding = 0, minh = 0.1 }, nodes = {} },

			{
				n = G.UIT.R,
				config = { align = "cl", padding = 0 },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "cl", padding = 0.05 },
						nodes = {
							create_toggle { col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = Compendium_Config, ref_value = "ModDecks" },
						}
					},
					{
						n = G.UIT.C,
						config = { align = "c", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = "Modded Legendary Decks", scale = 0.5, colour = G.C.UI.TEXT_LIGHT } },
						}
					},
				}
			},

		}
	}
end

----------------------------------------------
------------MOD CODE END----------------------
