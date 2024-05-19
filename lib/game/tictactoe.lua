--[[@alias tictactoe_player 0|1]]
--[[@alias tictactoe_entry tictactoe_player|null]]
--[[@class tictactoe_row: {[1]:tictactoe_entry,[2]:tictactoe_entry,[3]:tictactoe_entry}]]
--[[@class tictactoe_board: {[1]:tictactoe_row,[2]:tictactoe_row,[3]:tictactoe_row}]]

--[[@class tictactoe_state]]
--[[@field board tictactoe_board]]
--[[@field current_player tictactoe_player]]
--[[@field player_ids {[1]:unknown,[2]:unknown}]]

local mod = {}

local null = require("lib.null").null

--[[should be serializable into JSON]]
mod.new_state = function ()
  --[[@type tictactoe_state]]
  return {
    --[[all entries are initially null, so they do not need to be pre-filled]]
    board = { { null, null, null }, { null, null, null }, { null, null, null } },
    player_ids = { "X", "O" },
    current_player = 0,
  }
end

--[[return a deep clone of the state. note that copying `player_ids` is expensive and usually]]
--[[unnecessary, but it would be inconsistent to avoid copying it.]]
--[[@param state tictactoe_state]]
mod.copy_state = function (state)
  --[[@type tictactoe_state]]
  return {
    board = { { unpack(state.board[1]) }, { unpack(state.board[2]) }, { unpack(state.board[3]) } },
    player_ids = { unpack(state.player_ids) },
    current_player = state.current_player
  }
end

--[[@param state tictactoe_state]] --[[@param row integer]] --[[@param column integer]]
mod.make_turn = function (state, row, column)
  state.board[row][column] = state.current_player
  state.current_player = state.current_player == 0 and 1 or 0
  return state
end

return mod
