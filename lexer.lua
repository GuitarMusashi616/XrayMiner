-- works perfectly as is
local tArgs = {...}


local lexer = {
  i = 1,
  words = tArgs,
  lexeme_to_func = {
    fd=turtle.forward,
    bk=turtle.back,
    lt=function(a) for i=1,a do turtle.turnLeft() end end,
    rt=function(a) for i=1,a do turtle.turnRight() end end,
    sel=turtle.select,
    pl=turtle.placeDown,
    plfd = function(a) for i=1,a do turtle.placeDown() turtle.forward() end end,
  }
}

function lexer.peek()
  return lexer.words[lexer.i]
end

function lexer.next()
  local item = lexer.words[lexer.i]
  lexer.increment()
  return item
end

function lexer.increment()
  lexer.i = lexer.i + 1
end

function lexer.next_token()
  local peek = lexer.peek()
  assert(not tonumber(peek), "number must follow command")
  lexer.process_word()
end

function lexer.process_word()
  local word = lexer.next()
  local maybe = lexer.peek()
  local num_arg = 1
  if tonumber(maybe) then
    num_arg = maybe
    lexer.increment()
  end
  lexer.execute(word, num_arg)
end

function lexer.is_finished()
  return lexer.i > #lexer.words
end

function lexer.execute(word, num)
  local func = lexer.lexeme_to_func[word]
  assert(func, word.." is not an acceptable lexeme")
  func(num)
end

while not lexer.is_finished() do
  lexer.next_token()
end
