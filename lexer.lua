-- works perfectly as is

local lexer = {
  i = 1,
  words = {"fd", "5", "bk", "1", "lt", "rt", "fd"},
  lexeme_to_func = {
    fd=function(a) print("forward " .. tostring(a)) end,
    bk=function(a) print("back "..tostring(a)) end,
    lt=function(a) print("left "..tostring(a)) end,
    rt=function(a) print("right "..tostring(a)) end,
    sel=function(a) end,
    pldn=function(a) end,
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


