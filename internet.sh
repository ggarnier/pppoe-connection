#!/bin/bash

# Script que verifica o status da conexao, executando ate 3 pings ao site do provedor.
# Caso a conexao esteja inativa, ela e desconectada e reconectada.
# Este processo e repetido indefinidamente.
#
# Autor: Guilherme Garnier (http://ggarnier.wordpress.com/)

cmd_ping="/bin/ping"
cmd_pon="/usr/bin/pon"
cmd_poff="/usr/bin/poff"
provider="dsl-provider"
host="www.radlink.com.br"
frequency="10s"
verbose=0

while [ true ]
do
    ok=0
    for timeout in 1 2 3
    do
        `$cmd_ping -q -c 1 -W $timeout $host > /dev/null 2>&1`
        if [ $? -eq 0 ]
        then
            ok=1
            break
        fi
    done

    if [ $ok -eq 1 ]
    then
        sleep $frequency
        continue
    fi

    `$cmd_poff $provider > /dev/null 2>&1`
    `$cmd_pon $provider > /dev/null 2>&1`
    if [ $? -ne 0 ]
    then
        $verbose && echo "Erro na conexão com o provedor"
        exit 1
    fi

    sleep $frequency
done

exit 0