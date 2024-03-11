#!/bin/bash

function install_ao(){
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install 20
    npm i -g https://get_ao.g8way.io
}

function login(){
    aos
}

function check_wallet(){
    vim .aos.json
}

function chat(){
    cat> chatroom.lua<<EOF
Members = Members or {}
Handlers.add(
"register",
Handlers.utils.hasMatchingTag("Action", "Register"),
function (msg)
    table.insert(Members, msg.From)
    Handlers.utils.reply("registered")(msg)
end
)

Handlers.add(
"broadcast",
Handlers.utils.hasMatchingTag("Action", "Broadcast"),
function (msg)
    for _, recipient in ipairs(Members) do
    ao.send({Target = recipient, Data = msg.Data})
    end
    Handlers.utils.reply("Broadcasted.")(msg)
end
)
EOF
    /usr/bin/expect<<_EOF
    spawn  aos
    expect "aos>" 
    send   ".load-blueprint chat\r"
    expect "aos>" 
    send   ".load chatroom.lua\r"
    expect "aos>" 
    send "Handlers.list\r"
    expect "aos>"
    send "Send\\(\\{ Target = ao.id, Action = \"Register\" \\}\\)\r"
    expect eof
_EOF
}
# 主菜单
function main_menu() {
    clear
    echo "脚本以及教程由null编写"
    echo "================================================================"
    echo "请选择要执行的操作:"
    echo "1. 安装节点"
    echo "2. 登录节点"
    echo "3. 查询节点匹配的钱包地址"
    echo "4. 自由交互聊天室"
    read -p "请输入选项（1-5）: " OPTION

    case $OPTION in
    1) install_ao ;;
    2) login ;;
    3) check_wallet ;;
    4) chat ;;
    *) echo "无效选项。" ;;
    esac
}

# 显示主菜单
main_menu
