function enproxy
    set -xg HTTP_PROXY 'http://127.0.0.1:7897'
    set -xg HTTPS_PROXY 'http://127.0.0.1:7897'
    set -xg ALL_PROXY 'http://127.0.0.1:7897'
    echo "Proxy are: "
    echo $HTTP_PROXY
    echo $HTTPS_PROXY
    echo $ALL_PROXY
end

function deproxy
    set -e ALL_PROXY
    set -e HTTP_PROXY
    set -e HTTPS_PROXY
    echo "Proxy are: "
    echo $HTTP_PROXY
    echo $HTTPS_PROXY
    echo $ALL_PROXY
end
