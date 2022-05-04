#!/usr/bin/env sh

export DEVEN_ROOT=${HOME}/workspace
export UTILS_ROOT=${DEVEN_ROOT}/.utils
export REPOS_ROOT=${DEVEN_ROOT}/.repos

export NINJA_VERSION="1.10.2"
export CMAKE_VERSION="3.23.0"
export NEOVIM_VERSION="0.6.1"
export LUA_VERSION="5.4.4"

if [[ ! -d "${DEVEN_ROOT}" ]]; then
    mkdir -p ${REPOS_ROOT} \
             ${UTILS_ROOT}/share/man \
             ${UTILS_ROOT}/bin \
             ${UTILS_ROOT}/include \
             ${UTILS_ROOT}/lib \
             ${UTILS_ROOT}/sbin && \
    ln -s share/man ${UTILS_ROOT}/man
fi

if [[ "$PATH" != *"${UTILS_ROOT}/bin"* ]]; then
    export PATH=${UTILS_ROOT}/bin:$PATH
fi

if [[ "$(uname)" == "Darwin" ]]; then
    if [[  "$(which brew)" == "" \
        || "$(which brew)" == "brew no found" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile && \
        eval "$(/opt/homebrew/bin/brew shellenv)"

        brew install python
    fi

elif [[ "$(uname)" == "Linux" ]]; then
    if [[ "$(cat /etc/os-release | grep '^NAME=')" == *"Debian"*
       || "$(cat /etc/os-release | grep '^NAME=')" == *"Ubuntu"* ]]; then

        if [[ "$(which git)" == "" \
           || "$(which git)" == "git not found" ]]; then
            __INSTALL_PREREQ="${__INSTALL_PREREQ} git"
        fi

        if [[ "$(which python3)" == ""  \
           || "$(which python3)" == "python3 not found" ]]; then
            __INSTALL_PREREQ="${__INSTALL_PREREQ} python3"
        fi

        if [[ "$(which gcc)" == ""  \
           || "$(which gcc)" == "gcc not found" ]]; then
            __INSTALL_PREREQ="${__INSTALL_PREREQ} build-essential"
        fi

        if [[ "${__INSTALL_PREREQ}" != "" ]]; then
            sudo apt-get install -y ${__INSTALL_PREREQ}
        fi
    fi
fi


if [[  "$(which ninja)" == "" \
    || "$(which ninja)" == "ninja not found" \
    || "$(ninja --version)" != "${NINJA_VERSION}" ]]; then
    rm -f ${UTILS_ROOT}/bin/ninja

    if [[  "$(which python)" == "" \
        || "$(which python)" == "python not found" ]]; then
        ln -s $(which python3) ${UTILS_ROOT}/bin/python
    fi
    
    git clone --branch v${NINJA_VERSION} https://github.com/ninja-build/ninja ${REPOS_ROOT}/ninja && \
    pushd ${REPOS_ROOT}/ninja && \
    
    ./configure.py --bootstrap && mv ninja ${UTILS_ROOT}/bin && \
    
    popd && rm -rf ${REPOS_ROOT}/ninja
fi


if [[  "$(which cmake)" == "" \
    || "$(which cmake)" == "cmake not found" \
    || "$(cmake --version)" != *"${CMAKE_VERSION}"* ]]; then
    rm -rf ${UTILS_ROOT}/bin/ccmake \
           ${UTILS_ROOT}/bin/cmake \
           ${UTILS_ROOT}/bin/ctest \
           ${UTILS_ROOT}/bin/cpack \
           ${UTILS_ROOT}/doc/cmake-* \
           ${UTILS_ROOT}/share/cmake-* \
           ${UTILS_ROOT}/share/vim/vimfiles/indent \
           ${UTILS_ROOT}/share/vim/vimfiles/indent/cmake.vim \
           ${UTILS_ROOT}/share/vim/vimfiles/syntax \
           ${UTILS_ROOT}/share/vim/vimfiles/syntax/cmake.vim \
           ${UTILS_ROOT}/share/emacs/site-lisp/cmake-mode.el \
           ${UTILS_ROOT}/share/aclocal/cmake.m4 \
           ${UTILS_ROOT}/share/bash-completion/completions/cmake \
           ${UTILS_ROOT}/share/bash-completion/completions/cpack \
           ${UTILS_ROOT}/share/bash-completion/completions/ctest
    
    if [[ "$(uname)" == "Linux" ]]; then
        if [[ "$(cat /etc/os-release | grep '^NAME=')" == *"Debian"* 
           || "$(cat /etc/os-release | grep '^NAME=')" == *"Ubuntu"* ]]; then
            if [[ "$(apt list --installed | grep libssl-dev)" == "" ]]; then
                sudo apt-get install -y libssl-dev
            fi
        fi
    fi
    
    git clone --branch v${CMAKE_VERSION} https://gitlab.kitware.com/cmake/cmake ${REPOS_ROOT}/cmake && \
    pushd ${REPOS_ROOT}/cmake && \
    
    ./bootstrap --generator=Ninja --prefix=${UTILS_ROOT} && ninja && ninja install && \

    popd && rm -rf ${REPOS_ROOT}/cmake
fi


if [[  "$(which nvim)" == "" \
    || "$(which nvim)" == "nvim not found" \
    || "$(nvim --version | grep NVIM)" != *"v${NEOVIM_VERSION}"* ]]; then
    rm -rf ${UTILS_ROOT}/share/man/man1/nvim.1 \
           ${UTILS_ROOT}/bin/nvim \
           ${UTILS_ROOT}/lib/nvim \
           ${UTILS_ROOT}/share/locale/ja.euc-jp/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/cs.cp1250/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/sk.cp1250/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/nb/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/af/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/ca/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/cs/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/da/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/de/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/en_GB/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/eo/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/es/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/fi/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/fr/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/ga/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/it/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/ja/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/ko.UTF-8/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/nl/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/no/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/pl.UTF-8/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/pt_BR/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/ru/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/sk/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/sv/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/tr/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/uk/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/vi/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/zh_CN.UTF-8/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/locale/zh_TW.UTF-8/LC_MESSAGES/nvim.mo \
           ${UTILS_ROOT}/share/nvim
    
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install libtool automake pkg-config gettext
    elif [[ "$(uname)" == "Linux" ]]; then
        if [[ "$(cat /etc/os-release | grep '^NAME=')" == *"Debian"*
           || "$(cat /etc/os-release | grep '^NAME=')" == *"Ubuntu"* ]]; then
            sudo apt-get install -y gettext libtool libtool-bin autoconf automake pkg-config unzip curl doxygen
        fi
    fi

    git clone --branch v${NEOVIM_VERSION} https://github.com/neovim/neovim ${REPOS_ROOT}/neovim && \
    pushd ${REPOS_ROOT}/neovim && \

    make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=${UTILS_ROOT} && make install && \

    popd && rm -rf ${REPOS_ROOT}/neovim
fi


if [[  "$(which lua)" == "" \
    || "$(which lua)" == "lua not found" \
    || "$(lua -v)" != *"${LUA_VERSION}"* ]]; then

    rm -rf ${UTILS_ROOT}/bin/lua* \
           ${UTILS_ROOT}/include/lua*.h \
           ${UTILS_ROOT}/include/lua*.hpp \
           ${UTILS_ROOT}/lib/liblua.a \
           ${UTILS_ROOT}/man/man1/lua*.1

    if [[ "$(uname)" == "Linux" ]]; then
        if [[ "$(cat /etc/os-release | grep '^NAME=')" == *"Debian"*
           || "$(cat /etc/os-release | grep '^NAME=')" == *"Ubuntu"* ]]; then
            sudo apt-get install -y curl libreadline-dev
        fi
    fi

    curl -R -O -s http://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz && \
    tar zxf lua-${LUA_VERSION}.tar.gz && rm lua-${LUA_VERSION}.tar.gz && \
    pushd lua-${LUA_VERSION}

    if [[ "$(uname)" == "Darwin" ]]; then
        make macosx install INSTALL_TOP=${UTILS_ROOT}
    elif [[ "$(uname)" == "Linux" ]]; then
        make linux-readline install INSTALL_TOP=${UTILS_ROOT}
    fi

    popd && rm -rf lua-${LUA_VERSION}
fi