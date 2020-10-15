%w{rubygems wirble pp irb/ext/save-history ap}.each do |lib| 
  begin 
    require lib
  rescue LoadError => err
  end
end

if defined? Wirble
  Wirble.init
  Wirble.colorize
end

alias q exit

IRB.conf[:SAVE_HISTORY] = 1_000_000_000

