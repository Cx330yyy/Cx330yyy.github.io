#!/bin/bash

# 激活 Conda 环境（可选）
if [ -f ~/miniconda3/bin/activate ]; then
    echo "Activating Conda environment..."
    source ~/miniconda3/bin/activate
fi

# 安装 Homebrew（如果没装过）
if ! command -v brew &> /dev/null
then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 安装系统依赖
echo "Installing system libraries..."
brew install libffi libxml2

# 配置编译环境
export LDFLAGS="-L/opt/homebrew/opt/libffi/lib -L/opt/homebrew/opt/libxml2/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libffi/include -I/opt/homebrew/opt/libxml2/include"

# 安装 rbenv 和 Ruby
brew install rbenv ruby-build
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
source ~/.zshrc
rbenv install -s 3.2.2
rbenv global 3.2.2

# 安装 Bundler
gem install bundler

# 强制使用 Ruby 平台的二进制 gem
bundle config set force_ruby_platform true

# 安装主题依赖
echo "Installing Jekyll and Chirpy dependencies..."
bundle install

# 安装特殊 gem 避免 M2 编译问题
gem install nokogiri -- --use-system-libraries
gem install ffi

# 启动本地服务器
echo "Starting Jekyll server..."
bundle exec jekyll serve

