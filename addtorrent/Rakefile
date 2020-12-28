task :build do
  run "coffee -c --bare -o tmp lib"
  run "cat tmp/*.js > output/saber-addtorrent.user.js"
  run "sed -n '1,/UserScript/p' output/saber-addtorrent.user.js > output/saber-addtorrent.meta.js"
end

task :watch do
  run "bundle exec watchr saber-addtorrent.watchr"
end

task :server do
  run "bpm preview --port 4020 &>/dev/null &"
end

def run(cmd)
  puts cmd
  system cmd
end
