install_oracle_libraries(){
  echo $HOME
  local build_dir=${1:-}
  local container_dir=${2:-}
  #adding support for oracle drivers included with container
  echo "Installing oracle libraries"
  mkdir -p $build_dir/oracle
  echo "Moving oracle drivers"
  cd $build_dir
  
  mv $container_dir/instantclient-basic-linux.x64-12.2.0.1.0.zip $build_dir/oracle/instantclient-basic.zip
  mv $container_dir/instantclient-sdk-linux.x64-12.2.0.1.0.zip $build_dir/oracle/instantclient-sdk.zip

  cd $build_dir/oracle
  
  echo "unzipping libraries"
  unzip instantclient-basic.zip
  unzip instantclient-sdk.zip
  mv instantclient_12_2 instantclient
  cd instantclient
  ln -s libclntsh.so.12.1 libclntsh.so
}

install_node_modules() {
  local build_dir=${1:-}

  if [ -e $build_dir/package.json ]; then
    cd $build_dir

    if [ -e $build_dir/npm-shrinkwrap.json ]; then
      echo "Installing node modules (package.json + shrinkwrap)"
    else
      echo "Installing node modules (package.json)"
    fi
    npm install --unsafe-perm --userconfig $build_dir/.npmrc 2>&1
  else
    echo "Skipping (no package.json)"
  fi
}

rebuild_node_modules() {
  local build_dir=${1:-}

  if [ -e $build_dir/package.json ]; then
    cd $build_dir
    echo "Rebuilding any native modules"
    npm rebuild --nodedir=$build_dir/.heroku/node 2>&1
    if [ -e $build_dir/npm-shrinkwrap.json ]; then
      echo "Installing any new modules (package.json + shrinkwrap)"
    else
      echo "Installing any new modules (package.json)"
    fi
    npm install --unsafe-perm --userconfig $build_dir/.npmrc 2>&1
  else
    echo "Skipping (no package.json)"
  fi
}
