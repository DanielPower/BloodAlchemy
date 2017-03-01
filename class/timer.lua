local Timer = Lib.class('Timer')

function Timer:create(length, func, args)
    self.time = length
end

function Timer:update(dt)
  self.time = self.time - length
  if (self.time <= 0) then
    func(unpack(args))
  end
end
