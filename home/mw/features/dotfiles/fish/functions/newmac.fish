function newmac --wraps=sudo\ /sbin/ifconfig\ en0\ ether\ \\`openssl\ rand\ -hex\ 6\ \|\ sed\ \'s/\\\(..\\\)/\\1:/g\;\ s/.\$//\'\\`
sudo /sbin/ifconfig en0 ether \`openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.\$//'\`
end
