#!/bin/bash

git_port="22"
git_host="192.168.1.2"
git_user="git"
ssh_dir="$HOME/.ssh/"
git_ssh_key="$ssh_dir/id_rsa"
git_path="/srv/git"
key="/net/$git_host/data/things/keys/git/id_rsa"

repo=(Denver services sv_driver DenverCore DenverCoreUniTests DenverFwKievTests ConfigFiles)
reponame=(denver.git services.git sv_driver.git denver_core.git denver_core_unitests.git fwkiev_team.git config_files.git)

for ((i=0 ; i<${#repo[@]};i++)); do
	  declare -g "gt_${repo[$i]}=ssh://$git_user@$git_host:${git_port}${git_path}/${reponame[$i]}"
done

getgit_key () {

  mkdir -p "$ssh_dir" || { echo "Error: Unable to create $ssh_dir" ; return ;}
  { chmod 700 "$ssh_dir" && chown -R $UID "$ssh_dir"  ;} || return
  cp -a $key "$ssh_dir/"  || { echo "Error: Unable to copy git key" ; return ;}
  { chown $UID "$ssh_dir/id_rsa" && chmod 0600 "$ssh_dir/id_rsa" ;} || { echo "Error: unable to change file permission/owner $ssh_dir/id_rsa" ; return ;}
  rm -f "$ssh_dir/id_rsa.pub" || { echo "Error: unable to delete $ssh_dir/id_rsa.pub" ; return ;}
}

test_key () {
  return_msg=$(ssh -T -o PasswordAuthentication=no -i "$git_ssh_key" -l "$git_user" "$git_host" -p "$git_port" 2>&1)
  if ! grep -q -E '^fatal: What do you think I am\? A shell\?$' <<<"$return_msg"; then
      error=$(getgit_key)
      grep ^Error <<<"$error"
  fi
}

git_setup () {
  if  [[ ! $GIT_AUTHOR_NAME || ! $GIT_COMMITTER_NAME ]]; then
       while [[ ! $name ]]; do
         read -ep "Enter your full name (for git commit's author/commiter name): " name
       done
       GIT_AUTHOR_NAME=$name
       GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
  fi

  EMAIL="$USER@localhost"
  GIT_COMMITTER_EMAIL=$EMAIL
  export GIT_AUTHOR_NAME GIT_COMMITTER_NAME EMAIL GIT_COMMITTER_EMAIL
  test_key
}
