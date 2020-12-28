# lib/*.coffee
watch %r~lib/.*\.coffee~ do |m|
  run "bundle exec rakep build"
end

def run(cmd)
  puts cmd
  system cmd
end
