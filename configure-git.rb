# Usage: ./configure-git.rb <email> <username>
# Ex: ./configure-git.rb lucasmtercas@gmail.com lucastercas

email = ARGV[0]
username = ARGV[1]
`git config --global user.email #{email}`
`git config --global user.name #{username}`
